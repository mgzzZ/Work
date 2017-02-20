//
//  ActivitySubscribeVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/10.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "ActivitySubscribeVC.h"
#import "ActivitySubscribeCell.h"
#import "ActivitySubscribeModel.h"
#import "LiveListVC.h"
@interface ActivitySubscribeVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation ActivitySubscribeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"活动提醒";
    [self getData];
    self.tableView.tableFooterView = [UIView new];
}


- (void)getData{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/activity/rssactivitylist"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.dataArr = [ActivitySubscribeModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                               [weakSelf.tableView reloadData];
                               
                           }
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 101;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    ActivitySubscribeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ActivitySubscribeCell" owner:self options:nil][0];
        
    }
    if (self.dataArr.count != 0) {
        ActivitySubscribeModel *model = self.dataArr[indexPath.row];
        cell.model = model;
        if ([model.live_state isEqualToString:@"进行中"]) {
            //直播中
            [cell.typeImg setImage:IMAGE(@"mien_live_icon")];
            [cell.leftImg setImage:IMAGE(@"mine_dynamic_view_icon")];
            [cell.rightImg setImage:IMAGE(@"mine_dynamic_like_icon")];
            cell.leftLab.text = [NSString stringWithFormat:@"%@人观看",model.live_users];
            cell.rightLab.text = model.live_like;
            cell.titleLab.text = model.name;
            cell.rightImg.hidden = NO;
            cell.rightLab.hidden = NO;
        }else if ([model.live_state isEqualToString:@"预告"]){
            //预告
            [cell.typeImg setImage:IMAGE(@"mien_yugao_icon")];
            [cell.leftImg setImage:IMAGE(@"hot_icon")];
            [cell.rightImg setImage:IMAGE(@"mine_dynamic_like_icon")];
            cell.leftLab.text = [NSString stringWithFormat:@"%@热度",model.live_users];
            cell.rightLab.text = [NSString stringWithFormat:@"%@人关注",model.live_like];
            cell.titleLab.text = [NSString stringWithFormat:@" %@",model.name];
            cell.rightImg.hidden = YES;
            cell.rightLab.hidden = YES;
        }else if ([model.live_state isEqualToString:@"回放"]){
            //回放
            [cell.typeImg setImage:IMAGE(@"mien_huifang_icon")];
            [cell.leftImg setImage:IMAGE(@"mine_dynamic_view_icon")];
            [cell.rightImg setImage:IMAGE(@"mine_dynamic_like_icon")];
            cell.rightImg.hidden = YES;
            cell.leftLab.text = [NSString stringWithFormat:@"%@人观看",model.live_users];
            cell.rightLab.hidden = YES;
            cell.rightLab.text = [NSString stringWithFormat:@"%@人关注",model.live_like];
            cell.titleLab.text = [NSString stringWithFormat:@" %@",model.name];
        }else{
            
        }
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivitySubscribeModel *model = self.dataArr[indexPath.row];
 
    if ([model.live_state isEqualToString:@"进行中"]) {
        //直播中
        LiveListVC *livelistVC = [[LiveListVC alloc]init];
        livelistVC.livelistType = LiveListOfLiving;
        livelistVC.activity_id = model.fid;
        livelistVC.ac_state = model.ac_state;
        [self.navigationController pushViewController:livelistVC animated:YES];

    }else if ([model.live_state isEqualToString:@"预告"]){
        //预告

        LiveListVC *livelistVC = [[LiveListVC alloc]init];
        livelistVC.livelistType = LiveListOfPreHearting;
        livelistVC.activity_id = model.fid;
        livelistVC.ac_state = model.ac_state;
        [self.navigationController pushViewController:livelistVC animated:YES];
    }else if ([model.live_state isEqualToString:@"回放"]){
        //回放
        LiveListVC *livelistVC = [[LiveListVC alloc]init];
        livelistVC.livelistType = LiveListOfEnd;
        livelistVC.activity_id = model.fid;
        livelistVC.ac_state = model.ac_state;
        [self.navigationController pushViewController:livelistVC animated:YES];
    }else{
        
    }

}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [YPC_Tools customAlertViewWithTitle:@"提示:" Message:@"确认取消该活动?" BtnTitles:@[@"确定"] CancelBtnTitle:@"取消" DestructiveBtnTitle:@"" actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
        // 从列表中删除
        ActivitySubscribeModel *model = self.dataArr[indexPath.row];
        
        
        [YPCNetworking postWithUrl:@"shop/activity/rssactivitycancel"
                      refreshCache:YES
                            params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                   @"live_id":model.live_id
                                                                                   }]
                           success:^(id response) {
                               if ([YPC_Tools judgeRequestAvailable:response]) {
                                   
                                   
                               }
                               
                           }
                              fail:^(NSError *error) {
                                  
                              }];
        // 从数据源中删除
        [self.dataArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } cancelHandler:nil destructiveHandler:nil];

    
}

- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr= [NSMutableArray array];
    }
    return _dataArr;
}
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    
    return scrollView.frame.origin.y - 50;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"mine_dynamic_icon"];
    
    
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return YES;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"您还没有订阅活动";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName: [Color colorWithHex:@"0x2c2c2c"]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
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
