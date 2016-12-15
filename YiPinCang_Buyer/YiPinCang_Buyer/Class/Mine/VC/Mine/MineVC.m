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
#import "FollowVC.h"
#import "ActivitySubscribeVC.h"
static NSString *Identifier = @"identifier";
@interface MineVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_cellNameArr;
    NSArray *_cellImgArr;
}
@property (nonatomic, strong) UIButton *naviShopCar;
@property (nonatomic, strong) UIButton *naviMesCar;

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tvHeaderView;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIView *avatarBgView;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImgv;
@property (strong, nonatomic) IBOutlet UILabel *desL;

@property (strong, nonatomic) IBOutlet UIImageView *waitPay;
@property (strong, nonatomic) IBOutlet UIImageView *waitSend;
@property (strong, nonatomic) IBOutlet UIImageView *yetSend;
@property (strong, nonatomic) IBOutlet UIImageView *yetSuccess;


@end

@implementation MineVC

#pragma mark - VC声明周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.subviews.firstObject.alpha = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupNaviConfig];
    [self viewConfig];
    
    _cellNameArr    = @[
                        @[@"活动订阅", @"我的关注"], @[@"帮助中心", @"设置"]
                        ];
    _cellImgArr     = @[
                        @[@"mine_icon_activitiessubscribe", @"mine_myfollow_icon"],
                        @[@"mine_icon_helpcenter", @"mine_set_icon"]
                        ];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.naviMesCar.littleRedBadgeValue = [YPCRequestCenter shareInstance].kUnReadMesCount;
    self.naviShopCar.badgeValue = [YPCRequestCenter shareInstance].kShopingCarCount;
    
    self.waitPay.badgeValue = [YPCRequestCenter shareInstance].model.order_num.await_pay;
    self.waitSend.badgeValue = [YPCRequestCenter shareInstance].model.order_num.await_ship;
    self.yetSend.badgeValue = [YPCRequestCenter shareInstance].model.order_num.shipped;
    self.yetSuccess.badgeValue = [YPCRequestCenter shareInstance].model.order_num.finished;
    if ([YPCRequestCenter isLogin]) {
        [self getData];
        self.loginBtn.hidden = YES;
        self.avatarBgView.hidden = NO;
        [self.avatarImgv sd_setImageWithURL:[NSURL URLWithString:[YPCRequestCenter shareInstance].model.member_avatar] placeholderImage:IMAGE(@"mine_img_avatar")];
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
    [self.tvHeaderView setHeight:ScreenHeight / 20 * 9];
    [self.tableView setTableHeaderView:self.tvHeaderView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:Identifier];
}
- (void)getData{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/user/notify"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{}]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               NSString *cart = response[@"data"][@"cart_num"];
                               NSString *order_new = response[@"data"][@"order_new"];
                               NSString *order_pay = response[@"data"][@"order_pay"];
                               NSString *order_send = response[@"data"][@"order_send"];
                               weakSelf.waitPay.badgeValue = order_new;
                               weakSelf.waitSend.badgeValue = order_pay;
                               weakSelf.yetSend.badgeValue = order_send;
                               weakSelf.naviShopCar.badgeValue = cart;
                           }
                           
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 0;
            break;
        default:
            break;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = IMAGE([_cellImgArr[indexPath.section] objectAtIndex:indexPath.row]);
    cell.textLabel.text = [_cellNameArr[indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [Color colorWithHex:@"#2C2C2C"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    UIImageView *tvAccessoryImgV = [UIImageView new];
    tvAccessoryImgV.frame = CGRectMake(0, 0, 25, 25);
    tvAccessoryImgV.image = IMAGE(@"mine_icon_more");
    cell.accessoryView = tvAccessoryImgV;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 47.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionV = [UIView new];
    sectionV.backgroundColor = [Color colorWithHex:@"#F1F1F1"];
    return sectionV;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    //活动订阅
                {
                    
                    if ([YPCRequestCenter isLoginAndPresentLoginVC:self]) {
                        ActivitySubscribeVC *activity= [[ActivitySubscribeVC alloc]init];
                        activity.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:activity animated:YES];
                    }
                }
                    break;
                case 1:
                    //我的关注
                {
                    if ([YPCRequestCenter isLoginAndPresentLoginVC:self]) {
                        FollowVC *foll = [[FollowVC alloc]init];
                        foll.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:foll animated:YES];
                    }
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:{
                    //帮助中心
                    HelpCenterVC *help = [[HelpCenterVC alloc]init];
                    help.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:help animated:YES];
                }
                    break;
                case 1:{
                    //设置
                    SetVC *set = [[SetVC alloc]init];
                    set.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:set animated:YES];
                }
                    break;
                default:
                    break;
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
- (IBAction)orderBtnClickAction:(UIButton *)sender {
    switch (sender.tag) {
        case 100:{
            if ([YPCRequestCenter isLoginAndPresentLoginVC:self]) {
                // 全部订单
                OrderVC *order = [[OrderVC alloc]init];
                order.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:order animated:YES];
            }
        }
            break;
        case 101:{
            if ([YPCRequestCenter isLoginAndPresentLoginVC:self]) {
                // 待付款
                OrderListVC *order = [[OrderListVC alloc]init];
                order.hidesBottomBarWhenPushed = YES;
                order.orderType = @"state_new";
                [self.navigationController pushViewController:order animated:YES];
            }
        }
            break;
        case 102:{
            if ([YPCRequestCenter isLoginAndPresentLoginVC:self]) {
                // 待发货
                OrderListVC *order = [[OrderListVC alloc]init];
                order.orderType = @"state_pay";
                order.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:order animated:YES];
            }
        }
            break;
        case 103:{
            if ([YPCRequestCenter isLoginAndPresentLoginVC:self]) {
                // 已发货
                OrderListVC *order = [[OrderListVC alloc]init];
                order.orderType = @"state_send";
                order.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:order animated:YES];
            }
        }
            break;
        case 104:{
            if ([YPCRequestCenter isLoginAndPresentLoginVC:self]) {
                // 已完成
                OrderListVC *order = [[OrderListVC alloc]init];
                order.orderType = @"state_success";
                order.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:order animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}
/**
 登录
 */
- (IBAction)loginBtnClick:(UIButton *)sender {
    [YPCRequestCenter isLoginAndPresentLoginVC:self];
}

/**
 账户信息
 */
- (IBAction)accountInfoClickAction:(UIButton *)sender {
    AccounManagerVC *accoun = [[AccounManagerVC alloc]init];
    accoun.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:accoun animated:YES];
}

/**
 购物车
 */
- (void)shopCarClickAction{
    if ([YPCRequestCenter isLoginAndPresentLoginVC:self]) {
        ShoppingCarVC *shopcar = [[ShoppingCarVC alloc]init];
        shopcar.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shopcar animated:YES];
    }
}

/**
 消息
 */
- (void)mesBtnClickAction{
    if ([YPCRequestCenter isLoginAndPresentLoginVC:self]) {
        [YPC_Tools pushConversationListViewController:self];
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


#if 0
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
#endif

#pragma mark - Debug
- (IBAction)ChangeApi:(UIButton *)sender {
    [YPC_Tools customAlertViewWithTitle:nil
                                Message:nil
                              BtnTitles:@[@"54", @"56", @"线上"]
                         CancelBtnTitle:@"取消"
                    DestructiveBtnTitle:nil
                          actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                              if (index == 0) {
                                  [YPCNetworking updateBaseUrl:@"http://192.168.1.54/ypcang-api/api/ecapi/index.php?url="];
                              }else if (index == 1) {
                                  [YPCNetworking updateBaseUrl:@"http://192.168.1.56/ypcang-api/api/ecapi/index.php?url="];
                              }else {
                                  [YPCNetworking updateBaseUrl:@"http://api.gongchangtemai.com/index.php?url="];
                              }
                          } cancelHandler:nil
                     destructiveHandler:nil];
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
