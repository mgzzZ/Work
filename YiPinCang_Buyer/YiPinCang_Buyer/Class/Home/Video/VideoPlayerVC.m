//
//  VideoPlayerVC.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/15.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "VideoPlayerVC.h"
#import "PlayerViewModel.h"
#import "MainModel.h"
#import "CommendModel.h"
#import "AllGoodsTvCell.h"
#import "AllGoodsModel.h"
#import "CommendGoodsCvCell.h"
#import "VideoPlayerVC+Window.h"
#import "ChooseSizeModel.h"
#import "ChooseSize.h"
#import "DiscoverDetailVC.h"
#import "LiveBottomView.h"
#import "WebViewController.h"
#import "LiveDetailHHHVC.h"
static NSString *TvIdentifier = @"tvIdentifierCell";
static NSString *CvIdentifier = @"cvIdentifierCell";
@interface VideoPlayerVC ()
<
WMPlayerDelegate,
UITableViewDelegate,
UITableViewDataSource,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate
>
{
    BOOL goodsIsShowing;
    BOOL GroupInfoIsShowing;
}
@property (nonatomic, strong) AFNetworkReachabilityManager *internetReachability;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *playerHeightC; // playerV高度约束

@property (nonatomic, strong) MainModel *mainDataModel; // 主页面Model
@property (nonatomic, strong) PlayerViewModel *playerModel; // 播放器相关model
@property (nonatomic, strong) NSMutableArray *commendDataArr; // 推荐商品数组
@property (nonatomic, strong) NSMutableArray *allGoodsDataArr; // 所有商品数组

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tvHeaderView;
@property (strong, nonatomic) IBOutlet UILabel *countOfHotGoods;
@property (strong, nonatomic) IBOutlet UILabel *countOfAllGoods;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)ChooseSize *chooseSize;
@property (nonatomic,assign)BOOL isChooseSize;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)ChooseSizeModel *chooseModel;

@property (nonatomic, strong) LiveBottomView *liveBottomView;
@end

@implementation VideoPlayerVC
{
    NSInteger dataIndex;
}
#pragma mark - 懒加载
- (NSMutableArray *)commendDataArr
{
    if (_commendDataArr) {
        return _commendDataArr;
    }
    _commendDataArr = [NSMutableArray array];
    return _commendDataArr;
}
- (NSMutableArray *)allGoodsDataArr
{
    if (_allGoodsDataArr) {
        return _allGoodsDataArr;
    }
    _allGoodsDataArr = [NSMutableArray array];
    return _allGoodsDataArr;
}

#pragma mark - 懒加载
- (LiveBottomView *)liveBottomView
{
    WS(weakSelf);
    if (_liveBottomView == nil) {
        _liveBottomView = [[LiveBottomView alloc]init];
        _liveBottomView.store_id = self.mainDataModel.store_id;//加载数据
        //点击cell
        _liveBottomView.didcell = ^(NSString *liveId){
            [weakSelf.playerV pause];
            weakSelf.playerV.isRemoveFromWindow = YES;
            weakSelf.playerV.playerIsOnWindow = NO;
            VideoPlayerVC *vVC = [VideoPlayerVC new];
            vVC.liveId = liveId;
            vVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vVC animated:YES];
        };
        //点击私信
        _liveBottomView.pushMessage = ^(NSString *hx_name){
            if (weakSelf.playerV.state == WMPlayerStateFailed) {
                [YPC_Tools openConversationWithCilentId:hx_name ViewController:weakSelf andOrderId:nil  andOrderIndex:nil];
            }else {
                if (!weakSelf.playerV.playerIsOnWindow) {
                    [weakSelf playVideoOnWindow];
                    [YPC_Tools openConversationWithCilentId:hx_name ViewController:weakSelf andOrderId:nil andOrderIndex:nil];
                }
            }
        };
        _liveBottomView.didTxBtnClick = ^(NSString *storeId){
            LiveDetailHHHVC *live = [[LiveDetailHHHVC alloc]init];
            live.store_id = storeId;
            [weakSelf.navigationController pushViewController:live animated:YES];
        };
        [self.view addSubview:_liveBottomView];
    }
    return _liveBottomView;
}

- (void)dealloc
{
    YPCAppLog(@"VideoPlayerVC----Dealloc");
    [NotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = YES;
    self.rt_disableInteractivePop = YES;
    [YPC_Tools setStatusBarIsHidden:YES];
    
    [self configTableViewAndCollectionView];
    
    [self initChooseSizeView];
    
    [self getMainData];
    
    WS(weakSelf);
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf addIssueDataForFooter];
    }];
    self.tableView.mj_footer.hidden = YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [YPC_Tools setStatusBarIsHidden:YES];
//    if (self.playerV.playerIsOnWindow) {
//        [self hiddenVideoOnWindowWithViewController:self];
//    }
//    if (self.playerV.isRemoveFromWindow && !self.playerV.playerIsOnWindow) {
//        if (self.playerV.state == WMPlayerStateStopped) {
//            [self.playerV play];
//        }
//    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [YPC_Tools setStatusBarIsHidden:NO];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.playerV.state != WMPlayerStateFailed) {
        
        if (self.playerV.playerIsOnWindow) {
            [self hiddenVideoOnWindowWithViewController:self];
        }
        if (self.playerV.isRemoveFromWindow && !self.playerV.playerIsOnWindow) {
            if (self.playerV.state == WMPlayerStateStopped) {
                [self.playerV play];
            }
        }
    }
}

#pragma mark - TV CV相关配置
- (void)configTableViewAndCollectionView
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AllGoodsTvCell class]) bundle:nil] forCellReuseIdentifier:TvIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CommendGoodsCvCell class]) bundle:nil] forCellWithReuseIdentifier:CvIdentifier];
    
    // 设置tableview头部视图高度
    [self.tvHeaderView setHeight:80 + ScreenWidth * .4];
    [self.tableView setTableHeaderView:self.tvHeaderView];
}

#pragma mark - 获取数据
- (void)getMainData
{
    WS(weakSelf);
    [YPCNetworking postWithUrl:@"shop/activity/stopactivitydetail"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"live_id" : self.liveId
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.mainDataModel = [MainModel mj_objectWithKeyValues:response[@"data"][@"live_info"]];
                               weakSelf.commendDataArr = [CommendModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"commend_goods"]];
                               [weakSelf.collectionView reloadData];
                               
                               [weakSelf initWithPlayer];
                               
                               [weakSelf videoPlay];
                               
                               [weakSelf judgementNetworkType];
                               [weakSelf addNetworkNotifications];
                               
                               weakSelf.playerV.closeBtn.hidden = NO;
                               weakSelf.playerV.shareBtn.hidden = NO;
                               
                               // 获取商品数据
                               [weakSelf getIssueData];
                               
                           }
                       } fail:^(NSError *error) {
                           weakSelf.playerV.closeBtn.hidden = NO;
                           weakSelf.playerV.shareBtn.hidden = NO;
                       }];
}
- (void)getIssueData
{
    WS(weakSelf);
    dataIndex = 1;
    [YPCNetworking postWithUrl:@"shop/activity/showgoodslist"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"live_id" : self.liveId,
                                                                               @"live_state" : self.mainDataModel.live_state,
                                                                               @"pagination" : @{
                                                                                       @"page" : [NSString stringWithFormat:@"%ld", dataIndex],
                                                                                       @"count" : @"20"
                                                                                       }
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.allGoodsDataArr = [AllGoodsModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                               weakSelf.playerV.goodsBtn.badgeValue = response[@"paginated"][@"total"];
                               [weakSelf.tableView reloadData];
                               
                               if ([response[@"paginated"][@"more"] integerValue] == 1) {
                                   weakSelf.tableView.mj_footer.hidden = NO;
                               }else {
                                   weakSelf.tableView.mj_footer.hidden = YES;
                               }
                           }
                       } fail:^(NSError *error) {
                           
                       }];
}
- (void)addIssueDataForFooter
{
    WS(weakSelf);
    dataIndex++;
    [YPCNetworking postWithUrl:@"shop/activity/showgoodslist"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"live_id" : self.liveId,
                                                                               @"live_state" : self.mainDataModel.live_state,
                                                                               @"pagination" : @{
                                                                                       @"page" : [NSString stringWithFormat:@"%ld", dataIndex],
                                                                                       @"count" : @"20"
                                                                                       }
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               [weakSelf.allGoodsDataArr addObjectsFromArray:[AllGoodsModel mj_objectArrayWithKeyValuesArray:response[@"data"]]];
                               [weakSelf.tableView reloadData];
                               
                               if ([response[@"paginated"][@"more"] integerValue] == 1) {
                                   weakSelf.tableView.mj_footer.hidden = NO;
                               }else {
                                   weakSelf.tableView.mj_footer.hidden = YES;
                               }
                               [weakSelf.tableView.mj_footer endRefreshing];
                           }
                       } fail:^(NSError *error) {
                           
                       }];
}
- (void)getDataChooseSize:(NSString *)str price:(NSString *)price count:(NSString *)count maxCount:(NSString *)maxCount img:(NSString *)img{
    WS(weakSelf);
    [YPCNetworking postWithUrl:@"shop/cart/editinit"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"goods_id":str
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.chooseModel = [ChooseSizeModel mj_objectWithKeyValues:response[@"data"]];
                               
                               [weakSelf.chooseSize updateWithPrice:price img:img chooseMessage:@"请选择颜色和尺码" count:1 maxCount:10 model:weakSelf.chooseModel];
                               [weakSelf chooseSizeShow];
                           }
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}
#pragma mark - Player相关初始化
- (void)initWithPlayer
{
    goodsIsShowing = NO; // 商品View是否弹出
    GroupInfoIsShowing = NO;
    self.playerV.playerIsOnWindow = NO; // 视频是否在window上
    self.playerV.isRemoveFromWindow = NO; // 是否点击关闭从window上移除
    self.playerV.delegate = self;
    self.playerModel = [PlayerViewModel new];
    [self.playerModel setName:self.mainDataModel.store_name];
    [self.playerModel setAvator:self.mainDataModel.store_avatar];
    self.playerV.dataModel = self.playerModel;
    WS(weakSelf);
    [self.playerV setButtonClickedBlock:^(id type) {
        if ([type isEqualToString:@"seeGoods"]) {
            [weakSelf showGoodsAction];
        }else if ([type isEqualToString:@"share"]) {
            NSString *uid = [YPCRequestCenter shareInstance].model.user_id.length > 0 ? [YPCRequestCenter shareInstance].model.user_id : @"0";
            [YPCShare EndActivityShareInWindowWithName:weakSelf.mainDataModel.store_name
                                             StartTime:weakSelf.mainDataModel.endtime
                                                LiveID:weakSelf.mainDataModel.live_id
                                                 image:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:weakSelf.mainDataModel.activity_pic]
                                          activityName:weakSelf.mainDataModel.name
                                                   uid:uid
                                        viewController:weakSelf];
        }else if ([type isEqualToString:@"follow"]) {
            [YPCRequestCenter isLoginAndPresentLoginVC:weakSelf success:^{
                [weakSelf followLiveGroup];
            }];
        }else if ([type isEqualToString:@"seeAbout"]) {
            [weakSelf showGroupInfoAction];
        }
    }];
}
- (void)videoPlay
{
    [self.playerModel setGoodsCount:[NSString stringWithFormat:@"%ld", self.commendDataArr.count]];
    [self.playerModel setIsfollowSeller:self.mainDataModel.isfollowSeller];
    self.playerV.dataModel = self.playerModel;
    self.playerV.URLString = self.mainDataModel.video_url;
    [self.playerV play];
}

#pragma mark - 购物车初始化
- (void)initChooseSizeView{
    WS(weakSelf);
    self.bgView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.bgView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.bgView];
    self.bgView.alpha = 0.3;
    self.bgView.hidden = YES;
    self.isChooseSize = NO;
    self.chooseSize =  [[ChooseSize alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 483) count:15 maxCount:20];
    self.chooseSize.did = ^(NSString *goods_id,NSString *count,NSString *payType){
            [YPCNetworking postWithUrl:@"shop/cart/add"
                          refreshCache:YES
                                params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                       @"goods_id":goods_id,
                                                                                       @"count":count,
                                                                                       @"click_from_type":@"6"
                                                                                       }]
                               success:^(id response) {
                                   if ([YPC_Tools judgeRequestAvailable:response]) {
                                       [YPC_Tools showSvpWithNoneImgHud:@"添加成功"];
                                       NSString *carNumber = response[@"data"][@"num"];
                                       NSString *cart_add_time = response[@"data"][@"cart_add_time"];
                                       NSString *cart_expire_time = response[@"data"][@"cart_expire_time"];
                                       NSString *timeEnd = [NSString stringWithFormat:@"%zd",cart_add_time.integerValue + cart_expire_time.integerValue];
                                       
                                       [YPCRequestCenter shareInstance].carEndtime = timeEnd;
                                       [YPCRequestCenter shareInstance].cart_expire_time = cart_expire_time;
                                       [YPCRequestCenter shareInstance].carNumber = carNumber;
                                       [weakSelf chooseSizeHide];
                                   }
                               }
                                  fail:^(NSError *error) {
                                      
                                  }];
    };
    self.chooseSize.cancel = ^{
        // 取消
        [weakSelf chooseSizeHide];
    };
    self.chooseSize.push = ^{
        WebViewController *web = [[WebViewController alloc]init];
        web.navTitle = @"尺码助手";
        web.homeUrl = weakSelf.chooseModel.specdesc_url;
        [weakSelf.navigationController pushViewController:web animated:YES];
    };
    [self.view addSubview:self.chooseSize];
}

#pragma mark - 网络状态
- (void)judgementNetworkType
{
    WS(weakSelf);
    if ([YPCRequestCenter getCurrentNetworkType] == AFNetworkReachabilityStatusReachableViaWWAN) {
        [YPC_Tools customAlertViewWithTitle:@"提示"
                                    Message:@"当前非WiFi网络\n继续播放将产生流量费用"
                                  BtnTitles:nil
                             CancelBtnTitle:@"停止播放"
                        DestructiveBtnTitle:@"继续播放"
                              actionHandler:nil
                              cancelHandler:^(LGAlertView *alertView) {
                                  [weakSelf releaseWMPlayer];
                                  [weakSelf.navigationController popViewControllerAnimated:YES];
                              } destructiveHandler:^(LGAlertView *alertView) {
                                  
                              }];
    }
}

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
            
            break;
        case AFNetworkReachabilityStatusNotReachable:
            
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
        {
            WS(weakSelf);
            if (self.playerV.state == WMPlayerStateBuffering || self.playerV.state == WMPlayerStatePlaying) {
                [YPC_Tools customAlertViewWithTitle:@"提示"
                                            Message:@"当前非WiFi网络\n继续播放将产生流量费用"
                                          BtnTitles:nil
                                     CancelBtnTitle:@"停止播放"
                                DestructiveBtnTitle:@"继续播放"
                                      actionHandler:nil
                                      cancelHandler:^(LGAlertView *alertView) {
                                          [weakSelf releaseWMPlayer];
                                          [weakSelf.navigationController popViewControllerAnimated:YES];
                                      } destructiveHandler:^(LGAlertView *alertView) {
                                          
                                      }];
            }
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            
            break;
        default:
            break;
    }
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *count = [NSString stringWithFormat:@"全部宝贝 %ld", self.allGoodsDataArr.count];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:count];
    [str addAttribute:NSForegroundColorAttributeName value:[Color colorWithHex:@"0x2c2c2c" ] range:NSMakeRange(0,4)];
    
    [str addAttribute:NSForegroundColorAttributeName value:[Color colorWithHex:@"#F00E36" ] range:NSMakeRange(5,count.length - 5)];
    self.countOfAllGoods.attributedText = str;
    return self.allGoodsDataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllGoodsTvCell *cell = [tableView dequeueReusableCellWithIdentifier:TvIdentifier];
    cell.tempModel = self.allGoodsDataArr[indexPath.row];
    WS(weakSelf);
    [cell setButtonClickedBlock:^(id object) {
        if ([object isEqualToString:@"joinShopCar"]) {
            [YPCRequestCenter isLoginAndPresentLoginVC:self success:^{                
                AllGoodsModel *model = weakSelf.allGoodsDataArr[indexPath.row];
                [weakSelf getDataChooseSize:model.goods_commonid price:model.goods_price count:@"1" maxCount:model.total_storage img:model.goods_image];
            }];
            }
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakself);
    if (self.playerV.state == WMPlayerStateFailed) {
        DiscoverDetailVC *detailVC = [DiscoverDetailVC new];
        AllGoodsModel *model = self.allGoodsDataArr[indexPath.row];
        detailVC.live_id = self.mainDataModel.live_id;
        detailVC.strace_id = [self.allGoodsDataArr[indexPath.row] strace_id];
        detailVC.backBlock = ^(NSString *likeCount,NSString *isLike,NSString *commentCount){
            model.strace_cool = likeCount;
            model.strace_comment = commentCount;
            [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:detailVC animated:YES];
    }else {
        
        if (!self.playerV.playerIsOnWindow) {
            [self playVideoOnWindow];
            
            DiscoverDetailVC *detailVC = [DiscoverDetailVC new];
            detailVC.live_id = self.mainDataModel.live_id;
            AllGoodsModel *model = self.allGoodsDataArr[indexPath.row];
            detailVC.strace_id = [self.allGoodsDataArr[indexPath.row] strace_id];
            detailVC.backBlock = ^(NSString *likeCount,NSString *isLike,NSString *commentCount){
                model.strace_cool = likeCount;
                model.strace_comment = commentCount;
                [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
}

#pragma mark - collectionviewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSString *count = [NSString stringWithFormat:@"热销推荐 %ld", self.commendDataArr.count];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:count];
    [str addAttribute:NSForegroundColorAttributeName value:[Color colorWithHex:@"0x2c2c2c" ] range:NSMakeRange(0,4)];
    
    [str addAttribute:NSForegroundColorAttributeName value:[Color colorWithHex:@"#F00E36" ] range:NSMakeRange(5,count.length - 5)];
    self.countOfHotGoods.attributedText = str;
    return self.commendDataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CommendGoodsCvCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CvIdentifier forIndexPath:indexPath];
    cell.tempModel = self.commendDataArr[indexPath.row];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake((ScreenWidth - 10) / 3, self.tvHeaderView.height - 80);
    return size;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.playerV.state == WMPlayerStateFailed) {
        DiscoverDetailVC *detailVC = [DiscoverDetailVC new];
        detailVC.live_id = self.mainDataModel.live_id;
        detailVC.strace_id = [self.commendDataArr[indexPath.row] strace_id];
        [self.navigationController pushViewController:detailVC animated:YES];
    }else {
        if (!self.playerV.playerIsOnWindow) {
            [self playVideoOnWindow];
            
            DiscoverDetailVC *detailVC = [DiscoverDetailVC new];
            detailVC.live_id = self.mainDataModel.live_id;
            detailVC.strace_id = [self.commendDataArr[indexPath.row] strace_id];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
}

#pragma mark - NO DATA IMAGE SET
-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return scrollView.frame.origin.y - 50.f;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (scrollView == self.collectionView) {
        return [UIImage imageNamed:@"blankpage_Sellinggoods_img"];
    }else if(scrollView == self.tableView) {
        return [UIImage imageNamed:@"blankpage_goods_img"];
    }else {
        return nil;
    }
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

#pragma mark - PlayerDelegate
-(void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)closeBtn
{
    if (!self.playerV.playerIsOnWindow) {
        [self releaseWMPlayer];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (self.playerV.playerIsOnWindow) {
        [self removeVideoOnWindow];
        return;
    }
}
-(void)wmplayer:(WMPlayer *)wmplayer singleTaped:(UITapGestureRecognizer *)singleTap
{
    if (goodsIsShowing && !self.playerV.playerIsOnWindow) {
        [self hiddenGoodsAction];
    }
    if (self.playerV.playerIsOnWindow) {
        [self hiddenVideoOnWindowWithViewController:self];
    }
    if (GroupInfoIsShowing) {
        [self.liveBottomView animationHiden];
    }
}
-(void)wmplayer:(WMPlayer *)wmplayer doubleTaped:(UITapGestureRecognizer *)doubleTap
{
    
}
-(void)wmplayerFailedPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state
{
    
}
-(void)wmplayerReadyToPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state
{
    
}
-(void)wmplayerFinishedPlay:(WMPlayer *)wmplayer
{
    
}

-(void)releaseWMPlayer{
    //堵塞主线程
    //    [wmPlayer.player.currentItem cancelPendingSeeks];
    //    [wmPlayer.player.currentItem.asset cancelLoading];
    [self.playerV pause];
    
    [self.playerV removeFromSuperview];
    [self.playerV.playerLayer removeFromSuperlayer];
    [self.playerV.player replaceCurrentItemWithPlayerItem:nil];
    self.playerV.player = nil;
    self.playerV.currentItem = nil;
    
    self.playerV.playOrPauseBtn = nil;
    self.playerV.playerLayer = nil;
    self.playerV = nil;
}

#pragma mark - 弹出&隐藏商品方法
- (void)showGoodsAction
{
    if (!goodsIsShowing) {
        goodsIsShowing = YES;
        self.playerV.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        self.playerHeightC.constant = -ScreenHeight / 5 * 3;
        self.playerV.bottomView.hidden = YES;
        WS(weakself);
        [UIView animateWithDuration:.2f animations:^{
            [weakself.view layoutIfNeeded];
        }];
    }
}
- (void)hiddenGoodsAction
{
    if (goodsIsShowing) {
        goodsIsShowing = NO;
        self.playerV.playerLayer.videoGravity = AVLayerVideoGravityResize;
        self.playerHeightC.constant = 0;
        self.playerV.bottomView.hidden = NO;
        WS(weakself);
        [UIView animateWithDuration:.2f animations:^{
            [weakself.view layoutIfNeeded];
        }];
    }
}

#pragma mark - 直播员信息弹出隐藏
- (void)showGroupInfoAction
{
    if (!GroupInfoIsShowing) {
        [self.liveBottomView animationShow];
        GroupInfoIsShowing = YES;
    }else {
        [self.liveBottomView animationHiden];
        GroupInfoIsShowing = NO;
    }
}

#pragma mark - 购物车弹出隐藏
- (void)chooseSizeShow{
    WS(weakself);
    [UIView animateWithDuration:0.3 animations:^{
        weakself.chooseSize.frame = CGRectMake(0, ScreenHeight - 483, ScreenWidth, 483);
        weakself.bgView.hidden = NO;
        weakself.isChooseSize = YES;
    }];
}
- (void)chooseSizeHide{
    WS(weakself);
    [UIView animateWithDuration:0.3 animations:^{
        weakself.chooseSize.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 483);
        weakself.bgView.hidden = YES;
        weakself.isChooseSize = NO;
    }];
}

#pragma mark - Private Method
- (void)followLiveGroup
{
    WS(weakSelf);
    [YPCNetworking postWithUrl:@"shop/showstore/followstore/add"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"store_id" : self.mainDataModel.store_id
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               [YPC_Tools showSvpWithNoneImgHud:@"关注成功"];
                               [weakSelf.playerModel setIsfollowSeller:@"1"];
                               weakSelf.playerV.dataModel = self.playerModel;
                           }
                       }
                          fail:^(NSError *error) {
                              
                          }];
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
