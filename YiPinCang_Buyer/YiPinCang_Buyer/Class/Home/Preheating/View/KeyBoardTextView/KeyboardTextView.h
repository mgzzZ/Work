//
//  keyboardTextView.h
//  11111111
//
//  Created by Laomeng on 16/11/20.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyboardTextView : UIView
- (instancetype)initWithTextViewFrame:(CGRect)frame;
@property (nonatomic, copy) void (^ButtonClickedBlock)(NSString *text);

- (void)becomeFirstResponder;
- (void)resignFirstResponder;
- (BOOL)isFirstResponder;

- (BOOL)hasText;

@end
