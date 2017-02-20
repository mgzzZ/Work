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
@interface OrderListVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,copy)NSString *page;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,assign)BOOL ishave;
@end

@implementation OrderListVC
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.after) {
       [self addMjRefresh];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rt_disableInteractivePop = YES;
    self.view.backgroundColor = [Color colorWithHex:@"#EFEFEF"];
    [self initVar];

    [self addMjRefresh];
    [self getDataWithType:self.orderType page:self.page];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoOrderDetail) name:PaySuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoOrderDetailError) name:PayError object:nil];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:IMAGE(@"back_icon") forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self
               action:@selector(backClick)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    if (_isRefresh) {
        [self.tableView.mj_header beginRefreshing];
    }
}

/**
 初始化变量
 */
- (void)initVar{
    _page = @"1";
    _ishave = NO;
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

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
        [self.view addSubview:_tableView];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = NO;
        _tableView.backgroundColor = [Color colorWithHex:@"#EFEFEF"];
        _tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    }
    return _tableView;
}

#pragma mark - 刷新加载
- (void)addMjRefresh
{
    WS(weakSelf);
    self.tableView.mj_header = [YPCRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.page = @"1";
        [weakSelf getDataWithType:weakSelf.orderType page:weakSelf.page];
    }];
   // [self.tableView.mj_header beginRefreshing];
}
- (void)getDataWithType:(NSString *)type page:(NSString *)page{
     WS(weakSelf);
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
                           if ([weakSelf.page isEqualToString:@"1"]) {
                               [weakSelf.dataArr removeAllObjects];
                           }
                           NSMutableArray *arr = [OrderListModel mj_objectArrayWithKeyValuesArray:response [@"data"]];
                           [weakSelf.dataArr addObjectsFromArray:arr];
                           if (weakSelf.dataArr.count != 0 && _ishave == NO) {
                               _ishave = YES;
                               weakSelf.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                                   
                                   weakSelf.page = [NSString stringWithFormat:@"%zd",weakSelf.page.integerValue + 1];
                                   [weakSelf getDataWithType:weakSelf.orderType page:weakSelf.page];
                                   [weakSelf.tableView.mj_footer endRefreshing];
                                  
                               }];
                           }else if (weakSelf.dataArr == 0){
                               weakSelf.tableView.mj_footer.hidden = YES;
                           }else{
                               weakSelf.tableView.mj_footer.hidden = NO;
                           }
                           if (arr.count < 10) {
                               [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                           }
                           [weakSelf.tableView reloadData];
                            [weakSelf.tableView.mj_header endRefreshing];
                       }
                          fail:^(NSError *error) {
                              [weakSelf.tableView.mj_header endRefreshing];
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
        WS(weakself);
        cell.didCollect = ^{
            OrderListModel *model = weakself.dataArr[indexPath.row];
            OrderDetailVC *order = [[OrderDetailVC alloc]init];
            order.order_id = model.order_id;
            [weakself.navigationController pushViewController:order animated:YES];
        };
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

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    
    return scrollView.frame.origin.y - 50.f;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"blankpage_order_icon"];
    
    
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return YES;
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"您还没有相关订单";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName: [Color colorWithHex:@"0x2c2c2c"]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)gotoOrderDetail{
    self.page = @"1";
    self.orderType = @"state_pay";
    [self getDataWithType:@"state_pay" page:@"1"];

}
- (void)gotoOrderDetailError{
    self.page = @"1";
    self.orderType = @"state_new";
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
    [YPC_Tools customAlertViewWithTitle:@"提示:" Message:@"确认取消该订单?" BtnTitles:@[@"确认"] CancelBtnTitle:@"取消" DestructiveBtnTitle:nil actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
        WS(weakself);
        [YPCNetworking postWithUrl:@"shop/orders/cancel"
                      refreshCache:YES
                            params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                   @"order_id":model.order_id
                                                                                   }]
                           success:^(id response) {
                               model.order_state = @"state_cancel";
                               [weakself.dataArr removeObject:model];
                               [weakself.tableView reloadData];
                               if (weakself.dataArr.count == 0) {
                                   weakself.tableView.mj_footer.hidden = YES;
                               }
                               
                           }
                              fail:^(NSError *error) {
                                  
                              }];
    } cancelHandler:nil destructiveHandler:nil];

}

#pragma mark- 删除

- (void)deleteOrder:(OrderListModel *)model{

    [YPC_Tools customAlertViewWithTitle:@"提示:" Message:@"确认删除该订单?" BtnTitles:@[@"确认"] CancelBtnTitle:@"取消" DestructiveBtnTitle:nil actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
        WS(weakself);
        [YPCNetworking postWithUrl:@"shop/orders/delete"
                      refreshCache:YES
                            params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                   @"order_id":model.order_id
                                                                                   }]
                           success:^(id response) {
                               [weakself.dataArr removeObject:model];
                               [weakself.tableView reloadData];
                               if (weakself.dataArr.count == 0) {
                                   weakself.tableView.mj_footer.hidden = YES;
                               }
                               
                           }
                              fail:^(NSError *error) {
                                  
                              }];
    } cancelHandler:nil destructiveHandler:nil];
   
}

//确认收货
- (void)receiveOrder:(OrderListModel *)model{
 
    [YPC_Tools customAlertViewWithTitle:@"提示:" Message:@"确定对该订单进行确认收货?" BtnTitles:@[@"确认"] CancelBtnTitle:@"取消" DestructiveBtnTitle:nil actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
        WS(weakself);
        [YPCNetworking postWithUrl:@"shop/orders/receive"
                      refreshCache:YES
                            params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                   @"order_id":model.order_id
                                                                                   }]
                           success:^(id response) {
                               model.order_state = @"state_noeval";
                               [weakself addMjRefresh];
                               [weakself.tableView reloadData];
                               
                           }
                              fail:^(NSError *error) {
                                  
                              }];
    } cancelHandler:nil destructiveHandler:nil];
    
    
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
