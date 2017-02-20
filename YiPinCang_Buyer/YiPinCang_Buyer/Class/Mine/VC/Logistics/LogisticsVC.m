//
//  LogisticsVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/29.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LogisticsVC.h"
#import "LogisticsCell.h"
#import "LoginsticsHeaderView.h"
#import "LogisticsinModel.h"
@interface LogisticsVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)LoginsticsHeaderView *headerView;
@property (nonatomic,strong)LogisticsinModel *model;
@end

@implementation LogisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"查看物流";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:[UIView new]];
    [self getData];
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        [self.view addSubview:_tableView];
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(64, 0, 0, 0));
        
    }
    return _tableView;
}


- (LoginsticsHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [[LoginsticsHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 77)];
        self.tableView.tableHeaderView = _headerView;
    }
    return _headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.content.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    LogisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"LogisticsCell" owner:self options:nil][0];
    }
    if (indexPath.row == 0) {
        cell.textLab.textColor = [Color colorWithHex:@"#36A74D"];
        cell.lineView.hidden = YES;
    }else{
        cell.textLab.textColor = [Color colorWithHex:@"#2C2C2C"];
        cell.lineView.hidden = NO;
    }
    if (self.model.content.count != 0) {
        cell.model = self.model.content[indexPath.row];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    
    return scrollView.frame.origin.y - 50.f;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [UIImage imageNamed:@"viewlogistics_icon"];
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return YES;
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂时没有物流信息";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName: [Color colorWithHex:@"0x2c2c2c"]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)getData{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/orders/express"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"order_id":self.order_id
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.model = [LogisticsinModel mj_objectWithKeyValues:response[@"data"]];
                               if (weakSelf.model.exname.length > 0) {
                                  weakSelf.headerView.nameLab.text = weakSelf.model.exname;
                               }
                               if (weakSelf.model.codenumber.length > 0) {
                                   weakSelf.headerView.numberLab.text = weakSelf.model.codenumber;
                               }
                               
                               [weakSelf.tableView reloadData];
                               
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
