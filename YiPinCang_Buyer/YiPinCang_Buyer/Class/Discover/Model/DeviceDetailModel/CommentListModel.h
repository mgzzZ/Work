//
//  CommentListModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/15.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentListModel : NSObject

@property (nonatomic,copy)NSString *scomm_id;
@property (nonatomic,copy)NSString *scomm_content;
@property (nonatomic,copy)NSString *scomm_memberid;
@property (nonatomic,copy)NSString *scomm_membername;
@property (nonatomic,copy)NSString *scomm_memberavatar;
@property (nonatomic,copy)NSString *scomm_time;
@property (nonatomic,copy)NSString *comment_type;
@property (nonatomic,copy)NSString *reback_memberid;
@property (nonatomic,copy)NSString *reback_membername;
@property (nonatomic,copy)NSString *scommto_memberid;
@property (nonatomic,copy)NSString *scommto_membername;


@end
