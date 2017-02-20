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
#import "ShoppingCarDetailVC.h"
#import "LiveDetailHHHVC.h"
#import "LoginVC.h"
#import "DiscoverDetailVC.h"
#import "WebViewController.h"
#import "DiscoverDetailV2VC.h"
#import "RedManView.h"
#import "RedManModel.h"
#import "RedListModel.h"
#import "Pre_stracesModel.h"
#import "PreheatingDetailVC.h"
#import "YUSegment.h"
@interface DiscoverNewVC ()
@property (nonatomic,strong)UIButton *leftBtn;
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIButton *rightBtn;
@property (nonatomic,strong)BrandnewView *leftView;
@property (nonatomic,strong)RedManView *rightView;
@property (nonatomic,assign)CGFloat leftAlpha;
@property (nonatomic,assign)CGFloat rightAlpha;
@property (nonatomic, strong)YUSegment *segment;

@end

@implementation DiscoverNewVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar mz_setBackgroundImage:IMAGE(@"homepage_bar")];
    [self.navigationController.navigationBar mz_setBackgroundColor:[Color colorWithHex:@"#3B3B3B"]];
    [self.navigationController.navigationBar mz_setBackgroundAlpha:1];
    
    [self setTopView];
    [self setUI];
}
- (void)setTopView{
    self.segment = [[YUSegment alloc] initWithTitles:@[@"品牌",@"红人"] style:YUSegmentStyleBox];
    self.segment.backgroundColor = [UIColor clearColor];
    self.segment.indicator.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.segment];
    self.segment.frame = CGRectMake(0,0,148,30);
    self.segment.layer.borderWidth = 1;
    self.segment.layer.borderColor = [UIColor whiteColor].CGColor;
    self.segment.selectedIndex = 0;
    self.segment.textColor = [UIColor whiteColor];
    self.segment.selectedTextColor = [Color colorWithHex:@"#202020"];
    self.segment.font = YPCPFFont(17);
    self.segment.selectedFont = YPCPFFont(17);
    [self.segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segment;
}
- (void)setUI{
   WS(weakSelf);
    self.leftView = [[BrandnewView alloc]init];
   
    [self.view addSubview:self.leftView];
    self.leftView.didcell = ^(NSIndexPath *index,LiveDetailListDataModel *model,NSString *type){
        DiscoverDetailV2VC *diccover = [[DiscoverDetailV2VC alloc]init];
        diccover.live_id = model.fid;
        diccover.hidesBottomBarWhenPushed = YES;
        diccover.type = type;
        diccover.titleStr = model.name;
        diccover.message = model.message;
        [weakSelf.navigationController pushViewController:diccover animated:YES];
    };
    self.leftView.didlike = ^(NSIndexPath *index,GuessModel *model){
        DiscoverDetailVC *shopping = [[DiscoverDetailVC alloc]init];
        shopping.strace_id = model.strace_id;
        shopping.typeStr = @"淘好货";
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
                DiscoverDetailV2VC *dis = [[DiscoverDetailV2VC alloc]init];
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
        if (weakSelf.leftView.hidden == NO) {
//            if (offset > 250.f - 128.f) {
//          //      CGFloat alpha = MIN(1, 1 - ((250.f - 64.f - offset) / 64));
//               [[YPC_Tools getControllerWithView:weakSelf.view].navigationController.navigationBar mz_setBackgroundAlpha:1];
//                weakSelf.leftAlpha = 1;
//            }else{
//                [[YPC_Tools getControllerWithView:weakSelf.view].navigationController.navigationBar mz_setBackgroundAlpha:1];
//                weakSelf.leftAlpha = 1;
//            }
        }
        
    };
    self.leftView.hidden = NO;
    self.leftView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.rightView = [[RedManView alloc]init];
    [self.view addSubview:self.rightView];
    self.rightView.hidden = YES;
    self.rightView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(64, 0, 44, 0));
    self.rightView.didcell = ^(id typeModel,RedManViewToView toVuew){
        switch (toVuew) {
            case RedManViewToMan:
            {
                RedManModel *model = typeModel;
                LiveDetailHHHVC *live = [[LiveDetailHHHVC alloc]init];
                live.store_id = model.store_id;
                live.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:live animated:YES];
            
            }
                break;
            case RedManViewToNote:
            {
                RedListModel *model = typeModel;

                PreheatingDetailVC *detailVC = [PreheatingDetailVC new];
                detailVC.detailType = detailStyleUserCircle;
                detailVC.tempStrace_ID = model.strace_id;
                detailVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:detailVC animated:YES];
                
            }
                break;
            case RedManViewToShop:
            {
                RedListModel *model = typeModel;
                DiscoverDetailVC *shopping = [[DiscoverDetailVC alloc]init];
                shopping.strace_id = model.strace_id;
                shopping.typeStr = @"动态";
                shopping.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:shopping animated:YES];
            }
                break;
                
            default:
                break;
        }
    };
    self.rightView.didbanner = ^(NSString *str,UrlSechmeType type,NSString *activityType){
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
                DiscoverDetailV2VC *dis = [[DiscoverDetailV2VC alloc]init];
                dis.live_id = str;
                dis.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:dis animated:YES];
            }
                break;
                
            default:
                break;
        }
    };
    self.rightView.didscroll = ^(CGFloat offset){
//        if (offset > 221.f - 128.f) {
//          //  CGFloat alpha = MIN(1, 1 - ((221.f - 64.f - offset) / 64));
//          [[YPC_Tools getControllerWithView:weakSelf.view].navigationController.navigationBar mz_setBackgroundAlpha:1];
//            weakSelf.rightAlpha = 1;
//        }else{
//            [[YPC_Tools getControllerWithView:weakSelf.view].navigationController.navigationBar mz_setBackgroundAlpha:1];
//            weakSelf.rightAlpha = 1;
//        }
    };
}
- (void)leftBtnClcik{
    self.leftView.hidden = NO;
    self.rightView.hidden = YES;
    [[YPC_Tools getControllerWithView:self.view].navigationController.navigationBar mz_setBackgroundAlpha:1];
}
- (void)rightBtnClcik{
    self.leftView.hidden = YES;
    self.rightView.hidden = NO;
    [[YPC_Tools getControllerWithView:self.view].navigationController.navigationBar mz_setBackgroundAlpha:1];
}
- (void)login{
    LoginVC *login = [[LoginVC alloc]init];
    login.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
    self.navigationController.navigationBar.subviews.firstObject.alpha = 0;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}


- (void)change:(YUSegment *)sender{
    switch (sender.selectedIndex) {
        case 0:
        {
            [self leftBtnClcik];
        }
            break;
        case 1:
        {
            [self rightBtnClcik];
        }
            break;
            
        default:
            break;
    }
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
