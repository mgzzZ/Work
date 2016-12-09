//
//  MineVC.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/10/31.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "MineVC.h"
#import "LoginVC.h"
#import "OrderVC.h"
#import "OrderListVC.h"
#import "HelpCenterVC.h"
#import "MerchandiseDetailVC.h"
#import "SetVC.h"
#import "AccounManagerVC.h"
#import "HCPageVC.h"
#import "ShoppingCarVC.h"

static NSString *Identifier = @"identifier";
@interface MineVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *naviShopCar;
@property (nonatomic, strong) UIButton *naviMesCar;

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tvHeaderView;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIView *avatarBgView;
@property (strong, nonatomic) IBOutlet UILabel *desL;

@end

@implementation MineVC

#pragma mark - VC声明周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.subviews.firstObject.alpha = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupNaviConfig];
    [self viewConfig];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([YPCRequestCenter isLogin]) {
        self.naviMesCar.badgeValue = [YPCRequestCenter shareInstance].kUnReadMesCount;
        self.naviShopCar.badgeValue = [YPCRequestCenter shareInstance].kShopingCarCount;
        
        self.loginBtn.hidden = YES;
        self.avatarBgView.hidden = NO;
        [self.loginBtn setImage:IMAGE([YPCRequestCenter shareInstance].model.member_avatar) forState:UIControlStateNormal];
        self.desL.text = [YPCRequestCenter shareInstance].model.member_truename;
    }else {
        self.loginBtn.hidden = NO;
        self.avatarBgView.hidden = YES;
    }
}

#pragma mark - Config
- (void)setupNaviConfig
{
    self.naviShopCar = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.naviShopCar setImage:IMAGE(@"mine_icon_cart") forState:UIControlStateNormal];
    self.naviShopCar.acceptEventInterval = 1.f;
    [self.naviShopCar sizeToFit];
    [self.naviShopCar addTarget:self
                         action:@selector(shopCarClickAction)
               forControlEvents:UIControlEventTouchUpInside];
    
    self.naviMesCar = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.naviMesCar setImage:IMAGE(@"mine_icon_inform") forState:UIControlStateNormal];
    self.naviMesCar.acceptEventInterval = 1.f;
    [self.naviMesCar sizeToFit];
    [self.naviMesCar addTarget:self
                        action:@selector(mesBtnClickAction)
              forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *shopCarItem = [[UIBarButtonItem alloc] initWithCustomView:self.naviShopCar];
    UIBarButtonItem *mesItem = [[UIBarButtonItem alloc] initWithCustomView:self.naviMesCar];
    self.navigationItem.rightBarButtonItem = shopCarItem;
    self.navigationItem.leftBarButtonItem = mesItem;
}
- (void)viewConfig
{
    [self.tvHeaderView setHeight:ScreenHeight / 25 * 7 + 114];
    [self.tableView setTableHeaderView:self.tvHeaderView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:Identifier];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            return 2;
        }
            break;
        case 1:
        {
            return 2;
        }
            break;
        case 2:
        {
            return 1;
        }
            break;
        case 3:
        {
            return 1;
        }
            break;
        default:
            break;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        NSArray *nameArr = @[@[@"品牌订阅",@"活动订阅"],@[@"账户管理"],@[@"帮助中心"]];
        NSArray *imgArr = @[
                            @[@"mine_icon_brandsubscribe",@"mine_icon_activitiessubscribe"],
                            @[@"mine_icon_accountmanagement"],
                            @[@"mine_icon_helpcenter"]
                            ];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                //我的订单
                if (![YPCRequestCenter isLogin]) {
                    
                }else{
                    OrderVC *order = [[OrderVC alloc]init];
                    order.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:order animated:YES];
                }
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    //品牌阅读
                }
                    break;
                case 1:{
                    //活动订阅
                }
                    
                default:
                    break;
            }
        }
            break;
        case 2:{
            //账户管理
            if (![YPCRequestCenter isLogin]) {
                
            }else{
                AccounManagerVC *accoun = [[AccounManagerVC alloc]init];
                accoun.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:accoun animated:YES];
            }
            
        }
            break;
        case 3:{
            if (![YPCRequestCenter isLogin]) {
                
            }else{
                HelpCenterVC *help = [[HelpCenterVC alloc]init];
                help.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:help animated:YES];
            }
            
        }
            break;
        default:
            break;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView.contentOffset.y > 70) {
         CGFloat alpha = MIN(1, 1 - ((70 + 64 -scrollView.contentOffset.y) / 64));
        self.navigationController.navigationBar.subviews.firstObject.alpha = alpha;
    }else{
        self.navigationController.navigationBar.subviews.firstObject.alpha = 0;
    }
    
}


#pragma mark -
#pragma mark - btn action
/**
 等待晒单
 */
- (void)waitShowClick{
    if (![YPCRequestCenter isLogin]) {
        
    }else{
        OrderListVC *order = [[OrderListVC alloc]init];
        order.orderType = @"state_noeval";
        order.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:order animated:YES];
    }
}

/**
 等待发货
 */
- (void)waitShipmentsBtnClick{
    if (![YPCRequestCenter isLogin]) {
        
    }else{
        OrderListVC *order = [[OrderListVC alloc]init];
        order.orderType = @"state_pay";
        order.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:order animated:YES];
    }
}

/**
 已经发货
 */
- (void)shipmentsBtnClcik{
    if (![YPCRequestCenter isLogin]) {
        
    }else{
        OrderListVC *order = [[OrderListVC alloc]init];
        order.orderType = @"state_send";
        order.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:order animated:YES];
    }
}

/**
 待支付
 */
- (void)paymentBtnClick{
    if (![YPCRequestCenter isLogin]) {
        
    }else{
        OrderListVC *order = [[OrderListVC alloc]init];
        order.hidesBottomBarWhenPushed = YES;
        order.orderType = @"state_new";
        [self.navigationController pushViewController:order animated:YES];
    }
}

/**
 登录
 */
- (IBAction)loginBtnClick:(UIButton *)sender {
    [YPCRequestCenter isLoginAndPresentLoginVC:self];
}

/**
 设置
 */
- (void)setBtnClick{


    if (![YPCRequestCenter isLogin]) {



    }else{
        SetVC *set = [[SetVC alloc]init];
        set.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:set animated:YES];
    }
    
    
}

/**
 购物车
 */
- (void)shopCarClickAction{
    if (![YPCRequestCenter isLogin]) {
        
    }else{
        ShoppingCarVC *shopcar = [[ShoppingCarVC alloc]init];
        shopcar.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shopcar animated:YES];
    }
}

/**
 消息
 */
- (void)mesBtnClickAction{
    if (![YPCRequestCenter isLogin]) {
        
    }else{
        
    }
}

/**
 关注
 */
- (void)fllownBtnClick{
    if (![YPCRequestCenter isLogin]) {
        
    }else{
        
    }
}

/**
 收藏
 */
- (void)likeBtnClick{
    if (![YPCRequestCenter isLogin]) {
        
    }else{
        HCPageVC *pageVC = [HCPageVC new];
        pageVC.navigationItem.title = @"我的收藏";
        pageVC.subViewType = PageSubViewCollect;
        pageVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pageVC animated:YES];
    }
}

/**
 足迹
 */
- (void)footBtnClick{
    if (![YPCRequestCenter isLogin]) {
        
    }else{
        HCPageVC *pageVC = [HCPageVC new];
        pageVC.navigationItem.title = @"我的足迹";
        pageVC.subViewType = PageSubViewHistory;
        pageVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pageVC animated:YES];
    }
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
