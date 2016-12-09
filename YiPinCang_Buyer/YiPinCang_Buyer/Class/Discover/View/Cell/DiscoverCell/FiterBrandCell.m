//
//  FiterBrandCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/11.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "FiterBrandCell.h"
#import "FiterBrandTypeCell.h"
#import "BrandLiskTypeListModel.h"
#import "DiscoverBrandLiskModel.h"
@implementation FiterBrandCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //[self setup];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setDataArr:(NSMutableArray *)dataArr{
    if (_dataArr != dataArr) {
        _dataArr = dataArr;
    }
    NSInteger row = 0;
    if (dataArr.count % 4 == 0) {
        row = dataArr.count / 4;
    }else{
        row = dataArr.count / 4 + 1;
    }
    self.collectionView.sd_layout.heightIs(row * 37);
    [self.collectionView reloadData];
}
- (void)setup{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.collectionView];
    self.collectionView.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView,50)
    .rightEqualToView(self.contentView);
   
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FiterBrandTypeCell class]) bundle:nil] forCellWithReuseIdentifier:@"FiterBrandTypeCell"];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = @"FiterBrandTypeCell";
    
    FiterBrandTypeCell *cell = (FiterBrandTypeCell *)[_collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.bgView.backgroundColor = self.bgColor;
    cell.bgView.layer.borderColor = [Color colorWithHex:@"0xf0f0f0"].CGColor;
    cell.bgView.layer.borderWidth = 1;
    if ([self.type isEqualToString:@"brand"] || [self.type isEqualToString:@""] || self.type == nil) {
        DiscoverBrandLiskModel *model = self.dataArr[indexPath.row];
        cell.titleLab.text = model.brand_name;
        
    }else if([self.type isEqualToString:@"bind"]){
        BrandLiskTypeListModel *model = self.dataArr[indexPath.row];
        cell.titleLab.text = model.bind_name;
    }

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FiterBrandTypeCell *cell = (FiterBrandTypeCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.bgView.layer.borderColor = [UIColor redColor].CGColor;
    if ([self.type isEqualToString:@""] || self.type == nil) {
        DiscoverBrandLiskModel *model = self.dataArr[indexPath.row];
        if (self.backIdCell) {
            self.backIdCell(@"brandType",model.brand_id);
        }
    }else{
        if ([self.type isEqualToString:@"brand"]) {
            DiscoverBrandLiskModel *model = self.dataArr[indexPath.row];
            if (model.typelist.count != 0) {
                if (self.didseleteCell) {
                    self.didseleteCell(indexPath);
                }
                if (self.backIdCell) {
                    self.backIdCell(@"brand",model.brand_id);
                }
            }else{
                if (self.diddeleteCell) {
                    self.diddeleteCell(indexPath);
                }
            }
        }else{
            BrandLiskTypeListModel *model = self.dataArr[indexPath.row];
            if (self.backIdCell) {
                self.backIdCell(@"brandType",model.bind_id);
            }
        }
    }
    
    
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    FiterBrandTypeCell *cell = (FiterBrandTypeCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.bgView.layer.borderColor = [Color colorWithHex:@"0xf0f0f0"].CGColor;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){(ScreenWidth - 17 * 5 - 40) / 4,27};
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 10, 0, 10);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


@end
