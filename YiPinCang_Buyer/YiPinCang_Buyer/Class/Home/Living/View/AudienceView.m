//
//  AudienceView.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/12/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "AudienceView.h"
#import "AudienceModel.h"
#import "AudienceCvCell.h"

static NSString *Identifier = @"AudienceIdentfifer";
@implementation AudienceView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AudienceView class]) owner:self options:nil];
    [self addSubview:self.contentView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AudienceCvCell class]) bundle:nil] forCellWithReuseIdentifier:Identifier];
}

- (void)setTempDataArr:(NSArray *)tempDataArr
{
    _tempDataArr = tempDataArr;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tempDataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AudienceCvCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    cell.imageUrl = [self.tempDataArr[indexPath.row] aver];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(22, 22);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}

- (void)layoutSubviews
{
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

@end
