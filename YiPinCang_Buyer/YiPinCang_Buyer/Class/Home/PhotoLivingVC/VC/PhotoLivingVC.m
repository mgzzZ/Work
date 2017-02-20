//
//  PhotoLivingVC.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 17/1/2.
//  Copyright © 2017年 Laomeng. All rights reserved.
//

#import "PhotoLivingVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PhotoLivingModel.h"
#import "BranCell.h"
#import "LiveActivityModel.h"
#import "TopView.h"
#import "ClassSegView.h"
#import "DiscoverBrandLiskModel.h"
#import "DiscoverDetailVC.h"
#import "LiveDetailHHHVC.h"
#import "LeanChatFactory.h"

static NSString *Identifier = @"identifier";
@interface PhotoLivingVC () <UITableViewDelegate, UITableViewDataSource, AVIMClientDelegate>
@property (nonatomic, strong) UILabel *naviTitleLbl;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderV;
@property (strong, nonatomic) IBOutlet UIButton *fllowBtn;
@property (strong, nonatomic) IBOutlet UIImageView *videoBgImgV;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImgV;
@property (strong, nonatomic) IBOutlet UIButton *txBtn;
@property (strong, nonatomic) IBOutlet UILabel *nameL;
@property (strong, nonatomic) IBOutlet UILabel *followCountL;
@property (nonatomic, copy) NSString *listorder;
@property (nonatomic, strong) PhotoLivingModel *dataModel;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) CGFloat offset;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic) UIButton *movieCoverBtn;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) ClassSegView *classSegView;
@property (nonatomic, strong) TopView *topView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSMutableArray *brandListArr;
@property (nonatomic, copy) NSString *sectionStr;
@property (nonatomic, strong) NSMutableArray *sectionArr;
@property (nonatomic, strong) NSMutableDictionary *brandDic;
@property (nonatomic, strong) NSMutableArray *valueArr;//装model
@property (nonatomic, strong) NSMutableArray *bigValueArr;//装bigTValueArr
@property (nonatomic, strong) NSMutableArray *bigTValueArr;//装valueArr 和选中后的心分类
@property (nonatomic, copy) NSString *btnType;

@property (nonatomic, strong) AVIMClient *transientClient;



@property (nonatomic,assign)BOOL isTop;
@property (nonatomic,copy)NSString *topStr;

@property (strong, nonatomic) IBOutlet UILabel *nGoodsNoticeCountL;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nGoodsNoticeViewRightC;

@property (nonatomic, assign) NSUInteger dataIndex;

@end

@implementation PhotoLivingVC
{
    NSUInteger newGoodsCount;
    BOOL newGoodsBtnIsShowing;
    BOOL isAlreadyJoinTransilentRoom;
}

- (void)dealloc
{
    [self.transientClient closeWithCallback:^(BOOL succeeded, NSError * _Nullable error) {
        YPCAppLog(@"退出暂态聊天室");
    }];
    [NotificationCenter removeObserver:self];
    
}

#pragma mark - 懒加载
- (NSMutableArray *)sectionArr{
    if (_sectionArr == nil) {
        _sectionArr = [[NSMutableArray alloc]init];
    }
    return _sectionArr;
}
- (NSMutableArray *)brandListArr{
    if (_brandListArr == nil) {
        _brandListArr = [[NSMutableArray alloc]init];
    }
    return _brandListArr;
}
- (NSMutableArray *)dataArr
{
    if (_dataArr) {
        return _dataArr;
    }
    _dataArr = [NSMutableArray array];
    return _dataArr;
}

#pragma mark - VC声明周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar mz_setBackgroundImage:IMAGE(@"homepage_bar")];
    [self.navigationController.navigationBar mz_setBackgroundColor:[Color colorWithHex:@"#3B3B3B"]];
    [self.navigationController.navigationBar mz_setBackgroundAlpha:0.f];
    self.view.backgroundColor = [Color colorWithHex:@"0xe3e3e3"];
    self.tableView.backgroundColor = [Color colorWithHex:@"0xe3e3e3"];
    self.btnType = @"0";
    self.class_id = @"";
    self.sectionStr = @"";
    self.listorder = @"0";
    self.isTop = NO;
    self.topStr = @"1";
    newGoodsCount = 0;
    newGoodsBtnIsShowing = NO;
    isAlreadyJoinTransilentRoom = NO;
    
    self.dataIndex = 1;
    [self getDataWithListorder:self.listorder andClassId:self.class_id page:self.dataIndex];
    [self newGoodsBtnHiddenWithAnimation];
    WS(weakSelf);
    
    self.tableView.mj_header = [YPCRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.dataIndex = 1;
        [weakSelf getDataWithListorder:weakSelf.listorder andClassId:weakSelf.class_id page:weakSelf.dataIndex];
        [weakSelf newGoodsBtnHiddenWithAnimation];
    }];
//    [self.tableView.mj_header beginRefreshing];
    [self getDataOfBrand];
    
    self.tableHeaderV.height = ScreenWidth / 375 * 200 + 60;
    [self.tableView setTableHeaderView:self.tableHeaderV];
}

#pragma mark - Data
- (void)getDataWithListorder:(NSString *)listorder andClassId:(NSString *)classId page:(NSInteger)page
{
    WS(weakSelf);
    [YPCNetworking postWithUrl:@"shop/activity/storelivegoods"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"live_id" : weakSelf.liveId,
                                                                               @"listorder" : listorder,
                                                                               @"class_id" : classId,
                                                                               @"pagination" : @{
                                                                                       @"page":[NSString stringWithFormat:@"%ld", page],
                                                                                       @"count":@"10"
                                                                                       }
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.dataModel = [PhotoLivingModel mj_objectWithKeyValues:response[@"data"]];
                               if (page == 1) {
                                   [weakSelf.dataArr removeAllObjects];
                               }
                               NSArray *arr = [LiveActivityModel mj_objectArrayWithKeyValuesArray:weakSelf.dataModel.list];
                               [weakSelf.dataArr addObjectsFromArray:arr];
                               if ([weakSelf.dataModel.storeinfo.isfollowSeller isEqualToString:@"1"]) {
                                   weakSelf.fllowBtn.selected = YES;
                               }else{
                                   weakSelf.fllowBtn.selected = NO;
                               }

                               if (weakSelf.dataArr.count != 0 && weakSelf.tableView.mj_footer == nil) {
                                   weakSelf.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                                       weakSelf.dataIndex = weakSelf.dataIndex + 1;
                                       [weakSelf getDataWithListorder:weakSelf.listorder andClassId:weakSelf.class_id page:weakSelf.dataIndex];
                                   }];
                               }
                               [weakSelf.tableView reloadData];
                               
                               [weakSelf.tableView.mj_header endRefreshing];
                               if (arr.count < 10) {
                                   [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                               }else{
                                   [weakSelf.tableView.mj_footer endRefreshing];
                               }
                                
                               [weakSelf setDataForItem];
                               
                               if (!isAlreadyJoinTransilentRoom) {
                                   [weakSelf judementLoginAndJoinToTransientLeanCloudRoom];
                               }
                           }
                       } fail:^(NSError *error) {
                           YPCAppLog(@"%@", [error description]);
                       }];
}

- (void)getDataOfBrand{
    WS(weakSelf);
    [YPCNetworking postWithUrl:@"shop/activity/storeliveclass"
                  refreshCache:YES
                        params:@{
                                 @"live_id":weakSelf.liveId
                                 }
                       success:^(id response) {
                           weakSelf.brandListArr = [DiscoverBrandLiskModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                           [weakSelf segBrandData:weakSelf.brandListArr];
                       }
                          fail:^(NSError *error) {
                              YPCAppLog(@"%@", [error description]);
                          }];
}

- (void)setDataForItem
{
    [self.videoBgImgV sd_setImageWithURL:[NSURL URLWithString:self.dataModel.activityinfo.activity_pic] placeholderImage:YPCImagePlaceMainHomeHolder];
    [self.avatarImgV sd_setImageWithURL:[NSURL URLWithString:self.dataModel.storeinfo.store_avatar] placeholderImage:nil];
    self.nameL.text = self.dataModel.storeinfo.store_name;
    self.followCountL.text = self.dataModel.storeinfo.store_collect;

}

#pragma mark - 加入leancloud暂态聊天室
- (void)judementLoginAndJoinToTransientLeanCloudRoom
{
    if ([YPCRequestCenter isLogin]) {
        self.transientClient = [LCChatKit sharedInstance].client;
        WS(weakSelf);
        [self.transientClient openWithCallback:^(BOOL succeeded, NSError *error) {
            AVIMConversationQuery *query = [weakSelf.transientClient conversationQuery];
            [query getConversationById:weakSelf.dataModel.activityinfo.hx_lgroupid callback:^(AVIMConversation *conversation, NSError *error) {
                if (succeeded) {
                    [conversation joinWithCallback:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            YPCAppLog(@"进入暂态聊天室");
                             isAlreadyJoinTransilentRoom = YES;
                            [NotificationCenter addObserver:weakSelf selector:@selector(livingGoodsIssueAction:) name:DidReceiveLivingGoodsIssueLeanCloudCusstomMessage object:nil];
                        }else {
                            // TOTO 加入聊天室失败
                        }
                    }];
                }else {
                    // TOTO 加入聊天室失败
                }
            }];
        }];
    }else {
        WS(weakSelf);
        NSString *udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        self.transientClient = [[AVIMClient alloc] initWithClientId:udid];
        self.transientClient.delegate = self;
        [self.transientClient openWithCallback:^(BOOL succeeded, NSError *error) {
            AVIMConversationQuery *query = [weakSelf.transientClient conversationQuery];
            [query getConversationById:weakSelf.dataModel.activityinfo.hx_lgroupid callback:^(AVIMConversation *conversation, NSError *error) {
                if (succeeded) {
                    [conversation joinWithCallback:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            isAlreadyJoinTransilentRoom = YES;
                            YPCAppLog(@"进入暂态聊天室");
                        }else {
                            // TOTO 加入聊天室失败
                        }
                    }];
                }else {
                    // TOTO 加入聊天室失败
                }
            }];
        }];
    }
}

#pragma mark - 暂态消息接收
- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
//    NSDictionary *dic = message.attributes;
//    WS(weakSelf);
//    [YPCNetworking postWithUrl:@"shop/activity/getsimplegoodsinfo"
//                  refreshCache:YES
//                        params:@{@"strace_id" : [dic objectForKey:@"strace_id"]}
//                       success:^(id response) {
//                           [weakSelf.dataArr insertObject:[LiveActivityModel mj_objectWithKeyValues:response[@"data"]] atIndex:weakSelf.dataArr.count - 1];
//                           [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.dataArr.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//                       } fail:^(NSError *error) {
//                           
//                       }];
    newGoodsCount++;
    [self newGoodsBtnShowWithAnimation];
}
- (void)livingGoodsIssueAction:(NSNotification *)not
{
//    NSDictionary *notDic = not.object;
//    WS(weakSelf);
//    [YPCNetworking postWithUrl:@"shop/activity/getsimplegoodsinfo"
//                  refreshCache:YES
//                        params:@{@"strace_id" : [notDic objectForKey:@"strace_id"]}
//                       success:^(id response) {
//                           [weakSelf.dataArr insertObject:[LiveActivityModel mj_objectWithKeyValues:response[@"data"]] atIndex:weakSelf.dataArr.count - 1];
//                           [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.dataArr.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//                       } fail:^(NSError *error) {
//                           
//                       }];
    newGoodsCount++;
    [self newGoodsBtnShowWithAnimation];
}

- (IBAction)NewGoodsBtnClickAction:(UIButton *)sender {
    [self newGoodsBtnHiddenWithAnimation];
}

- (void)newGoodsBtnShowWithAnimation
{
    self.nGoodsNoticeCountL.text = [NSString stringWithFormat:@"%ld", newGoodsCount];
    if (!newGoodsBtnIsShowing) {
        self.nGoodsNoticeViewRightC.constant = 0.f;
        WS(weakSelf);
        [UIView animateWithDuration:.2f animations:^{
            [weakSelf.view layoutIfNeeded];
        }completion:^(BOOL finished) {
            newGoodsBtnIsShowing = YES;
        }];
    }
}

- (void)newGoodsBtnHiddenWithAnimation
{
    if (newGoodsBtnIsShowing) {
        newGoodsCount = 0;
        self.nGoodsNoticeViewRightC.constant = -52.f;
        WS(weakSelf);
        [UIView animateWithDuration:.2f animations:^{
            [weakSelf.view layoutIfNeeded];
        }completion:^(BOOL finished) {
            newGoodsBtnIsShowing = NO;
            [weakSelf.tableView.mj_header beginRefreshing];
        }];
    }
}



#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.topView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 42;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BranCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[BranCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (self.dataArr.count != 0) {
       cell.model = self.dataArr[indexPath.row];
        cell.shareBtn.tag = indexPath.row;
        [cell.shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveActivityModel *model = self.dataArr[indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[BranCell class] contentViewWidth:[self cellContentViewWith]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WS(wealself);
    LiveActivityModel *model = self.dataArr[indexPath.row];
    DiscoverDetailVC *dic = [[DiscoverDetailVC alloc]init];
    dic.strace_id = model.strace_id;
    dic.typeStr = @"淘好货";
    dic.backBlock = ^(NSString *likeCount,NSString *isLike,NSString *commentCount){
        model.strace_cool = likeCount;
        model.strace_comment = commentCount;
        [wealself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:dic animated:YES];
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    self.offset = point.y;
    if (point.y > 50 + ScreenWidth * 150 / 375 - 64.f) {
        CGFloat alpha = MIN(1, 1 - ((50 + ScreenWidth * 150 / 375 - point.y) / 64));
        [self.navigationController.navigationBar mz_setBackgroundAlpha:alpha];

        self.navigationItem.title = self.dataModel.storeinfo.store_name;
    }else{
        [self.navigationController.navigationBar mz_setBackgroundAlpha:0.f];
        self.navigationItem.title = @"";
    }
    if (self.dataArr.count > 0) {
        if (scrollView.contentOffset.y <= (120 + ScreenWidth * 150 / 375 - 64) && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
        }else if(scrollView.contentOffset.y >= 120 + ScreenWidth * 150 / 375 - 64) {
            
            scrollView.contentInset  = UIEdgeInsetsMake(64, 0, 0, 0);
            
            
        }
        
    }
}
//转换json
- (void)segBrandData:(NSMutableArray *)listArr{
    if (listArr.count == 0) {
        return;
    }else{
        self.bigValueArr = [[NSMutableArray alloc]init];
        self.brandDic = [[NSMutableDictionary alloc]init];
    }
    for (int i = 0; i < listArr.count; i++) {
        DiscoverBrandLiskModel *model = listArr[i];
        if (![model.brand_initial isEqualToString:_sectionStr]) {
            if (_valueArr && _valueArr.count != 0) {
                [self.bigTValueArr addObject:_valueArr];
                [self.bigValueArr addObject:_bigTValueArr];
            }
            _valueArr = [[NSMutableArray alloc]init];
            _bigTValueArr = [[NSMutableArray alloc]init];
            [self.sectionArr addObject:model.brand_initial];
            _sectionStr = model.brand_initial;
            [_valueArr addObject:model];
            if (i == listArr.count - 1) {
                [self.bigTValueArr addObject:_valueArr];
                [self.bigValueArr addObject:_bigTValueArr];
            }
        }else{
            
            [_valueArr addObject:model];
            if (i == listArr.count - 1) {
                [self.bigTValueArr addObject:_valueArr];
                [self.bigValueArr addObject:_bigTValueArr];
            }
            
        }
    }
    for (int i = 0; i < self.sectionArr.count; i++) {
        [self.brandDic setValue:self.bigValueArr[i] forKey:self.sectionArr[i]];
    }
}
#pragma mark - ButtonAction
- (IBAction)buttonClickAction:(UIButton *)sender {
    switch (sender.tag) {
        case 200:
            // 播放视频
            [self videoPlayActionWithURL:self.dataModel.activityinfo.video];
            break;
        case 201:
            // 关注/取消关注
            break;
            
        default:
            break;
    }
}

#pragma mark - 播放视频Method
- (void)videoPlayActionWithURL:(NSString *)urlStr
{
    if (![urlStr isEmpty]) {
        // 设置视频播放器
        self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:urlStr]];
        self.moviePlayer.allowsAirPlay = YES;
        [self.moviePlayer setControlStyle:MPMovieControlStyleNone];
        [self.moviePlayer.view setFrame:self.view.bounds];
        self.moviePlayer.repeatMode = MPMovieRepeatModeOne;
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows) {
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            if(windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                [window addSubview:self.moviePlayer.view];
                break;
            }
        }
        [self.moviePlayer play];
        self.movieCoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.movieCoverBtn.frame = self.view.bounds;
        self.movieCoverBtn.backgroundColor = [UIColor clearColor];
        [self.moviePlayer.view addSubview:self.movieCoverBtn];
        [self.movieCoverBtn addTarget:self action:@selector(dismissMoviePlayer) forControlEvents:UIControlEventTouchUpInside];
        
        [NotificationCenter addObserver:self selector:@selector(moviePlayerLoadStateDidChange) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
        
        self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.loadingView.center = self.movieCoverBtn.center;
        [self.movieCoverBtn addSubview:self.loadingView];
        [self.loadingView startAnimating];
        
        [YPC_Tools setStatusBarIsHidden:YES];
    }else {
        [YPC_Tools showSvpWithNoneImgHud:@"暂无视频,请稍等直播员上传~"];
    }
}

/**
 *  视频播放状态改变
 */
- (void)moviePlayerLoadStateDidChange
{
    switch (self.moviePlayer.loadState)
    {
        case MPMovieLoadStatePlayable:
        {
            /** 可播放 */;
            [self.loadingView stopAnimating];
        }
            break;
        case MPMovieLoadStatePlaythroughOK:
        {
            /** 状态为缓冲几乎完成，可以连续播放 */;
            [self.loadingView stopAnimating];
        }
            break;
        case MPMovieLoadStateStalled:
        {
            /** 缓冲中 */
            [self.loadingView startAnimating];
        }
            break;
        case MPMovieLoadStateUnknown:
        {
            /** 未知状态 */
            [self.loadingView startAnimating];
        }
            break;
    }
}

- (ClassSegView *)classSegView{
    WS(weakSelf);
    if (_classSegView == nil) {
        _classSegView = [[ClassSegView alloc]init];
        [self.view addSubview:_classSegView];
        _classSegView.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .heightIs(0);
        _classSegView.hidden = YES;
        if (self.offset < 270 && self.offset > 0) {
            _classSegView.sd_layout.topSpaceToView(self.view,120 + ScreenWidth * 150 / 375 + 42 - self.offset );
            self.isTop = NO;
            self.topStr = @"2";
        }else if (self.offset >= 270){
            _classSegView.sd_layout.topSpaceToView(self.view,64 + 42);
            self.isTop = NO;
            self.topStr = @"2";
        }else{
            _classSegView.sd_layout.topSpaceToView(self.view,120 + ScreenWidth * 150 / 375 + 42);
            self.isTop = YES;
            self.topStr = @"1";
        }
        __block NSInteger page = self.dataIndex;
        _classSegView.classBackId = ^(NSString *class_id){
            weakSelf.class_id = class_id;
            weakSelf.isTop = YES;
            [weakSelf getDataWithListorder:weakSelf.listorder andClassId:weakSelf.class_id page:page];
            [weakSelf segBrandViewHiden];
        };
    }
    return _classSegView;
}
- (UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.3;
        [self.view addSubview:_bgView];
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelClick:)];
        _bgView.sd_layout
        .topSpaceToView(self.view,64 + 42)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomEqualToView(self.view);
        self.bgView.hidden = YES;
    }
    return _bgView;
}

- (TopView *)topView{
    if (_topView == nil) {
        
        _topView = [[TopView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 42)];
        _topView.bgView.layer.borderColor = [Color colorWithHex:@"0xefefef"].CGColor;
        _topView.bgView.layer.borderWidth = 1;
        _topView.recommendBtn.selected = NO;
        WS(weakself);
        _topView.didBtnClick = ^(UIButton *clickBtn, NSInteger tag){
            switch (tag) {
                case 1000:
                {
                    if (weakself.dataArr.count == 0) {
                        return;
                    }
                    clickBtn.selected = NO;
                    weakself.class_id =@"";
                    [weakself chooseHiden];
                    if (![weakself.listorder isEqualToString:@"0"]) {
                        weakself.listorder = @"0";
                        [weakself.dataArr removeAllObjects];
                        [weakself getDataWithListorder:weakself.listorder andClassId:weakself.class_id page:weakself.dataIndex];
                    }else{
                        weakself.listorder = @"0";
                    }
                    [weakself.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_unclicked") forState:UIControlStateNormal];
                    [weakself.topView.brandBtn setTitleColor:[Color colorWithHex:@"666666"] forState:UIControlStateNormal];
                    weakself.dataIndex = 1;
                    [weakself getDataWithListorder:weakself.listorder andClassId:weakself.class_id page:weakself.dataIndex];
                }
                    break;
                case 1001:
                {
                    if (weakself.dataArr.count == 0) {
                        return;
                    }
                    
                    if (clickBtn.selected == NO) {
                        
                        if (weakself.dataArr.count > 1) {
                            weakself.bgView.backgroundColor = [UIColor  blackColor];
                            if ([weakself.topStr isEqualToString:@"1"]) {
                                weakself.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                            }
                            weakself.isTop = YES;
                            [weakself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                            //                            weakself.naviTitleLbl.alpha = 1;
                            weakself.navigationItem.title = weakself.dataModel.storeinfo.store_name;
                        }else{
                            if ([weakself.topStr isEqualToString:@"1"]) {
                                weakself.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                            }
                            weakself.bgView.backgroundColor = [UIColor clearColor];
                        }
                        clickBtn.selected = YES;
                        weakself.topView.brandBtn.selected = NO;
                        weakself.topView.priceBtn.selected = NO;
                        weakself.topView.recommendBtn.selected = YES;
                        [weakself chooseHiden];
                        [weakself segBrandViewHidenNo:weakself.sectionArr];
                        [weakself.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_unclicked") forState:UIControlStateNormal];
                        weakself.dataIndex = 1;
                        [weakself getDataWithListorder:weakself.listorder andClassId:weakself.class_id page:weakself.dataIndex];
                        [weakself.topView.brandBtn setTitleColor:[Color colorWithHex:@"666666"] forState:UIControlStateNormal];
                    }else{
                        clickBtn.selected = NO;
                        weakself.class_id =@"";
                        weakself.topView.recommendBtn.selected = NO;
                        [weakself chooseHiden];
                        
                    }
                    
                    
                }
                    break;
                case 1002:
                {
                    if (weakself.dataArr.count == 0) {
                        return;
                    }
                    
                    weakself.topView.priceBtn.selected = NO;
                    weakself.topView.otherBtn.selected = NO;
                    
                    if ([weakself.listorder isEqualToString:@"0"] || [weakself.listorder isEqualToString:@"3"]) {
                        weakself.listorder = @"1";
                        [weakself.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_clicked_ascending") forState:UIControlStateNormal];
                        [weakself.topView.brandBtn setTitleColor:[Color colorWithHex:@"#EC0024"] forState:UIControlStateNormal];
                        weakself.topView.recommendBtn.selected = YES;
                    }else if ([weakself.listorder isEqualToString:@"1"]){
                        weakself.listorder = @"2";
                        [weakself.topView.brandBtn setTitleColor:[Color colorWithHex:@"#EC0024"] forState:UIControlStateNormal];
                        [weakself.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_clicked_descending") forState:UIControlStateNormal];
                        weakself.topView.recommendBtn.selected = YES;
                    }else if ([weakself.listorder isEqualToString:@"2"]){
                        weakself.listorder = @"0";
                        [weakself.topView.brandBtn setTitleColor:[Color colorWithHex:@"#666666"] forState:UIControlStateNormal];
                        [weakself.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_unclicked") forState:UIControlStateNormal];
                        weakself.topView.recommendBtn.selected = NO;
                    }
                    weakself.dataIndex = 1;
                    [weakself getDataWithListorder:weakself.listorder andClassId:weakself.class_id page:weakself.dataIndex];
                    
                }
                    break;
                case 1003:
                {
                    if (weakself.dataArr.count == 0) {
                        return;
                    }
                    if (clickBtn.selected == NO) {
                        weakself.listorder = @"3";
                        clickBtn.selected = YES;
                        weakself.topView.recommendBtn.selected = YES;
                    }else{
                        weakself.listorder = @"0";
                        clickBtn.selected = NO;
                        weakself.topView.recommendBtn.selected = NO;
                    }
                    [weakself chooseHiden];
                    weakself.dataIndex = 1;
                    [weakself getDataWithListorder:weakself.listorder andClassId:weakself.class_id page:weakself.dataIndex];
                    [weakself.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_unclicked") forState:UIControlStateNormal];
                    [weakself.topView.brandBtn setTitleColor:[Color colorWithHex:@"666666"] forState:UIControlStateNormal];
                    
                }
                    break;
                    
                default:
                    break;
            }
        };
        [_topView.brandBtn setImage:IMAGE(@"find_button_pricesort_unclicked") forState:UIControlStateNormal];
        
        _topView.hidden = NO;
    }
    return _topView;
}
#pragma mark- btn action
- (void)cancelClick:(UIGestureRecognizer *)sender{
    self.topView.otherBtn.selected = NO;
    self.topView.priceBtn.selected = NO;
    self.topView.recommendBtn.selected = NO;
    self.topView.priceBtn.selected = NO;
    self.topView.otherBtn.selected = NO;
    [self.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_unclicked") forState:UIControlStateNormal];
    [self.topView.brandBtn setTitleColor:[Color colorWithHex:@"666666"] forState:UIControlStateNormal];
    [self chooseHiden];
}

- (void)dismissMoviePlayer
{
    if (self.moviePlayer) {
        [YPC_Tools setStatusBarIsHidden:NO];
        [self.moviePlayer stop];
        [self.moviePlayer.view removeFromSuperview];
        [self.movieCoverBtn removeFromSuperview];
        self.moviePlayer = nil;
        self.movieCoverBtn = nil;
        
        [NotificationCenter removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    }
}
#pragma mark-  筛选栏逻辑
//判断筛选栏是否在下拉状态


// 根据btnType 选择收回View
- (void)chooseHiden{
    if ([self.btnType isEqualToString:@"0"]) {
        return;
    }
    if( [self.btnType isEqualToString:@"2"]){
        [self segBrandViewHiden];
    }
}
//隐藏 筛选品牌
- (void)segBrandViewHiden{
    if (self.bgView.hidden == YES) {
        return;
    }
    WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.bgView.hidden = YES;
        weakSelf.classSegView.tableView.sd_layout.heightIs(0);
        weakSelf.classSegView.sd_layout.heightIs(0);
    }];
    [self.bgView removeGestureRecognizer:_tap];
    self.classSegView = nil;
    self.btnType = @"0";
}
// 展示 筛选品牌
- (void)segBrandViewHidenNo:(NSArray *)arr{
    
    [self.bgView addGestureRecognizer:_tap];
    self.classSegView.dataDic = self.brandDic;
//    CGFloat height = 0;
//    if (arr.count * 80 > 282) {
//        height = 282;
//    }else{
//        height = arr.count * 80;
//    }
    WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.bgView.hidden = NO;
        weakSelf.classSegView.hidden = NO;
        weakSelf.classSegView.sd_layout.heightIs(355);
        weakSelf.classSegView.tableView.sd_layout.heightIs(355);
        
    }];
    
    self.btnType = @"2";
}
- (IBAction)fllowBtnClick:(UIButton *)sender {
    WS(weakSelf);
    [YPCRequestCenter isLoginAndPresentLoginVC:self success:^{        
        if (sender.selected) {
            
            WS(weakSelf);
            [YPC_Tools customAlertViewWithTitle:@"提示:" Message:@"是否取消关注?" BtnTitles:@[@"确认"] CancelBtnTitle:@"取消" DestructiveBtnTitle:nil actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                [weakSelf followstore_cancel:weakSelf.dataModel.storeinfo.store_id];
                sender.selected = NO;
            } cancelHandler:nil destructiveHandler:nil];
        }else{
            [weakSelf followstore_add:weakSelf.dataModel.storeinfo.store_id];
            sender.selected = YES;
        }
    }];
    
}
- (void)followstore_add:(NSString *)store_id{
    [YPCNetworking postWithUrl:@"shop/showstore/followstore/add"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{@"store_id":store_id
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               [YPC_Tools showSvpWithNoneImgHud:@"关注成功"];
                           }
                       }
                          fail:^(NSError *error) {
                              
                          }];
}
- (void)followstore_cancel:(NSString *)store_id{
    
    [YPCNetworking postWithUrl:@"shop/showstore/followstore/cancel"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{@"store_id":store_id
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               [YPC_Tools showSvpWithNoneImgHud:@"取消成功"];
                           }
                       }
                          fail:^(NSError *error) {  
                          }];
}
- (void)shareBtnClick:(UIButton *)sender{
    LiveActivityModel *model = self.dataArr[sender.tag];
    NSString *uid = [YPCRequestCenter shareInstance].model.user_id.length > 0 ? [YPCRequestCenter shareInstance].model.user_id : @"0";
    [YPCShare GoodsShareInWindowWithStraceName:model.strace_title StraceId:model.strace_id image:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:model.strace_content[0]] discount:model.goods_discount price:model.goods_price uid:uid viewController:self];
}

- (IBAction)txBtnClick:(UIButton *)sender {
    __block BOOL isPush = YES;
    WS(weakSelf);
    [self.rt_navigationController.rt_viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj class] isEqual:[LiveDetailHHHVC class]]) {
            [weakSelf.navigationController popToViewController:obj animated:YES];
            isPush = NO;
            *stop = YES;
        }
    }];
    if (isPush) {
        LiveDetailHHHVC *live = [[LiveDetailHHHVC alloc]init];
        live.store_id = self.dataModel.storeinfo.store_id;
        [self.navigationController pushViewController:live animated:YES];
    }
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
