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

static NSString *PhotoIdentifier = @"photoPreheadtingCell";
static NSString *VideoIdentifier = @"videoPreheadtingCell";
static NSString *PreGoodsIdentifier = @"goodsPreheadtingCell";
@interface PreheatingVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PreheatingModel *dataModel;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet UITableView *preGoodsTableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *preGoodsTVConstraint;
@property (strong, nonatomic) IBOutlet TimeCutdownView *cutdownV;

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
    // Do any additional setup after loading the view from its nib.
    self.title = self.tempModel.name;
    
    [self.mainTableView registerClass:[PreheatingCell class] forCellReuseIdentifier:PhotoIdentifier];
    [self.mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([shortVideoCell class]) bundle:nil] forCellReuseIdentifier:VideoIdentifier];
    [self.preGoodsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([preGoodsCell class]) bundle:nil] forCellReuseIdentifier:PreGoodsIdentifier];
    
    [self configNaviRightBtn];
    [self viewConfig];
    [self getDataWithWillActivityDetail];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Data数据
- (void)getDataWithWillActivityDetail
{
    [YPCNetworking postWithUrl:@"shop/activity/willactivitydetail"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"live_id" : self.tempModel.live_id
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               self.dataModel = [PreheatingModel mj_objectWithKeyValues:response[@"data"]];
                               self.mainDataArr = [Pre_stracesModel mj_objectArrayWithKeyValuesArray:self.dataModel.pre_straces];
                               // 更新头部视图
                               if (self.mainDataArr.count > 0) {
                                   self.tableViewHeaderV.height += 42.f;
                                   [self.mainTableView setTableHeaderView:self.tableViewHeaderV];
                                   self.preTitleView.hidden = NO;
                               }
                               [self.mainTableView reloadData];
                               
                               [self getDataWithPreHeatingGoods];
                           }
                       }
                          fail:^(NSError *error) {
                              
                          }];
}
- (void)getDataWithPreHeatingGoods
{
    [YPCNetworking postWithUrl:@"shop/activity/pregoodslist"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"live_id" : self.tempModel.live_id
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               self.goodsDataArr = [PreheatingGoodsModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                               if (self.goodsDataArr.count > 0) {
                                   [self.preGoodsTableView reloadData];
                                   [self.tableFooterV setHeight:57 + 90 * self.goodsDataArr.count];
                                   self.preGoodsTVConstraint.constant = 90 * self.goodsDataArr.count;
                                   [self.view updateConstraints];
                                   [self.mainTableView setTableFooterView:self.tableFooterV];
                                   self.footerLabel.hidden = NO;
                               }else {
                                   [self.tableFooterV setHeight:0];
                                   self.preGoodsTVConstraint.constant = 0;
                                   [self.view updateConstraints];
                                   [self.mainTableView setTableFooterView:self.tableFooterV];
                                   self.footerLabel.hidden = YES;
                               }
                           }
                       }
                          fail:^(NSError *error) {
                              
                          }];
}

#pragma mark - 视图相关配置
- (void)viewConfig
{
    // tableView头部视图
    [self.tableViewHeaderV setHeight:137.f + ScreenWidth / 100 * 69 + [YPC_Tools heightForText:self.tempModel.live_msg Font:[UIFont systemFontOfSize:13] Width:ScreenWidth - 85]];
    [self.mainTableView setTableHeaderView:self.tableViewHeaderV];
    
    // 定时器
    [self.cutdownV startTime:self.tempModel.starttime endTime:self.tempModel.endtime];
    
    // 头部视图添加数据
    [self.headImgV sd_setImageWithURL:[NSURL URLWithString:self.tempModel.store_avatar] placeholderImage:YPCImagePlaceHolder];
    self.nameL.text = self.tempModel.store_name;
    self.describeL.text = self.tempModel.live_msg;
    [self.bigImgV sd_setImageWithURL:[NSURL URLWithString:self.tempModel.activity_pic] placeholderImage:YPCImagePlaceHolder];
    self.timeL.text = [NSString stringWithFormat:@"%@-%@", [YPC_Tools timeWithTimeIntervalString:self.tempModel.start Format:@"MM月dd日"], [YPC_Tools timeWithTimeIntervalString:self.tempModel.end Format:@"MM月dd日"]];
    self.addressL.text = self.tempModel.address;
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
        return 90.f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView) {
        PreheatingDetailVC *detailVC = [PreheatingDetailVC new];
        detailVC.detailType = detailStylePerhearting;
        detailVC.tempModel = self.mainDataArr[indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }else {
        DiscoverDetailVC *detailVC = [DiscoverDetailVC new];
        detailVC.live_id = self.tempModel.live_id;
        detailVC.strace_id = [self.goodsDataArr[indexPath.row] strace_id];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark - 播放上方广告视频
- (IBAction)playBrandVideoAction:(UIButton *)sender {
    [self videoPlayActionWithURL:[NSURL URLWithString:self.tempModel.video]];
}

#pragma mark - 播放视频
- (void)videoPlayActionWithURL:(NSURL *)url
{
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
    [YPC_Tools setStatusBarIsHidden:YES];
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
    }
}

#pragma mark - Navi右按钮
- (void)configNaviRightBtn
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:IMAGE(@"mine_productdetails_icon_share") forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self
               action:@selector(naviRightAction:)
     forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = shareItem;
}

- (void)naviRightAction:(UIButton *)sender
{
    
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
