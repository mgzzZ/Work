//
//  RegistModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/3.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Ordeer_num;
@interface UserModel : NSObject

@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *rank_name;
@property (nonatomic, copy) NSString *rank_level;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *hx_uname;
@property (nonatomic, copy) NSString *reg_id;
@property (nonatomic, copy) NSString *lc_uid;
@property (nonatomic, copy) NSString *member_truename;
@property (nonatomic, copy) NSString *member_avatar;
@property (nonatomic, copy) NSString *member_groupid;
@property (nonatomic, copy) NSString *member_mobile;
@property (nonatomic, copy) NSString *card_num;
@property (nonatomic, copy) NSString *member_sex;
@property (nonatomic, copy) NSString *member_birthday;
@property (nonatomic, copy) NSString *weixin_info;
@property (nonatomic, strong) Ordeer_num *order_num;
@end


@interface Ordeer_num : NSObject

@property (nonatomic,copy)NSString *await_pay;
@property (nonatomic,copy)NSString *await_ship;
@property (nonatomic,copy)NSString *shipped;
@property (nonatomic,copy)NSString *finished;
@end
