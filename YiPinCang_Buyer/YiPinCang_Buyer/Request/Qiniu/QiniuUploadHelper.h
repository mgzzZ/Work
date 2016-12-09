//
//  TableViewHeaderView.h
//  TaoFactory_Seller
//
//  Created by YPC on 16/9/1.
//  Copyright © 2016年 YPC_mz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QiniuUploadHelper : NSObject


@property (copy, nonatomic) void (^singleSuccessBlock)(NSString *);
@property (copy, nonatomic)  void (^singleFailureBlock)();

+ (instancetype)sharedUploadHelper;
@end
