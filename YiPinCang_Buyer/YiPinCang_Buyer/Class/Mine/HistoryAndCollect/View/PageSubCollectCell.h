//
//  PageSubCell.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/4.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageSubCollectCell : UICollectionViewCell

@property (nonatomic, copy) void (^ButtonClickedBlock)(id object);
@property (nonatomic, assign) BOOL editStatus;

@end
