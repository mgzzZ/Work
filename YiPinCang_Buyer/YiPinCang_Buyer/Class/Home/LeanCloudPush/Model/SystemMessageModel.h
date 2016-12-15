//
//  SystemMessageModel.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/12/12.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemMessageModel : NSObject
@property (nonatomic, copy) NSString *m_id;
@property (nonatomic, copy) NSString *r_type;
@property (nonatomic, copy) NSString *t_title;
@property (nonatomic, copy) NSString *t_msg;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *member_id;
@property (nonatomic, copy) NSString *jumptype;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *order_state;
@end
