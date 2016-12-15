//
//  HelpDetailVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/11.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "HelpDetailVC.h"
#import "HelpDetailCell.h"
#import "HelpDetailModel.h"
#import "WebViewController.h"
@interface HelpDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation HelpDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [Color colorWithHex:@"0xefefef"];
    self.navigationItem.title = self.name;
}
- (void)setAc_id:(NSString *)ac_id{
    if (![_ac_id isEqualToString:ac_id]) {
        _ac_id = ac_id;
    }
    [self getData];
}

- (void)getData{
    WS(weakself);
    [YPCNetworking postWithUrl:@"shop/help/articlelist"
                  refreshCache:YES
                        params:@{
                                 @"ac_id":weakself.ac_id
                                 }
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakself.dataArr = [HelpDetailModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                               [weakself.tableView reloadData];
                           }
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    HelpDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"HelpDetailCell" owner:self options:nil][0];
    }
    cell.model = self.dataArr[indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HelpDetailModel *model = self.dataArr[indexPath.row];
    WebViewController *web = [[WebViewController alloc]init];
    web.navTitle = model.article_title;
    web.homeUrl = model.article_url;
    [self.navigationController pushViewController:web animated:YES];
}

- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
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
