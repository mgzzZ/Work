//
//  StarRatingVC.h
//  FrameWork2.0
//
//  Created by jiaming yan on 16/7/26.
//  Copyright © 2016年 yanjiaming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YJMGuideViewManager : NSObject
/*
 方法描述:
 创建单例模式
 
 参数说明:
 <#参数说明#>
 
 返回结果:
 <#返回结果#>
 
 */

+ (instancetype)sharedInstance;
/*
 方法描述:
 引导页图片
 
 参数说明:
 *  @param images      引导页图片
 *  @param title       按钮文字
 *  @param titleColor  文字颜色
 *  @param bgColor     按钮背景颜色
 *  @param borderColor 按钮边框颜色
 
 返回结果:
 <#返回结果#>
 
 */

- (void)showGuideViewWithImages:(NSArray *)images
                 andButtonTitle:(NSString *)title
            andButtonTitleColor:(UIColor *)titleColor
               andButtonBGColor:(UIColor *)bgColor
           andButtonBorderColor:(UIColor *)borderColor;

@end
