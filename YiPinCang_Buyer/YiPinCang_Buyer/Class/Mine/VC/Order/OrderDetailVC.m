//
//  OrderDetailVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/4.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "OrderDetailVC.h"
#import "OrderDetailModel.h"
#import "OrderWaitSendWCell.h"
#import "OrderFooter.h"
#import "OrderHeader.h"
#import "OrderDetailView.h"
#import "LogisticsVC.h"
@interface OrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (strong, nonatomic)OrderDetailModel *model;
@property (nonatomic,strong)OrderFooter *footerView;
@property (nonatomic,strong)OrderHeader *headerView;
@property (nonatomic,strong)OrderDetailView *orderDetailView;
@end

@implementation OrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    
    [self setRightBar];
    
    [self getData];

    // Do any additional setup after loading the view from its nib.
}
- (void)setRightBar{
    UIButton *rightBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn1.frame = CGRectMake(0, 0, 25, 25);
    [rightBtn1 setImage:IMAGE(@"mine_icon_news") forState:UIControlStateNormal];
    [rightBtn1 addTarget:self action:@selector(messageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *message = [[UIBarButtonItem alloc]initWithCustomView:rightBtn1];
    self.navigationItem.rightBarButtonItems = @[message];
    rightBtn1.badgeValue = @"2";
}
- (void)setup{
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 49, 0));
    
   
    if ([self.model.invoice_info isEqualToString:@"不需要发票"]) {
        self.footerView = [[OrderFooter alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 270 - 26)];
        self.footerView.invNameLabHeight.constant = 0;
        self.footerView.invTitleLabHeight.constant = 0;
        
    }else{
         self.footerView = [[OrderFooter alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 270)];
        self.footerView.invNameLabHeight.constant = 13;
        self.footerView.invTitleLabHeight.constant = 13;
        self.footerView.invNameLab.text = [NSString stringWithFormat:@"发票抬头:%@",@""];
        self.footerView.invTitleLab.text = [NSString stringWithFormat:@"发票内容:%@",@"明细"];
    }
    self.footerView.invTypeLab.text = self.model.invoice_info;
    self.footerView.orderPriceLab.text = [NSString stringWithFormat:@"¥%@",_model.order_amount];
    self.footerView.sendPriceLab.text = [NSString stringWithFormat:@"¥%@",_model.shipping_fee];
    self.footerView.payPriceLab.text = [NSString stringWithFormat:@"¥%@",_model.goods_amount];
    self.footerView.titleLab.text = self.model.order_message;
    self.footerView.payTypeLab.text = self.model.payment_name;
    self.footerView.orderTypeLab.text = _model.state_desc;
   
    if ([self.model.state_desc isEqualToString:@"待付款"]) {
        _headerView = [[OrderHeader alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 171)];
        _headerView.payViewHeight.constant = 82;
        _headerView.sendtimeLabHeight.constant = 0;
        _headerView.timeLabHeight.constant = 0;
        _headerView.paytimeLabHeight.constant = 0;
        self.orderDetailView = [[OrderDetailView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 49, ScreenWidth, 49) orderType:OrderTypeOfState_pay];
        [self.view addSubview:self.orderDetailView];
        self.orderDetailView.time = self.model.remaintime;
    }else if ([self.model.state_desc isEqualToString:@"已发货"]){
        _headerView = [[OrderHeader alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 220)];
        _headerView.payViewHeight.constant = 153;
        _headerView.timeLabHeight.constant = 0;
        self.orderDetailView = [[OrderDetailView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 49, ScreenWidth, 49) orderType:OrderTypeOfSent];
        [self.view addSubview:self.orderDetailView];
    }else if ([self.model.state_desc isEqualToString:@"已完成"]){
        _headerView = [[OrderHeader alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 242)];
        self.orderDetailView = [[OrderDetailView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 49, ScreenWidth, 49) orderType:OrderTypeOfFinish];
        [self.view addSubview:self.orderDetailView];
    }else if ([self.model.state_desc isEqualToString:@"待发货"]){
        _headerView = [[OrderHeader alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 210)];
        _headerView.payViewHeight.constant = 82 + 30 ;
        _headerView.sendtimeLabHeight.constant = 0;
        _headerView.timeLabHeight.constant = 0;
        _headerView.paytimeLabHeight.constant = 13;
        self.orderDetailView = [[OrderDetailView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 49, ScreenWidth, 49) orderType:OrderTypeOfState_sent];
        self.orderDetailView.hidden = YES;
        [self.view addSubview:self.orderDetailView];
        self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    }else{
        _headerView = [[OrderHeader alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 171)];
        _headerView.payViewHeight.constant = 82;
        _headerView.sendtimeLabHeight.constant = 0;
        _headerView.timeLabHeight.constant = 0;
        _headerView.paytimeLabHeight.constant = 0;
        self.orderDetailView = [[OrderDetailView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 49, ScreenWidth, 49) orderType:OrderTypeOfFinish];
        self.orderDetailView.hidden = YES;
        [self.view addSubview:self.orderDetailView];
        self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    }
    _headerView.nameLab.text = [NSString stringWithFormat:@"收货人:%@ %@",self.model.reciver_info.reciver_name,self.model.reciver_info.mob_phone];
    _headerView.areaLab.text = [NSString stringWithFormat:@"详细地址:%@",self.model.reciver_info.address];
    _headerView.payNumberLab.text = [NSString stringWithFormat:@"交易编号:%@",self.model.pay_sn];
    _headerView.orderTypeLab.text = [NSString stringWithFormat:@"订单状态:%@",self.model.state_desc];
    NSString *downTime = [YPC_Tools timeWithTimeIntervalString:self.model.add_time Format:@"YYYY-MM-dd HH:mm:ss"];
    NSString *payTime = [YPC_Tools timeWithTimeIntervalString:self.model.payment_time Format:@"YYYY-MM-dd HH:mm:ss"];
    NSString *finTime = [YPC_Tools timeWithTimeIntervalString:self.model.finnshed_time Format:@"YYYY-MM-dd HH:mm:ss"];
    NSString *sendTime = [YPC_Tools timeWithTimeIntervalString:self.model.shipping_time Format:@"YYYY-MM-dd HH:mm:ss"];
    _headerView.downOrderTimeLab.text = [NSString stringWithFormat:@"下单时间:%@",downTime];
    _headerView.payPriceLab.text = [NSString stringWithFormat:@"付款时间:%@",payTime];
    _headerView.sendTimeLab.text = [NSString stringWithFormat:@"发货时间:%@",sendTime];
    _headerView.timeLab.text = [NSString stringWithFormat:@"收货时间:%@",finTime];

    self.tableView.tableHeaderView = _headerView;
    self.tableView.tableFooterView = self.footerView;
    WS(weakself);
    self.orderDetailView.btnClick = ^(NSString *str){
        YPCAppLog(@"%@",str);
        if ([str isEqualToString:@"查看物流"]) {
            LogisticsVC *logistics = [[LogisticsVC alloc]init];
            logistics.order_id = weakself.order_id;
            [weakself.navigationController pushViewController:logistics animated:YES];
        }
    };

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 42;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 101;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    OrderGoodsInfoModel * model = self.model.goodsinfo[section];
    UIView *hearderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 42)];
    hearderView.backgroundColor = [UIColor whiteColor];
    UIImageView *img = [[UIImageView alloc]init];
    [hearderView addSubview:img];
    img.sd_layout.leftSpaceToView(hearderView,15)
    .centerYEqualToView(hearderView)
    .widthIs(30)
    .heightIs(30);
    [img setSd_cornerRadiusFromWidthRatio:@0.5];
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text = model.store.store_name;
    [img sd_setImageWithURL:[NSURL URLWithString:model.store.store_avatar] placeholderImage:YPCImagePlaceHolder];
    titleLab.font = [UIFont boldSystemFontOfSize:18];
    titleLab.textAlignment = NSTextAlignmentLeft;
    [hearderView addSubview:titleLab];
    titleLab.sd_layout.leftSpaceToView(img,15)
    .topEqualToView(hearderView)
    .rightEqualToView(hearderView)
    .bottomEqualToView(hearderView);
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 41.5, ScreenWidth, 0.5)];
    lineView.backgroundColor = [Color colorWithHex:@"0xefefef"];
    [hearderView addSubview:lineView];
    return hearderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    OrderGoodsInfoModel * model = self.model.goodsinfo[section];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 101)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *orderNumber = [[UILabel alloc]init];
    [view addSubview:orderNumber];
    orderNumber.textColor = [Color colorWithHex:@"#BFBFBF"];
    orderNumber.textAlignment = NSTextAlignmentLeft;
    orderNumber.font = [UIFont systemFontOfSize:13];
    orderNumber.text = [NSString stringWithFormat:@"订单编号:%@",model.store.order_sn];
    orderNumber.sd_layout
    .leftSpaceToView(view,15)
    .rightEqualToView(view)
    .topEqualToView(view)
    .heightIs(37);
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [Color colorWithHex:@"0xefefef"];
    [view addSubview:lineView];
    lineView.sd_layout
    .leftEqualToView(view)
    .rightEqualToView(view)
    .topSpaceToView(orderNumber,0)
    .heightIs(1);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"订单咨询" forState:UIControlStateNormal];
    [btn setTitleColor:[Color colorWithHex:@"#2C2C2C"] forState:UIControlStateNormal];
    [btn setImage:IMAGE(@"order_advice_icon") forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.layer.cornerRadius = 2;
    btn.layer.borderWidth = 1;
    [btn addTarget:self action:@selector(orderClick) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.borderColor = [Color colorWithHex:@"0X2C2C2C"].CGColor;
    [view addSubview:btn];
    btn.sd_layout
    .centerXEqualToView(view)
    .topSpaceToView(lineView,13)
    .widthIs(100)
    .heightIs(30);
    UIView *lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = [Color colorWithHex:@"0xefefef"];
    [view addSubview:lineView2];
    lineView2.sd_layout
    .leftEqualToView(view)
    .rightEqualToView(view)
    .topSpaceToView(btn,14)
    .heightIs(7);
    UIView *lineView3 = [[UIView alloc]init];
    lineView3.backgroundColor = [Color colorWithHex:@"0xefefef"];
    [view addSubview:lineView3];
    lineView3.sd_layout
    .leftEqualToView(view)
    .rightEqualToView(view)
    .topSpaceToView(view,0)
    .heightIs(1);
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.model.goodsinfo.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    OrderGoodsInfoModel * model = self.model.goodsinfo[section];
    return model.goods.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"orderDetail";
    OrderWaitSendWCell *cell = (OrderWaitSendWCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"OrderWaitSendWCell" owner:self options:nil];
        cell = arr[0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    OrderGoodsInfoModel * model = self.model.goodsinfo[indexPath.section];
    GoodsModel *goodsModel = model.goods[indexPath.row];
    cell.model = goodsModel;
    return cell;
}

- (void)getData{
    WS(weakself);
    [YPCNetworking postWithUrl:@"shop/orders/detail"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"order_id":_order_id
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakself.model = [OrderDetailModel mj_objectWithKeyValues:response[@"data"]];
                               if (!weakself.tableView) {
                                   [weakself setup];
                               }else{
                                   [weakself.tableView reloadData];
                               }
                           }
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}


#pragma mark - 右上角
- (void)messageBtnClick{
    
}

#pragma mark - 订单咨询
- (void)orderClick{
    YPCAppLog(@"订单咨询");
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
