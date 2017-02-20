//
//  ChoosePayVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/25.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "ChoosePayVC.h"
#import "ChoosePayCell.h"
#import "ChoosePayModel.h"
#import "PayManager.h"
#import "OrderListVC.h"
#import "PayParamModel.h"
#import "PaylistModel.h"
@interface ChoosePayVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataArr;

@property (nonatomic,copy)NSString *payType;

@property (nonatomic,strong)UIView *bottomView;

@property (nonatomic,strong)ChoosePayModel *model;

@property (nonatomic,strong)PayParamModel *payModel;
@end

@implementation ChoosePayVC
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Color colorWithHex:@"0xefefef"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"支付方式";
    [self getdata];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoOrderDetail) name:PaySuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoOrderDetailError) name:PayError object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoOrderDetailWechatPay) name:WechatPay object:nil];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:IMAGE(@"back_icon") forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self
               action:@selector(backClick123)
     forControlEvents:UIControlEventTouchUpInside];
    //button.frame = CGRectMake(0, 0, 44, 44);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];

}

#pragma mark- setup

- (void)setup{
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    self.bottomView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs(49);
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [payBtn setTitle:@"付款" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    payBtn.backgroundColor = [Color colorWithHex:@"#E4393C"];
    [payBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:payBtn];
    
    UILabel *priceLab = [[UILabel alloc]init];
    priceLab.textColor = [Color colorWithHex:@"#e4393c"];
    priceLab.textAlignment = NSTextAlignmentLeft;
    priceLab.font = [UIFont systemFontOfSize:15];
    [self.bottomView addSubview:priceLab];
    priceLab.text = [NSString stringWithFormat:@"支付 ¥%@",self.model.amount];
    
    payBtn.sd_layout
    .rightEqualToView(self.bottomView)
    .topEqualToView(self.bottomView)
    .bottomEqualToView(self.bottomView)
    .widthIs(116);
    priceLab.sd_layout
    .leftSpaceToView(self.bottomView,15)
    .topEqualToView(self.bottomView)
    .bottomEqualToView(self.bottomView)
    .rightEqualToView(payBtn);
}


#pragma mark- getdata

- (void)getdata{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/flow/prepay"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"pay_sn":self.pay_sn
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.model = [ChoosePayModel mj_objectWithKeyValues:response[@"data"]];
                               [weakSelf.tableView reloadData];
                               if (weakSelf.bottomView == nil) {
                                   [weakSelf setup];

                               }
                           }
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}


#pragma mark- tableView deleta && datasourse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.paylist.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    view.backgroundColor = [Color colorWithHex:@"0xefefef"];
    UILabel *titileLab = [[UILabel alloc]init];
    titileLab.text = @"目前仅支持以下付款方式";
    titileLab.font = [UIFont systemFontOfSize:10];
    titileLab.textAlignment = NSTextAlignmentLeft;
    titileLab.textColor = [Color colorWithHex:@"0xbfbfbf"];
    [view addSubview:titileLab];
    titileLab.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 15, 0, 0));
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"paycell";
    ChoosePayCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ChoosePayCell" owner:self options:nil][0];
    }
    
    PaylistModel *model = self.model.paylist[indexPath.row];
    [cell.payTypeImg sd_setImageWithURL:[NSURL URLWithString:model.img.small] placeholderImage:YPCImagePlaceHolder];
    cell.payLab.text = model.name;
    if (indexPath.row == 0) {
        self.payType = model.type;
        [cell.chooseImg setImage:IMAGE(@"mmine_cart_button_clicked")];
    }else{
        [cell.chooseImg setImage:IMAGE(@"mmine_cart_button_unclicked")];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 0) {
        ChoosePayCell *cell1 = (ChoosePayCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell1.chooseImg setImage:IMAGE(@"mmine_cart_button_unclicked")];
    }
    ChoosePayCell *cell = (ChoosePayCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.chooseImg setImage:IMAGE(@"mmine_cart_button_clicked")];
    PaylistModel *model = self.model.paylist[indexPath.row];
    self.payType = model.type;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChoosePayCell *cell = (ChoosePayCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.chooseImg setImage:IMAGE(@"mmine_cart_button_unclicked")];
     PaylistModel *model = self.model.paylist[indexPath.row];
    self.payType = model.type;
}

#pragma mark--lazy loading

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        [self.view addSubview:_tableView];
        _tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(64, 0, 49, 0));
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}


#pragma action

- (void)payBtnClick:(UIButton *)sender{
    WS(weakself);
    sender.enabled = NO;
    if ([self.payType isEqualToString:@"alipay"]) {
        [YPCNetworking postWithUrl:@"shop/flow/getpayparam"
                      refreshCache:YES
                            params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                   @"pay_sn":weakself.pay_sn,
                                                                                   @"type":weakself.payType
                                                                                   }]
                           success:^(id response) {
                               if ([YPC_Tools judgeRequestAvailable:response]) {
                                   
                                   //weakself.payModel = [PayParamModel mj_objectWithKeyValues:response[@"data"][@"param"]];
                                   NSString *param = response[@"data"][@"param"];
                                   [PayManager doAlipayPayNoNONO:weakself.model.amount body:param success:^{
                                       [[NSNotificationCenter defaultCenter] postNotificationName:PaySuccess object:nil];
                                   } failur:^(NSString *error) {
                                       [YPC_Tools showSvpWithNoneImgHud:[NSString stringWithFormat:@"支付失败:%@",error]];
                                       [[NSNotificationCenter defaultCenter] postNotificationName:PayError object:nil];
                                   }];
                               }
                               
                           }
                              fail:^(NSError *error) {
                                  
                              }];

    }else if([self.payType isEqualToString:@"wechat"]){
        [YPCNetworking postWithUrl:@"shop/flow/getpayparam"
                      refreshCache:YES
                            params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                   @"pay_sn":weakself.pay_sn,
                                                                                   @"type":weakself.payType
                                                                                   }]
                           success:^(id response) {
                               if ([YPC_Tools judgeRequestAvailable:response]) {
                                   
                                   NSString *param = response[@"data"][@"param"];
                                   [PayManager doWechatPayNoNONO:@"" body:param success:^{
//                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                           [[NSNotificationCenter defaultCenter] postNotificationName:PaySuccess object:nil];
                                    //   });
                                   } failur:^(NSString *error) {
                                       [YPC_Tools showSvpWithNoneImgHud:[NSString stringWithFormat:@"支付失败:%@",error]];
                                       [[NSNotificationCenter defaultCenter] postNotificationName:PayError object:nil];
                                   }];
                               }
                               
                           }
                              fail:^(NSError *error) {
                                  
                              }];
    }
}

-(void)gotoOrderDetail{
    OrderListVC *order = [[OrderListVC alloc]init];
    order.orderType = @"state_pay";
    order.hidesBottomBarWhenPushed = YES;
    order.payType = @"1";
    order.isRefresh = YES;
    order.after = YES;
    [self.navigationController pushViewController:order animated:YES];
}
- (void)gotoOrderDetailError{
    OrderListVC *order = [[OrderListVC alloc]init];
    order.orderType = @"state_new";
    order.payType = @"1";
    order.after = YES;
    order.isRefresh = YES;
    order.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:order animated:YES];
}

- (void)gotoOrderDetailWechatPay{
    OrderListVC *order = [[OrderListVC alloc]init];
    order.orderType = @"";
    order.payType = @"1";
    order.after = YES;
    order.isRefresh = YES;
    order.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:order animated:YES];
}

- (void)backClick123{
    [self gotoOrderDetailError];
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
