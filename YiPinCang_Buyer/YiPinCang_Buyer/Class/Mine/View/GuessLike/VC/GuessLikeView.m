//
//  GuessLikeView.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/3.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "GuessLikeView.h"
#import "GuessLikeCell.h"

@implementation GuessLikeView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUp];
    }
    return self;
}

- (void)setUp{
    UIView *midView = [[UIView alloc]init];
    [self addSubview:midView];
    midView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topSpaceToView(self,0)
    .heightIs(60);
    UILabel *guessLab = [[UILabel alloc]init];
    guessLab.text = @"猜你喜欢";
    guessLab.font = [UIFont systemFontOfSize:18];
    guessLab.textColor = [Color colorWithHex:@"#2c2c2c"];
    guessLab.textAlignment = NSTextAlignmentCenter;
    [midView addSubview:guessLab];
    guessLab.sd_layout
    .centerXEqualToView(midView)
    .centerYEqualToView(midView)
    .widthIs(80)
    .heightIs(20);
    UIView *leftView = [[UIView alloc]init];
    leftView.backgroundColor = [Color colorWithHex:@"0x2c2c2c"];
    [midView addSubview:leftView];
    leftView.sd_layout
    .rightSpaceToView(guessLab,15)
    .widthIs(36)
    .heightIs(1)
    .centerYEqualToView(guessLab);
    
    UIView *rightView = [[UIView alloc]init];
    [midView addSubview:rightView];
    rightView.sd_layout
    .leftSpaceToView(guessLab,15)
    .widthIs(36)
    .heightIs(1)
    .centerYEqualToView(guessLab);
    rightView.backgroundColor = [Color colorWithHex:@"0x2c2c2c"];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    _collectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectView.delegate = self;
    _collectView.dataSource = self;
    _collectView.scrollEnabled = NO;
    _collectView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_collectView];
    _collectView.sd_layout
    .topSpaceToView(midView,0)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .bottomEqualToView(self);
    [self.collectView registerNib:[UINib nibWithNibName:NSStringFromClass([GuessLikeCell class]) bundle:nil] forCellWithReuseIdentifier:@"GuessLikeCell"];
//    WS(weakself);
//    self.collectView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        if (weakself.refresh) {
//            weakself.refresh();
//        }
//    }];

}

- (void)setDataArr:(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]initWithArray:dataArr];
    }
    _dataArr = dataArr;
    
    [_collectView reloadData];
}


#pragma mark- colllection delegate&dataSource



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return  self.dataArr.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = @"GuessLikeCell";
    GuessLikeCell *cell = (GuessLikeCell *)[_collectView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.model = _dataArr[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didSelect) {
        self.didSelect(indexPath);
    }
}	
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){(ScreenWidth - 46) / 2,(ScreenWidth - 46) / 2 * 182 / 137 +60};
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 14, 20, 14);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 18.f;
}

@end
