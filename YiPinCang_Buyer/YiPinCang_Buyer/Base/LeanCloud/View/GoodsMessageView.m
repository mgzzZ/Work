//
//  GoodsMessageView.m
//  TaoFactory_Seller
//
//  Created by 孟镇 on 16/10/8.
//  Copyright © 2016年 YPC_mz. All rights reserved.
//

#import "GoodsMessageView.h"
#import "GoodsImgCell.h"
#import "OrderGoodsModel.h"
#import "GoodsModel.h"

@interface GoodsMessageView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) IBOutlet UILabel *stateL;
@property (nonatomic, strong) IBOutlet UILabel *orderNumL;
@property (nonatomic, strong) IBOutlet UILabel *endPriceL;
@property (nonatomic, strong) IBOutlet UILabel *goodsCountL;
@property (nonatomic, strong) IBOutlet UILabel *transportationPrice;
@property (nonatomic, strong) IBOutlet UIImageView *goodsImgV;

@property (nonatomic, strong) IBOutlet UICollectionView *goodsImgCollectionView;

@property (nonatomic, strong) IBOutlet UILabel *desL;

@property (nonatomic, strong) OrderDetailModel *dataModel;

@end

@implementation GoodsMessageView

+ (id)GoodsMessageViewWithGoodsCount:(NSInteger)goodsCount
{
    if (goodsCount > 1) { // 多件商品, 使用collectionView展示
        return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }else { // 单间商品, 一张图片展示
        return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    }
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
    WS(weakSelf);
    !self.GoodsMesViewClickBlock ?: self.GoodsMesViewClickBlock(weakSelf.dataModel);
}

- (void)configureWithModel:(OrderDetailModel *)model andDataIndex:(NSString *)index
{
    self.dataModel = model;
    
    self.orderNumL.text = [[self.dataModel.goodsinfo.firstObject store] order_sn];
    self.endPriceL.text = self.dataModel.order_amount;
    self.transportationPrice.text = [NSString stringWithFormat:@"(含运费: %@)", self.dataModel.shipping_fee];
    self.goodsCountL.text = [NSString stringWithFormat:@"共%ld件商品", [self.dataModel.goodsinfo.firstObject goods].count];
    
    if ([self.dataModel.goodsinfo.firstObject goods].count > 1) { // 多件商品, 使用collectionView展示
        [self configTempCell];
    }else { // 单间商品, 一张图片展示
        [self.goodsImgV sd_setImageWithURL:[NSURL URLWithString:[[self.dataModel.goodsinfo.firstObject goods].firstObject goods_image]] placeholderImage:YPCImagePlaceHolderSquare];
        self.desL.text = [[self.dataModel.goodsinfo.firstObject goods].firstObject goods_name];
    }
    
    if (self.dataModel.order_state.integerValue == 0) {
        // 已取消
        self.stateL.text = @"已取消";
        self.stateL.textColor = [Color colorWithHex:@"#F00E36"];
    }else if (self.dataModel.order_state.integerValue == 10) {
        // 待付款
        self.stateL.text = @"待付款";
        self.stateL.textColor = [Color colorWithHex:@"#F00E36"];
    }else if (self.dataModel.order_state.integerValue == 20) {
        // 待发货
        self.stateL.text = @"待发货";
        self.stateL.textColor = [Color colorWithHex:@"#1CBBB4"];
    }else if (self.dataModel.order_state.integerValue == 30) {
        // 已发货
        self.stateL.text = @"已发货";
        self.stateL.textColor = [Color colorWithHex:@"#1CBBB4"];
    }else if (self.dataModel.order_state.integerValue == 40) {
        // 已完成
        self.stateL.text = @"已完成";
        self.stateL.textColor = [Color colorWithHex:@"#1CBBB4"];
    }
}

- (void)configTempCell
{
    self.goodsImgCollectionView.delegate = self;
    self.goodsImgCollectionView.dataSource = self;
    [self.goodsImgCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsImgCell class]) bundle:nil] forCellWithReuseIdentifier:@"goodsImgItem"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataModel.goodsinfo.firstObject goods].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"goodsImgItem" forIndexPath:indexPath];
    cell.tempModel = [self.dataModel.goodsinfo.firstObject goods][indexPath.item];
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
