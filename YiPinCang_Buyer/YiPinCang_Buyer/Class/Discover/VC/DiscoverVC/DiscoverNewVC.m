//
//  DiscoverNewVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/8.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "DiscoverNewVC.h"
#import "BrandnewView.h"
#import "LiveDetailListDataModel.h"
#import "DiscoverDetailNewVC.h"
#import "ShoppingCarDetailVC.h"
#import "LIveView.h"
#import "LiveDetailHHHVC.h"
#import "LoginVC.h"
#import "DiscoverDetailVC.h"
#import "WebViewController.h"
@interface DiscoverNewVC ()
@property (nonatomic,strong)UIButton *leftBtn;
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIButton *rightBtn;
@property (nonatomic,strong)BrandnewView *leftView;
@property (nonatomic,strong)LIveView *rightView;
@property (nonatomic,assign)CGFloat alpha;
@end

@implementation DiscoverNewVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar mz_setBackgroundImage:IMAGE(@"homepage_bar")];
    [self.navigationController.navigationBar mz_setBackgroundColor:[Color colorWithHex:@"#3B3B3B"]];
    [self.navigationController.navigationBar mz_setBackgroundAlpha:0.f];
    [self setTopView];
    [self setUI];
}
- (void)setTopView{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 75, 20);
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [btn addTarget:self action:@selector(leftBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:@"品牌" forState:UIControlStateNormal];
    btn.selected = YES;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(75, 0, 75, 20);
    [btn1 addTarget:self action:@selector(rightBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    btn1.backgroundColor = [UIColor clearColor];
    btn1.titleLabel.font = [UIFont systemFontOfSize:17];
    btn1.selected = NO;
    [btn1 setTitle:@"直播组" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
    [_topView addSubview:btn];
    [_topView addSubview:btn1];
    _leftBtn = btn;
    _rightBtn = btn1;
    self.navigationItem.titleView = _topView;
}
- (void)setUI{
   WS(weakSelf);
    self.leftView = [[BrandnewView alloc]init];
   
    [self.view addSubview:self.leftView];
    self.leftView.didcell = ^(NSIndexPath *index,LiveDetailListDataModel *model,NSString *type,TempHomePushModel *tempModel,NSString *livingshowinitimg){
        DiscoverDetailNewVC *diccover = [[DiscoverDetailNewVC alloc]init];
        diccover.live_id = model.live_id;
        diccover.hidesBottomBarWhenPushed = YES;
        diccover.tempModel = tempModel;
        diccover.type = type;
        diccover.message = model.message;
        diccover.livingshowinitimg = livingshowinitimg;
        [weakSelf.navigationController pushViewController:diccover animated:YES];
    };
    self.leftView.didlike = ^(NSIndexPath *index,GuessModel *model){
        ShoppingCarDetailVC *shopping = [[ShoppingCarDetailVC alloc]init];
        shopping.goods_id = model.goods_commonid;
        shopping.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:shopping animated:YES];
    };
    
    self.leftView.didbanner = ^(NSString *str,UrlSechmeType type,NSString *activityType){
        switch (type) {
            case urlSechmeWebView:
                [weakSelf pushWebViewAction:str title:activityType]; // 加载网页
                break;
            case urlSechmeGoodsDetail:
            {
                DiscoverDetailVC *discoverDetail = [[DiscoverDetailVC alloc]init];
                discoverDetail.strace_id = str;
                discoverDetail.live_id = @"";
                if ([activityType isEqualToString:@"淘好货"]) {
                    discoverDetail.typeStr = @"淘好货";
                }else{
                    discoverDetail.typeStr = @"品牌";
                }
                discoverDetail.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:discoverDetail animated:YES];
            }
                
                break;
            case urlSechmeActivityDeatail:
                [YPC_Tools customAlertViewWithTitle:@"Tip"
                                            Message:@"活动详情"
                                          BtnTitles:nil
                                     CancelBtnTitle:nil
                                DestructiveBtnTitle:@"确定"
                                      actionHandler:nil
                                      cancelHandler:nil
                                 destructiveHandler:nil];
                break;
            case urlSechmeLivingGroupDetail:
            {
                LiveDetailHHHVC *live = [[LiveDetailHHHVC alloc]init];
                live.store_id = str;
                live.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:live animated:YES];
            }
                break;
            case urlSechmeBrandDetail:
            {
                DiscoverDetailNewVC *dis = [[DiscoverDetailNewVC alloc]init];
                dis.live_id = str;
                dis.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:dis animated:YES];
            }
                break;
                
            default:
                break;
        }
    };
    
    self.leftView.didscroll = ^(CGFloat offset){
        if (offset > 250.f - 128.f) {
            CGFloat alpha = MIN(1, 1 - ((250.f - 64.f - offset) / 64));
            [[YPC_Tools getControllerWithView:weakSelf.view].navigationController.navigationBar mz_setBackgroundAlpha:alpha];
            weakSelf.alpha = alpha;
        }else{
            [[YPC_Tools getControllerWithView:weakSelf.view].navigationController.navigationBar mz_setBackgroundAlpha:0.f];
        }
    };
    self.leftView.hidden = NO;
    self.leftView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(-64, 0, 0, 0));
    
    self.rightView = [[LIveView alloc]init];
    [self.view addSubview:self.rightView];
    self.rightView.hidden = YES;
    self.rightView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(-64, 0, 0, 0));
    self.rightView.txdid = ^(LiveTopViewModel *model){
        LiveDetailHHHVC *live = [[LiveDetailHHHVC alloc]init];
        live.hidesBottomBarWhenPushed = YES;
        live.store_id = model.store_id;
        [weakSelf.navigationController pushViewController:live animated:YES];
    };
    //重新登录
    self.rightView.login = ^{
        [weakSelf login];
    };

}
- (void)leftBtnClcik{
    self.leftView.hidden = NO;
    self.rightView.hidden = YES;
    self.leftBtn.selected = YES;
    self.rightBtn.selected = NO;
    self.leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [[YPC_Tools getControllerWithView:self.view].navigationController.navigationBar mz_setBackgroundAlpha:_alpha];
}
- (void)rightBtnClcik{
    self.leftView.hidden = YES;
    self.rightView.hidden = NO;
    self.leftBtn.selected = NO;
    self.rightBtn.selected = YES;
    self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [[YPC_Tools getControllerWithView:self.view].navigationController.navigationBar mz_setBackgroundAlpha:0.f];
}
- (void)login{
    LoginVC *login = [[LoginVC alloc]init];
    login.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
    self.navigationController.navigationBar.subviews.firstObject.alpha = 0;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
#pragma mark - bannerClickAction
- (void)pushWebViewAction:(NSString *)url title:(NSString *)title
{
    WebViewController *webVC = [WebViewController new];
    webVC.navTitle = title;
    //    webVC.homeUrl = [NSURL URLWithString:(NSString *)[self.bannerDataArr[atIndex] url]];
    webVC.homeUrl = url;
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
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
