//
//  ChooseSize.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/17.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseSizeModel.h"

/**
 确认按钮回调

 @param goods_id 选择规格id
 @param count 选择数量
 @param typeStr 选择规格汉字
 */
typedef void(^DidBlock)(NSString *goods_id,NSString *count,NSString *typeStr);

typedef void(^CancelBlock)();

typedef void(^PushSizeHelpBlock)();

@interface ChooseSize : UIView

- (instancetype)initWithFrame:(CGRect)frame count:(NSInteger)count maxCount:(NSInteger)maxCount;

- (instancetype)initWith:(NSInteger)count maxCount:(NSInteger)maxCount;
- (void)updateWith:(NSInteger)count maxCount:(NSInteger)maxCount;
- (void)updateWithPrice:(NSString *)price img:(NSString *)img chooseMessage:(NSString *)chooseMessage count:(NSInteger)count maxCount:(NSInteger)maxCount model:(ChooseSizeModel *)model;
@property (nonatomic,copy)DidBlock did;
@property (nonatomic,copy)CancelBlock cancel;
@property (nonatomic,strong)ChooseSizeModel *model;
@property (nonatomic,copy)PushSizeHelpBlock push;
- (void)keyboredHiden;
@end
