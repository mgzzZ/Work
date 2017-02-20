//
//  OrderMessageVC.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/12/12.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LCPushMessageVC.h"
#import "LCPushMessageCell.h"
#import "OrderMessageModel.h"
#import "SystemMessageModel.h"
#import "ActivityMessageModel.h"
#import "WebViewController.h"
#import "OrderVC.h"
#import "OrderListVC.h"
#import "PreheatingVC.h"
#import "LivingVC.h"
#import "VideoPlayerVC.h"
#import "LiveListVC.h"
#import "PhotoLivingVC.h"
#import "VideoPlayerVC.h"

static NSString *SystemIdentifier = @"systemIdentifier";
static NSString *OrderIdentifier = @"orderIdentifier";
static NSString *ActivityIdentifier = @"activityIdentifier";
@interface LCPushMessageVC () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation LCPushMessageVC
{
    CGFloat cellHeight;
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArr
{
    if (_dataArr) {
        return _dataArr;
    }
    _dataArr = [NSMutableArray array];
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewConfig];
    [self getDataForTableView];
}

#pragma mark - config
- (void)viewConfig
{
    if (self.messageType == LCMessageTypeSystem) {
        self.title = @"系统消息";
    }else if (self.messageType == LCMessageTypeOrder) {
        self.title = @"订单助手";
    }else if (self.messageType == LCMessageTypeActivity) {
        self.title = @"活动提醒";
    }
}

#pragma mark - Data
- (void)getDataForTableView
{
    WS(weakSelf);
    [YPCNetworking postWithUrl:@"shop/message/getsysmsglist"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{@"pagination" : @{
                                                                                       @"page":@"1",
                                                                                       @"count":@"30"
                                                                                       },
                                                                               @"type" : [NSString stringWithFormat:@"%ld", (unsigned long)self.messageType]
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               if (weakSelf.messageType == LCMessageTypeSystem) {
                                   weakSelf.dataArr = [SystemMessageModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                               }else if (weakSelf.messageType == LCMessageTypeOrder) {
                                   weakSelf.dataArr = [OrderMessageModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                               }else if (weakSelf.messageType == LCMessageTypeActivity) {
                                   weakSelf.dataArr = [ActivityMessageModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                               }
                               [weakSelf.tableView reloadData];
                           }
                       }
                          fail:^(NSError *error) {
                              
                          }];
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCPushMessageCell *cell = nil;
    if (self.messageType == LCMessageTypeSystem) {
        cell = [tableView dequeueReusableCellWithIdentifier:SystemIdentifier];
        if (!cell) {
            cell = (LCPushMessageCell *)[[NSBundle  mainBundle] loadNibNamed:NSStringFromClass([LCPushMessageCell class]) owner:self options:nil].firstObject;
        }
        cell.systemModel = self.dataArr[indexPath.row];
    }else if (self.messageType == LCMessageTypeOrder) {
        cell = [tableView dequeueReusableCellWithIdentifier:OrderIdentifier];
        if (!cell) {
            cell = (LCPushMessageCell *)[[NSBundle  mainBundle] loadNibNamed:NSStringFromClass([LCPushMessageCell class]) owner:self options:nil][1];
        }
        cell.orderModel = self.dataArr[indexPath.row];
    }else if (self.messageType == LCMessageTypeActivity) {
        cell = [tableView dequeueReusableCellWithIdentifier:ActivityIdentifier];
        if (!cell) {
            cell = (LCPushMessageCell *)[[NSBundle  mainBundle] loadNibNamed:NSStringFromClass([LCPushMessageCell class]) owner:self options:nil].lastObject;
        }
        cell.activityModel = self.dataArr[indexPath.row];
        return cell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.messageType == LCMessageTypeSystem) {
        cellHeight = 168.f;
    }else if (self.messageType == LCMessageTypeOrder) {
        cellHeight = 196.f;
    }else if (self.messageType == LCMessageTypeActivity) {
        cellHeight = 244.f;
    }else {
        cellHeight = 0.f;
    }
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.messageType == LCMessageTypeSystem) {
        [self systemMessageMethodWithIndexPath:indexPath];
    }else if (self.messageType == LCMessageTypeOrder) {
        [self OrderMessageMethodWithIndexPath:indexPath];
    }else if (self.messageType == LCMessageTypeActivity) {
        [self ActivityMessageMethodWithIndexPath:indexPath];
    }
}

- (void)systemMessageMethodWithIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataArr[indexPath.row] jumptype].integerValue == 1) {
        WebViewController *webVC = [WebViewController new];
        webVC.homeUrl = [self.dataArr[indexPath.row] content];
        webVC.navTitle = [self.dataArr[indexPath.row] t_title];
        [self.navigationController pushViewController:webVC animated:YES];
    }else if ([self.dataArr[indexPath.row] jumptype].integerValue == 3) {
        if ([self.dataArr[indexPath.row] order_state].integerValue == 0) {
            // 全部订单
            OrderVC *order = [OrderVC new];
            order.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:order animated:YES];
        }else if ([self.dataArr[indexPath.row] order_state].integerValue == 10) {
            // 待付款
            OrderListVC *order = [OrderListVC new];
            order.hidesBottomBarWhenPushed = YES;
            order.orderType = @"state_new";
            [self.navigationController pushViewController:order animated:YES];
        }else if ([self.dataArr[indexPath.row] order_state].integerValue == 20) {
            // 待发货
            OrderListVC *order = [OrderListVC new];
            order.orderType = @"state_pay";
            order.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:order animated:YES];
        }else if ([self.dataArr[indexPath.row] order_state].integerValue == 30) {
            // 已发货
            OrderListVC *order = [OrderListVC new];
            order.orderType = @"state_send";
            order.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:order animated:YES];
        }else if ([self.dataArr[indexPath.row] order_state].integerValue == 40) {
            // 已完成
            OrderListVC *order = [OrderListVC new];
            order.orderType = @"state_success";
            order.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:order animated:YES];
        }
    }
}

- (void)OrderMessageMethodWithIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataArr[indexPath.row] order_state].integerValue == 0) {
        // 全部订单
        OrderVC *order = [OrderVC new];
        order.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:order animated:YES];
    }else if ([self.dataArr[indexPath.row] order_state].integerValue == 10) {
        // 待付款
        OrderListVC *order = [OrderListVC new];
        order.hidesBottomBarWhenPushed = YES;
        order.orderType = @"state_new";
        [self.navigationController pushViewController:order animated:YES];
    }else if ([self.dataArr[indexPath.row] order_state].integerValue == 20) {
        // 待发货
        OrderListVC *order = [OrderListVC new];
        order.orderType = @"state_pay";
        order.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:order animated:YES];
    }else if ([self.dataArr[indexPath.row] order_state].integerValue == 30) {
        // 已发货
        OrderListVC *order = [OrderListVC new];
        order.orderType = @"state_send";
        order.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:order animated:YES];
    }else if ([self.dataArr[indexPath.row] order_state].integerValue == 40) {
        // 已完成
        OrderListVC *order = [OrderListVC new];
        order.orderType = @"state_success";
        order.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:order animated:YES];
    }
}

- (void)ActivityMessageMethodWithIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataArr[indexPath.row] jumptype].integerValue == 6) {
        // 跳转直播组
        if ([self.dataArr[indexPath.row] ac_state].integerValue == 0) {
            // 预热
            LiveListVC *listVC = [LiveListVC new];
            listVC.livelistType = LiveListOfPreHearting;
            listVC.activity_id = [self.dataArr[indexPath.row] activity_id];
            listVC.ac_state = [self.dataArr[indexPath.row] ac_state];
            listVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:listVC animated:YES];
            
        }else if ([self.dataArr[indexPath.row] ac_state].integerValue == 1) {
            // 进行中
            LiveListVC *listVC = [LiveListVC new];
            listVC.livelistType = LiveListOfLiving;
            listVC.activity_id = [self.dataArr[indexPath.row] activity_id];
            listVC.ac_state = [self.dataArr[indexPath.row] ac_state];
            listVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:listVC animated:YES];
            
        }else if ([self.dataArr[indexPath.row] ac_state].integerValue == 0) {
            // 结束
            LiveListVC *listVC = [LiveListVC new];
            listVC.livelistType = LiveListOfEnd;
            listVC.activity_id = [self.dataArr[indexPath.row] activity_id];
            listVC.ac_state = [self.dataArr[indexPath.row] ac_state];
            listVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:listVC animated:YES];
            
        }
        
    }else if ([self.dataArr[indexPath.row] jumptype].integerValue == 2 || [self.dataArr[indexPath.row] jumptype].integerValue == 5) {
        // 跳到具体活动
        if ([self.dataArr[indexPath.row] live_state].integerValue == 0) {
            // 预热
            PreheatingVC *pVC = [PreheatingVC new];
            pVC.liveId = [self.dataArr[indexPath.row] live_id];
            pVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pVC animated:YES];
            
        }else if ([self.dataArr[indexPath.row] live_state].integerValue == 1 || [self.dataArr[indexPath.row] live_state].integerValue == 4){
            // 直播
            if ([[self.dataArr[indexPath.row] live_data] activity_type].integerValue == 0) {
                // 图文直播
                PhotoLivingVC *pVC = [PhotoLivingVC new];
                pVC.liveId = [self.dataArr[indexPath.row] live_id];
                [self.navigationController pushViewController:pVC animated:YES];
                
            }else if ([[self.dataArr[indexPath.row] live_data] activity_type].integerValue == 1) {
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
                             [self.navigationController pushViewController:lVC animated:YES];
                         });
                     }else {
                         [YPC_Tools showSvpHudError:@"加载失败, 请重试"];
                     }
                 }];
            }
            
        }else if ([self.dataArr[indexPath.row] live_state].integerValue == 2 || [self.dataArr[indexPath.row] live_state].integerValue == 3) {
            VideoPlayerVC *vVC = [VideoPlayerVC new];
            vVC.liveId = [self.dataArr[indexPath.row] live_id];
            [self.navigationController pushViewController:vVC animated:YES];
        }
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
