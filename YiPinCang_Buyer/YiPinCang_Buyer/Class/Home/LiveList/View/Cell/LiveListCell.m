//
//  LiveListCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 17/1/1.
//  Copyright © 2017年 Laomeng. All rights reserved.
//

#import "LiveListCell.h"

@interface LiveListCell ()
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UIImageView *txImg;
@property (strong, nonatomic) IBOutlet UILabel *countLab;
@property (strong, nonatomic) IBOutlet UILabel *desLab;
@property (strong, nonatomic) IBOutlet UIImageView *CrownImg;
@end

@implementation LiveListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTempMpdel:(LiveGroupListModel *)tempMpdel
{
    _tempMpdel = tempMpdel;
    [self.txImg sd_setImageWithURL:[NSURL URLWithString:tempMpdel.store_avatar] placeholderImage:YPCImagePlaceHolderSquare];
    self.nameLab.text = tempMpdel.store_name;
    self.countLab.text = tempMpdel.store_collect;
    self.desLab.text = tempMpdel.store_description;
    
    if (self.livelistType == LiveListOfLiving) {
        if (tempMpdel.activity_type.integerValue == 0) {
            self.img.image = IMAGE(@"liveteampage_tuwen_icon");
        }else if (tempMpdel.activity_type.integerValue == 1) {
            [self animationWithButton];
        }
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 3) {
        self.CrownImg.hidden = NO;
    }else {
        self.CrownImg.hidden = YES;
    }
}

- (void)setLivelistType:(LiveListType)livelistType
{
    _livelistType = livelistType;
}

/*!
 *
 *    直播中动效
 *
 */
- (void)animationWithButton
{
    [self.img setImage:IMAGE(@"liveteampage_living_icon1")];
    [self.img sizeToFit];
    NSArray *images = [[NSArray alloc] init];

    images = [NSArray arrayWithObjects:
              IMAGE(@"liveteampage_living_icon2"),
              IMAGE(@"liveteampage_living_icon3"),
              IMAGE(@"liveteampage_living_icon1"),
              nil];
    
    self.img.animationImages = images;
    self.img.animationDuration = .5f;
    self.img.animationRepeatCount = 0;
    [self.img startAnimating];
}
@end
