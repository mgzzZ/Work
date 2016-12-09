//
//  TimeCutdownView.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/16.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeCutdownView : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic,strong) dispatch_source_t timer;
// 结束
@property (nonatomic,copy) void (^TimeEndBlock)(void);
// 开始
@property (nonatomic,copy) void (^TimeStartBlock)(void);
// 是否结束
@property (nonatomic,assign) BOOL timeEnd;
// 是否开始
@property (nonatomic,assign) BOOL timeStart;

- (void)startTime:(NSString *)startTime endTime:(NSString *)endTime;

@end
