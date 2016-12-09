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
@interface LogisticsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)LoginsticsHeaderView *headerView;
@property (nonatomic,strong)LogisticsinModel *model;
@end

@implementation LogisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"查看物流";
    [self getData];
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        [self.view addSubview:_tableView];
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _headerView = [[LoginsticsHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 77)];
        _tableView.tableHeaderView = _headerView;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
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
