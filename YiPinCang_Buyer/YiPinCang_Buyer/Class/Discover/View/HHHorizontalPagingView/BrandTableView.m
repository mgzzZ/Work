//
//  BrandTableView.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/16.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "BrandTableView.h"
#import "FiterBrandView.h"
#import "TopView.h"
#import "LiveDetailLiveActivityCell.h"
#import "DiscoverBrandLiskModel.h"
#import "ClassSegView.h"
#import "BranCell.h"
@interface BrandTableView ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
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

@implementation BrandTableView

+ (BrandTableView *)contentTableView{
    BrandTableView *contentTV = [[BrandTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    contentTV.backgroundColor = [UIColor whiteColor];
    contentTV.dataSource = contentTV;
    contentTV.delegate = contentTV;
    contentTV.backgroundColor = [Color colorWithHex:@"0xefefef"];
    contentTV.emptyDataSetSource = contentTV;
    contentTV.emptyDataSetDelegate = contentTV;
    contentTV.isHave = NO;
    contentTV.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    [YPCNetworking postWithUrl:@"shop/showstore/brandgoodsv2"
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.topView = [[TopView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 42)];
    self.topView.bgView.layer.borderColor = [Color colorWithHex:@"0xefefef"].CGColor;
    self.topView.bgView.layer.borderWidth = 1;
    [self.topView.priceBtn addTarget:self action:@selector(priceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView.brandBtn addTarget:self action:@selector(brandBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView.otherBtn addTarget:self action:@selector(otherBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView.recommendBtn addTarget:self action:@selector(recommendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if ([self.listorder isEqualToString:@"1"]) {
        
        [self.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_clicked_ascending") forState:UIControlStateNormal];
    }else if ([self.listorder isEqualToString:@"2"]){
        
        [self.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_clicked_descending") forState:UIControlStateNormal];
    }else if ([self.listorder isEqualToString:@"0"]){
        
        [self.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_unclicked") forState:UIControlStateNormal];
    }
    return self.topView;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 42;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    BranCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[BranCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LiveActivityModel *model = self.dataArr[indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[BranCell class]  contentViewWidth:[self cellContentViewWith]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LiveActivityModel *model = self.dataArr[indexPath.row];
    if (self.didcell) {
        self.didcell(indexPath,model);
    }
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
- (void)recommendBtnClick:(UIButton *)sender{
    sender.selected = NO;
    [self chooseHiden];
    if (![self.listorder isEqualToString:@"0"]) {
        self.listorder = @"0";
        self.page = @"1";
        [self getData:self.page isRefresh:YES];
    }else{
        self.listorder = @"0";
    }
    [self.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_unclicked") forState:UIControlStateNormal];
}

- (void)priceBtnClick:(UIButton *)sender{
    sender.selected = YES;
    self.topView.brandBtn.selected = NO;
    self.topView.otherBtn.selected = NO;
    self.topView.recommendBtn.selected = YES;
    [self chooseHiden];
    [self segBrandViewHidenNo:self.sectionArr];
    [self.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_unclicked") forState:UIControlStateNormal];
}

- (void)brandBtnClick:(UIButton *)sender{
    
    self.topView.priceBtn.selected = NO;
    self.topView.otherBtn.selected = NO;
    self.topView.recommendBtn.selected = YES;
    if ([self.listorder isEqualToString:@"0"]) {
        self.listorder = @"1";
        [self.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_clicked_ascending") forState:UIControlStateNormal];
    }else if ([self.listorder isEqualToString:@"1"]){
        self.listorder = @"2";
        [self.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_clicked_descending") forState:UIControlStateNormal];
    }else if ([self.listorder isEqualToString:@"2"]){
        self.listorder = @"0";
        [self.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_unclicked") forState:UIControlStateNormal];
    }
    self.page = @"1";
    [self getData:self.page isRefresh:YES];
}

- (void)otherBtnClick:(UIButton *)sender{
    if (sender.selected == NO) {
        self.listorder = @"3";
        sender.selected = YES;
        self.topView.recommendBtn.selected = YES;
    }else{
        self.listorder = @"0";
        sender.selected = NO;
        self.topView.recommendBtn.selected = NO;
    }
    [self chooseHiden];
    self.page = @"1";
    [self getData:self.page isRefresh:YES];
    [self.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_unclicked") forState:UIControlStateNormal];
}
- (void)cancelClick:(UIGestureRecognizer *)sender{
    self.topView.otherBtn.selected = NO;
    self.topView.priceBtn.selected = NO;
    
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
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
- (NSMutableArray *)valueArr{
    if (_valueArr == nil) {
        _valueArr = [[NSMutableArray alloc]init];
    }
    return _valueArr;
}

@end
