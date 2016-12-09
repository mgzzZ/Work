//
//  GoodsMessageView.m
//  TaoFactory_Seller
//
//  Created by 孟镇 on 16/10/8.
//  Copyright © 2016年 YPC_mz. All rights reserved.
//

#import "GoodsMessageView.h"
//#import "OrderGoodsModel.h"
#import "GoodsImgCell.h"

@interface GoodsMessageView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) IBOutlet UILabel *storeNameL;
@property (nonatomic, strong) IBOutlet UILabel *stateL;
@property (nonatomic, strong) IBOutlet UILabel *endPriceL;

@property (nonatomic, strong) IBOutlet UICollectionView *goodsImgCollectionView;

@property (nonatomic, strong) NSMutableArray *collectionDataArr;

//@property (nonatomic, strong) OdModel *dataModel;

@end

@implementation GoodsMessageView

- (NSMutableArray *)collectionDataArr
{
    if (_collectionDataArr) {
        return _collectionDataArr;
    }
    _collectionDataArr = [NSMutableArray array];
    return _collectionDataArr;
}

+ (id)GoodsMessageView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    UITapGestureRecognizer *tapGestureRecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gMesClicked)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)gMesClicked
{
//    !self.GoodsMesViewClickBlock ?: self.GoodsMesViewClickBlock(self.dataModel);
}

//- (void)configureWithOdModel:(OdModel *)model
//{
//    self.dataModel = model;
//    self.storeNameL.text = model.store_name;
//    self.stateL.text = model.state_desc;
//    self.collectionDataArr = [OrderGoodsModel mj_objectArrayWithKeyValuesArray:model.goods];
//    self.endPriceL.text = [NSString stringWithFormat:@"共%ld件商品 已付款: ¥%@ (含运费: ¥%@)", (unsigned long)self.collectionDataArr.count, model.goods_amount, model.shipping_fee];
//    [self configTempCell];
//}

- (void)configTempCell
{
    self.goodsImgCollectionView.delegate = self;
    self.goodsImgCollectionView.dataSource = self;
    [self.goodsImgCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsImgCell class]) bundle:nil] forCellWithReuseIdentifier:@"goodsImgItem"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionDataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"goodsImgItem" forIndexPath:indexPath];
//    cell.tempStr = [self.collectionDataArr[indexPath.item] goods_image];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 60);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 10);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
