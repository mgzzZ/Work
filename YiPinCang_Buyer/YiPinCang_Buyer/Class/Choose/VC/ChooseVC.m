//
//  ChooseVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "ChooseVC.h"
#import "AppDelegate.h"
#import "YYFPSLabel.h"
#import "YJMGuideViewManager.h"
@interface ChooseVC ()

@end

@implementation ChooseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSMutableArray *images = [NSMutableArray new];
    
    [images addObject:[UIImage imageNamed:@"1navigationpage"]];
    [images addObject:[UIImage imageNamed:@"2navigationpage"]];
    [images addObject:[UIImage imageNamed:@"3navigationpage"]];
    [images addObject:[UIImage imageNamed:@"4navigationpage"]];
    
    /****考虑到app包大小问题，以后引导页面切图只切6p或者6的图，程序中会对图片进行裁剪。所以设计的时候需要对内容部分进行分割设计，顶部和底部只是用纯色来填充，立即体验的按钮可以看情况是放到图中还是自己的，如果是图片中的需要全部clear颜色，然后放大按钮位置****/
    
    /****所以这种情况下必须设计做的时候需要随时沟通，做完一张就需要测试后才往下设计****/
    [[YJMGuideViewManager sharedInstance] showGuideViewWithImages:images
                                                   andButtonTitle:@""
                                              andButtonTitleColor:[UIColor whiteColor]
                                                 andButtonBGColor:[UIColor clearColor]
                                             andButtonBorderColor:[UIColor clearColor]];
}

/**
 选择女性

 @param sender 女性
 */
- (IBAction)womenBtnClick:(UIButton *)sender {
    [YPCRequestCenter shareInstance].homeStyleType = homeStyleFemale;
    [self setWindowRootViewController];
}

/**
 选择男性

 @param sender 男性
 */
- (IBAction)manBtnClick:(UIButton *)sender {
    [YPCRequestCenter shareInstance].homeStyleType = homeStyleMale;
    [self setWindowRootViewController];
}

/**
 选择儿童

 @param sender 儿童
 */
- (IBAction)kidBtnClick:(UIButton *)sender {
    [YPCRequestCenter shareInstance].homeStyleType = homeStyleChildren;
    [self setWindowRootViewController];
}

/**
 选择居家

 @param sender 居家
 */
- (IBAction)homeBtnClick:(UIButton *)sender {
    [YPCRequestCenter shareInstance].homeStyleType = homeStyleHousehold;
    [self setWindowRootViewController];
}

/*!
 *
 *    设置window跟视图
 *
 */
- (void)setWindowRootViewController
{
    CATransition *transition = [CATransition animation];
    transition.duration = .5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionFromBottom;
    UITabBarController *rootTab = [YPC_Tools setupTabBar];
    [AppDelegate shareAppDelegate].window.rootViewController = rootTab;
    [[AppDelegate shareAppDelegate].window.layer addAnimation:transition forKey:@"animation"];
    
//    YYFPSLabel *fps = [YYFPSLabel new];
//    fps.width = 50;
//    fps.left = 120;
//    fps.top = 0;
//    [[AppDelegate shareAppDelegate].window addSubview:fps];
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
