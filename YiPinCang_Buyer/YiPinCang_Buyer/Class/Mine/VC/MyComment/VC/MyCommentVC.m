//
//  MyCommentVC.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 17/1/18.
//  Copyright © 2017年 Laomeng. All rights reserved.
//

#import "MyCommentVC.h"
#import "MyCommentCell.h"
#import "MyCommentModel.h"
#import "PreheatingDetailVC.h"
#import "DiscoverDetailVC.h"

static NSString *Identifier = @"identifier";
@interface MyCommentVC () <UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, assign) NSInteger dataIndex;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MyCommentVC

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
    self.title = @"我的评论";
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyCommentCell class]) bundle:nil] forCellReuseIdentifier:Identifier];
    
    WS(weakSelf);
    self.tableView.mj_header = [YPCRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf addDataForTableViewFooter];
    }];
    self.tableView.mj_footer.hidden = YES;
    
    [self getData];
}

- (void)getData
{
    WS(weakSelf);
    self.dataIndex = 1;
    [YPCNetworking postWithUrl:@"shop/message/commentmsglist"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"pagination" : @{
                                                                                       @"count" : @"30",
                                                                                       @"page" : [NSString stringWithFormat:@"%ld", self.dataIndex]
                                                                                       },
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               
                               weakSelf.dataArr = [MyCommentModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                               [weakSelf.tableView reloadData];
                               
                               [weakSelf.tableView.mj_header endRefreshing];
                               
                               // 隐藏MJ加载尾部视图
                               if ([response[@"paginated"][@"more"] integerValue] == 1) {
                                   weakSelf.tableView.mj_footer.hidden = NO;
                               }else {
                                   weakSelf.tableView.mj_footer.hidden = YES;
                               }
                           }
                       } fail:^(NSError *error) {
                           
                       }];
}

- (void)addDataForTableViewFooter
{
    WS(weakSelf);
    self.dataIndex++;
    [YPCNetworking postWithUrl:@"shop/message/commentmsglist"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"pagination" : @{
                                                                                       @"count" : @"30",
                                                                                       @"page" : [NSString stringWithFormat:@"%ld", self.dataIndex]
                                                                                       },
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               [weakSelf.dataArr addObjectsFromArray:[MyCommentModel mj_objectArrayWithKeyValuesArray:response[@"data"]]];
                               [weakSelf.tableView reloadData];
                               [weakSelf.tableView.mj_footer endRefreshing];
                               if ([response[@"paginated"][@"more"] integerValue] == 1) {
                                   weakSelf.tableView.mj_footer.hidden = NO;
                               }else {
                                   weakSelf.tableView.mj_footer.hidden = YES;
                               }
                           }
                       } fail:^(NSError *error) {
                           
                       }];
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    cell.tempModel = self.dataArr[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:Identifier cacheByIndexPath:indexPath configuration:^(MyCommentCell *cell) {
        cell.tempModel = self.dataArr[indexPath.row];
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.dataArr[indexPath.row] strace_type] integerValue] == 1 && [[(MyCommentModel *)self.dataArr[indexPath.row] type] integerValue] == 1 ) { // 预热贴
        PreheatingDetailVC *pVC = [PreheatingDetailVC new];
        pVC.detailType = detailStylePerhearting;
        pVC.tempStrace_ID = [self.dataArr[indexPath.row] strace_id];
        [self.navigationController pushViewController:pVC animated:YES];
    }else if ([[self.dataArr[indexPath.row] strace_type] integerValue] == 2 && [[(MyCommentModel *)self.dataArr[indexPath.row] type] integerValue] == 1 ) { // 活动商品贴
        DiscoverDetailVC *dVC = [DiscoverDetailVC new];
        dVC.strace_id = [self.dataArr[indexPath.row] strace_id];
        dVC.typeStr = @"淘好货";
        [self.navigationController pushViewController:dVC animated:YES];
    }else if ([[self.dataArr[indexPath.row] strace_type] integerValue] == 2 && [[(MyCommentModel *)self.dataArr[indexPath.row] type] integerValue] == 2 ) { // 笔记
        PreheatingDetailVC *pVC = [PreheatingDetailVC new];
        pVC.detailType = detailStyleUserCircle;
        pVC.tempStrace_ID = [self.dataArr[indexPath.row] strace_id];
        [self.navigationController pushViewController:pVC animated:YES];
    }else if ([[self.dataArr[indexPath.row] strace_type] integerValue] == 4 && [[(MyCommentModel *)self.dataArr[indexPath.row] type] integerValue] == 2 ) { // 好货分享
        DiscoverDetailVC *dVC = [DiscoverDetailVC new];
        dVC.strace_id = [self.dataArr[indexPath.row] strace_id];
        dVC.typeStr = @"动态";
        [self.navigationController pushViewController:dVC animated:YES];
    }
}

#pragma mark - EmptyDataImageSet
-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return scrollView.frame.origin.y - 50.f;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"blankpage_informations_icon"];
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"您还没有任何评论回复呢~";
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
