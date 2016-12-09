//
//  PageSubCell.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/4.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "PageSubCollectCell.h"

@interface PageSubCollectCell ()

@property (strong, nonatomic) IBOutlet UIImageView *imgV;
@property (strong, nonatomic) IBOutlet UILabel *titleL;
@property (strong, nonatomic) IBOutlet UILabel *priceL;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation PageSubCollectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setEditStatus:(BOOL)editStatus
{
    _editStatus = editStatus;
    if (_editStatus) {
        self.deleteBtn.hidden = NO;
    }else {
        self.deleteBtn.hidden = YES;
    }
}

- (IBAction)buttonClickAction:(UIButton *)sender
{
    if (sender.tag == 100) {
        self.ButtonClickedBlock(@"delete");
    }else if (sender.tag == 101) {
        self.ButtonClickedBlock(@"similar");
    }
}

@end
