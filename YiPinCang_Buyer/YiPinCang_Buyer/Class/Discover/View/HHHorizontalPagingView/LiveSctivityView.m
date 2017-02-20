//
//  LiveSctivityView.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/6.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LiveSctivityView.h"

#import "FiterBrandView.h"
#import "TopView.h"
#import "LiveDetailLiveActivityCell.h"
#import "DiscoverBrandLiskModel.h"
#import "DiscoverLivegoodsModel.h"
#import "BrandFlowLayout.h"
@interface LiveSctivityView ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic,strong)FiterBrandView *fiterBrandView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)TopView *topView;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UITapGestureRecognizer *tap;
@property (nonatomic,copy)NSString *btnType;//记录点击筛选按钮0 是没有点击 1是点击筛选价格 2点击筛选品牌
@property (nonatomic,copy)NSMutableArray *brandListArr;
@property (nonatomic,copy)NSString *sectionStr;
@property (nonatomic,strong)NSMutableArray *sectionArr;
@property (nonatomic,strong)NSMutableDictionary *brandDic;
@property (nonatomic,strong)NSMutableArray *valueArr;//装model
@property (nonatomic,strong)NSMutableArray *bigValueArr;//装bigTValueArr
@property (nonatomic,strong)NSMutableArray *bigTValueArr;//装valueArr 和选中后的心分类
@property (nonatomic,copy)NSString *listorder;
@property (nonatomic,copy)NSString *brand;
@property (nonatomic,copy)NSString *bind;
@property (nonatomic,copy)NSString *page;
@property (nonatomic,assign)BOOL isHave;
@property (nonatomic,assign)CGFloat topHeight;
@end

@implementation LiveSctivityView

+ (LiveSctivityView *)contentTableView{
    BrandFlowLayout * layout = [[BrandFlowLayout alloc]init];
    layout.naviHeight = 84;
    layout.headerReferenceSize = CGSizeMake(ScreenWidth, 42);
    LiveSctivityView *contentTV = [[LiveSctivityView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    contentTV.backgroundColor = [UIColor whiteColor];
    contentTV.contentInset = UIEdgeInsetsMake(0, 0, 25, 0);
    contentTV.dataSource = contentTV;
    contentTV.delegate = contentTV;
    contentTV.backgroundColor = [Color colorWithHex:@"0xefefef"];
    contentTV.isHave = NO;
    contentTV.emptyDataSetSource = contentTV;
    contentTV.emptyDataSetDelegate = contentTV;
    [contentTV registerNib:[UINib nibWithNibName:NSStringFromClass([LiveDetailLiveActivityCell class]) bundle:nil] forCellWithReuseIdentifier:@"LiveDetailLiveActivityCell"];
    [contentTV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    contentTV.topHeight = 42;
    return contentTV;
}

- (void)setStore_id:(NSString *)store_id{
    if (![_store_id isEqualToString:store_id]) {
        _store_id = store_id;
    }
    self.btnType = @"0";
    self.brand = @"";
    self.bind = @"";
    self.sectionStr = @"";
    self.page = @"1";
    self.listorder = @"0";
    [self getData:self.page isRefresh:YES];
    
    [self getDataOfBrand];
   
}
- (void)getData:(NSString *)page isRefresh:(BOOL)isRefresh{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/showstore/activitygoods"
                  refreshCache:YES
                        params:@{@"store_id":weakSelf.store_id,
                                 @"listorder":weakSelf.listorder,
                                 @"brand":weakSelf.brand,
                                 @"bind":weakSelf.bind,
                                 @"pagination":@{
                                         @"page":page,
                                         @"count":@"10"
                                         }
                                 }
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               if (isRefresh) {
                                   [weakSelf.dataArr removeAllObjects];
                               }
                               NSMutableArray *arr = [LiveActivityModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                               [weakSelf.dataArr addObjectsFromArray:arr];
                               if (weakSelf.dataArr.count != 0 && weakSelf.mj_footer == nil) {
                                   [weakSelf upRefresh];
                                   weakSelf.isHave = YES;
                               }
                               if (weakSelf.dataArr.count == 0 ) {
                                   weakSelf.mj_footer = nil;
                               }
                               [weakSelf reloadData];
                               if (arr.count < 10) {
                                   [weakSelf.mj_footer endRefreshingWithNoMoreData];
                               }else{
                                   [weakSelf.mj_footer endRefreshing];
                               }
                               [weakSelf.mj_header endRefreshing];
                           }
                       }
                          fail:^(NSError *error) {
                              
                          }];
}



- (void)upRefresh{
    
    WS(weakself);
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakself.page = [NSString stringWithFormat:@"%zd",weakself.page.integerValue + 1];
        [weakself getData:weakself.page isRefresh:NO];
    }];
}

- (void)getDataOfBrand{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/explore/brandlist"
                  refreshCache:YES
                        params:@{
                                 @"store_id":weakSelf.store_id
                                 }
                       success:^(id response) {
                           
                           weakSelf.brandListArr = [DiscoverBrandLiskModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                           
                           [weakSelf segBrandData:weakSelf.brandListArr];
                           
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}

- (FiterBrandView *)fiterBrandView{
    WS(weakSelf);
    if (_fiterBrandView == nil) {
        _fiterBrandView = [[FiterBrandView alloc]init];
        _fiterBrandView.type = Brand;
        [self addSubview:self.fiterBrandView];
        self.fiterBrandView.sd_layout.topSpaceToView(self,self.topHeight)
        .leftEqualToView(self)
        .rightEqualToView(self)
        .heightIs(0);
        self.fiterBrandView.hidden = YES;
        self.fiterBrandView.backId = ^(NSString *brand,NSString *bind){
            [weakSelf chooseHiden];
            if (bind.length != 0) {
                weakSelf.bind = bind;
            }else{
                weakSelf.bind = @"";
            }
            if (brand.length == 0) {
                [YPC_Tools showSvpWithNoneImgHud:@"请先选择品牌!"];
            }else{
               weakSelf.brand = brand;
            }
            weakSelf.topView.priceBtn.selected = NO;
            if (weakSelf.brand.length != 0) {
                [weakSelf getData:weakSelf.page isRefresh:YES];
            }else{
                [weakSelf chooseHiden];
            }
            
        };
    }
    return _fiterBrandView;
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
    
    NSString *identifier = @"LiveDetailLiveActivityCell";
    LiveDetailLiveActivityCell *cell = (LiveDetailLiveActivityCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    cell.priceLab.textColor = [UIColor redColor];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LiveActivityModel *model = self.dataArr[indexPath.row];
    if (self.didcell) {
        self.didcell(indexPath,model);
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){(ScreenWidth) / 2,312 };
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 20, 0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        if (_topView == nil) {
            self.topView = [[TopView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 42)];
            self.topView.bgView.layer.borderColor = [Color colorWithHex:@"0xefefef"].CGColor;
            self.topView.bgView.layer.borderWidth = 1;
            WS(weakself);
            self.topView.didBtnClick = ^(UIButton *clickBtn, NSInteger tag){
                switch (tag) {
                    case 1000:
                    {
                        clickBtn.selected = NO;
                        [weakself chooseHiden];
                        weakself.listorder = @"0";
                        weakself.page = @"1";
                        weakself.brand = @"";
                        weakself.bind = @"";
                        [weakself getData:weakself.page isRefresh:weakself];
                        [weakself.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_unclicked") forState:UIControlStateNormal];
                        [weakself.topView.brandBtn setTitleColor:[Color colorWithHex:@"0x666666"] forState:UIControlStateNormal];

                    }
                        break;
                    case 1001:
                    {
                        
                        if (clickBtn.selected == NO) {
                            weakself.fiterBrandView = nil;
                            clickBtn.selected = YES;
                            weakself.topView.brandBtn.selected = NO;
                            weakself.topView.priceBtn.selected = NO;
                            weakself.topView.recommendBtn.selected = YES;
                            [weakself chooseHiden];
                            [weakself segBrandViewHidenNo:weakself.sectionArr];
                            [weakself.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_unclicked") forState:UIControlStateNormal];
                            [weakself.topView.brandBtn setTitleColor:[Color colorWithHex:@"0x666666"] forState:UIControlStateNormal];
                        }else{
                            clickBtn.selected = NO;
                            weakself.topView.recommendBtn.selected = NO;
                            [weakself chooseHiden];
                            weakself.listorder = @"0";
                        }
                    }
                        break;
                    case 1002:
                    {
                        weakself.topView.priceBtn.selected = NO;
                        weakself.topView.otherBtn.selected = NO;
                        weakself.topView.recommendBtn.selected = YES;
                        if ([weakself.listorder isEqualToString:@"0"] || [weakself.listorder isEqualToString:@"3"] ) {
                            weakself.listorder = @"1";
                            [weakself.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_clicked_ascending") forState:UIControlStateNormal];
                            [weakself.topView.brandBtn setTitleColor:[Color colorWithHex:@"#EC0024"] forState:UIControlStateNormal];
                        }else if ([weakself.listorder isEqualToString:@"1"]){
                            weakself.listorder = @"2";
                            [weakself.topView.brandBtn setTitleColor:[Color colorWithHex:@"#EC0024"] forState:UIControlStateNormal];
                            [weakself.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_clicked_descending") forState:UIControlStateNormal];
                        }else if ([weakself.listorder isEqualToString:@"2"]){
                            weakself.listorder = @"0";
                            [weakself.topView.brandBtn setTitleColor:[Color colorWithHex:@"#666666"] forState:UIControlStateNormal];
                            [weakself.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_unclicked") forState:UIControlStateNormal];
                        }
                        weakself.page = @"1";
                        [weakself getData:weakself.page isRefresh:YES];
                    }
                        break;
                    case 1003:
                    {
                        if (clickBtn.selected == NO) {
                            weakself.listorder = @"3";
                            clickBtn.selected = YES;
                            weakself.topView.recommendBtn.selected = YES;
                        }else{
                            weakself.listorder = @"0";
                            clickBtn.selected = NO;
                            weakself.topView.recommendBtn.selected = NO;
                        }
                        [weakself chooseHiden];
                        weakself.page = @"1";
                        [weakself getData:weakself.page isRefresh:YES];
                        [weakself.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_unclicked") forState:UIControlStateNormal];
                        [weakself.topView.brandBtn setTitleColor:[Color colorWithHex:@"0x666666"] forState:UIControlStateNormal];
                    }
                        break;
                        
                    default:
                        break;
                }
            };
            
            if ([self.listorder isEqualToString:@"1"]) {
                
                [self.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_clicked_ascending") forState:UIControlStateNormal];
            }else if ([self.listorder isEqualToString:@"2"]){
                
                [self.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_clicked_descending") forState:UIControlStateNormal];
            }else if ([self.listorder isEqualToString:@"0"]){
                
                [self.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_unclicked") forState:UIControlStateNormal];
            }
            
            [headerView addSubview:self.topView];
        }
        
        reusableview = headerView;
    }

   
    
    return reusableview;
}



//转换json
- (void)segBrandData:(NSMutableArray *)listArr{
    if (listArr.count == 0) {
        return;
    }else{
        self.bigValueArr = [[NSMutableArray alloc]init];
        self.brandDic = [[NSMutableDictionary alloc]init];
    }
    for (int i = 0; i < listArr.count; i++) {
        DiscoverBrandLiskModel *model = listArr[i];
        if (![model.brand_initial isEqualToString:_sectionStr]) {
            if (_valueArr && _valueArr.count != 0) {
                [self.bigTValueArr addObject:_valueArr];
                [self.bigValueArr addObject:_bigTValueArr];
            }
            _valueArr = [[NSMutableArray alloc]init];
            _bigTValueArr = [[NSMutableArray alloc]init];
            [self.sectionArr addObject:model.brand_initial];
            _sectionStr = model.brand_initial;
            [_valueArr addObject:model];
            if (i == listArr.count - 1) {
                [self.bigTValueArr addObject:_valueArr];
                [self.bigValueArr addObject:_bigTValueArr];
            }
        }else{
            
            [_valueArr addObject:model];
            if (i == listArr.count - 1) {
                [self.bigTValueArr addObject:_valueArr];
                [self.bigValueArr addObject:_bigTValueArr];
            }
            
        }
    }
    for (int i = 0; i < self.sectionArr.count; i++) {
        [self.brandDic setValue:self.bigValueArr[i] forKey:self.sectionArr[i]];
    }
}
#pragma mark- btn action

- (void)cancelClick:(UIGestureRecognizer *)sender{
    self.topView.otherBtn.selected = NO;
    self.topView.priceBtn.selected = NO;
    self.topView.recommendBtn.selected = NO;
    self.topView.priceBtn.selected = NO;
    self.topView.otherBtn.selected = NO;
    [self.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_unclicked") forState:UIControlStateNormal];
    [self.topView.brandBtn setTitleColor:[Color colorWithHex:@"666666"] forState:UIControlStateNormal];
    [self chooseHiden];
}

#pragma mark-  筛选栏逻辑
//判断筛选栏是否在下拉状态


// 根据btnType 选择收回View
- (void)chooseHiden{
    if ([self.btnType isEqualToString:@"0"]) {
        return;
    }
    if( [self.btnType isEqualToString:@"2"]){
        [self segBrandViewHiden];
    }
}
//隐藏 筛选品牌
- (void)segBrandViewHiden{
    if (self.bgView.hidden == YES) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.hidden = YES;
        self.fiterBrandView.tableView.sd_layout.heightIs(0);
        self.fiterBrandView.bottomView.sd_layout.heightIs(0);
        self.fiterBrandView.sd_layout.heightIs(0);
        self.fiterBrandView.finishBtn.hidden = YES;
        self.fiterBrandView.resetBtn.hidden = YES;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.fiterBrandView removeFromSuperview];
            self.fiterBrandView = nil;
        }
    }];
    [self.bgView removeFromSuperview];
    self.bgView = nil;
    [self.bgView removeGestureRecognizer:_tap];
    self.btnType = @"0";
}
// 展示 筛选品牌
- (void)segBrandViewHidenNo:(NSArray *)arr{
    [self addSubview:self.bgView];
    [self.bgView addGestureRecognizer:_tap];
    self.fiterBrandView.dataDic = self.brandDic;
    CGFloat height = 0;
    if (iPhone5) {
        if (arr.count * 80 > 150) {
            height = 150;
        }else{
            height = arr.count * 80;
        }
    }else if(iPhone6){
        if (arr.count * 80 > 200) {
            height = 200;
        }else{
            height = arr.count * 80;
        }
    }else if(iPhone6P){
        if (arr.count * 80 > 282) {
            height = 282;
        }else{
            height = arr.count * 80;
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        
        [UIView animateWithDuration:0.15 delay:0 options:0 animations:^{
            self.bgView.hidden = NO;
            self.fiterBrandView.sd_layout.heightIs(height + 50);
            self.fiterBrandView.tableView.sd_layout.heightIs(height);
        } completion:^(BOOL finished) {
            
        }];
        [UIView animateWithDuration:0.1 delay:0.2 options:0 animations:^{
            self.fiterBrandView.bottomView.sd_layout.heightIs(50);
            
            self.fiterBrandView.hidden = NO;
        } completion:^(BOOL finished) {
            self.fiterBrandView.finishBtn.hidden = NO;
            self.fiterBrandView.resetBtn.hidden = NO;
        }];
    }];
    
    self.btnType = @"2";
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.bgView.hidden == NO) {
        [self segBrandViewHiden];
        self.topView.otherBtn.selected = NO;
        self.topView.priceBtn.selected = NO;
        self.topView.recommendBtn.selected = NO;
        self.topView.priceBtn.selected = NO;
        self.topView.otherBtn.selected = NO;
        [self.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_unclicked") forState:UIControlStateNormal];
        [self.topView.brandBtn setTitleColor:[Color colorWithHex:@"666666"] forState:UIControlStateNormal];
        [self chooseHiden];
    }
    

    
    if (scrollView.contentOffset.y <= -75) {
        self.topHeight = 42;
    }else if(scrollView.contentOffset.y > -75 && scrollView.contentOffset.y < 0){
        self.topHeight = 125 - fabs(scrollView.contentOffset.y) ;
    }else{
        self.topHeight = 125 + fabs(scrollView.contentOffset.y);
    }
}

#pragma mark - 懒加载


- (UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor clearColor];
        _bgView.alpha = 0.3;
        [self addSubview:_bgView];
        
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelClick:)];
        _bgView.sd_layout
        .topSpaceToView(self,self.topHeight)
        .leftEqualToView(self)
        .rightEqualToView(self)
        .heightIs(1000);
        _bgView.hidden = YES;
        
    }
    return _bgView;
}

- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)sectionArr{
    if (_sectionArr == nil) {
        _sectionArr = [[NSMutableArray alloc]init];
    }
    return _sectionArr;
}

- (NSMutableArray *)valueArr{
    if (_valueArr == nil) {
        _valueArr = [[NSMutableArray alloc]init];
    }
    return _valueArr;
}
-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    if (iPhone5) {
        return scrollView.frame.origin.y + 100;
    }else if(iPhone6){
        return scrollView.frame.origin.y + 105;
    }else if (iPhone6P){
        return scrollView.frame.origin.y + 110;
    }
    return 0;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"blankpage_livememberinformation_activitygoods_icon"];
    
    
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return YES;
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂未找到您想要的商品";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName: [Color colorWithHex:@"0x2c2c2c"]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
@end
