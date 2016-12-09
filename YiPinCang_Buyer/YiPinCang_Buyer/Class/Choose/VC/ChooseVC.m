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

@interface ChooseVC ()

@end

@implementation ChooseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    
    YYFPSLabel *fps = [YYFPSLabel new];
    fps.width = 50;
    fps.left = 120;
    fps.top = 0;
    [[AppDelegate shareAppDelegate].window addSubview:fps];
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
