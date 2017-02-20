//
//  OrderTypeCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/3.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "OrderTypeCell.h"
#import "OrderImgCell.h"
@implementation OrderTypeCell
- (void)setModel:(OrderListModel *)model{
    WS(weakself);
    if (_model != model) {
        _model = model;
    }
    //self.nameLab.text = model.store_name;
    self.stateLab.text = model.state_desc;
   
    if (self.model.goods.count == 1) {
        GoodsModel *goodsModel = self.model.goods[0];
        self.merchandiseTitleLab.text = goodsModel.goods_name;
//        self.merchandisePriceLab.text = [NSString stringWithFormat:@"¥%@",goodsModel.goods_price];
        self.merchandiseColor.text = goodsModel.goods_spec;
        self.countLab.text = [NSString stringWithFormat:@"共%@件商品",model.goods_num];
        [self.merchandiseImg sd_setImageWithURL:[NSURL URLWithString:goodsModel.goods_image] placeholderImage:YPCImagePlaceHolder];

    }else{
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didCollectionView)];
        [self.collectionView addGestureRecognizer:tap];
        self.countMoreLab.text = [NSString stringWithFormat:@"共%@件商品",model.goods_num];
         self.merchandiseMoreTypeLab.text = model.state_desc;
        [self.collectionView reloadData];
    }
    
    
    if ([model.state_desc isEqualToString:@"待收货"] ||[model.state_desc isEqualToString:@"已发货"]  ) {
        [self.leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = NO;
        [self.rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        NSString *priceStr = [NSString stringWithFormat:@"实付¥%@(含运费¥%@)",model.order_amount,model.shipping_fee];
        [self attributStrText:priceStr model:model];
        self.timeLab.text = model.store_name;
        self.timeLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
        self.timeImgWidth.constant = 0;
        
        self.leftMoreBtn.hidden = YES;
        self.rightMoreBtn.hidden = NO;
        [self.rightMoreBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        self.timeMoreLab.text = model.store_name;
        self.timeMoreLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
        self.timeLab.font = [UIFont systemFontOfSize:15];
        self.timeMoreLab.font = [UIFont systemFontOfSize:15];
        self.moreImgWidth.constant = 0;
        
    }else if ([model.state_desc isEqualToString:@"待付款"]){
        [self.leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"立即付款" forState:UIControlStateNormal];
        self.leftBtn.hidden = NO;
        self.rightBtn.hidden = NO;
        NSString *priceStr = [NSString stringWithFormat:@"需付¥%@(含运费¥%@)",model.order_amount,model.shipping_fee];
        [self attributStrText:priceStr model:model];
        self.timeImgWidth.constant = 15.;
        [self.leftMoreBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [self.rightMoreBtn setTitle:@"立即付款" forState:UIControlStateNormal];
        self.leftMoreBtn.hidden = NO;
        self.rightMoreBtn.hidden = NO;
      
        self.moreImgWidth.constant = 15.;
        if (!_timer) {
            __block int timeout = model.remaintime.intValue; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout <= 0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakself.moreImgWidth.constant = 0.;
                        weakself.timeMoreLab.text = model.store_name;
                        weakself.timeLab.text = model.store_name;
                        weakself.timeLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
                        weakself.timeMoreLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
                        weakself.timeLab.font = [UIFont systemFontOfSize:15];
                        weakself.timeMoreLab.font = [UIFont systemFontOfSize:15];
                    });
                }else{
                    int minutes = timeout / 60;
                    int seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"剩余%.2d:%.2d",minutes, seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakself.timeMoreLab.text = strTime;
                        weakself.timeLab.text = strTime;
                    });
                    timeout--;
                    
                }
            });
            dispatch_resume(_timer);
        }

    }else if ([model.state_desc isEqualToString:@"待发货"]){
        [self.leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"立即付款" forState:UIControlStateNormal];
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = YES;
        NSString *priceStr = [NSString stringWithFormat:@"实付¥%@(含运费¥%@)",model.order_amount,model.shipping_fee];
       [self attributStrText:priceStr model:model];
        self.timeLab.text = model.store_name;
        self.timeLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
       self.timeImgWidth.constant = 0;
        
        
        
        self.leftMoreBtn.hidden = YES;
        self.rightMoreBtn.hidden = YES;
        [self.rightMoreBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        self.timeMoreLab.text = model.store_name;
        self.timeMoreLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
        self.timeLab.font = [UIFont systemFontOfSize:15];
        self.timeMoreLab.font = [UIFont systemFontOfSize:15];
        self.moreImgWidth.constant = 0;
    }else if ([model.state_desc isEqualToString:@"已取消"]){
        [self.leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = NO;
        NSString *priceStr = [NSString stringWithFormat:@"需付¥%@(含运费¥%@)",model.order_amount,model.shipping_fee];
        [self attributStrText:priceStr model:model];
        self.timeLab.text = model.store_name;
        self.timeLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
        self.timeImgWidth.constant = 0;
        
        self.leftMoreBtn.hidden = YES;
        self.rightMoreBtn.hidden = NO;
        [self.rightMoreBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        self.timeMoreLab.text = model.store_name;
        self.timeMoreLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
        self.timeLab.font = [UIFont systemFontOfSize:15];
        self.timeMoreLab.font = [UIFont systemFontOfSize:15];
        self.moreImgWidth.constant = 0;
    }else if ([model.state_desc isEqualToString:@"已完成"]){
        [self.leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = NO;
        NSString *priceStr = [NSString stringWithFormat:@"实付¥%@(含运费¥%@)",model.order_amount,model.shipping_fee];
        [self attributStrText:priceStr model:model];
        self.timeLab.text = model.store_name;
        self.timeLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
        self.timeImgWidth.constant = 0;
        
        self.leftMoreBtn.hidden = YES;
        self.rightMoreBtn.hidden = NO;
        [self.rightMoreBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        self.timeMoreLab.text = model.store_name;
        self.timeMoreLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
        self.timeLab.font = [UIFont systemFontOfSize:15];
        self.timeMoreLab.font = [UIFont systemFontOfSize:15];
        self.moreImgWidth.constant = 0;
    }
    [self setNeedsLayout];
}

- (void)attributStrText:(NSString *)priceStr model:(OrderListModel *)model{
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:priceStr];
    //更改字体颜色
    [mutableString addAttribute:NSForegroundColorAttributeName value:[Color colorWithHex:@"#2C2C2C"] range:NSMakeRange(0, 2)];
    [mutableString addAttribute:NSForegroundColorAttributeName value:[Color colorWithHex:@"#E4393C"] range:NSMakeRange(2, model.order_amount.length + 1)];
    [mutableString addAttribute:NSForegroundColorAttributeName value:[Color colorWithHex:@"#2C2C2C"] range:NSMakeRange(model.order_amount.length + 3, model.shipping_fee.length + 6)];
    self.payPriceLab.attributedText = mutableString;
    self.payPriceMoreLab.attributedText = mutableString;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"OrderImgCell" bundle:nil] forCellWithReuseIdentifier:@"orderimgs"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
  
}
#pragma mark : Collection View Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.goods.count > 0 ? self.model.goods.count : 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(80, 80);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (OrderImgCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OrderImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"orderimgs" forIndexPath:indexPath];
    
    //Add your cell Values here
    if (self.model.goods.count > 1) {
        GoodsModel *goodsModel = self.model.goods[indexPath.row];
        cell.model = goodsModel;
    }
    
    return cell;
}

- (void)didCollectionView{
    if (self.didCollect) {
        self.didCollect();
    }
}

- (IBAction)leftMoreBtnClick:(UIButton *)sender {
    
    if (self.btnclick) {
        self.btnclick(self.model,sender.titleLabel.text);
    }
}
- (IBAction)rightMoreBtnClick:(UIButton *)sender {
    if (self.btnclick) {
        self.btnclick(self.model,sender.titleLabel.text);
    }
}

- (IBAction)leftBtnClick:(UIButton *)sender {
    if (self.btnclick) {
        self.btnclick(self.model,sender.titleLabel.text);
    }
}
- (IBAction)rightBtnClick:(UIButton *)sender {
    if (self.btnclick) {
        self.btnclick(self.model,sender.titleLabel.text);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
