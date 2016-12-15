//
//  FollowVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/10.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "FollowVC.h"
#import "FollowCell.h"
#import "FollowModel.h"
#import "LiveDetailHHHVC.h"
@interface FollowVC ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation FollowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的关注";
    self.tableView.tableFooterView = [UIView new];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.view.backgroundColor = [Color colorWithHex:@"0xefefef"];
    self.tableView.backgroundColor = [Color colorWithHex:@"0xefefef"];
    [self getData];
}




- (void)getData{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/showstore/followstore/list"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                             
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.dataArr = [FollowModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                               [weakSelf.tableView reloadData];
                               
                           }
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}

- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 87;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    FollowCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"FollowCell" owner:self options:nil][0];
    }
    cell.followBtn.tag = indexPath.row;
    if(self.dataArr.count != 0  ){
        cell.model = self.dataArr[indexPath.row];
    }
    [cell.followBtn addTarget:self action:@selector(followBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LiveDetailHHHVC *live = [[LiveDetailHHHVC alloc]init];
    FollowModel *model = self.dataArr[indexPath.row];
    live.store_id = model.store_id;
    [self.navigationController pushViewController:live animated:YES];
}


- (void)followBtnClick:(UIButton *)sender{
    
    FollowModel *model = self.dataArr[sender.tag];
    if (sender.selected) {
        [YPCNetworking postWithUrl:@"shop/showstore/followstore/add"
                      refreshCache:YES
                            params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                   @"store_id":model.store_id
                                                                                   }]
                           success:^(id response) {
                               if ([YPC_Tools judgeRequestAvailable:response]) {
                                   sender.selected =! sender.selected;
                                   
                               }
                               
                           }
                              fail:^(NSError *error) {
                                  
                              }];
    }else{
        [YPCNetworking postWithUrl:@"shop/showstore/followstore/cancel"
                      refreshCache:YES
                            params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                   @"store_id":model.store_id
                                                                                   }]
                           success:^(id response) {
                               if ([YPC_Tools judgeRequestAvailable:response]) {
                                   sender.selected =! sender.selected;
                                   
                               }
                               
                           }
                              fail:^(NSError *error) {
                                  
                              }];
    }
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
    
    return [UIImage imageNamed:@"mine_follow_icon"];
    
    
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return YES;
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"您还没有关注任何主播";
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
