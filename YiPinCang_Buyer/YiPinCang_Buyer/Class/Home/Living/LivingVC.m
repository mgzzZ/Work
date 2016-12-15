//
//  LivingVC.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/15.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LivingVC.h"
#import "LivingVC+PrivateMethod.h"
#import "AudienceModel.h"
#import "CommendModel.h"
#import "AllGoodsModel.h"
#import "DanmuMessage.h"
#import "TimerLiveInfoModel.h"
#import "DiscoverDetailVC.h"
#import "LivingLikeMessage.h"
#import "LiveBottomView.h"
#import "VideoPlayerVC.h"

#define Window [UIApplication sharedApplication].keyWindow

static NSString *status[] = {
    @"PLPlayerStatusUnknow",
    @"PLPlayerStatusPreparing",
    @"PLPlayerStatusReady",
    @"PLPlayerStatusCaching",
    @"PLPlayerStatusPlaying",
    @"PLPlayerStatusPaused",
    @"PLPlayerStatusStopped",
    @"PLPlayerStatusError"
};

@interface LivingVC ()
<
PLPlayerDelegate,
UITextFieldDelegate
>

@property (nonatomic, assign) NSInteger reconnectCount; // error重新连接次数
@property (nonatomic, strong) AFNetworkReachabilityManager *internetReachability; // 网络监测

@property (strong, nonatomic) IBOutlet UIImageView *playerPHView; // 拉流前占位图片
@property (strong, nonatomic) IBOutlet UIButton *failBtn; // 出现error显示图片
@property (strong, nonatomic) IBOutlet UIImageView *livingPauseImgV; // 直播暂停显示图片
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *goodsBottomConstraint;
@property (strong, nonatomic) IBOutlet UIView *smallPlayerBgView;

@property (nonatomic, strong) dispatch_source_t timer; // 强引用time, 防止提前释放
@property (nonatomic, strong) TimerLiveInfoModel *timerLiveModel;

@property (nonatomic, strong) LiveBottomView *liveBottomView;

@end

@implementation LivingVC
{
    BOOL goodsIsShowing;
    BOOL LivingGroupInfoIsShowing;
    BOOL isFirstLoadData;
    NSDictionary *_currentTopGoodsDic;
}
#pragma mark - 懒加载
- (LiveBottomView *)liveBottomView
{
    WS(weakSelf);
    if (_liveBottomView == nil) {
        _liveBottomView = [[LiveBottomView alloc]init];
        _liveBottomView.store_id = self.rtmpModel.store_id;//加载数据
        //点击cell
        _liveBottomView.didcell = ^(TempHomePushModel *model){
            [weakSelf.player stop];
            weakSelf.isRemoveFromWindow = YES;
            weakSelf.playerIsOnWindow = NO;
            VideoPlayerVC *vVC = [VideoPlayerVC new];
            vVC.tempModel = model;
            vVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vVC animated:YES];
        };
        //点击私信
        _liveBottomView.pushMessage = ^(NSString *hx_name){
            if (weakSelf.player.status == AVIMClientStatusNone || weakSelf.player.status == AVIMClientStatusClosing || weakSelf.player.status == AVIMClientStatusClosed) {
                [YPC_Tools openConversationWithCilentId:hx_name andViewController:weakSelf];
            }else {
                if (!weakSelf.playerIsOnWindow) {
                    [weakSelf playVideoOnWindow];
                    [YPC_Tools openConversationWithCilentId:hx_name andViewController:weakSelf];
                }
            }
        };
        [self.view addSubview:_liveBottomView];
    }
    return _liveBottomView;
}

#pragma mark - ViewController声明周期
-(void)dealloc
{
    [self.player stop];
    self.player = nil;
    [NotificationCenter removeObserver:self];
    YPCAppLog(@"Dealloc");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.rt_disableInteractivePop = YES;
    [YPC_Tools setStatusBarIsHidden:YES];
    
    [self config];
    // 获取拉流初试信息
    [self getRtmpUrlInfo];
    [self addKeyboardNotifications];
    [self getMainData];
    [self getIssueData];
    
    [self goodsItemSelectedAction];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [YPC_Tools setStatusBarIsHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [YPC_Tools setStatusBarIsHidden:NO];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!isFirstLoadData) {
        [self resumeTimer];
    }
    isFirstLoadData = NO;
    if (self.player.status != AVIMClientStatusNone || self.player.status != AVIMClientStatusClosing || self.player.status != AVIMClientStatusClosed) {
        
        if (self.playerIsOnWindow) {
            [self hiddenVideoOnWindowWithViewController:self];
        }
        if (self.isRemoveFromWindow && !self.playerIsOnWindow) {
            if (self.player.status == PLPlayerStatusStopped) {
                [self.player play];
            }
        }
    }
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self pauseTimer];
}

- (void)config
{
    isFirstLoadData = YES;
    goodsIsShowing = NO;
    LivingGroupInfoIsShowing = NO;
    self.playerIsOnWindow = NO;
    self.isRemoveFromWindow = NO;
    self.localLikeCount = 0;
    self.playerPHView.image = self.playerPHImg;
    
    // 隐藏商品轻拍手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenOrShowGoodsView:)];
    [self.itemContentView addGestureRecognizer:singleTap];
    // 小视频单击手势, 返回页面, 全屏播放
    UITapGestureRecognizer *smallSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenOrShowGoodsView:)];
    [self.player.playerView addGestureRecognizer:smallSingleTap];
    // 小视频拖拽手势
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doHandlePanAction:)];
    [self.player.playerView addGestureRecognizer:panGes];
    // 点击头像
    UITapGestureRecognizer *avatorTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookLivingGroupInfoAction:)];
    [self.avatorImgV addGestureRecognizer:avatorTap];
}
#pragma mark - DATA
// 推流相关初始数据
- (void)getRtmpUrlInfo
{
    WS(weakSelf);
    [YPCNetworking postWithUrl:@"shop/activity/checklivinginfo"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"live_id" : self.tempModel.live_id
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               _rtmpModel = [RTMPModel mj_objectWithKeyValues:response[@"data"]];
                               if (_rtmpModel.state.integerValue == 4) {
                                   weakSelf.livingPauseImgV.hidden = NO;
                               }else {                                   
                                   // 配置拉流, 准备拉流
                                   [weakSelf configPlayer];
                               }
                               // 控件赋值
                               [weakSelf setDataForItem];
                               // 加入弹幕聊天室
                               [weakSelf joinDanmakuChatroomWithConversationId:_rtmpModel.hx_lgroupid];
                               // 初始化定时器
                               [weakSelf setUpTimer];
                           }
                       } fail:^(NSError *error) {
                           YPCAppLog(@"%@", [error description]);
                       }];
}
- (void)setDataForItem
{
    [self.avatorImgV sd_setImageWithURL:[NSURL URLWithString:self.tempModel.store_avatar] placeholderImage:YPCImagePlaceHolder];
    self.livingNameL.text = self.tempModel.store_name;
    if (self.rtmpModel.live_like.length > 4) {
        self.likeCountL.text = [NSString stringWithFormat:@"%.2f万   ", self.rtmpModel.live_like.floatValue / 10000];
    }else {
        self.likeCountL.text = [NSString stringWithFormat:@"%@   ", self.rtmpModel.live_like];
    }
    self.likeCount = self.rtmpModel.live_like.integerValue;
    if (self.rtmpModel.live_users.length > 4) {
        self.audienceCountL.text = [NSString stringWithFormat:@"观众数:%.2f万人", self.rtmpModel.live_users.floatValue / 10000];
    }else {
        self.audienceCountL.text = [NSString stringWithFormat:@"观众数:%@人", self.rtmpModel.live_users];
    }
    if (self.rtmpModel.isfollowSeller.integerValue == 1) {
        self.groupBgWidthC.constant = 52 + [self.livingNameL.text stringSizeWithFont:LightFont(15)].width;
        self.followBtn.hidden = YES;
    }else {
        self.groupBgWidthC.constant = 100 + [self.livingNameL.text stringSizeWithFont:LightFont(15)].width;
        self.followBtn.hidden = NO;
    }
    [self.view layoutIfNeeded];
    
    self.audienceView.tempDataArr = [AudienceModel mj_objectArrayWithKeyValuesArray:self.rtmpModel.live_useravars];
}

// 商品相关数据
- (void)getMainData
{
    WS(weakSelf);
    [YPCNetworking postWithUrl:@"shop/activity/stopactivitydetail"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"live_id" : self.tempModel.live_id
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.goodsView.commendDataArr = [CommendModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"commend_goods"]];
                           }
                       } fail:^(NSError *error) {
                           YPCAppLog(@"%@", [error description]);
                       }];
}
- (void)getIssueData
{
    WS(weakSelf);
    [YPCNetworking postWithUrl:@"shop/activity/showgoodslist"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"live_id" : self.tempModel.live_id,
                                                                               @"store_id" : self.tempModel.store_id
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.goodsView.allGoodsDataArr = [AllGoodsModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                           }
                       } fail:^(NSError *error) {
                           YPCAppLog(@"%@", [error description]);
                       }];
}
- (void)refreshLivingInfoData
{
    WS(weakSelf);
    [YPCNetworking postWithUrl:@"shop/activity/timergetlivinginfo"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"live_id" : self.tempModel.live_id
                                                                               }]
                       success:^(id response) {
                           if ([response[@"status"][@"succeed"] integerValue] == 1) {
                               weakSelf.timerLiveModel = [TimerLiveInfoModel mj_objectWithKeyValues:response[@"data"]];
                               weakSelf.audienceView.tempDataArr = [AudienceModel mj_objectArrayWithKeyValuesArray:self.timerLiveModel.live_useravars];
                               
                               // 观众人数及其点赞数量实时更新
                               if (weakSelf.timerLiveModel.live_like.length > 4) {
                                   weakSelf.likeCountL.text = [NSString stringWithFormat:@"%.2f万   ", self.timerLiveModel.live_like.floatValue / 10000];
                               }else {
                                   weakSelf.likeCountL.text = [NSString stringWithFormat:@"%@   ", self.timerLiveModel.live_like];
                               }
                               if (weakSelf.timerLiveModel.live_users.length > 4) {
                                   weakSelf.audienceCountL.text = [NSString stringWithFormat:@"观众数:%.2f万人", self.timerLiveModel.live_users.floatValue / 10000];
                               }else {
                                   weakSelf.audienceCountL.text = [NSString stringWithFormat:@"观众数:%@人", self.timerLiveModel.live_users];
                               }
                           }
                           weakSelf.likeCount = weakSelf.timerLiveModel.live_like.integerValue;
                       } fail:^(NSError *error) {
                           YPCAppLog(@"%@", [error description]);
                       }];
}
- (void)uploadLocalLikeCount
{
    WS(weakSelf);
    [YPCNetworking postWithUrl:@"shop/activity/timerlikeliving"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"live_id" : self.tempModel.live_id,
                                                                               @"announcement_id" : self.tempModel.announcement_id,
                                                                               @"count" : [NSString stringWithFormat:@"%ld", weakSelf.localLikeCount]
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.localLikeCount = 0;
                           }
                       } fail:^(NSError *error) {
                           YPCAppLog(@"%@", [error description]);
                       }];
}

#pragma mark - Object Init
- (void)configPlayer
{
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    [option setOptionValue:@10 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    
    self.player = [PLPlayer playerWithURL:[NSURL URLWithString:self.rtmpModel.qn_rtmppublishurl] option:option];
    self.player.delegate = self;
    self.player.delegateQueue = dispatch_get_main_queue();
    self.player.backgroundPlayEnable = YES;
    self.player.playerView.hidden = YES;
    [self.view insertSubview:self.player.playerView belowSubview:self.itemContentView];
    [self.player.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(ScreenHeight);
    }];
    
    [self.player.playerView addSubview:self.smallCloseBtn];
    [self.smallCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.player.playerView.mas_right);
        make.top.equalTo(self.player.playerView.mas_top);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [self startPlayer];
    
    self.reconnectCount = 0; // 重新连接次数
}
- (void)startPlayer {
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [self.player play];
    [self addNotifications];
}

#pragma mark - 定时器
- (void)setUpTimer
{
    WS(weakSelf);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        [weakSelf refreshLivingInfoData];
        [weakSelf uploadLocalLikeCount];
    });
    dispatch_resume(_timer);
}
- (void)pauseTimer{
    if(_timer){
        dispatch_suspend(_timer);
    }
}
- (void)resumeTimer{
    if(_timer){
        dispatch_resume(_timer);
    }
}
- (void)stopTimer{
    if(_timer){
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

#pragma mark - 监听
- (void)addNotifications
{
    [NotificationCenter addObserver:self
                           selector:@selector(startPlayer)
                               name:UIApplicationWillEnterForegroundNotification
                             object:nil];
    // 网络状态监控
    [NotificationCenter addObserver:self
                           selector:@selector(reachabilityChanged:)
                               name:AFNetworkingReachabilityDidChangeNotification
                             object:nil];
    self.internetReachability = [AFNetworkReachabilityManager sharedManager];
    [self.internetReachability startMonitoring];
    
    // Leancloud监听
    [NotificationCenter addObserver:self selector:@selector(animationWithLivingLike) name:DidReceiveLivingLikeFormLeanCloudCusstomMessage object:nil];
    [NotificationCenter addObserver:self selector:@selector(livingGoodsTopAction:) name:DidReceiveLivingGoodsTopFormLeanCloudCusstomMessage object:nil];
    [NotificationCenter addObserver:self selector:@selector(livingGoodsIssueAction:) name:DidReceiveLivingGoodsIssueLeanCloudCusstomMessage object:nil];
    [NotificationCenter addObserver:self selector:@selector(MessagelivingPauseAction) name:DidReceiveLivingLivingPauseLeanCloudCusstomMessage object:nil];
    [NotificationCenter addObserver:self selector:@selector(MessagelivingStopAction) name:DidReceiveLivingLivingStopLeanCloudCusstomMessage object:nil];
}
- (void)addKeyboardNotifications
{
    // 键盘监听
    [NotificationCenter addObserver:self
                           selector:@selector(keyboardWillShow:)
                               name:UIKeyboardWillShowNotification
                             object:nil];
    
    [NotificationCenter addObserver:self
                           selector:@selector(keyboardWillHide:)
                               name:UIKeyboardWillHideNotification
                             object:nil];
}
- (void)reachabilityChanged:(NSNotification *)not
{
    switch (self.internetReachability.networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
            
            break;
        case AFNetworkReachabilityStatusNotReachable:
            [self.player stop];
            if (!self.player.playerView.hidden) {
                self.player.playerView.hidden = YES;
                self.failBtn.hidden = NO;
            }
            [YPC_Tools dismissHud];
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            if (self.player.status == PLPlayerStatusPlaying || self.player.status == PLPlayerStatusCaching) {
                WS(weakSelf);
                [YPC_Tools customAlertViewWithTitle:@"提示"
                                            Message:@"当前非WiFi网络\n继续播放将产生流量费用"
                                          BtnTitles:nil
                                     CancelBtnTitle:@"停止播放"
                                DestructiveBtnTitle:@"继续播放"
                                      actionHandler:nil
                                      cancelHandler:^(LGAlertView *alertView) {
                                          [weakSelf.player stop];
                                          [weakSelf.navigationController popViewControllerAnimated:YES];
                                      } destructiveHandler:nil];
            }
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            break;
        default:
            break;
    }
}
-(void)keyboardWillShow:(NSNotification *)note{
    NSDictionary *userInfo = [note userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    self.tfBottomC.constant = keyboardRect.size.height;
    self.danmakuViewBottomC.constant = keyboardRect.size.height + 40;
    [UIView animateWithDuration:duration.floatValue animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    self.tfBottomC.constant = -40;
    self.danmakuViewBottomC.constant = 72.f;
    [UIView animateWithDuration:duration.floatValue animations:^{
        [self.view layoutIfNeeded];
    }];
}
#pragma mark - <PLPlayerDelegate>
- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
    if (PLPlayerStatusCaching == state) {
        [YPC_Tools showSvpHudWithNoneMask];
    } else if (PLPlayerStatusPlaying == state) {
        [YPC_Tools dismissHud];
        if (self.player.playerView.hidden) {
            self.player.playerView.hidden = NO;
            self.failBtn.hidden = YES;
            [self.player play];
        }
        self.reconnectCount = 0;
    }else if(PLPlayerStatusError == state) {
        self.player.playerView.hidden = YES;
        self.failBtn.hidden = NO;
        [self.player stop];
        [YPC_Tools dismissHud];
    }else if (PLPlayerStateAutoReconnecting == state) {
        [YPC_Tools showSvpHudWithNoneMask];
        self.player.playerView.hidden = YES;
        self.failBtn.hidden = YES;
    }else if (PLPlayerStatusStopped == state) {
        [YPC_Tools dismissHud];
    }
    NSLog(@"%@", status[state]);
}
- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error
{
    if (self.reconnectCount < 3) {
        self.reconnectCount++;
        [YPC_Tools showSvpHud:[NSString stringWithFormat:@"正在进行第%ld次重新连接", (long)self.reconnectCount]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * pow(2, self.reconnectCount) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.player play];
        });
    }else {
        [YPC_Tools showSvpHudError:@"连接失败"];
        [self.player stop];
        self.player.playerView.hidden = YES;
        self.failBtn.hidden = NO;
    }
}
- (void)playerWillBeginBackgroundTask:(nonnull PLPlayer *)player
{

}
- (void)playerWillEndBackgroundTask:(nonnull PLPlayer *)player
{
    
}

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    if (![textField.text isEmpty]) {
        // 发送弹幕
        DanmuMessage *message = [DanmuMessage messageWithText:textField.text attributes:@{@"uID" : [YPCRequestCenter shareInstance].uID, @"name" : [YPCRequestCenter shareInstance].model.name}];
        AVIMMessageOption *option = [AVIMMessageOption new];
        option.transient = YES;
        option.priority = AVIMMessagePriorityLow;
        [self.danmuconversation sendMessage:message option:option callback:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:message.attributes];
                [dic setObject:textField.text forKey:@"message"];
                [NotificationCenter postNotificationName:DidReceiveDanmakuFormLeanCloudCusstomMessage object:dic];
            }
        }];
        
    }
    return YES;
}

#pragma mark - BtnClick
- (IBAction)btnClickAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 2000:
            // 关注
            [self followLivingGroup];
            break;
        case 2001:
            // 分享
            break;
        case 2002:
            // 关闭
            [self stopTimer];
            [YPC_Tools dismissHud];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 2003:
            // 商品
            [self showGoodsAction];
            break;
        case 2004:
            // 点赞
            [self LivingLikeActionWithSender:sender];
            break;
        case 2005:
            // 发弹幕
            [self.danmakuTF becomeFirstResponder];
            break;
        case 2006:
            // 小窗口拉流关闭
            [self removeVideoOnWindow];
            break;
        case 2007:
            // 出现错误重新连接
            sender.hidden = YES;
            [self.player play];
            break;
        case 2222:{
            // 直播间弹出商品
            if (!self.playerIsOnWindow) {
                [self playVideoOnWindow];
                
                DiscoverDetailVC *detailVC = [DiscoverDetailVC new];
                detailVC.live_id = self.tempModel.live_id;
                detailVC.strace_id = [_currentTopGoodsDic safe_objectForKey:@"strace_id"];
                [self.navigationController pushViewController:detailVC animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}
- (void)hiddenOrShowGoodsView:(UITapGestureRecognizer *)tap
{
    if (goodsIsShowing && !self.playerIsOnWindow) {
        [self hiddenGoodsAction];
    }
    if (self.playerIsOnWindow) {
        [self hiddenVideoOnWindowWithViewController:self];
    }
    if (self.player.status == AVIMClientStatusNone || self.player.status == AVIMClientStatusClosing || self.player.status == AVIMClientStatusClosed) {
        [self hiddenGoodsAction];
    }
    if (LivingGroupInfoIsShowing) {
        [self.liveBottomView animationHiden];
        LivingGroupInfoIsShowing = NO;
    }
}
- (void)lookLivingGroupInfoAction:(UITapGestureRecognizer *)tap
{
    if (!LivingGroupInfoIsShowing) {
        [self.liveBottomView animationShow];
        LivingGroupInfoIsShowing = YES;
    }else {
        [self.liveBottomView animationHiden];
        LivingGroupInfoIsShowing = NO;
    }
}

#pragma mark - 商品弹出&隐藏方法
- (void)showGoodsAction
{
    if (!goodsIsShowing) {
        goodsIsShowing = YES;
        self.goodsBottomConstraint.constant = -ScreenHeight / 5 * 3;
        self.bottomView.hidden = YES;
        self.audienceView.hidden = YES;
        self.danmakuView.hidden = YES;
        self.audienceCountL.hidden = YES;
        self.smallPlayerBgView.hidden = NO;
        WS(weakself);
        CGFloat height = ScreenHeight - ScreenHeight / 5 * 3;
        CGFloat radio = ScreenWidth / ScreenHeight;
        [UIView animateWithDuration:.2f animations:^{
            [weakself.player.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_top);
                make.left.equalTo(self.view.mas_left).offset((ScreenWidth - radio * height) / 2);
                make.width.mas_equalTo(radio * height);
                make.height.mas_equalTo(height);
            }];
            [weakself.view layoutIfNeeded];
        }];
    }
}
- (void)hiddenGoodsAction
{
    if (goodsIsShowing) {
        goodsIsShowing = NO;
        self.goodsBottomConstraint.constant = 0;
        self.bottomView.hidden = NO;
        self.audienceView.hidden = NO;
        self.danmakuView.hidden = NO;
        self.audienceCountL.hidden = NO;
        WS(weakself);
        [UIView animateWithDuration:.2f animations:^{
            [weakself.player.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_top);
                make.left.equalTo(self.view.mas_left);
                make.width.mas_equalTo(ScreenWidth);
                make.height.mas_equalTo(ScreenHeight);
            }];
            [weakself.view layoutIfNeeded];
        }completion:^(BOOL finished) {
            self.smallPlayerBgView.hidden = YES;;
        }];
    }
}

- (void)LivingLikeActionWithSender:(UIButton *)sender
{
    self.likeCount++;
    self.localLikeCount++;
    if (self.likeCount > 10000) {
        self.likeCountL.text = [NSString stringWithFormat:@"%.2f万   ", self.likeCount / 10000.f];
    }else {
        self.likeCountL.text = [NSString stringWithFormat:@"%ld   ", self.likeCount];
    }
    [self showTheApplauseInView:self.view belowView:sender];
    LivingLikeMessage *message = [LivingLikeMessage messageWithText:@"0" attributes:nil];
    AVIMMessageOption *option = [AVIMMessageOption new];
    option.transient = YES;
    option.priority = AVIMMessagePriorityLow;
    [self.danmuconversation sendMessage:message option:option callback:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
        }
    }];
}

#pragma mark - LeanCloud暂态消息接收
- (void)animationWithLivingLike
{
    [self showTheApplauseInView:self.view belowView:[self.view viewWithTag:2004]];
}
- (void)livingGoodsTopAction:(NSNotification *)not
{
    _currentTopGoodsDic = [not userInfo];
    if (self.livingTopGoodsView.hidden) {
        self.livingTopGoodsView.hidden = NO;
    }
    [self.topGoodsImgV sd_setImageWithURL:[NSURL URLWithString:[_currentTopGoodsDic safe_objectForKey:@"img"]] placeholderImage:YPCImagePlaceHolderSquare];
    self.topGoodsTitleL.text = [_currentTopGoodsDic safe_objectForKey:@"name"];
    self.topGoodPriceL.text = [_currentTopGoodsDic safe_objectForKey:@"goods_price"];
    
    // 刷新推荐商品跟总列表商品
    [self getMainData];
    [self getIssueData];
    
}
- (void)livingGoodsIssueAction:(NSNotification *)not
{
    [self getIssueData];
}
- (void)MessagelivingPauseAction
{
    [self.player stop];
    self.livingPauseImgV.hidden = NO;
    self.player.playerView.hidden = YES;
}
- (void)MessagelivingStopAction
{
    [self.player stop];
    self.livingPauseImgV.image = IMAGE(@"liveover_placeholder");
    self.livingPauseImgV.hidden = NO;
    self.player.playerView.hidden = YES;
}

#pragma mark - 商品点击block
- (void)goodsItemSelectedAction;
{
    WS(weakSelf);
    [self.goodsView setCellSelectedBlock:^(NSString *strace_id) {
        if (strace_id) {
            if (self.player.status == AVIMClientStatusNone || self.player.status == AVIMClientStatusClosing || self.player.status == AVIMClientStatusClosed) {
                
                DiscoverDetailVC *detailVC = [DiscoverDetailVC new];
                detailVC.live_id = weakSelf.tempModel.live_id;
                detailVC.strace_id = strace_id;
                [weakSelf.navigationController pushViewController:detailVC animated:YES];
            }else {
                if (!weakSelf.playerIsOnWindow) {
                    [weakSelf playVideoOnWindow];
                    
                    DiscoverDetailVC *detailVC = [DiscoverDetailVC new];
                    detailVC.live_id = weakSelf.tempModel.live_id;
                    detailVC.strace_id = strace_id;
                    [weakSelf.navigationController pushViewController:detailVC animated:YES];
                }
            }
            
        }
    }];
}

#pragma mark - Pan Method
- (void)doHandlePanAction:(UIPanGestureRecognizer *)pan
{
    CGPoint translation = [pan translationInView:Window];
    CGPoint newCenter = CGPointMake(pan.view.center.x+ translation.x,
                                    pan.view.center.y + translation.y);//    限制屏幕范围：
    newCenter.y = MAX(pan.view.frame.size.height/2, newCenter.y);
    newCenter.y = MIN(Window.frame.size.height - pan.view.frame.size.height/2,  newCenter.y);
    newCenter.x = MAX(pan.view.frame.size.width/2, newCenter.x);
    newCenter.x = MIN(Window.frame.size.width - pan.view.frame.size.width/2,newCenter.x);
    pan.view.center = newCenter;
    [pan setTranslation:CGPointZero inView:Window];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
