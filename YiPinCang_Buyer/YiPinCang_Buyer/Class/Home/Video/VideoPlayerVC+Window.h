//
//  VideoPlayerVC+Window.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/23.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "VideoPlayerVC.h"

@interface VideoPlayerVC (Window)

- (void)playVideoOnWindow;
- (void)hiddenVideoOnWindowWithViewController:(UIViewController *)vc;
- (void)removeVideoOnWindow;

@end
