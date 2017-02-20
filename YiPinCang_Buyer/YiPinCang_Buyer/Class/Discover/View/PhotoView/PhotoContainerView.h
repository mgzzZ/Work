//
//  PhotoContainerView.h
//  TaoFactory_Seller
//
//  Created by 孟镇 on 16/9/27.
//  Copyright © 2016年 YPC_mz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface  PhotoContainerView: UIView

@property (nonatomic, assign) CGFloat WH;
@property (nonatomic, strong) NSArray *picPathStringsArray;
@property (nonatomic, strong) NSArray *thumbPicPathStringsArray;
@property (nonatomic, assign) PhotoContainerType containerType;
@property (nonatomic, assign) PhotoContainerModeType modeType;//默认没有
@end
