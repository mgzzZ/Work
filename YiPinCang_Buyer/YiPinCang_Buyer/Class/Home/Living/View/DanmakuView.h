//
//  DanmakuView.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/12/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DanmakuModel.h"

@interface DanmakuView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UITableView *danmakuTableView;
@property (nonatomic, strong) NSMutableArray *danmakuDataArr; // 弹幕消息容器
@property (nonatomic, strong) DanmakuModel *danmakuModel; // 弹幕model

@property (strong, nonatomic) IBOutlet UIView *nMesRemindBgView; // 新消息提醒父view
@property (strong, nonatomic) IBOutlet UILabel *nMesRemindL; // 新消息提醒数

@end
