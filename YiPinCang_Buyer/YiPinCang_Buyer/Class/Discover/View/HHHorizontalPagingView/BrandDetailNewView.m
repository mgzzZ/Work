//
//  BrandDetailNewView.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/8.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "BrandDetailNewView.h"
#import "BrandFlowLayout.h"
#import "FiterBrandView.h"
#import "TopView.h"
#import "LiveDetailLiveActivityCell.h"
#import "DiscoverBrandLiskModel.h"
#import "ClassSegView.h"
@interface BrandDetailNewView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic,strong)FiterBrandView *fiterBrandView;

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
@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *class_id;//分类
@property (nonatomic,strong)ClassSegView *classSegView;
@property (nonatomic,assign)BOOL isHave;
@end


@implementation BrandDetailNewView

+ (BrandDetailNewView *)contentTableView{
    BrandFlowLayout * layout = [[BrandFlowLayout alloc]init];
    layout.naviHeight = 30;
    layout.headerReferenceSize = CGSizeMake(ScreenWidth, 42);
    BrandDetailNewView *contentTV = [[BrandDetailNewView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    contentTV.backgroundColor = [UIColor whiteColor];
    contentTV.dataSource = contentTV;
    contentTV.delegate = contentTV;
    contentTV.backgroundColor = [Color colorWithHex:@"0xefefef"];
    contentTV.emptyDataSetSource = contentTV;
    contentTV.emptyDataSetDelegate = contentTV;
    contentTV.isHave = NO;
    [contentTV registerNib:[UINib nibWithNibName:NSStringFromClass([LiveDetailLiveActivityCell class]) bundle:nil] forCellWithReuseIdentifier:@"LiveDetailLiveActivityCell"];
    [contentTV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    return contentTV;
}

- (void)setLive_id:(NSString *)live_id{
    if (![_live_id isEqualToString:live_id]) {
        _live_id = live_id;
    }
    self.btnType = @"0";
    self.class_id = @"";
    self.sectionStr = @"";
    self.page = @"1";
    self.listorder = @"0";
    [self getData:self.page isRefresh:YES];
    
    [self getDataOfBrand];
}


- (void)getData:(NSString *)page isRefresh:(BOOL)isRefresh{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/showstore/brandgoods"
                  refreshCache:YES
                        params:@{@"live_id":weakSelf.live_id,
                                 @"listorder":weakSelf.listorder,
                                 @"brand_id":weakSelf.class_id,
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
                               NSMutableArray *arr = [LiveActivityModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"list"]];
                               [weakSelf.dataArr addObjectsFromArray:arr];
                               if (weakSelf.dataArr.count != 0 && weakSelf.isHave == NO) {
                                   [weakSelf upRefresh];
                                   weakSelf.isHave = YES;
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
    
    [YPCNetworking postWithUrl:@"shop/showstore/brandclass"
                  refreshCache:YES
                        params:@{
                                 @"live_id":weakSelf.live_id
                                 }
                       success:^(id response) {
                           
                           weakSelf.brandListArr = [DiscoverBrandLiskModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                           
                           [weakSelf segBrandData:weakSelf.brandListArr];
                           
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}



- (ClassSegView *)classSegView{
    WS(weakSelf);
    if (_classSegView == nil) {
        _classSegView = [[ClassSegView alloc]init];
        [self addSubview:_classSegView];
        _classSegView.sd_layout
        .topSpaceToView(self,60)
        .leftEqualToView(self)
        .rightEqualToView(self)
        .heightIs(0);
        _classSegView.hidden = YES;
        _classSegView.classBackId = ^(NSString *class_id){
            weakSelf.class_id = class_id;
            weakSelf.page = @"1";
            [weakSelf getData:weakSelf.page isRefresh:YES];
            [weakSelf segBrandViewHiden];
        };
    }
    return _classSegView;
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
    cell.imgHeight.constant = 251.0;
    cell.labHeight.constant = 0;
    cell.priceLab.textColor = [UIColor redColor];
    cell.model = self.dataArr[indexPath.row];
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
    return (CGSize){(ScreenWidth) / 2,332 };
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 0, 20, 0);
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
        self.topView = [[TopView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 42)];
        self.topView.bgView.layer.borderColor = [Color colorWithHex:@"0xefefef"].CGColor;
        self.topView.bgView.layer.borderWidth = 1;
        if ([self.listorder isEqualToString:@"1"]) {
            [self.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_clicked_ascending") forState:UIControlStateNormal];
        }else if ([self.listorder isEqualToString:@"2"]){
            [self.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_clicked_descending") forState:UIControlStateNormal];
        }else if ([self.listorder isEqualToString:@"0"]){            
            [self.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_unclicked") forState:UIControlStateNormal];
        }
        WS(weakself);
        self.topView.didBtnClick = ^(UIButton *clickBtn,NSInteger tag){
            switch (tag) {
                case 1000:
                {
                    clickBtn.selected = NO;
                    [weakself chooseHiden];
                    if (![weakself.listorder isEqualToString:@"0"]) {
                        weakself.listorder = @"0";
                        weakself.page = @"1";
                        [weakself getData:weakself.page isRefresh:YES];
                    }else{
                        weakself.listorder = @"0";
                    }
                    [weakself.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_unclicked") forState:UIControlStateNormal];
                }
                    break;
                case 1001:
                {
                    clickBtn.selected = YES;
                    weakself.topView.brandBtn.selected = NO;
                    weakself.topView.priceBtn.selected = NO;
                    weakself.topView.recommendBtn.selected = YES;
                    [weakself chooseHiden];
                    [weakself segBrandViewHidenNo:weakself.sectionArr];
                    [weakself.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_unclicked") forState:UIControlStateNormal];
                }
                    break;
                case 1002:
                {
                    weakself.topView.priceBtn.selected = NO;
                    weakself.topView.otherBtn.selected = NO;
                    weakself.topView.recommendBtn.selected = YES;
                    if ([weakself.listorder isEqualToString:@"0"]) {
                        weakself.listorder = @"1";
                        [weakself.topView.brandBtn setTitleColor:[Color colorWithHex:@"#EC0024"] forState:UIControlStateNormal];
                        [weakself.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_clicked_ascending") forState:UIControlStateNormal];
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
                    
                    [weakself.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_unclicked") forState:UIControlStateNormal];
                }
                    break;
                    
                default:
                    break;
            }
            
            
            
        };
        
        [headerView addSubview:self.topView];
        
        reusableview = headerView;
    }
    
    
    
    return reusableview;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    
    return scrollView.frame.origin.y + 50.f;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"blankpage_brand_icon"];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return YES;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"该品牌下没有活动商品哦";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName: [Color colorWithHex:@"0x2c2c2c"]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
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
        self.classSegView.tableView.sd_layout.heightIs(0);
        self.classSegView.sd_layout.heightIs(0);
    }];
    [self.bgView removeGestureRecognizer:_tap];
    self.btnType = @"0";
}
// 展示 筛选品牌
- (void)segBrandViewHidenNo:(NSArray *)arr{
    
    [self.bgView addGestureRecognizer:_tap];
    self.classSegView.dataDic = self.brandDic;
    CGFloat height = 0;
    if (arr.count * 80 > 282) {
        height = 282;
    }else{
        height = arr.count * 80;
    }
    [UIView animateWithDuration:0.3 animations:^{

            self.bgView.hidden = NO;
            self.classSegView.hidden = NO;
            self.classSegView.sd_layout.heightIs(height);
            self.classSegView.tableView.sd_layout.heightIs(height);
        
    }];
    
    self.btnType = @"2";
}


#pragma mark - 懒加载


- (UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.3;
        [self addSubview:_bgView];
        
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelClick:)];
        _bgView.sd_layout
        .topSpaceToView(self,60)
        .leftEqualToView(self)
        .rightEqualToView(self)
        .bottomEqualToView(self);
        self.bgView.hidden = YES;
        
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
@end
