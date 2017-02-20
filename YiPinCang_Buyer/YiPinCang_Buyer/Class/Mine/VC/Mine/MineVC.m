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
#import "ShoppingCarVC.h"
#import "FollowVC.h"
#import "ActivitySubscribeVC.h"
#import "MyCommentVC.h"

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

@property (nonatomic, strong) UILabel *commentLbl;
@end

@implementation MineVC

- (UILabel *)commentLbl
{
    if (_commentLbl) {
        return _commentLbl;
    }
    _commentLbl = [UILabel new];
    _commentLbl.backgroundColor = [UIColor redColor];
    _commentLbl.textColor = [UIColor whiteColor];
    _commentLbl.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    _commentLbl.textAlignment = NSTextAlignmentCenter;
    _commentLbl.layer.cornerRadius = 8.f;
    _commentLbl.layer.masksToBounds = YES;
    _commentLbl.hidden = YES;
    return _commentLbl;
}

#pragma mark - VC声明周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.subviews.firstObject.alpha = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupNaviConfig];
    [self viewConfig];
    
    _cellNameArr    = @[
                        @[@"活动提醒", @"我的关注"],@[@"我的评论"], @[@"帮助中心", @"设置"]
                        ];
    _cellImgArr     = @[
                        @[@"mine_icon_activitiessubscribe", @"mine_myfollow_icon"],
                        @[@"mine_comments_icon"],
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
        [self.avatarImgv sd_setImageWithURL:[NSURL URLWithString:[YPCRequestCenter shareInstance].model.member_avatar] placeholderImage:IMAGE(@"mine_avatar_zhanweitu_img")];
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
    [self.tvHeaderView setHeight:302.f];
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
                               NSString *cart_add_time = response[@"data"][@"cart_add_time"];
                               NSString *cart_expire_time = response[@"data"][@"cart_expire_time"];
                               NSString *timeEnd = [NSString stringWithFormat:@"%zd",cart_add_time.integerValue + cart_expire_time.integerValue];
                               [YPCRequestCenter shareInstance].carNumber = cart;
                               [YPCRequestCenter shareInstance].carEndtime = timeEnd;
                               [YPCRequestCenter shareInstance].cart_expire_time = cart_expire_time;
                               weakSelf.naviShopCar.badgeValue = cart;
                               NSString *order_new = response[@"data"][@"order_new"];
                               NSString *order_pay = response[@"data"][@"order_pay"];
                               NSString *order_send = response[@"data"][@"order_send"];
                               weakSelf.waitPay.badgeValue = order_new;
                               weakSelf.waitSend.badgeValue = order_pay;
                               weakSelf.yetSend.badgeValue = order_send;
                               weakSelf.naviShopCar.badgeValue = cart;
                               
                               if (weakSelf.commentLbl) {                                   
                                   if ([response[@"data"][@"unread_comment"] integerValue] > 0) {
                                       if ([response[@"data"][@"unread_comment"] integerValue] > 99) {
                                           weakSelf.commentLbl.text = @"99";
                                       }else {
                                           weakSelf.commentLbl.text = response[@"data"][@"unread_comment"];
                                       }
                                       weakSelf.commentLbl.hidden = NO;
                                   }else {
                                       weakSelf.commentLbl.hidden = YES;
                                   }
                               }
                           }
                       }
                          fail:^(NSError *error) {
                              
                          }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
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
    if (indexPath.section == 1) {
        [cell.contentView addSubview:self.commentLbl];
        [self.commentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(128);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.width.mas_equalTo(16);
            make.height.mas_equalTo(16);
        }];
    }
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
    WS(weakSelf);
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    //活动订阅
                {
                    
                    [YPCRequestCenter isLoginAndPresentLoginVC:self success:^{
                        ActivitySubscribeVC *activity= [[ActivitySubscribeVC alloc]init];
                        activity.hidesBottomBarWhenPushed = YES;
                        [weakSelf.navigationController pushViewController:activity animated:YES];
                    }];
                }
                    break;
                case 1:
                    //我的关注
                {
                    [YPCRequestCenter isLoginAndPresentLoginVC:self success:^{
                        FollowVC *foll = [[FollowVC alloc]init];
                        foll.hidesBottomBarWhenPushed = YES;
                        [weakSelf.navigationController pushViewController:foll animated:YES];
                    }];
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            [YPCRequestCenter isLoginAndPresentLoginVC:self success:^{
                MyCommentVC *commentVC = [MyCommentVC new];
                commentVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:commentVC animated:YES];
            }];
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:{
                    //帮助中心
                    HelpCenterVC *help = [[HelpCenterVC alloc]init];
                    help.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:help animated:YES];
                }
                    break;
                case 1:{
                    //设置
                    SetVC *set = [[SetVC alloc]init];
                    set.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:set animated:YES];
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
    WS(weakSelf);
    switch (sender.tag) {
        case 100:{
            [YPCRequestCenter isLoginAndPresentLoginVC:self success:^{
                // 全部订单
                OrderVC *order = [[OrderVC alloc]init];
                order.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:order animated:YES];
            }];
        }
            break;
        case 101:{
            [YPCRequestCenter isLoginAndPresentLoginVC:self success:^{
                // 待付款
                OrderListVC *order = [[OrderListVC alloc]init];
                order.hidesBottomBarWhenPushed = YES;
                order.orderType = @"state_new";
                [weakSelf.navigationController pushViewController:order animated:YES];
            }];
        }
            break;
        case 102:{
            [YPCRequestCenter isLoginAndPresentLoginVC:self success:^{
                // 待发货
                OrderListVC *order = [[OrderListVC alloc]init];
                order.orderType = @"state_pay";
                order.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:order animated:YES];
            }];
        }
            break;
        case 103:{
            [YPCRequestCenter isLoginAndPresentLoginVC:self success:^{
                // 已发货
                OrderListVC *order = [[OrderListVC alloc]init];
                order.orderType = @"state_send";
                order.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:order animated:YES];
            }];
        }
            break;
        case 104:{
            [YPCRequestCenter isLoginAndPresentLoginVC:self success:^{
                // 已完成
                OrderListVC *order = [[OrderListVC alloc]init];
                order.orderType = @"state_success";
                order.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:order animated:YES];
            }];
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
    [YPCRequestCenter isLoginAndPresentLoginVC:self success:^{}];
}

/**
 账户信息
 */
- (IBAction)accountInfoClickAction:(UIButton *)sender {
    WS(weakSelf);
    AccounManagerVC *accoun = [[AccounManagerVC alloc]init];
    accoun.hidesBottomBarWhenPushed = YES;
    [weakSelf.navigationController pushViewController:accoun animated:YES];
}

/**
 购物车
 */
- (void)shopCarClickAction{
    WS(weakSelf);
    [YPCRequestCenter isLoginAndPresentLoginVC:self success:^{
        ShoppingCarVC *shopcar = [[ShoppingCarVC alloc]init];
        shopcar.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:shopcar animated:YES];
    }];
}

/**
 消息
 */
- (void)mesBtnClickAction{
    WS(weakSelf);
    [YPCRequestCenter isLoginAndPresentLoginVC:self success:^{
        [YPC_Tools pushConversationListViewController:weakSelf];
    }];
}

/**
 关注
 */
- (void)fllownBtnClick{
    if (![YPCRequestCenter isLogin]) {
        
    }else{
        
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
