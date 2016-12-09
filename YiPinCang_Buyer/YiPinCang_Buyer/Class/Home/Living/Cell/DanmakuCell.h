//
//  DanmakuCell.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/12/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DanmakuCell : UITableViewCell

@property (nonatomic, copy) NSAttributedString *tempDanmaku;
@property (strong, nonatomic) IBOutlet UILabel *danmakuL;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
