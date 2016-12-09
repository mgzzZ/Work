//
//  OrderListVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/3.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "OrderListVC.h"
#import "OrderWaitSendWCell.h"
#import "OrderTypeCell.h"
#import "OrderDetailVC.h"
#import "OrderListModel.h"
#import "DiscoverDetailVC.h"
#import "ChoosePayVC.h"
@interface OrderListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,copy)NSString *page;
@property (nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation OrderListVC
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rt_disableInteractivePop = YES;
    self.view.backgroundColor = [Color colorWithHex:@"#EFEFEF"];
    [self initVar];
    [self setup];
    [self getDataWithType:_orderType page:_page];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoOrderDetail) name:PaySuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoOrderDetailError) name:PayError object:nil];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:IMAGE(@"logon_icon_return") forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self
               action:@selector(backClick)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 44, 44);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

/**
 初始化变量
 */
- (void)initVar{
    _page = @"1";
    self.dataArr = [[NSMutableArray alloc]init];
    if (_orderType) {
        self.navigationItem.title = @"我的订单";
        return;
    }
    switch (self.selectIndex) {
        case 0:
        {
            _orderType = @"";
        }
            break;
        case 1:
        {
            _orderType = @"state_new";
        }
            break;
        case 2:
        {
            _orderType = @"state_pay";
        }
            break;
        case 3:
        {
            _orderType = @"state_send";
        }
            break;
            
            
        default:
            break;
    }
    
}
- (void)setup{
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = NO;
    self.tableView.backgroundColor = [Color colorWithHex:@"#EFEFEF"];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    WS(weakSelf);
    _tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.page = @"1";
        [weakSelf.dataArr removeAllObjects];
        [weakSelf getDataWithType:weakSelf.orderType page:weakSelf.page];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.page = [NSString stringWithFormat:@"%zd",weakSelf.page.integerValue + 1];
        [weakSelf getDataWithType:weakSelf.orderType page:weakSelf.page];
        [weakSelf.tableView.mj_footer endRefreshing];
        
    }];
}

- (void)getDataWithType:(NSString *)type page:(NSString *)page{
    [YPCNetworking postWithUrl:@"shop/orders/list"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"pagination":@{
                                                                                       @"page":page,
                                                                                       @"count":@"10"
                                                                                       },
                                                                               @"type":type
                                                                               }]
                       success:^(id response) {
                           
                           NSMutableArray *arr = [OrderListModel mj_objectArrayWithKeyValuesArray:response [@"data"]];
                           [self.dataArr addObjectsFromArray:arr];
                           if (!arr) {
                               [self.tableView.mj_footer endRefreshingWithNoMoreData];
                           }
                           [self.tableView reloadData];
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderListModel *model = _dataArr[indexPath.row];
    if (model.goods.count == 1) {
        return 233;
    }else{
        return 248;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderListModel *model = _dataArr[indexPath.row];
    WS(weakself);
    static NSString *cellId = @"cell";
    OrderTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (model.goods.count == 1) {
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrderTypeCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
        }
    }else{
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrderTypeCell" owner:self options:nil];
            cell = [nib objectAtIndex:1];
            
        }
    }
    cell.btnclick = ^(OrderListModel *model,NSString *str){
        if ([str isEqualToString:@"立即付款"]) {
            [weakself goPay:model];
        }else if ([str isEqualToString:@"确认收货"]){
            [weakself receiveOrder:model];
        }else if ([str isEqualToString:@"取消订单"]){
            [weakself cancelOrder:model];
        }else if ([str isEqualToString:@"删除订单"]){
            [weakself deleteOrder:model];
        }else{
            
        }
    };

    cell.model = model;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
   
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderListModel *model = _dataArr[indexPath.row];
    OrderDetailVC *order = [[OrderDetailVC alloc]init];
    order.order_id = model.order_id;
    [self.navigationController pushViewController:order animated:YES];
}
- (void)gotoOrderDetail{
    [self getDataWithType:@"state_pay" page:@"1"];

}
- (void)gotoOrderDetailError{
    [self getDataWithType:@"state_new" page:@"1"];

}
- (void)backClick{
    if ([self.payType isEqualToString:@"1"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark- 去支付

- (void)goPay:(OrderListModel *)model{
    ChoosePayVC *chose = [[ChoosePayVC alloc]init];
    chose.price = model.order_amount;
    chose.pay_sn = model.pay_sn;
    [self.navigationController pushViewController:chose animated:YES];
}

#pragma mark- 取消

- (void)cancelOrder:(OrderListModel *)model{
    WS(weakself);
    [YPCNetworking postWithUrl:@"shop/orders/cancel"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"order_id":model.order_id
                                                                               }]
                       success:^(id response) {
                           model.order_state = @"state_cancel";
                           [weakself.tableView reloadData];
                           
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}

#pragma mark- 删除

- (void)deleteOrder:(OrderListModel *)model{
    WS(weakself);
    [YPCNetworking postWithUrl:@"shop/orders/delete"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"order_id":model.order_id
                                                                               }]
                       success:^(id response) {
                           [weakself.dataArr removeObject:model];
                           [weakself.tableView reloadData];
                           
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}

//确认收货
- (void)receiveOrder:(OrderListModel *)model{
    WS(weakself);
    [YPCNetworking postWithUrl:@"shop/orders/receive"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"order_id":model.order_id
                                                                               }]
                       success:^(id response) {
                           
                           model.order_state = @"state_noeval";
                           [weakself.tableView reloadData];
                           
                           
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
