//
//  LIveView.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/9.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LIveView.h"
#import <iCarousel.h>
#import "LiveTopView.h"
#import "LiveBottomCell.h"
#import "HJCarouselViewLayout.h"
@interface LIveView ()<iCarouselDataSource, iCarouselDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UIImageView *bgImg;
@property (nonatomic,strong)iCarousel *topView;
@property (nonatomic,strong)iCarousel *bottomView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)UICollectionView *collevtion;
@property (nonatomic,assign)NSInteger oldRow;
@property (nonatomic,assign)CGFloat xxx;

@end

@implementation LIveView
- (void)dealloc
{
    self.topView.delegate = nil;
    self.topView.dataSource = nil;
    self.bottomView.delegate = nil;
    self.bottomView.dataSource = nil;
}



- (instancetype)init{
    self = [super init];
    if (self) {
        self.oldRow = 0;
        [self getData];
    }
    return self;
}


- (void)getData{
    WS(weakSelf);
    if (![YPCRequestCenter isLogin]) {
        [YPCNetworking postWithUrl:@"shop/showstore/storelist"
                      refreshCache:YES
                            params:@{
                                     }
                           success:^(id response) {
                               if ([YPC_Tools judgeRequestAvailable:response]) {
                                   
                                   weakSelf.dataArr = [LiveTopViewModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                                    [weakSelf addSubview:self.bgImg];
                                   [weakSelf.topView reloadData];
                                   //[weakSelf.collevtion reloadData];
                               }
                               
                           }
                              fail:^(NSError *error) {
                                  
                              }];
    }else{
        [YPCNetworking postWithUrl:@"shop/showstore/storelist"
                      refreshCache:YES
                            params:[YPCRequestCenter getUserInfo]
                           success:^(id response) {
                               if ([YPC_Tools judgeRequestAvailable:response]) {
                                   
                                   weakSelf.dataArr = [LiveTopViewModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                                   [weakSelf addSubview:self.bgImg];
                                   [weakSelf.topView reloadData];
                                  // [weakSelf.collevtion reloadData];
                               }
                               
                           }
                              fail:^(NSError *error) {
                                  
                              }];
    }
    
}

#pragma mark - 懒加载

- (iCarousel *)topView{
    if (_topView == nil) {
        _topView = [[iCarousel alloc]init];
        _topView.delegate = self;
        _topView.dataSource = self;

        _topView.type = iCarouselTypeCustom;
        CGSize offset = CGSizeMake(0.0f, -40);
        _topView.viewpointOffset = offset;
        [self addSubview:_topView];
        _topView.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .bottomSpaceToView(self,100)
        .topSpaceToView(self,64);
    }
    return _topView;
}

- (iCarousel *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[iCarousel alloc]init];
        _bottomView.delegate = self;
        _bottomView.dataSource = self;

        _bottomView.type = iCarouselTypeRotary;
        CGSize offset = CGSizeMake(0.0f, 20);
        _bottomView.viewpointOffset = offset;
        [self addSubview:_bottomView];
        _bottomView.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .bottomEqualToView(self)
        .heightIs(150);
    }
    return _bottomView;
}
- (UICollectionView *)collevtion{
    if (_collevtion == nil) {
        HJCarouselViewLayout *layout = [[HJCarouselViewLayout alloc] initWithAnim:HJCarouselAnimLinear];
        layout.itemSize = CGSizeMake(50, 50);

        layout.visibleCount = (ScreenWidth - 20) / 48;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collevtion = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collevtion.delegate = self;
        _collevtion.backgroundColor = [UIColor clearColor];
        _collevtion.dataSource = self;
        _collevtion.showsVerticalScrollIndicator = NO;
        _collevtion.showsHorizontalScrollIndicator = NO;
        //_collevtion.contentSize = CGSizeMake(ScreenWidth - 20, 0);
        [_collevtion registerNib:[UINib nibWithNibName:NSStringFromClass([LiveBottomCell class]) bundle:nil] forCellWithReuseIdentifier:@"LiveCell"];
        [self addSubview:_collevtion];
        _collevtion.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .bottomSpaceToView(self,30)
        .heightIs(100);
    }
    return _collevtion;
}
- (UIImageView *)bgImg{
    if (_bgImg == nil) {
        _bgImg = [[UIImageView alloc]initWithImage:IMAGE(@"find_background")];
        _bgImg.frame = self.bounds;
        [self addSubview:_bgImg];
    }
    return _bgImg;
}
- (NSMutableArray *)dataArr
{
    if (_dataArr) {
        return _dataArr;
    }
    _dataArr = [NSMutableArray array];
   
    return _dataArr;
}

#pragma mark - iCarouselDelegate
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.dataArr.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (carousel == self.topView) {

        LiveTopView *topView = nil;
        if (view == nil)
        {
            CGFloat width = kWidth(290);
            CGFloat height = kHeight(461);
            view = [UIView new];
            view.frame = CGRectMake(0, 0, width, height);
            view.layer.cornerRadius = 4;
            view.backgroundColor = [UIColor whiteColor];
            topView = [[LiveTopView alloc] initWithFrame:view.bounds];
            topView.tag = 10000 + index;
            topView.layer.cornerRadius = 4;
            topView.layer.masksToBounds = YES;
            [view addSubview:topView];
        }
        else
        {
            topView = (LiveTopView *)[view viewWithTag:10000 + index];
        }
        topView.txBtn.tag = index;
        [topView.txBtn addTarget:self action:@selector(liveDetail:) forControlEvents:UIControlEventTouchUpInside];
        topView.fllowBtn.tag = index;
        [topView.fllowBtn addTarget:self action:@selector(fllowBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        topView.model = self.dataArr[index];
        
        return view;
    }else if(carousel == self.bottomView){
        UIImageView *img = nil;
        if (view == nil)
        {
            view = [UIView new];
            view.frame = CGRectMake(0, 0, 48, 48);
            view.layer.cornerRadius = 24;
            view.backgroundColor = [UIColor whiteColor];
            img = [[UIImageView alloc] initWithFrame:view.bounds];
            img.layer.cornerRadius = 24;
            img.layer.masksToBounds = YES;
            img.tag = 1000 + index;
            [view addSubview:img];
        }
        else
        {
            img = (UIImageView *)[view viewWithTag:1000 + index];
        }
        LiveTopViewModel *model = self.dataArr[index];
        [img sd_setImageWithURL:[NSURL URLWithString:model.store_avatar] placeholderImage:YPCImagePlaceHolder];
        
        return view;
    }else{
        return nil;
    }
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionFadeMin:
            return -0.2;
        case iCarouselOptionFadeMax:
            return 0.2;
        case iCarouselOptionFadeRange:
            return 2.0;
        case iCarouselOptionWrap:
            return YES;
        default:
            return value;
    }
}

-(CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    static CGFloat max_sacle = 1.0f;
    static CGFloat min_scale = 0.7f;
    if (offset <= 1 && offset >= -1) {
        float tempScale = offset < 0 ? 1 + offset : 1 - offset;
        float slope = (max_sacle - min_scale) / 1;
        
        CGFloat scale = min_scale + slope * tempScale;
        transform = CATransform3DScale(transform, scale, scale, 1);
    }else {
        transform = CATransform3DScale(transform, min_scale, min_scale, 1);
    }
    return CATransform3DTranslate(transform, offset * self.topView.itemWidth * 1.4, 0.0, 0.0);
}



- (void)carouselDidScroll:(iCarousel *)carousel{
//    if (carousel == self.topView) {
//        NSNumber *index = [NSNumber numberWithFloat:carousel.scrollOffset];
//      
//        [self scrollToindex:index.integerValue];
//    }
}


#pragma mark - collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = @"LiveCell";
    LiveBottomCell *cell = (LiveBottomCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
     
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){48 ,48 };
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.topView scrollToItemAtIndex:indexPath.row animated:YES];
//    NSInteger row = indexPath.row;
//    self.oldRow = [self scrollToItem];
//    if (row - self.oldRow > 0) {
//        [self.collevtion setContentOffset:CGPointMake(self.xxx + (row - self.oldRow) * 50, 0)];
//    }else{
//         [self.collevtion setContentOffset:CGPointMake(self.xxx - (self.oldRow - row) * 50, 0)];
//    }
    


}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    self.xxx = scrollView.contentOffset.x;
//    
//}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    if (scrollView == self.collevtion) {
//        [self.topView scrollToItemAtIndex:[self scrollToItem] animated:YES];
//    }
}
- (void)liveDetail:(UIButton *)sender{
    
    LiveTopViewModel *model = self.dataArr[sender.tag];
    if (self.txdid) {
        self.txdid(model);
    }
}

- (void)fllowBtnClick:(UIButton *)sender{
    if (![YPCRequestCenter isLogin]) {
        if (self.login) {
            self.login();
        }
    }else{
        LiveTopViewModel *model = self.dataArr[sender.tag];
        if (sender.selected) {
            [self followstore_cancel:model.store_id];
            sender.selected = NO;
        }else{
            sender.selected = YES;
            [self followstore_add:model.store_id];
        }
    }
    
}

- (void)followstore_add:(NSString *)store_id{
    [YPCNetworking postWithUrl:@"shop/showstore/followstore/add"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"store_id":store_id
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               
                              
                           }
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}
- (void)followstore_cancel:(NSString *)store_id{
    [YPCNetworking postWithUrl:@"shop/showstore/followstore/cancel"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"store_id":store_id
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               
                               
                           }
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}
- (NSIndexPath *)curIndexPath {
    NSArray *indexPaths = [self.collevtion indexPathsForVisibleItems];
    NSIndexPath *curIndexPath = nil;
    NSInteger curzIndex = 0;
    for (NSIndexPath *path in indexPaths.objectEnumerator) {
        UICollectionViewLayoutAttributes *attributes = [self.collevtion layoutAttributesForItemAtIndexPath:path];
        if (!curIndexPath) {
            curIndexPath = path;
            curzIndex = attributes.zIndex;
            continue;
        }
        if (attributes.zIndex > curzIndex) {
            curIndexPath = path;
            curzIndex = attributes.zIndex;
        }
    }
    return curIndexPath;
}

- (NSInteger)scrollToItem{

    return (self.xxx + 182)/50;
}
- (void)scrollToindex:(NSInteger)index{
    [self.collevtion setContentOffset:CGPointMake(-182 + index * 50, 0)];
}
@end
