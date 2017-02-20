//
//  PreheatingVC.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/16.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "PreheatingVC.h"
#import "PreheatingModel.h"
#import "TimeCutdownView.h"
#import "PreheatingCell.h"
#import "Pre_stracesModel.h"
#import "PreheatingGoodsModel.h"
#import "shortVideoCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "preGoodsCell.h"
#import "DiscoverDetailVC.h"
#import "PreheatingDetailVC.h"
#import "LiveDetailHHHVC.h"

static NSString *PhotoIdentifier = @"photoPreheadtingCell";
static NSString *VideoIdentifier = @"videoPreheadtingCell";
static NSString *PreGoodsIdentifier = @"goodsPreheadtingCell";
@interface PreheatingVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PreheatingModel *dataModel;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet UITableView *preGoodsTableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *preGoodsTVConstraint;
@property (strong, nonatomic) IBOutlet TimeCutdownView *cutdownV;
@property (strong, nonatomic) IBOutlet UIButton *followBtn;
@property (strong, nonatomic) IBOutlet UIView *tableViewHeaderV;
@property (strong, nonatomic) IBOutlet UIView *tableFooterV;
@property (strong, nonatomic) IBOutlet UILabel *footerLabel;
@property (strong, nonatomic) IBOutlet UIImageView *headImgV;
@property (strong, nonatomic) IBOutlet UILabel *nameL;
@property (strong, nonatomic) IBOutlet UILabel *describeL;
@property (strong, nonatomic) IBOutlet UIImageView *bigImgV;
@property (strong, nonatomic) IBOutlet UILabel *timeL;
@property (strong, nonatomic) IBOutlet UILabel *addressL;

@property (nonatomic, strong) NSMutableArray *mainDataArr;
@property (nonatomic, strong) NSMutableArray *goodsDataArr;

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic) UIButton *movieCoverBtn;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@property (strong, nonatomic) IBOutlet UIView *preTitleView;


@end

@implementation PreheatingVC

- (void)dealloc
{
    YPCAppLog(@"dealloc");
}

- (NSMutableArray *)mainDataArr
{
    if (_mainDataArr) {
        return _mainDataArr;
    }
    _mainDataArr = [NSMutableArray array];
    return _mainDataArr;
}

- (NSMutableArray *)goodsDataArr
{
    if (_goodsDataArr) {
        return _goodsDataArr;
    }
    _goodsDataArr = [NSMutableArray array];
    return _goodsDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar mz_setBackgroundImage:IMAGE(@"homepage_bar")];
    [self.navigationController.navigationBar mz_setBackgroundColor:[Color colorWithHex:@"#3B3B3B"]];
    [self.navigationController.navigationBar mz_setBackgroundAlpha:0.f];
    
    [self.mainTableView registerClass:[PreheatingCell class] forCellReuseIdentifier:PhotoIdentifier];
    [self.mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([shortVideoCell class]) bundle:nil] forCellReuseIdentifier:VideoIdentifier];
    [self.preGoodsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([preGoodsCell class]) bundle:nil] forCellReuseIdentifier:PreGoodsIdentifier];
    
    [self configNaviRightBtn];
    [self getDataWithWillActivityDetail];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Data数据
- (void)getDataWithWillActivityDetail
{
    WS(weakSelf);
    [YPCNetworking postWithUrl:@"shop/activity/willactivitydetail"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"live_id" : self.liveId
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.dataModel = [PreheatingModel mj_objectWithKeyValues:response[@"data"]];
                               weakSelf.mainDataArr = [Pre_stracesModel mj_objectArrayWithKeyValuesArray:weakSelf.dataModel.pre_straces];
                               // 更新头部视图
                               if (weakSelf.mainDataArr.count > 0) {
                                   weakSelf.tableViewHeaderV.height += 42.f;
                                   [weakSelf.mainTableView setTableHeaderView:self.tableViewHeaderV];
                                   weakSelf.preTitleView.hidden = NO;
                               }
                               [weakSelf.mainTableView reloadData];
                               
                               [weakSelf getDataWithPreHeatingGoods];
                               
                               [weakSelf DataForviewConfig];
                               
                               // 设置navigation标题
                               weakSelf.title = weakSelf.dataModel.live_info.name;
                           }
                       }
                          fail:^(NSError *error) {
                              
                          }];
}
- (void)getDataWithPreHeatingGoods
{
    WS(weakSelf);
    [YPCNetworking postWithUrl:@"shop/activity/pregoodslist"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"live_id" : self.liveId
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.goodsDataArr = [PreheatingGoodsModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                               if (weakSelf.goodsDataArr.count > 0) {
                                   [weakSelf.preGoodsTableView reloadData];
                                   [weakSelf.tableFooterV setHeight:57 + 90 * self.goodsDataArr.count];
                                   weakSelf.preGoodsTVConstraint.constant = 90 * self.goodsDataArr.count;
                                   [weakSelf.view updateConstraints];
                                   [weakSelf.mainTableView setTableFooterView:weakSelf.tableFooterV];
                                   weakSelf.footerLabel.hidden = NO;
                                   weakSelf.tableFooterV.hidden = NO;
                               }else {
                                   [weakSelf.tableFooterV setHeight:0];
                                   weakSelf.preGoodsTVConstraint.constant = 0;
                                   [weakSelf.view updateConstraints];
                                   [weakSelf.mainTableView setTableFooterView:weakSelf.tableFooterV];
                                   weakSelf.footerLabel.hidden = YES;
                                   weakSelf.tableFooterV.hidden = YES;
                               }
                           }
                       }
                          fail:^(NSError *error) {
                              
                          }];
}

#pragma mark - 视图相关配置
- (void)DataForviewConfig
{
    // tableView头部视图
    [self.tableViewHeaderV setHeight:73.f + ScreenWidth / 375 * 188];
    [self.mainTableView setTableHeaderView:self.tableViewHeaderV];
    
    // 定时器
    [self.cutdownV startTime:self.dataModel.live_info.starttime endTime:self.dataModel.live_info.endtime];
    
    // 头部视图添加数据
    [self.headImgV sd_setImageWithURL:[NSURL URLWithString:self.dataModel.live_info.store_avatar] placeholderImage:YPCImagePlaceHolder];
    self.nameL.text = self.dataModel.live_info.store_name;
    self.describeL.text = self.dataModel.live_info.store_collect;
    [self.bigImgV sd_setImageWithURL:[NSURL URLWithString:self.dataModel.live_info.activity_pic] placeholderImage:IMAGE(@"live_zhanweitu2")];
    self.timeL.text = [NSString stringWithFormat:@"%@-%@", [YPC_Tools timeWithTimeIntervalString:self.dataModel.live_info.start Format:@"MM月dd日"], [YPC_Tools timeWithTimeIntervalString:self.dataModel.live_info.end Format:@"MM月dd日"]];
    self.addressL.text = self.dataModel.live_info.address;
    if ([self.dataModel.live_info.isfollowSeller isEqualToString:@"0"]) {
        self.followBtn.selected = NO;
    }else{
        self.followBtn.selected = YES;
    }
    // 头像添加手势
    UITapGestureRecognizer *avatorTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookGroupInfoAction:)];
    [self.headImgV addGestureRecognizer:avatorTap];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.mainTableView) {
        return self.mainDataArr.count;
    }else {
        return self.goodsDataArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView) {
        if ([[self.mainDataArr[indexPath.row] content_type] integerValue] == 2) {
            shortVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:VideoIdentifier];
            cell.tempModel = self.mainDataArr[indexPath.row];
            WS(weakSelf);
            [cell setButtonClickedBlock:^(id object) {
                if ([object isEqualToString:@"play"]) {
                    [weakSelf videoPlayActionWithURL:[NSURL URLWithString:[weakSelf.mainDataArr[indexPath.row] video]]];
                }
            }];
            return cell;
        }else {
            PreheatingCell *cell = [tableView dequeueReusableCellWithIdentifier:PhotoIdentifier];
            cell.tempModel = self.mainDataArr[indexPath.row];
            [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            return cell;
        }
    }else {
        preGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:PreGoodsIdentifier];
        cell.tempModel = self.goodsDataArr[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView) {
        if ([[self.mainDataArr[indexPath.row] content_type] integerValue] == 2) {
            return ScreenWidth > 320 ? 170 + 88 : 150 + 88;
        }else {
            Pre_stracesModel *model = self.mainDataArr[indexPath.row];
            return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"tempModel" cellClass:[PreheatingCell class]  contentViewWidth:ScreenWidth];
        }
    }else {
        return 100.f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakself);
    if (tableView == self.mainTableView) {
        PreheatingDetailVC *detailVC = [PreheatingDetailVC new];
        detailVC.detailType = detailStylePerhearting;
        Pre_stracesModel *model = self.mainDataArr[indexPath.row];
        detailVC.tempStrace_ID = [self.mainDataArr[indexPath.row] strace_id];
        detailVC.backBlock = ^(NSString *likeCount,NSString *isLike,NSString *comment){
            model.strace_cool = likeCount;
            model.strace_comment = comment;
            [weakself.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:detailVC animated:YES];
    }else {
        DiscoverDetailVC *detailVC = [DiscoverDetailVC new];
        detailVC.live_id = self.liveId;
        detailVC.strace_id = [self.goodsDataArr[indexPath.row] strace_id];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    if (point.y > 50 + ScreenWidth * 150 / 375 - 64.f) {
        CGFloat alpha = MIN(1, 1 - ((50 + ScreenWidth * 150 / 375 - point.y) / 64));
        [self.navigationController.navigationBar mz_setBackgroundAlpha:alpha];
        self.navigationItem.title = self.dataModel.live_info.store_name;
    }else{
        [self.navigationController.navigationBar mz_setBackgroundAlpha:0.f];
        self.navigationItem.title = @"";
    }
}

#pragma mark - 播放上方广告视频
- (IBAction)playBrandVideoAction:(UIButton *)sender {
    if (![self.dataModel.live_info.video isEmpty]) {
        [self videoPlayActionWithURL:[NSURL URLWithString:self.dataModel.live_info.video]];
    }else {
        [YPC_Tools showSvpWithNoneImgHud:@"暂无视频~"];
    }
}

#pragma mark - 播放视频
- (void)videoPlayActionWithURL:(NSURL *)url
{
    if (url) {
        // 设置视频播放器
        self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
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
        [self.moviePlayer.view addSubview:self.loadingView];
        [self.loadingView startAnimating];
        
        [YPC_Tools setStatusBarIsHidden:YES];
    }else {
        [YPC_Tools showSvpHudError:@"无法播放视频"];
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

#pragma mark - Navi右按钮
- (void)configNaviRightBtn
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:IMAGE(@"mshare_button") forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self
               action:@selector(naviRightAction:)
     forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = shareItem;
}

- (void)naviRightAction:(UIButton *)sender
{
    NSString *uid = [YPCRequestCenter shareInstance].model.user_id.length > 0 ? [YPCRequestCenter shareInstance].model.user_id : @"0";
    [YPCShare WillActivityShareInWindowWithName:self.dataModel.live_info.store_name
                                      StartTime:self.dataModel.live_info.starttime
                                         LiveID:self.liveId
                                          image:self.bigImgV.image
                                      brandName:self.dataModel.live_info.name
                                        endTime:self.dataModel.live_info.endtime
                                            uid:uid
                                 viewController:self];
}
- (IBAction)followBtnClick:(UIButton *)sender {
    WS(weakSelf);
    [YPCRequestCenter isLoginAndPresentLoginVC:[YPC_Tools getControllerWithView:self] success:^{
        if (sender.selected) {
            
            [YPC_Tools customAlertViewWithTitle:@"提示:" Message:@"是否取消关注" BtnTitles:@[@"确认"] CancelBtnTitle:@"取消" DestructiveBtnTitle:@"" actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                [weakSelf followstore_cancel:weakSelf.dataModel.live_info.store_id];
                sender.selected = NO;
            } cancelHandler:^(LGAlertView *alertView) {
                
            } destructiveHandler:nil];
            
        }else{
            sender.selected = YES;
            [weakSelf followstore_add:weakSelf.dataModel.live_info.store_id];
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
- (void)lookGroupInfoAction:(UITapGestureRecognizer *)tap
{
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
        live.store_id = self.dataModel.live_info.store_id;
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
