//
//  HomeVC.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/10/31.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "HomeVC.h"
#import <SDCycleScrollView.h>
#import "HomeCell.h"
#import "JPVideoPlayer.h"
#import "BannerModel.h"
#import "WebViewController.h"
#import "HomeTVDetailModel.h"
#import "VideoPlayerVC.h"
#import "LivingVC.h"
#import "PreheatingVC.h"
#import "IndexModel.h"
#import "ShoppingCarVC.h"
#import "TempHomePushModel.h"
#import "DiscoverDetailVC.h"
#import "LiveDetailHHHVC.h"
#import "DiscoverDetailNewVC.h"
#import "ChooseVC.h"
/*
 * 滚动类型
 */
typedef NS_ENUM(NSUInteger, ScrollDerection) {
    ScrollDerectionUp = 1, // 向上滚动
    ScrollDerectionDown = 2 // 向下滚动
};
static BOOL Debug = NO;
@interface HomeVC () <UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate, UITabBarControllerDelegate>
{
    CGFloat rowHeight;
    CGFloat sectionHeight;
    CGFloat tvHeaderViewHeight;
    NSUInteger maxSection;
    BOOL _isFirstCome; // 判断是否
    BOOL _videoIsPlaying; // 判断当前是否播放
    UIButton *_button1;
    UIButton *_button2;
    UIButton *_button3;
    IndexModel *_indexModel1;
    IndexModel *_indexModel2;
    IndexModel *_indexModel3;
    CGFloat willCellHeight;
    CGFloat startCellHeight;
    CGFloat endCellHeight;
}
@property (nonatomic, strong) AFNetworkReachabilityManager *internetReachability;

@property (nonatomic, strong) NSMutableArray *bannerDataArr; // 轮播图数据
@property (nonatomic, strong) NSMutableArray *tableDataArr; // tableview主数据
@property (nonatomic, strong) NSMutableArray *endActivityDataArr; // 结束活动推荐商品数据

@property (nonatomic, strong) UILabel *naviTitleLbl;
@property (nonatomic, strong) UIButton *naviShopCar;
@property (nonatomic, strong) UIButton *naviMesBtn;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet SDCycleScrollView *bannerView;
@property (nonatomic, strong) UIImageView *sectionImgV;

@property (nonatomic, strong) HomeCell *playingCell; // 正在播放视频的cell
@property (nonatomic, strong) NSIndexPath *playingIndexPath; //正在播放cell的indexpath
@property (nonatomic, strong) NSString *currentVideoPath; // 当前播放视频的网络链接地址
@property (nonatomic, assign) ScrollDerection preDerection; // 之前滚动方向类型
@property (nonatomic, assign) ScrollDerection currentDerection; // 当前滚动方向类型
@property (nonatomic, assign) CGFloat contentOffsetY; // 刚开始拖拽时scrollView的偏移量Y值, 用来判断滚动方向

@property (nonatomic, assign) CurrentNetWorkType networkType; // 当前网络type

@end

static NSString *LivingIdentifier =   @"livingCell";
static NSString *PreHeartIdentifier = @"preheartCell";
static NSString *EndIdentifier =      @"endCell";
@implementation HomeVC

#pragma mark - 懒加载
- (NSMutableArray *)bannerDataArr
{
    if (_bannerDataArr) {
        return _bannerDataArr;
    }
    _bannerDataArr = [NSMutableArray array];
    return _bannerDataArr;
}
- (NSMutableArray *)tableDataArr
{
    if (_tableDataArr) {
        return _tableDataArr;
    }
    _tableDataArr = [NSMutableArray array];
    return _tableDataArr;
}
- (NSMutableArray *)endActivityDataArr
{
    if (_endActivityDataArr) {
        return _endActivityDataArr;
    }
    _endActivityDataArr = [NSMutableArray array];
    return _endActivityDataArr;
}

#pragma mark - VC生命周期周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar mz_setBackgroundImage:IMAGE(@"homepage_bar")];
    [self.navigationController.navigationBar mz_setBackgroundColor:[Color colorWithHex:@"#3B3B3B"]];
    [self.navigationController.navigationBar mz_setBackgroundAlpha:0.f];
    self.tabBarController.delegate = self;
    
    sectionHeight = 42.f;
    tvHeaderViewHeight = ScreenHeight / 100 * 29;
    
    [self setupNaviConfig];
    [self configBannerView];
    [self getDataWithBanner];
    [self addMjRefresh];
    
    _videoIsPlaying = NO;
    _isFirstCome = YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.bannerView adjustWhenControllerViewWillAppera];
    if ([YPCRequestCenter isLogin]) {
        self.naviMesBtn.littleRedBadgeValue = [YPCRequestCenter shareInstance].kUnReadMesCount;
        self.naviShopCar.badgeValue = [YPCRequestCenter shareInstance].kShopingCarCount;
        [self getData];
    }
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_videoIsPlaying) {
        if (!Debug) {
            [self stopPlay];
        }
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_isFirstCome) {
        if (!Debug) {
            [self handleScrollStop];
        }
    }
    _isFirstCome = NO;
}

#pragma mark - Config
- (void)setupNaviConfig
{
    self.naviTitleLbl = [UILabel new];
    self.naviTitleLbl.alpha = 0;
    self.naviTitleLbl.text = @"壹品仓-品牌仓储特卖";
    self.naviTitleLbl.font = BoldFont(18);
    self.naviTitleLbl.textColor = [UIColor whiteColor];
    [self.naviTitleLbl sizeToFit];
    self.navigationItem.titleView = self.naviTitleLbl;
    
    self.naviShopCar = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.naviShopCar setImage:IMAGE(@"mine_icon_cart") forState:UIControlStateNormal];
    self.naviShopCar.acceptEventInterval = 1.f;
    [self.naviShopCar sizeToFit];
    [self.naviShopCar addTarget:self
                         action:@selector(shopCarClickAction)
               forControlEvents:UIControlEventTouchUpInside];
    
    self.naviMesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.naviMesBtn setImage:IMAGE(@"mine_icon_inform") forState:UIControlStateNormal];
    self.naviMesBtn.acceptEventInterval = 1.f;
    [self.naviMesBtn sizeToFit];
    [self.naviMesBtn addTarget:self
                        action:@selector(mesBtnClickAction)
              forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *shopCarItem = [[UIBarButtonItem alloc] initWithCustomView:self.naviShopCar];
    UIBarButtonItem *mesItem = [[UIBarButtonItem alloc] initWithCustomView:self.naviMesBtn];
    self.navigationItem.rightBarButtonItem = shopCarItem;
    self.navigationItem.leftBarButtonItem = mesItem;
}
- (void)configBannerView
{
    [self.bannerView setHeight:tvHeaderViewHeight];
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.bannerView.delegate = self;
//    self.bannerView.titlesGroup = titles;
    self.bannerView.autoScrollTimeInterval = 4.f;
    self.bannerView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    self.bannerView.placeholderImage = IMAGE(@"homepage_banner_zhanweitu");
    [self.tableView setTableHeaderView:self.bannerView];
}

#pragma mark - 刷新加载
- (void)addMjRefresh
{
    WS(weakSelf);
    self.tableView.mj_header = [YPCRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf getDataWithBanner];
    }];
}

#pragma mark - 数据获取
- (void)getDataWithBanner
{
    NSString *type = @"";
    switch ([YPCRequestCenter shareInstance].homeStyleType) {
        case homeStyleFemale:
        {
            type = @"2";
        }
            break;
        case homeStyleMale:
        {
            type = @"1";
        }
            break;
        case homeStyleChildren:
        {
            type =@"3";
        }
            break;
        case homeStyleHousehold:
        {
            type = @"4";
        }
            break;
            
        default:
            break;
    }

    WS(weakSelf);
    [YPCNetworking getWithUrl:@"shop/home/data"
                 refreshCache:YES
                       params:@{@"type":type}
                      success:^(id response) {
                          if ([YPC_Tools judgeRequestAvailable:response]) {
                              weakSelf.bannerDataArr = [BannerModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"banners"]];
                              NSMutableArray *bannerImgArr = [NSMutableArray new];
                              for (BannerModel *model in weakSelf.bannerDataArr) {
                                  [bannerImgArr addObject:model.pic];
                              }
                              weakSelf.bannerView.imageURLStringsGroup = bannerImgArr;
                              
                              [self getDataWithTableView];
                          }
                      } fail:^(NSError *error) {
                          YPCAppLog(@"%@", [error description]);
                      }];
}
- (void)getDataWithTableView
{
    WS(weakSelf);
    [YPCNetworking getWithUrl:@"shop/home/activitylist"
                 refreshCache:YES
                       params:@{@"getjson" : [YPCRequestCenter getUserInfoAppendDictionary:@{@"pagination":
                                                                                                 @{
                                                                                                     @"page":@"1",
                                                                                                     @"count":@"30"
                                                                                                     }}]}
                      success:^(id response) {
                          if ([YPC_Tools judgeRequestAvailable:response]) {
                              
                              weakSelf.tableDataArr = [HomeTVDetailModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"activity_list"]];
                              _indexModel1 = [IndexModel mj_objectWithKeyValues:response[@"data"][@"indexs"][@"0"]];
                              _indexModel2 = [IndexModel mj_objectWithKeyValues:response[@"data"][@"indexs"][@"1"]];
                              _indexModel3 = [IndexModel mj_objectWithKeyValues:response[@"data"][@"indexs"][@"2"]];
                              
                              [weakSelf.tableView reloadData];

                              [weakSelf.tableView.mj_header endRefreshing];
                              if (!Debug) {
                                  // 判断是否播放短视频
                                  [weakSelf judgeCurrentNetworkIsAutoPlayVideos];
                                  [weakSelf addNetworkNotifications];
                              }
                          }
                      }
                         fail:^(NSError *error) {
                             YPCAppLog(@"%@", [error description]);
                         }];
}
// 购物车数量
- (void)getData{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/user/notify"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{}]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               NSString *cart = response[@"data"][@"cart_num"];
                               
                               weakSelf.naviShopCar.badgeValue = cart;
                           }
                           
                           
                       }
                          fail:^(NSError *error) {
                              YPCAppLog(@"%@", [error description]);
                          }];
}
#pragma mark - 网络状态判断是否播放视频
- (void)judgeCurrentNetworkIsAutoPlayVideos
{
    self.networkType = [YPCRequestCenter getCurrentNetworkType];
    if (self.networkType == CurrentNetWork3G4G) {
        
    }else if (self.networkType == CurrentNetWorkWifi) {
        // 在可见cell中找第一个有视频的进行播放
        [self playVideoInVisiableCells];
    }else {
        // TODO;
    }
}

#pragma mark - 监测网络状态
- (void)addNetworkNotifications
{
    // 网络状态监控
    [NotificationCenter addObserver:self selector:@selector(reachabilityChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    self.internetReachability = [AFNetworkReachabilityManager sharedManager];
    [self.internetReachability startMonitoring];
}
- (void)reachabilityChanged:(NSNotification *)not
{
    switch (self.internetReachability.networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
            self.networkType = CurrentNetWorkUnknown;
            break;
        case AFNetworkReachabilityStatusNotReachable:
            self.networkType = CurrentNetWorkNotReachable;
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            self.networkType = CurrentNetWork3G4G;
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            self.networkType = CurrentNetWorkWifi;
            break;
        default:
            break;
    }
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableDataArr.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self setupSectionView];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = nil;
    if (indexPath.row <= _indexModel1.count.integerValue - 1) {
        cell = [self judgementActivityTypeWithStringType:_indexModel1.type andTableView:tableView];
    }else if (indexPath.row > _indexModel1.count.integerValue - 1 && indexPath.row <= _indexModel2.count.integerValue + _indexModel1.count.integerValue - 1) {
        cell = [self judgementActivityTypeWithStringType:_indexModel2.type andTableView:tableView];
    }else{
        cell = [self judgementActivityTypeWithStringType:_indexModel3.type andTableView:tableView];
    }
    cell.videoPath = [self.tableDataArr[indexPath.row] video];
    cell.tempModel = self.tableDataArr[indexPath.row];
    cell.indexPath = indexPath;
//    if ([self.playingIndexPath isEqual:indexPath] && cell.autoPlayStyle != NotAutoPlayCellStyle) {
    if ([self.playingIndexPath isEqual:indexPath]) {
        cell.isImgPHViewHidden = YES;
    }else {
        cell.isImgPHViewHidden = NO;
    }
//    if (self.networkType == CurrentNetWorkWifi && cell.autoPlayStyle != NotAutoPlayCellStyle) {
    if (self.networkType == CurrentNetWorkWifi) {
        cell.playBtn.hidden = YES;
    }else {
        cell.playBtn.hidden = NO;
    }

    cell.cellStyle = PlayUnreachCellStyleNone;

    __weak HomeCell *tempCell = cell;
    WS(weakSelf);
    [cell setButtonClickedBlock:^(id object) {
        if ([object isEqualToString:@"play"]) {
            [weakSelf cellPlayVideoActionWithCell:tempCell];
        }else if ([object isEqualToString:@"successRss"]) {
            [[weakSelf.tableDataArr[indexPath.row] store_info] setIsRss:@"1"];
        }else if ([object isEqualToString:@"cancelRss"]) {
            [[weakSelf.tableDataArr[indexPath.row] store_info] setIsRss:@"0"];
        }
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <= _indexModel1.count.integerValue - 1) {
        return [self heightWithActivityTypeWithStringType:_indexModel1.type andTableDataModel:self.tableDataArr[indexPath.row]];
    }else if (indexPath.row > _indexModel1.count.integerValue - 1 && indexPath.row <= _indexModel2.count.integerValue + _indexModel1.count.integerValue - 1) {
        return [self heightWithActivityTypeWithStringType:_indexModel2.type andTableDataModel:self.tableDataArr[indexPath.row]];
    }else{
        return [self heightWithActivityTypeWithStringType:_indexModel3.type andTableDataModel:self.tableDataArr[indexPath.row]];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return sectionHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <= _indexModel1.count.integerValue - 1) {
        [self pushViewControllerActivityTypeWithStringType:_indexModel1.type andDataArr:self.tableDataArr andIndexPath:indexPath];
    }else if (indexPath.row > _indexModel1.count.integerValue - 1 && indexPath.row <= _indexModel2.count.integerValue + _indexModel1.count.integerValue - 1) {
        [self pushViewControllerActivityTypeWithStringType:_indexModel2.type andDataArr:self.tableDataArr andIndexPath:indexPath];
    }else{
        [self pushViewControllerActivityTypeWithStringType:_indexModel3.type andDataArr:self.tableDataArr andIndexPath:indexPath];
    }
}

#pragma mark - scrollViewDelegate
/**
 * 松手时已经静止, 只会调用scrollViewDidEndDragging
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate == NO && self.networkType == CurrentNetWorkWifi) {
        // scrollView已经完全静止
        if (!Debug) {
            [self handleScrollStop];
        }
    }
}
/**
 * 松手时还在运动, 先调用scrollViewDidEndDragging, 再调用scrollViewDidEndDecelerating
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // scrollView已经完全静止
    if (self.networkType == CurrentNetWorkWifi) {
        if (!Debug) {
            [self handleScrollStop];
        }
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.contentOffsetY = scrollView.contentOffset.y;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self handleQuickScroll]; // 处理循环利用
    
    [self AnimationWithSectionViewChangeWithContentOffset:scrollView.contentOffset];
    
    if (self.tableDataArr.count > 0) {
        if (scrollView.contentOffset.y <= sectionHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }else if (scrollView.contentOffset.y >= sectionHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        }
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self handleScrollStop];
}
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return YES;
}

#pragma mark playerMethod
- (void)playVideoInVisiableCells{
    
    NSArray *visiableCells = [self.tableView visibleCells];
    // 在可见cell中找到第一个有视频的cell
    HomeCell *videoCell = nil;
    for (HomeCell *cell in visiableCells) {
        if (cell.videoPath.length > 0) {
            videoCell = cell;
            break;
        }
    }
    // 如果找到了, 就开始播放视频
    if (videoCell) {
        // 播放视频隐藏图片开始播放视频
        [UIView animateWithDuration:1.f animations:^{
            videoCell.nowifiImgPHView.alpha = 0;
        }completion:^(BOOL finished) {
            videoCell.nowifiImgPHView.hidden = YES;
        }];
        self.playingIndexPath = videoCell.indexPath;
        
        self.playingCell = videoCell;
        self.currentVideoPath = videoCell.videoPath;
        JPVideoPlayer *player = [JPVideoPlayer sharedInstance];
        [player playWithUrl:[NSURL URLWithString:videoCell.videoPath] showView:videoCell.containerView];
        player.mute = YES;
        _videoIsPlaying = YES;
    }
}
- (void)handleQuickScroll{
    
    if (!self.playingCell) return;
    
    NSArray *visiableCells = [self.tableView visibleCells];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (HomeCell *cell in visiableCells) {
        [indexPaths addObject:cell.indexPath];
    }
    
    BOOL isPlayingCellVisiable = YES;
    if (![indexPaths containsObject:self.playingCell.indexPath]) {
        isPlayingCellVisiable = NO;
    }
    // 当前播放视频的cell移出视线， 或者cell被快速的循环利用了， 都要移除播放器
    if (!isPlayingCellVisiable || ![self.playingCell.videoPath isEqualToString:self.currentVideoPath]) {
        [self stopPlay];
    }
}

- (void)handleScrollStop{
    // 找到下一个要播放的cell(最在屏幕中心的)
    HomeCell *finnalCell = nil;
    NSArray *visiableCells = [self.tableView visibleCells];
    NSMutableArray *indexPaths = [NSMutableArray array];
    CGFloat gap = MAXFLOAT;
    
    for (HomeCell *cell in visiableCells) {
        [indexPaths addObject:cell.indexPath];
        if (cell.videoPath.length > 0) { // 如果这个cell有视频
            // 优先查找滑动不可及cell
            if (cell.cellStyle != PlayUnreachCellStyleNone) {
                // 并且不可及cell要全部露出
                if (cell.cellStyle == PlayUnreachCellStyleUp) {
                    CGPoint cellLeftUpPoint = cell.frame.origin;
                    // 不要在边界上
                    cellLeftUpPoint.y += 1;
                    CGPoint coorPoint = [cell.superview convertPoint:cellLeftUpPoint toView:nil];
                    CGRect windowRect = self.view.window.bounds;
                    BOOL isContain = CGRectContainsPoint(windowRect, coorPoint);
                    if (isContain) {
                        finnalCell = cell;
                    }
                }
                else if (cell.cellStyle == PlayUnreachCellStyleDown){
                    CGPoint cellLeftUpPoint = cell.frame.origin;
                    cellLeftUpPoint.y += cell.bounds.size.height;
                    // 不要在边界上
                    cellLeftUpPoint.y -= 1;
                    CGPoint coorPoint = [cell.superview convertPoint:cellLeftUpPoint toView:nil];
                    CGRect windowRect = self.view.window.bounds;
                    BOOL isContain = CGRectContainsPoint(windowRect, coorPoint);
                    if (isContain) {
                        finnalCell = cell;
                    }
                }
            }
            else if(!finnalCell || finnalCell.cellStyle == PlayUnreachCellStyleNone){
                CGPoint coorCentre = [cell.superview convertPoint:cell.center toView:nil];
                CGFloat delta = fabs(coorCentre.y-[UIScreen mainScreen].bounds.size.height*0.5);
                if (delta < gap) {
                    gap = delta;
                    finnalCell = cell;
                }
            }
        }
    }
    // 注意, 如果正在播放的cell和finnalCell是同一个cell, 不应该在播放
//    if (self.playingCell != finnalCell && finnalCell != nil && finnalCell.autoPlayStyle != NotAutoPlayCellStyle) {
    if (self.playingCell != finnalCell && finnalCell != nil && finnalCell.autoPlayStyle) {
        self.playingCell.nowifiImgPHView.hidden = NO;
        [UIView animateWithDuration:.2f animations:^{
            self.playingCell.nowifiImgPHView.alpha = 1;
            finnalCell.nowifiImgPHView.alpha = 0;
        }completion:^(BOOL finished) {
            finnalCell.nowifiImgPHView.hidden = YES;
        }];
        if (self.networkType == CurrentNetWorkWifi) {
            finnalCell.playBtn.hidden = YES;
        }else {
            self.playingCell.playBtn.hidden = NO;
        }
        self.playingIndexPath = finnalCell.indexPath;
        [[JPVideoPlayer sharedInstance] playWithUrl:[NSURL URLWithString:finnalCell.videoPath] showView:finnalCell.containerView];
        self.playingCell = finnalCell;
        self.currentVideoPath = finnalCell.videoPath;
        [JPVideoPlayer sharedInstance].mute = YES;
        _videoIsPlaying = YES;
        return;
    }
    // 再看正在播放视频的那个cell移出视野, 则停止播放
    BOOL isPlayingCellVisiable = YES;
    if (![indexPaths containsObject:self.playingCell.indexPath]) {
        isPlayingCellVisiable = NO;
    }
    if (!isPlayingCellVisiable && self.playingCell) {
        [self stopPlay];
    }
}
-(void)stopPlay{
    [[JPVideoPlayer sharedInstance] stop];
    self.playingCell.nowifiImgPHView.hidden = NO;
    [UIView animateWithDuration:.2f animations:^{
        self.playingCell.nowifiImgPHView.alpha = 1;
    }];
    if (self.networkType == CurrentNetWorkWifi) {
        self.playingCell.playBtn.hidden = YES;
    }else {
        self.playingCell.playBtn.hidden = NO;
    }
    self.playingIndexPath = nil;
    
    self.playingCell = nil;
    self.currentVideoPath = nil;
    _videoIsPlaying = NO;
}

#pragma mark - BannerViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    BannerModel *model = self.bannerDataArr[index];
    BannerDetailModel *detailModel = model.param;
        switch ([YPC_Tools judgementUrlSechmeTypeWithUrlString:(NSString *)[self.bannerDataArr[index] url]]) {
        case urlSechmeWebView:
            [self pushWebViewAction:index]; // 加载网页
            break;
        case urlSechmeGoodsDetail:
        {
            DiscoverDetailVC *discoverDetail = [[DiscoverDetailVC alloc]init];
            discoverDetail.strace_id = detailModel.data.strace_id;
            discoverDetail.live_id = @"";
            if ([detailModel.type isEqualToString:@"livegoods"]) {
                discoverDetail.typeStr = @"淘好货";
            }else{
                discoverDetail.typeStr = @"品牌";
            }
            discoverDetail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:discoverDetail animated:YES];
        }
            
            break;
        case urlSechmeActivityDeatail:
            [YPC_Tools customAlertViewWithTitle:@"Tip"
                                        Message:@"活动详情"
                                      BtnTitles:nil
                                 CancelBtnTitle:nil
                            DestructiveBtnTitle:@"确定"
                                  actionHandler:nil
                                  cancelHandler:nil
                             destructiveHandler:nil];
            break;
        case urlSechmeLivingGroupDetail:
        {
            LiveDetailHHHVC *live = [[LiveDetailHHHVC alloc]init];
            live.store_id = detailModel.data.store_id;
            live.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:live animated:YES];
        }
            break;
        case urlSechmeBrandDetail:
        {
            DiscoverDetailNewVC *dis = [[DiscoverDetailNewVC alloc]init];
            dis.live_id = detailModel.data.live_id;
            dis.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:dis animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - bannerClickAction
- (void)pushWebViewAction:(NSInteger)atIndex
{
    WebViewController *webVC = [WebViewController new];
    webVC.navTitle = [self.bannerDataArr[atIndex] adv_title];
    webVC.homeUrl = [NSString stringWithFormat:@"%@",[self.bannerDataArr[atIndex] url]];
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - BtnClickAction
- (void)shopCarClickAction
{
    if ([YPCRequestCenter isLoginAndPresentLoginVC:self]) {
        ShoppingCarVC *carVC = [ShoppingCarVC new];
        carVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:carVC animated:YES];
    }
}
- (void)mesBtnClickAction
{
    if ([YPCRequestCenter isLoginAndPresentLoginVC:self]) {
        [YPC_Tools pushConversationListViewController:self];
    }
}
- (void)sectionBtnClickAction:(UIButton *)btn
{
    if (btn.tag == 1000) {
        [self stopPlay];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else if (btn.tag == 1001) {
        [self stopPlay];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_indexModel1.count.integerValue inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else if (btn.tag == 1002) {
        [self stopPlay];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_indexModel1.count.integerValue + _indexModel2.count.integerValue inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark - Private Method
/*!
 *
 *    判断tableviewCell类型
 *
 */
- (HomeCell *)judgementActivityTypeWithStringType:(NSString *)type andTableView:(UITableView *)tableView
{
    if ([type isEqualToString:KEY_Will_Activity]) {
        HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:PreHeartIdentifier];
        if (!cell) {
            cell = (HomeCell *)[[NSBundle  mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil][1];
        }
        cell.autoPlayStyle = CanAutoPlayCellStyle;
        return cell;
    }else if ([type isEqualToString:KEY_Start_Activity]) {
        HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:LivingIdentifier];
        if (!cell) {
            cell = (HomeCell *)[[[NSBundle  mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil]  firstObject];
        }
        cell.autoPlayStyle = CanAutoPlayCellStyle;
        return cell;
    }else if ([type isEqualToString:KEY_End_Activity]) {
        HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:EndIdentifier];
        if (!cell) {
            cell = (HomeCell *)[[[NSBundle  mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil]  lastObject];
        }
        cell.autoPlayStyle = NotAutoPlayCellStyle;
        return cell;
    }else {
        return nil;
    }
}
/*!
 *
 *    根据cell类型判断cell高度
 *
 */
- (CGFloat)heightWithActivityTypeWithStringType:(NSString *)type andTableDataModel:(HomeTVDetailModel *)model
{
    if ([type isEqualToString:KEY_Will_Activity]) {
        willCellHeight = ScreenWidth / 100 * 71 + 147.5f;
        return willCellHeight;
    }else if ([type isEqualToString:KEY_Start_Activity]) {
        startCellHeight = ScreenWidth / 100 * 71 + 94.5f;
        return startCellHeight;
    }else if ([type isEqualToString:KEY_End_Activity]) {
        if (model.goods_data.count > 0) {
            endCellHeight = ScreenWidth / 100 * 71 + 97.f + 160.f;
            return endCellHeight;
        }else {
            endCellHeight = ScreenWidth / 100 * 71 + 97.f;
            return endCellHeight;
        }
    }else {
        return 0;
    }
}
/*!
 *
 *    根据cell类型, push对应VC
 *
 */
- (void)pushViewControllerActivityTypeWithStringType:(NSString *)type andDataArr:(NSArray *)dataArr andIndexPath:(NSIndexPath *)indexPath
{
    if ([type isEqualToString:KEY_Will_Activity]) {
        PreheatingVC *pVC = [PreheatingVC new];
        
        TempHomePushModel *model = [TempHomePushModel new];
        [model setLive_id:[(HomeTVDetailModel *)dataArr[indexPath.row] live_id]];
        [model setLive_msg:[dataArr[indexPath.row] store_info].live_msg];
        [model setStarttime:[dataArr[indexPath.row] starttime]];
        [model setEndtime:[dataArr[indexPath.row] endtime]];
        [model setActivity_pic:[dataArr[indexPath.row] activity_pic]];
        [model setStart:[(HomeTVDetailModel *)dataArr[indexPath.row] start]];
        [model setEnd:[(HomeTVDetailModel *)dataArr[indexPath.row] end]];
        [model setAddress:[(HomeTVDetailModel *)dataArr[indexPath.row] address]];
        [model setName:[(HomeTVDetailModel *)dataArr[indexPath.row] name]];
        [model setStore_avatar:[dataArr[indexPath.row] store_info].store_avatar];
        [model setStore_name:[dataArr[indexPath.row] store_info].store_name];
        
        pVC.tempModel = model;
        pVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pVC animated:YES];
    }else if ([type isEqualToString:KEY_Start_Activity]) {
        if ([YPCRequestCenter isLoginAndPresentLoginVC:self]) {
            WS(weakSelf);
            [YPC_Tools showSvpHud];
            LivingVC *lVC = [LivingVC new];
            
            TempHomePushModel *model = [TempHomePushModel new];
            [model setLive_id:[dataArr[indexPath.row] live_id]];
            [model setStore_avatar:[dataArr[indexPath.row] store_info].store_avatar];
            [model setStore_name:[dataArr[indexPath.row] store_info].store_name];
            [model setAnnouncement_id:[dataArr[indexPath.row] announcement_id]];
            [model setStore_id:[dataArr[indexPath.row] store_info].store_id];
            lVC.tempModel = model;
            
            lVC.hidesBottomBarWhenPushed = YES;
            [[SDWebImageDownloader sharedDownloader]
             downloadImageWithURL:[NSURL URLWithString:[self.tableDataArr[indexPath.row] livingshowinitimg]]
             options:SDWebImageDownloaderUseNSURLCache
             progress:nil
             completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                 if (finished && !error) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         lVC.playerPHImg = image;
                         [weakSelf.navigationController pushViewController:lVC animated:YES];
                         [YPC_Tools dismissHud];
                     });
                 }else {
                     [YPC_Tools showSvpHudError:@"图片未下载成功"];
                 }
             }];
        }
    }else if ([type isEqualToString:KEY_End_Activity]) {
        VideoPlayerVC *vVC = [VideoPlayerVC new];
        TempHomePushModel *model = [TempHomePushModel new];
        [model setLive_id:[dataArr[indexPath.row] live_id]];
        [model setLive_state:[(HomeTVDetailModel *)dataArr[indexPath.row] state]];
        [model setStore_avatar:[dataArr[indexPath.row] store_info].store_avatar];
        [model setStore_name:[dataArr[indexPath.row] store_info].store_name];
        [model setVideo:[dataArr[indexPath.row] video]];
        vVC.tempModel = model;
        vVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vVC animated:YES];
    }
}
/*!
 *
 *    创建tableview SectionView
 *
 */
- (UIImageView *)setupSectionView
{
    if (_indexModel1 && _indexModel2 && _indexModel3) {
        
        self.sectionImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 42.f)];
        self.sectionImgV.userInteractionEnabled = YES;
        if ([YPCRequestCenter shareInstance].homeStyleType == homeStyleMale) {
            self.sectionImgV.image = IMAGE(@"homepage_man_live_button");
        }else if ([YPCRequestCenter shareInstance].homeStyleType == homeStyleFemale) {
            self.sectionImgV.image = IMAGE(@"homepage_woman_live_button");
        }else if ([YPCRequestCenter shareInstance].homeStyleType == homeStyleChildren) {
            self.sectionImgV.image = IMAGE(@"homepage_children_live_button");
        }else if ([YPCRequestCenter shareInstance].homeStyleType == homeStyleHousehold) {
            self.sectionImgV.image = IMAGE(@"homepage_home_live_button");
        }
        
        _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button1.acceptEventInterval = 1.f;
        _button1.frame = CGRectMake(0, 0, ScreenWidth / 3, 42.f);
        _button1.titleLabel.font = BoldFont(16);
//        [_button1 setTitleColor:[YPCRequestCenter shareInstance].homeStyleType == homeStyleChildren ? [UIColor blackColor] : [Color colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
         [_button1 setTitleColor:[Color colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
        [_button1 setTitle:_indexModel1.name forState:UIControlStateNormal];
        [_button1 addTarget:self action:@selector(sectionBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.sectionImgV addSubview:_button1];
        _button1.tag = 1000;
        
        _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button2.acceptEventInterval = 1.f;
        _button2.frame = CGRectMake(ScreenWidth / 3, 0, ScreenWidth / 3, 42.f);
        _button2.titleLabel.font = LightFont(16);
        [_button2 setTitleColor:[Color colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
        [_button2 setTitle:_indexModel2.name forState:UIControlStateNormal];
        [_button2 addTarget:self action:@selector(sectionBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.sectionImgV addSubview:_button2];
        _button2.tag = 1001;
        
        _button3 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button3.acceptEventInterval = 1.f;
        _button3.frame = CGRectMake(ScreenWidth / 3 * 2, 0, ScreenWidth / 3, 42.f);
        _button3.titleLabel.font = LightFont(16);
        [_button3 setTitleColor:[Color colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
        [_button3 setTitle:_indexModel3.name forState:UIControlStateNormal];
        [_button3 addTarget:self action:@selector(sectionBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.sectionImgV addSubview:_button3];
        _button3.tag = 1002;
        
        [self animationWithButton];
        
        return self.sectionImgV;
    }else {
        return nil;
    }
}
/*!
 *
 *    section类型对应切换动画
 *
 */
- (void)AnimationWithSectionViewChangeWithContentOffset:(CGPoint)point
{
    if (point.y > tvHeaderViewHeight - 64) {
        CGFloat alpha = MIN(1, 1 - ((tvHeaderViewHeight - point.y) / 64));
        [self.navigationController.navigationBar mz_setBackgroundAlpha:alpha];
        self.naviTitleLbl.alpha = alpha;
    }else{
        [self.navigationController.navigationBar mz_setBackgroundAlpha:0.f];
        self.naviTitleLbl.alpha = 0.f;
    }
    
    CGFloat h1 = [self getCellHeightWithIndexModel:_indexModel1];
    CGFloat h2 = [self getCellHeightWithIndexModel:_indexModel2];
//    CGFloat h3 = [self getCellHeightWithIndexModel:_indexModel3];
    
    if (point.y < h1) {
        if (![[self getTypeImageWithIndexModel:_indexModel1] isEqual:self.sectionImgV.image]) {
//            CATransition *transition = [CATransition animation];
//            transition.type = @"cube";
//            transition.duration = .3f;
//            transition.repeatCount = 1;
//            transition.subtype = kCATransitionFromTop;
//            [self.sectionImgV.layer addAnimation:transition forKey:@"AnimationCube"];
            self.sectionImgV.image = [self getTypeImageWithIndexModel:_indexModel1];
            _button1.titleLabel.font = BoldFont(16);
            _button2.titleLabel.font = LightFont(16);
            _button3.titleLabel.font = LightFont(16);
//            [_button1 setTitleColor:[YPCRequestCenter shareInstance].homeStyleType == homeStyleChildren ? [UIColor blackColor] : [Color colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
//            [_button2 setTitleColor:[YPCRequestCenter shareInstance].homeStyleType == homeStyleChildren ? [UIColor blackColor] : [Color colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
//            [_button3 setTitleColor:[YPCRequestCenter shareInstance].homeStyleType == homeStyleChildren ? [UIColor blackColor] : [Color colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
        }
    }else if (point.y > h1 && point.y < h1 + h2) {
        if (![[self getTypeImageWithIndexModel:_indexModel2] isEqual:self.sectionImgV.image]) {
//            CATransition *transition = [CATransition animation];
//            transition.type = @"cube";
//            transition.duration = .3f;
//            transition.repeatCount = 1;
//            transition.subtype = kCATransitionFromTop;
//            [self.sectionImgV.layer addAnimation:transition forKey:@"AnimationCube"];
            self.sectionImgV.image = [self getTypeImageWithIndexModel:_indexModel2];
            _button1.titleLabel.font = LightFont(16);
            _button2.titleLabel.font = BoldFont(16);
            _button3.titleLabel.font = LightFont(16);
//            [_button1 setTitleColor:[Color colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
//            [_button2 setTitleColor:[Color colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
//            [_button3 setTitleColor:[Color colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
        }
    }else{
        if (![[self getTypeImageWithIndexModel:_indexModel3] isEqual:self.sectionImgV.image]) {
//            CATransition *transition = [CATransition animation];
//            transition.type = @"cube";
//            transition.duration = .3f;
//            transition.repeatCount = 1;
//            transition.subtype = kCATransitionFromTop;
//            [self.sectionImgV.layer addAnimation:transition forKey:@"AnimationCube"];
            self.sectionImgV.image = [self getTypeImageWithIndexModel:_indexModel3];
            _button1.titleLabel.font = LightFont(16);
            _button2.titleLabel.font = LightFont(16);
            _button3.titleLabel.font = BoldFont(16);
//            [_button1 setTitleColor:[Color colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
//            [_button2 setTitleColor:[Color colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
//            [_button3 setTitleColor:[Color colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
        }
    }
}
/*!
 *
 *    根据不同indexModel类型  
 *    return 相应偏移量
 *
 */
- (CGFloat)getCellHeightWithIndexModel:(IndexModel *)model
{
    if ([model.type isEqualToString:KEY_Will_Activity]) {
        return willCellHeight * model.count.integerValue;
    }else if ([model.type isEqualToString:KEY_Start_Activity]) {
        return startCellHeight * model.count.integerValue;
    }else if ([model.type isEqualToString:KEY_End_Activity]) {
        return endCellHeight * model.count.integerValue;
    }else {
        return 0.f;
    }
}
/*!
 *
 *    根据不同indexModel类型
 *    return 相应image
 *
 */
- (UIImage *)getTypeImageWithIndexModel:(IndexModel *)model
{
    if ([model.type isEqualToString:KEY_Will_Activity]) {
        if ([YPCRequestCenter shareInstance].homeStyleType == homeStyleChildren) {
            return IMAGE(@"homepage_childen_advance_button");
        }else {
            return IMAGE(@"homepage_womanhome_advance_button");
        }
    }else if ([model.type isEqualToString:KEY_Start_Activity]) {
        if ([YPCRequestCenter shareInstance].homeStyleType == homeStyleMale) {
            return IMAGE(@"homepage_man_live_button");
        }else if ([YPCRequestCenter shareInstance].homeStyleType == homeStyleFemale) {
            return IMAGE(@"homepage_woman_live_button");
        }else if ([YPCRequestCenter shareInstance].homeStyleType == homeStyleChildren) {
            return IMAGE(@"homepage_children_live_button");
        }else if ([YPCRequestCenter shareInstance].homeStyleType == homeStyleHousehold) {
            return IMAGE(@"homepage_home_live_button");
        }else {
            return nil;
        }
    }else if ([model.type isEqualToString:KEY_End_Activity]) {
        if ([YPCRequestCenter shareInstance].homeStyleType == homeStyleChildren) {
            return IMAGE(@"homepage_childen_over_button");
        }else{
            return IMAGE(@"homepage_home_over_button");
        }
    }else {
        return nil;
    }
}
/*!
 *
 *    点击播放按钮播放视频
 *
 */
- (void)cellPlayVideoActionWithCell:(HomeCell *)cell
{
    WS(weakSelf);
    if (self.networkType == CurrentNetWork3G4G) {
        [YPC_Tools customAlertViewWithTitle:nil
                                    Message:@"正在使用流量播放视频"
                                  BtnTitles:nil
                             CancelBtnTitle:@"取消"
                        DestructiveBtnTitle:@"确定"
                              actionHandler:nil
                              cancelHandler:nil
                         destructiveHandler:^(LGAlertView *alertView) {
                             
                             [weakSelf videoPlayingWithCell:cell];
                         }];
    }else {
        [self videoPlayingWithCell:cell];
    }
}
- (void)videoPlayingWithCell:(HomeCell *)tempCell
{
    [[JPVideoPlayer sharedInstance] playWithUrl:[NSURL URLWithString:tempCell.videoPath] showView:tempCell.containerView];
    self.playingCell = tempCell;
    self.currentVideoPath = tempCell.videoPath;
    [JPVideoPlayer sharedInstance].mute = YES;
    _videoIsPlaying = YES;
    // 播放视频隐藏图片开始播放视频
    [UIView animateWithDuration:.2f animations:^{
        tempCell.nowifiImgPHView.alpha = 0;
    }completion:^(BOOL finished) {
        tempCell.nowifiImgPHView.hidden = YES;
    }];
}

/*!
 *
 *    直播中动效
 *
 */
- (void)animationWithButton
{
    [_button1 setImage:IMAGE(@"homepage_icon_live1_children") forState:UIControlStateNormal];
    [_button1 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    NSArray *images = [[NSArray alloc] init];
//    if ([YPCRequestCenter shareInstance].homeStyleType == homeStyleChildren) {
    //        images = [NSArray arrayWithObjects:
    //                  IMAGE(@"homepage_icon_live1_children"),
    //                  IMAGE(@"homepage_icon_live2_children"),
    //                  IMAGE(@"homepage_icon_live3_children"),
    //                  nil];
    //    }else{
    images = [NSArray arrayWithObjects:
              IMAGE(@"homepage_icon_live1"),
              IMAGE(@"homepage_icon_live2"),
              IMAGE(@"homepage_icon_live3"),
              nil];
//    }
    _button1.imageView.animationImages = images;
    _button1.imageView.animationDuration = .5f;
    _button1.imageView.animationRepeatCount = 0;
    [_button1.imageView startAnimating];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    UIViewController *selectTab = tabBarController.selectedViewController;
    if ([selectTab isEqual:viewController] && tabBarController.selectedIndex == 0) {
        WS(weakSelf);
        ChooseVC *cVC = [ChooseVC new];
        cVC.isChangeHomeStyle = YES;
        [cVC setChangeStyleBlock:^{
            [weakSelf.tableView.mj_header beginRefreshing];
        }];
        [self presentViewController:cVC animated:YES completion:nil];
    }
    return YES;
}

@end
