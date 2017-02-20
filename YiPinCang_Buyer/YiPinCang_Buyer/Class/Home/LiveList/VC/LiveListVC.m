//
//  LiveListVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 17/1/1.
//  Copyright © 2017年 Laomeng. All rights reserved.
//

#import "LiveListVC.h"
#import "LiveListCell.h"
#import "LiveListHeaderView.h"
#import "LiveListModel.h"
#import "LiveGroupListModel.h"
#import "LivingVC.h"
#import "PhotoLivingVC.h"
#import "PreheatingVC.h"
#import "VideoPlayerVC.h"
#import "YPCShare.h"
@interface LiveListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LiveListModel *dataModel;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) LiveListHeaderView *headerView;
@end

@implementation LiveListVC
{
    NSUInteger dataIndex;
}

- (void)dealloc
{
    YPCAppLog(@"%@  Dealloc", NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self getData];
    
    WS(weakSelf);
    self.tableView.mj_header = [YPCRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf addDataFotTableViewFooter];
    }];
    self.tableView.mj_footer.hidden = YES;
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.acceptEventInterval = 1.f;
    [shareBtn sizeToFit];
    [shareBtn setImage:IMAGE(@"mshare_button") forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(messageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItems = @[share];
}

- (void)getData
{
    dataIndex = 1;
    WS(weakSelf);
    [YPCNetworking postWithUrl:@"shop/home/getshowstorelist"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"activity_id" : self.activity_id,
                                                                               @"ac_state" : self.ac_state,
                                                                               @"pagination" : @{
                                                                                       @"page" : [NSString stringWithFormat:@"%ld", dataIndex],
                                                                                       @"count" : @"20"
                                                                                       }
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               if ([response[@"paginated"][@"more"] integerValue] == 1) {
                                   weakSelf.tableView.mj_footer.hidden = NO;
                               }else {
                                   weakSelf.tableView.mj_footer.hidden = YES;
                               }
                               weakSelf.dataModel = [LiveListModel mj_objectWithKeyValues:response[@"data"]];
                               weakSelf.dataArr = [LiveGroupListModel mj_objectArrayWithKeyValuesArray:weakSelf.dataModel.store_list];
                               
                               [weakSelf configTvHeaderViewData];
                               
                               [weakSelf.tableView reloadData];
                               
                               [weakSelf.tableView.mj_header endRefreshing];
                           }
                       } fail:^(NSError *error) {
                           YPCAppLog(@"%@", [error description]);
                       }];
}

- (void)addDataFotTableViewFooter
{
    dataIndex++;
    WS(weakSelf);
    [YPCNetworking postWithUrl:@"shop/home/getshowstorelist"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"activity_id" : self.activity_id,
                                                                               @"ac_state" : self.ac_state,
                                                                               @"pagination" : @{
                                                                                       @"page" : [NSString stringWithFormat:@"%ld", dataIndex],
                                                                                       @"count" : @"20"
                                                                                       }
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.dataModel = [LiveListModel mj_objectWithKeyValues:response[@"data"]];
                               [weakSelf.dataArr addObjectsFromArray:[LiveGroupListModel mj_objectArrayWithKeyValuesArray:weakSelf.dataModel.store_list]];
                               [weakSelf.tableView reloadData];
                               [weakSelf.tableView.mj_footer endRefreshing];
                               if ([response[@"paginated"][@"more"] integerValue] == 1) {
                                   weakSelf.tableView.mj_footer.hidden = NO;
                               }else {
                                   weakSelf.tableView.mj_footer.hidden = YES;
                               }
                           }
                       } fail:^(NSError *error) {
                           YPCAppLog(@"%@", [error description]);
                       }];
}

- (void)configTvHeaderViewData
{
    self.title = self.dataModel.activity_info.name;
    [self.headerView.bgImg sd_setImageWithURL:[NSURL URLWithString:self.dataModel.activity_info.activity_pic] placeholderImage:YPCImagePlaceMainHomeHolder];
    if (self.livelistType != LiveListOfEnd) {
        [_headerView.timeLineView startTime:self.dataModel.activity_info.starttime endTime:self.dataModel.activity_info.endtime];
    }
    if (self.dataModel.activity_info.isRss.integerValue == 0) {
        [self.headerView.noticeBtn setImage:IMAGE(@"homepage_icon_playtips") forState:UIControlStateNormal];
    }else if (self.dataModel.activity_info.isRss.integerValue == 1) {
        [self.headerView.noticeBtn setImage:IMAGE(@"homepage_icon_playdown") forState:UIControlStateNormal];
    }
    
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = @[@"liveing",@"hot",@"old"];
    LiveListCell *cell = [tableView dequeueReusableCellWithIdentifier:arr[self.livelistType]];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"LiveListCell" owner:self options:nil][self.livelistType];
    }
    cell.indexPath = indexPath;
    cell.livelistType = self.livelistType;
    cell.tempMpdel = self.dataArr[indexPath.row];
    cell.backgroundColor = [Color colorWithHex:@"#efefef"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.livelistType) {
        case LiveListOfLiving:
            [self pushToLivingViewControllerWithIndexPath:indexPath];
            break;
        case LiveListOfPreHearting:
            [self pushToPreHeartingViewControllerWithIndexPath:indexPath];
            break;
        case LiveListOfEnd:
            [self pushToEndActivityViewControllerWithIndexPath:indexPath];
            break;
            
        default:
            break;
    }
}

#pragma mark - ParviteMethod
- (void)pushToLivingViewControllerWithIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataArr[indexPath.row] activity_type].integerValue == 0) {
        // 图文直播
        PhotoLivingVC *pVC = [PhotoLivingVC new];
        pVC.liveId = [self.dataArr[indexPath.row] live_id];
        [self.navigationController pushViewController:pVC animated:YES];
        
    }else if ([self.dataArr[indexPath.row] activity_type].integerValue == 1) {
        // 实时直播
        WS(weakSelf);
        [[SDWebImageDownloader sharedDownloader]
         downloadImageWithURL:[NSURL URLWithString:[self.dataArr[indexPath.row] livingshowinitimg]]
         options:SDWebImageDownloaderUseNSURLCache
         progress:nil
         completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
             if (finished && !error) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     LivingVC *lVC = [LivingVC new];
                     lVC.liveId = [self.dataArr[indexPath.row] live_id];
                     lVC.playerPHImg = image;
                     [weakSelf.navigationController pushViewController:lVC animated:YES];
                     [YPC_Tools dismissHud];
                 });
             }else {
                 [YPC_Tools showSvpHudError:@"加载失败, 请重试"];
             }
         }];
    }
}

- (void)pushToPreHeartingViewControllerWithIndexPath:(NSIndexPath *)indexPath
{
    PreheatingVC *pVC = [PreheatingVC new];
    pVC.liveId = [self.dataArr[indexPath.row] live_id];
    [self.navigationController pushViewController:pVC animated:YES];
}

- (void)pushToEndActivityViewControllerWithIndexPath:(NSIndexPath *)indexPath
{
    VideoPlayerVC *vVC = [VideoPlayerVC new];
    vVC.liveId = [self.dataArr[indexPath.row] live_id];
    [self.navigationController pushViewController:vVC animated:YES];
}

#pragma mark - 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.backgroundColor = [Color colorWithHex:@"#efefef"];
        [self.view addSubview:_tableView];
        _tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    }
    return _tableView;
}

- (LiveListHeaderView *)headerView{
    if (_headerView == nil) {
        switch (self.livelistType) {
            case LiveListOfLiving:
            {
                _headerView = [[LiveListHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 66 + ScreenWidth * 188 / 375)];
                _headerView.noticeBtn.hidden = YES;
            }
                break;
            case LiveListOfPreHearting:
            {
                _headerView = [[LiveListHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 113 + ScreenWidth * 188 / 375)];
                _headerView.noticeBtn.acceptEventInterval = .5f;
                [_headerView.noticeBtn addTarget:self action:@selector(liveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case LiveListOfEnd:
            {
                _headerView = [[LiveListHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 8 + ScreenWidth * 188 / 375)];
                _headerView.timeLineView.hidden = YES;
                _headerView.noticeBtn.hidden = YES;
            }
                break;
                
            default:
                break;
                
        }
        _headerView.timeLineView.backgroundColor = [Color colorWithHex:@"#EFEFEF"];
    }
    return _headerView;
}

#pragma mark - 开播提醒按钮
- (void)messageBtnClick{
    NSString *uid = [YPCRequestCenter shareInstance].model.user_id.length > 0 ? [YPCRequestCenter shareInstance].model.user_id : @"0";
    [YPCShare BrandActivityShareInWindowWithBrandName:self.dataModel.activity_info.name BrandDescription:self.dataModel.activity_info.endtime BrandID:self.activity_id image:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.dataModel.activity_info.activity_pic] uid:uid viewController:self];
}
- (void)liveBtnClick:(UIButton *)sender{
    WS(weakSelf);
    if (self.dataModel.activity_info.isRss.integerValue == 0) {
        [YPCRequestCenter isLoginAndPresentLoginVC:[YPC_Tools getControllerWithView:self] success:^{
            [YPCNetworking postWithUrl:@"shop/activity/rssactivity"
                          refreshCache:YES
                                params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                       @"activity_id"   : weakSelf.dataModel.activity_info.fid
                                                                                       }]
                               success:^(id response) {
                                   if ([YPC_Tools judgeRequestAvailable:response]) {
                                       [YPC_Tools showSvpWithNoneImgHud:@"设置提醒成功"];
                                       [sender setImage:IMAGE(@"homepage_icon_playdown") forState:UIControlStateNormal];
                                       [weakSelf.dataModel.activity_info setIsRss:@"1"];
                                   }
                               }
                                  fail:nil];
        }];
    }else {
        
        [YPCRequestCenter isLoginAndPresentLoginVC:[YPC_Tools getControllerWithView:self] success:^{
            [YPCNetworking postWithUrl:@"shop/activity/rssactivitycancel"
                          refreshCache:YES
                                params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                       @"activity_id"   : weakSelf.dataModel.activity_info.fid
                                                                                       }]
                               success:^(id response) {
                                   if ([YPC_Tools judgeRequestAvailable:response]) {
                                       [YPC_Tools showSvpWithNoneImgHud:@"取消订阅成功"];
                                       [sender setImage:IMAGE(@"homepage_icon_playtips") forState:UIControlStateNormal];
                                       [weakSelf.dataModel.activity_info setIsRss:@"0"];
                                   }
                               }
                                  fail:nil];
        }];
    }
}




- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
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
