//
//  HomeVC.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/10/31.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "HomeVC.h"
#import <SAMKeychain.h>
#import "JPUSHService.h"
#import "LeanChatFactory.h"
#import <SDCycleScrollView.h>
#import "HomeCell.h"
#import "BannerModel.h"
#import "WebViewController.h"
#import "HomeTVDetailModel.h"
#import "IndexModel.h"
#import "ShoppingCarVC.h"
#import "DiscoverDetailVC.h"
#import "LiveDetailHHHVC.h"
#import "ChooseVC.h"
#import "DiscoverDetailV2VC.h"
#import "LiveListVC.h"

@interface HomeVC () <UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate, UITabBarControllerDelegate>
{
    CGFloat rowHeight;
    CGFloat sectionHeight;
    CGFloat tvHeaderViewHeight;
    NSUInteger maxSection;
    BOOL _isFirstCome; // 判断是否
    IndexModel *_indexModel1;
    IndexModel *_indexModel2;
    IndexModel *_indexModel3;
    CGFloat willCellHeight;
    CGFloat startCellHeight;
    CGFloat endCellHeight;
}
@property (nonatomic, strong) AFNetworkReachabilityManager *internetReachability;

@property (nonatomic, strong) NSMutableArray *bannerDataArr; // 轮播图数据
@property (nonatomic, strong) NSMutableArray *tableSection1DataArr; // tableview主数据
@property (nonatomic, strong) NSMutableArray *tableSection2DataArr;
@property (nonatomic, strong) NSMutableArray *tableSection3DataArr;
@property (nonatomic, strong) NSMutableArray *endActivityDataArr; // 结束活动推荐商品数据

@property (nonatomic, strong) UILabel *naviTitleLbl;
@property (nonatomic, strong) UIButton *naviShopCar;
@property (nonatomic, strong) UIButton *naviMesBtn;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet SDCycleScrollView *bannerView;
@property (nonatomic, strong) UIImageView *sectionImgV;
@property (strong, nonatomic) IBOutlet UIView *noNetPhView;

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
- (NSMutableArray *)tableSection1DataArr
{
    if (_tableSection1DataArr) {
        return _tableSection1DataArr;
    }
    _tableSection1DataArr = [NSMutableArray array];
    return _tableSection1DataArr;
}
- (NSMutableArray *)tableSection2DataArr
{
    if (_tableSection2DataArr) {
        return _tableSection2DataArr;
    }
    _tableSection2DataArr = [NSMutableArray array];
    return _tableSection2DataArr;
}
- (NSMutableArray *)tableSection3DataArr
{
    if (_tableSection3DataArr) {
        return _tableSection3DataArr;
    }
    _tableSection3DataArr = [NSMutableArray array];
    return _tableSection3DataArr;
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
    
    sectionHeight = 52.f;
    tvHeaderViewHeight = ScreenHeight / 100 * 29;
    
    [self setupNaviConfig];
    [NotificationCenter addObserver:self selector:@selector(updateUnReadMessageCount:) name:LeanCloudNotReadMessageCount object:nil];
    
    [self judgementKeychainIsOutOfDate];
    
    [self configBannerView];
    
    [self getAppConfigData];
    
    _isFirstCome = YES;
    
}

- (void)getAppConfigData
{
    WS(weakSelf);
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSString *delteDotVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    [YPCNetworking getWithUrl:@"merchant/config"
                 refreshCache:YES
                       params:@{@"version" : delteDotVersion}
                      success:^(id response) {
                          if ([YPC_Tools judgeRequestAvailable:response]) {
                              [YPCRequestCenter shareInstance].configModel = [AppConfigModel mj_objectWithKeyValues:response[@"data"][@"share_data"]];
                              [YPCNetworking updateBaseUrl:response[@"data"][@"api_url"]];
                              
                              [weakSelf getDataWithBanner];
                              [weakSelf addMjRefresh];
                              
                              weakSelf.noNetPhView.hidden = YES;
                          }
                      } fail:^(NSError *error) {
                          if ([error code] == -1009) {
                              weakSelf.noNetPhView.hidden = NO;
                          }
                      }];
}

- (void)updateUnReadMessageCount:(NSNotification *)object
{
    self.naviMesBtn.littleRedBadgeValue = object.object;
}

- (void)judgementKeychainIsOutOfDate
{
    WS(weakSelf);
    NSString *SID = [SAMKeychain passwordForService:KEY_KEYCHAIN_SERVICE account:KEY_KEYCHAIN_NAME];
    if (SID) {
//        [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
            NSDictionary *sessionDic = @{
                                         @"session" : @{@"sid" : SID,
                                                        @"uid" : @"0"},
                                         @"registration_id" : [JPUSHService registrationID] != nil ? [JPUSHService registrationID] : @"0"
                                         };
            [YPCNetworking postWithUrl:@"shop/user/checkinfo"
                          refreshCache:YES
                                params:sessionDic
                               success:^(id response) {
                                   NSNumber *num = [NSNumber numberWithInteger:0];
                                   if (response[@"status"][@"succeed"] != num) {
                                       NSString *cart = response[@"data"][@"user"][@"cart_num"];
                                       NSString *cart_add_time = response[@"data"][@"user"][@"cart_add_time"];
                                       NSString *cart_expire_time = response[@"data"][@"user"][@"cart_expire_time"];
                                       NSString *timeEnd = [NSString stringWithFormat:@"%zd",cart_add_time.integerValue + cart_expire_time.integerValue];
                                       [YPCRequestCenter shareInstance].carNumber = cart;
                                       [YPCRequestCenter shareInstance].carEndtime = timeEnd;
                                       [YPCRequestCenter shareInstance].cart_expire_time = cart_expire_time;
                                       weakSelf.naviShopCar.badgeValue = cart;
                                       [YPCRequestCenter setUserInfoWithResponse:response];
                                       [LeanChatFactory invokeThisMethodAfterLoginSuccessWithClientId:response[@"data"][@"user"][@"hx_uname"] success:^{
                                           [YPCRequestCenter setUserLogin];
                                       } failed:^(NSError *error) {
                                           YPCAppLog(@"%@", [error description]);
                                           [YPCRequestCenter removeCacheUserKeychain];
                                       }];
                                   }else {
                                       [YPCRequestCenter removeCacheUserKeychain];
                                   }
                               }
                                  fail:^(NSError *error) {
                                      [YPCRequestCenter removeCacheUserKeychain];
                                      YPCAppLog(@"%@", [error description]);
                                  }];
//        }];
    }else {
        [YPCRequestCenter removeCacheUserKeychain];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.bannerView adjustWhenControllerViewWillAppera];
    self.naviMesBtn.littleRedBadgeValue = [YPCRequestCenter shareInstance].kUnReadMesCount;
    if ([YPCRequestCenter isLogin] && !_isFirstCome) {
        [self getData];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_isFirstCome) {
        _isFirstCome = NO;
    }
}

#pragma mark - Config
- (void)setupNaviConfig
{
    self.naviTitleLbl = [UILabel new];
    self.naviTitleLbl.text = @"壹品仓-品牌仓储特卖";
    self.naviTitleLbl.font = BoldFont(18);
    self.naviTitleLbl.textColor = [UIColor whiteColor];
    [self.naviTitleLbl sizeToFit];
    self.navigationItem.titleView = self.naviTitleLbl;
    self.naviTitleLbl.alpha = 0;
    
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
    WS(weakSelf);
    [YPCNetworking getWithUrl:@"shop/home/data"
                 refreshCache:YES
                       params:@{}
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
                          [weakSelf.tableView.mj_header endRefreshing];
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
                              
                              _indexModel1 = [IndexModel mj_objectWithKeyValues:response[@"data"][@"indexs"][@"1"]];
                              _indexModel2 = [IndexModel mj_objectWithKeyValues:response[@"data"][@"indexs"][@"2"]];
                              _indexModel3 = [IndexModel mj_objectWithKeyValues:response[@"data"][@"indexs"][@"3"]];
                              
                              weakSelf.tableSection1DataArr = [HomeTVDetailModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"activity_list"][_indexModel1.type]];
                              weakSelf.tableSection2DataArr = [HomeTVDetailModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"activity_list"][_indexModel2.type]];
                              weakSelf.tableSection3DataArr = [HomeTVDetailModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"activity_list"][_indexModel3.type]];
                              
                              [weakSelf.tableView reloadData];

                              [weakSelf.tableView.mj_header endRefreshing];
                          }
                      }
                         fail:^(NSError *error) {
                             YPCAppLog(@"%@", [error description]);
                             [weakSelf.tableView.mj_header endRefreshing];
                         }];
}
// 购物车数量
- (void)getData{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/user/notify"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfo]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               NSString *cart = response[@"data"][@"cart_num"];
                               NSString *cart_add_time = response[@"data"][@"cart_add_time"];
                               NSString *cart_expire_time = response[@"data"][@"cart_expire_time"];
                               NSString *timeEnd = [NSString stringWithFormat:@"%zd",cart_add_time.integerValue + cart_expire_time.integerValue];
                               [YPCRequestCenter shareInstance].carNumber = cart;
                               [YPCRequestCenter shareInstance].carEndtime = timeEnd;
                               [YPCRequestCenter shareInstance].cart_expire_time = cart_expire_time;
                               weakSelf.naviShopCar.badgeValue = cart;
                           }
                           
                           
                       }
                          fail:^(NSError *error) {
                              YPCAppLog(@"%@", [error description]);
                          }];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_indexModel1.count.integerValue > 0 && _indexModel2.count.integerValue > 0 && _indexModel3.count.integerValue > 0) {
        return 3;
    }else if ((_indexModel1.count.integerValue > 0 && _indexModel2.count.integerValue > 0 && _indexModel3.count.integerValue == 0) ||
              (_indexModel1.count.integerValue > 0 && _indexModel3.count.integerValue > 0 && _indexModel2.count.integerValue == 0) ||
              (_indexModel2.count.integerValue > 0 && _indexModel3.count.integerValue > 0 && _indexModel1.count.integerValue == 0)) {
        return 2;
    }else if ((_indexModel1.count.integerValue > 0 && _indexModel2.count.integerValue == 0 && _indexModel3.count.integerValue == 0) ||
              (_indexModel2.count.integerValue > 0 && _indexModel1.count.integerValue == 0 && _indexModel3.count.integerValue == 0) ||
              (_indexModel3.count.integerValue > 0 && _indexModel1.count.integerValue == 0 && _indexModel2.count.integerValue == 0)) {
        return 1;
    }else {
        return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _indexModel1.count.integerValue;
    }else if (section == 1) {
        return _indexModel2.count.integerValue;
    }else if (section == 2) {
        return _indexModel3.count.integerValue;
    }else {
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self setupSectionViewWithSection:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [self judgementActivityTypeWithStringType:_indexModel1.type andTableView:tableView];
        cell.tempModel = self.tableSection1DataArr[indexPath.row];
    }else if (indexPath.section == 1) {
        cell = [self judgementActivityTypeWithStringType:_indexModel2.type andTableView:tableView];
        cell.tempModel = self.tableSection2DataArr[indexPath.row];
    }else if (indexPath.section == 2) {
        cell = [self judgementActivityTypeWithStringType:_indexModel3.type andTableView:tableView];
        cell.tempModel = self.tableSection3DataArr[indexPath.row];
    }

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [self heightWithActivityTypeWithIndexModel:_indexModel1 andTableDataModel:self.tableSection1DataArr[indexPath.row] andIndexPath:indexPath];
    }else if (indexPath.section == 1) {
        return [self heightWithActivityTypeWithIndexModel:_indexModel2 andTableDataModel:self.tableSection2DataArr[indexPath.row] andIndexPath:indexPath];
    }else if (indexPath.section == 2) {
        return [self heightWithActivityTypeWithIndexModel:_indexModel3 andTableDataModel:self.tableSection3DataArr[indexPath.row] andIndexPath:indexPath];
    }else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return sectionHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self pushViewControllerActivityTypeWithIndexModel:_indexModel1 andDataArr:self.tableSection1DataArr andIndexPath:indexPath];
    }else if (indexPath.section == 1) {
        [self pushViewControllerActivityTypeWithIndexModel:_indexModel2 andDataArr:self.tableSection2DataArr andIndexPath:indexPath];
    }else if(indexPath.section == 2) {
        [self pushViewControllerActivityTypeWithIndexModel:_indexModel3 andDataArr:self.tableSection3DataArr andIndexPath:indexPath];
    }
}

#pragma mark - scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    if (point.y > tvHeaderViewHeight - 64 * 2) {
        CGFloat alpha = MIN(1, 1 - ((tvHeaderViewHeight - point.y) / (64 * 2)));
        [self.navigationController.navigationBar mz_setBackgroundAlpha:alpha];
        self.naviTitleLbl.alpha = alpha;
    }else{
        [self.navigationController.navigationBar mz_setBackgroundAlpha:0.f];
        self.naviTitleLbl.alpha = 0.f;
    }
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
            DiscoverDetailV2VC *dis = [[DiscoverDetailV2VC alloc]init];
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
    WS(weakSelf);
    [YPCRequestCenter isLoginAndPresentLoginVC:self success:^{
        ShoppingCarVC *carVC = [ShoppingCarVC new];
        carVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:carVC animated:YES];
        [weakSelf getDataWithBanner];
    }];
}
- (void)mesBtnClickAction
{
    WS(weakSelf);
    [YPCRequestCenter isLoginAndPresentLoginVC:self success:^{
        [YPC_Tools pushConversationListViewController:weakSelf];
        [weakSelf getDataWithBanner];
    }];
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
        return cell;
    }else if ([type isEqualToString:KEY_Start_Activity]) {
        HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:LivingIdentifier];
        if (!cell) {
            cell = (HomeCell *)[[[NSBundle  mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil]  firstObject];
        }
        return cell;
    }else if ([type isEqualToString:KEY_End_Activity]) {
        HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:EndIdentifier];
        if (!cell) {
            cell = (HomeCell *)[[[NSBundle  mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil]  lastObject];
        }
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
- (CGFloat)heightWithActivityTypeWithIndexModel:(IndexModel *)indexModel andTableDataModel:(HomeTVDetailModel *)model andIndexPath:(NSIndexPath *)indexPath
{
    if ([indexModel.type isEqualToString:KEY_Will_Activity]) {
        if (indexModel.count.integerValue - 1 == indexPath.row) {
            willCellHeight = 160.f - 15.f - 15.f - 10.f;
        }else {
            willCellHeight = 160.f - 15.f;
        }
        return willCellHeight;
    }else if ([indexModel.type isEqualToString:KEY_Start_Activity]) {
        if (indexModel.count.integerValue - 1 == indexPath.row) {
            startCellHeight = ScreenWidth / 50 * 33;
        }else {
            startCellHeight = ScreenWidth / 50 * 33 + 15.f;
        }
        return startCellHeight;
    }else if ([indexModel.type isEqualToString:KEY_End_Activity]) {
        if (indexModel.count.integerValue - 1 == indexPath.row) {
            if (model.goods_data.count > 0) {
                endCellHeight = ScreenWidth / 100 * 61 + 112.f;
                return endCellHeight;
            }else {
                endCellHeight = ScreenWidth / 100 * 61;
                return endCellHeight;
            }
        }else {
            if (model.goods_data.count > 0) {
                endCellHeight = ScreenWidth / 100 * 61 + 112.f + 15.f;
                return endCellHeight;
            }else {
                endCellHeight = ScreenWidth / 100 * 61 + 15.f;
                return endCellHeight;
            }
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
- (void)pushViewControllerActivityTypeWithIndexModel:(IndexModel *)indexModel andDataArr:(NSArray *)dataArr andIndexPath:(NSIndexPath *)indexPath
{
    LiveListVC *live = [[LiveListVC alloc]init];
    live.activity_id = [dataArr[indexPath.row] fid];
    live.ac_state = [dataArr[indexPath.row] ac_state];
    if ([indexModel.type isEqualToString:KEY_Will_Activity]) {
        live.livelistType = LiveListOfPreHearting;
    }else if ([indexModel.type isEqualToString:KEY_Start_Activity]) {
        live.livelistType = LiveListOfLiving;
    }else if ([indexModel.type isEqualToString:KEY_End_Activity]) {
        live.livelistType = LiveListOfEnd;
    }
    live.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:live animated:YES];
}
/*!
 *
 *    创建tableview SectionView
 *
 */
- (UIView *)setupSectionViewWithSection:(NSInteger)section
{
    UIView *sectionV = [UIView new];
    sectionV.frame = CGRectMake(13, 0, ScreenWidth - 26, 52.f);
    
    self.sectionImgV = [[UIImageView alloc] initWithFrame:CGRectMake(13, 0, ScreenWidth - 26, 52.f)];
    self.sectionImgV.contentMode = UIViewContentModeScaleAspectFit;
    [sectionV addSubview:self.sectionImgV];
    
    if (section == 0) {
        if ([_indexModel1.type isEqualToString:KEY_Will_Activity]) {
            self.sectionImgV.image = IMAGE(@"homepage_yugao_img");
        }else if ([_indexModel1.type isEqualToString:KEY_Start_Activity]) {
            self.sectionImgV.image = IMAGE(@"homepage_zhiboz_img");
        }else if ([_indexModel1.type isEqualToString:KEY_End_Activity]) {
            self.sectionImgV.image = IMAGE(@"homepage_huifang_img");
        }
        return sectionV;
    }else if (section == 1) {
        if ([_indexModel2.type isEqualToString:KEY_Will_Activity]) {
            self.sectionImgV.image = IMAGE(@"homepage_yugao_img");
        }else if ([_indexModel2.type isEqualToString:KEY_Start_Activity]) {
            self.sectionImgV.image = IMAGE(@"homepage_zhiboz_img");
        }else if ([_indexModel2.type isEqualToString:KEY_End_Activity]) {
            self.sectionImgV.image = IMAGE(@"homepage_huifang_img");
        }
        return sectionV;
    }else if (section == 2) {
        if ([_indexModel3.type isEqualToString:KEY_Will_Activity]) {
            self.sectionImgV.image = IMAGE(@"homepage_yugao_img");
        }else if ([_indexModel3.type isEqualToString:KEY_Start_Activity]) {
            self.sectionImgV.image = IMAGE(@"homepage_zhiboz_img");
        }else if ([_indexModel3.type isEqualToString:KEY_End_Activity]) {
            self.sectionImgV.image = IMAGE(@"homepage_huifang_img");
        }
        return sectionV;
    }else {
        return nil;
    }
}

- (IBAction)noNetReloadAction:(UIButton *)sender {
    [self configBannerView];
    [self getAppConfigData];
}

@end
