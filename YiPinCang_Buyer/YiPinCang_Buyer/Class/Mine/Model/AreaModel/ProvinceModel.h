//
//  ProvinceModel.h
//  duobaoyu_iOS
//
//  Created by 朱帅 on 16/9/29.
//  Copyright © 2016年 zhushuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProvinceModel : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSArray  *cities;
@property(nonatomic,strong)NSMutableArray *citiesArr;
@end
