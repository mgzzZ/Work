//
//  ChooseSize_dataModel.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/18.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChooseSize_dataModel : NSObject

@property (nonatomic,copy)NSString *goods_id;

@property (nonatomic,copy)NSString *goods_storage;

@property (nonatomic,strong)NSMutableArray *goods_spec;

@end
