//
//  LiveListHeaderView.h
//  YiPinCang_Buyer
//
//  Created by YPC on 17/1/1.
//  Copyright © 2017年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeCutdownView.h"
@interface LiveListHeaderView : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UIImageView *bgImg;
@property (strong, nonatomic) IBOutlet TimeCutdownView *timeLineView;
@property (strong, nonatomic) IBOutlet UIButton *noticeBtn;

@end
