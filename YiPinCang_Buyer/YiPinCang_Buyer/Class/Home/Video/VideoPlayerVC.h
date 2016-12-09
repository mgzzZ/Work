//
//  VideoPlayerVC.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/15.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "BaseNaviConfigVC.h"
#import "TempHomePushModel.h"
#import "WMPlayer.h"

@interface VideoPlayerVC : BaseNaviConfigVC
@property (nonatomic, strong) TempHomePushModel *tempModel;

@property (strong, nonatomic) IBOutlet UIView *playerBgView;
@property (strong, nonatomic) IBOutlet WMPlayer *playerV;

@end
