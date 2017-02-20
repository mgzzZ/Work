//
//  AppDelegate.h
//  YiPinCang_Buyer
//
//  Created by Apple on 16/10/31.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *) shareAppDelegate;

@property (nonatomic, strong) NSURL *url;

@end

