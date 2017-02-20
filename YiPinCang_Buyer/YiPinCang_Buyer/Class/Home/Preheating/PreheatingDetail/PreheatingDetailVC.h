//
//  PreheatingDetailVC.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/19.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "BaseNaviConfigVC.h"
#import "Pre_stracesModel.h"

typedef enum : NSUInteger {
    detailStylePerhearting = 1,
    detailStyleUserCircle,
} DetailStyleType;

typedef void(^BackLikeAndCommentBlock)(NSString *likeCount,NSString * isLike,NSString *commentCount);

@interface PreheatingDetailVC : BaseNaviConfigVC
@property (nonatomic, copy) NSString *tempStrace_ID;
@property (nonatomic, assign) DetailStyleType detailType;
@property (nonatomic, copy) BackLikeAndCommentBlock backBlock;
@end
