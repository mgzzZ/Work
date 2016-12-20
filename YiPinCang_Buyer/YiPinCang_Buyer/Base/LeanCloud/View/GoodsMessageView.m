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
@property (strong, nonatomic) IBOutlet UIImageView *avatarImgV;
@property (nonatomic, strong) IBOutlet UILabel *storeNameL;
@property (nonatomic, strong) IBOutlet UILabel *stateL;
@property (nonatomic, strong) IBOutlet UILabel *endPriceL;

@property (nonatomic, strong) IBOutlet UICollectionView *goodsImgCollectionView;

@property (nonatomic, strong) OrderDetailModel *dataModel;

@end

@implementation GoodsMessageView

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
    WS(weakSelf);
    !self.GoodsMesViewClickBlock ?: self.GoodsMesViewClickBlock(weakSelf.dataModel);
}

- (void)configureWithModel:(OrderDetailModel *)model andDataIndex:(NSString *)index
{
    self.dataModel = model;
    [self.avatarImgV sd_setImageWithURL:[NSURL URLWithString:[model.goodsinfo[index.integerValue] store].store_avatar] placeholderImage:nil];
    self.storeNameL.text = [model.goodsinfo[index.integerValue] store].store_name;
    
//    CGFloat totalPrice;
//    for (GoodsModel *gm in model.goodsinfo) {
//        <#statements#>
//    }
    
    if ([model.state_desc isEqualToString:@"已取消"] ||[model.state_desc isEqualToString:@"待付款"]) {
        self.endPriceL.text = [NSString stringWithFormat:@"需付款: ¥%@ (含运费: ¥%@)", model.order_amount, model.shipping_fee];
    }else {
        self.endPriceL.text = [NSString stringWithFormat:@"已付款: ¥%@ (含运费: ¥%@)", model.order_amount, model.shipping_fee];
    }
    
    if (self.dataModel.order_state.integerValue == 0) {
        // 已取消
        self.stateL.text = @"已取消";
        self.stateL.textColor = [Color colorWithHex:@"#E4393C"];
    }else if (self.dataModel.order_state.integerValue == 10) {
        // 待付款
        self.stateL.text = @"待付款";
        self.stateL.textColor = [Color colorWithHex:@"#E4393C"];
    }else if (self.dataModel.order_state.integerValue == 20) {
        // 待发货
        self.stateL.text = @"待发货";
        self.stateL.textColor = [Color colorWithHex:@"#E4393C"];
    }else if (self.dataModel.order_state.integerValue == 30) {
        // 已发货
        self.stateL.text = @"已发货";
        self.stateL.textColor = [Color colorWithHex:@"#E4393C"];
    }else if (self.dataModel.order_state.integerValue == 40) {
        // 已完成
        self.stateL.text = @"已完成";
        self.stateL.textColor = [Color colorWithHex:@"#36A74D"];
    }
    [self configTempCell];
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
    cell.tempStr = [[self.dataModel.goodsinfo.firstObject goods][indexPath.item] goods_image];
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
