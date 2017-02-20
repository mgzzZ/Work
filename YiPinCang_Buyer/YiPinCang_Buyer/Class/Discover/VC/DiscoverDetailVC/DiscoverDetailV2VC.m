//
//  DiscoverDetailV2VC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/19.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "DiscoverDetailV2VC.h"
#import "BrandDetailHeaderView.h"
#import "BrandDetailNewView.h"
#import "BrandDetailModel.h"
#import "LiveDetailHHHVC.h"
#import "DiscoverDetailVC.h"
#import "WebViewController.h"
#import "TopView.h"
#import "ClassSegView.h"
#import "FiterBrandView.h"
#import "BranCell.h"
#import "DiscoverBrandLiskModel.h"
#import <MediaPlayer/MediaPlayer.h>

@interface DiscoverDetailV2VC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic,strong)BrandDetailHeaderView *headerView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)BrandDetailModel *model;
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
@property (nonatomic,copy)NSString *page;
@property (nonatomic,copy)NSString *class_id;//分类
@property (nonatomic,strong)ClassSegView *classSegView;
@property (nonatomic,assign)BOOL isHave;
@property (nonatomic,assign)CGFloat offset;
@property (nonatomic,assign)BOOL isTop;
@property (nonatomic,copy)NSString *topStr;
@property (nonatomic,assign)CGFloat KheaderViewHeight;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic) UIButton *movieCoverBtn;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@end

@implementation DiscoverDetailV2VC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar mz_setBackgroundImage:IMAGE(@"homepage_bar")];
    [self.navigationController.navigationBar mz_setBackgroundColor:[Color colorWithHex:@"#3B3B3B"]];
    [self.navigationController.navigationBar mz_setBackgroundAlpha:0];
    self.view.backgroundColor = [Color colorWithHex:@"0xe3e3e3"];
    self.btnType = @"0";
    self.class_id = @"";
    self.sectionStr = @"";
    self.isTop = NO;
    self.topStr = @"1";
    self.page = @"1";
    self.listorder = @"0";
    [self addMjRefresh];
    [self getDataOfBrand];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.KheaderViewHeight = ScreenWidth * 150 / 375;
    self.page = @"1";
    [self getData:self.page isRefresh:YES];
}
- (void)getData:(NSString *)page isRefresh:(BOOL)isRefresh{
    WS(weakSelf);
    
    NSDictionary *parms = [YPCRequestCenter isLogin] > 0 ? [YPCRequestCenter getUserInfoAppendDictionary:@{@"live_id":weakSelf.live_id,
                                                                                                           @"listorder":weakSelf.listorder,
                                                                                                           @"class_id":weakSelf.class_id,
                                                                                                           @"pagination":@{
                                                                                                                   @"page":page,
                                                                                                                   @"count":@"10"
                                                                                                                   }
                                                                                                           }] : @{@"live_id":weakSelf.live_id,
                                                                                                                  @"listorder":weakSelf.listorder,
                                                                                                                  @"class_id":weakSelf.class_id,
                                                                                                                  @"pagination":@{
                                                                                                                          @"page":page,
                                                                                                                          @"count":@"10"
                                                                                                                          }
                                                                                                                  };
    
    [YPCNetworking postWithUrl:@"shop/showstore/brandgoodsv2"
                  refreshCache:YES
                        params:parms
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               
                               weakSelf.model = [BrandDetailModel mj_objectWithKeyValues:response[@"data"]];
                               [weakSelf.headerView.bgimg sd_setImageWithURL:[NSURL URLWithString:weakSelf.model.brand.bgurl] placeholderImage:IMAGE(@"find_logo_placeholder")];
                               [weakSelf.headerView.brandBtn setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:weakSelf.model.brand.store_avatar]]] forState:UIControlStateNormal];
                               weakSelf.headerView.brandNameLab.text = weakSelf.model.brand.brand_name;
                               weakSelf.headerView.BrandTitleLab.text = weakSelf.message;
                               
                               if ([weakSelf.type isEqualToString:@"直播中"]) {
                                   [weakSelf.headerView.typeImg setImage:IMAGE(@"find_live_icon")];
                                   weakSelf.headerView.LiveImg.hidden = NO;
                                   [weakSelf animationWithButton];
                                   
                               }else if ([weakSelf.type isEqualToString:@"预告"]){
                                   [weakSelf.headerView.typeImg setImage:IMAGE(@"find_kan xianchang_icon")];
                                   weakSelf.headerView.LiveImg.hidden = YES;
                               }else{
                                   [weakSelf.headerView.typeImg setImage:IMAGE(@"find_kan huifang_icon")];
                                   weakSelf.headerView.LiveImg.hidden = YES;
                               }
                               if ([weakSelf.model.brand.isfavor isEqualToString:@"1"]) {
                                   weakSelf.headerView.fllowBtn.selected = YES;
                               }else{
                                   weakSelf.headerView.fllowBtn.selected = NO;
                               }
                               if ([weakSelf.listorder isEqualToString:@"0"]) {
                                   weakSelf.topView.recommendBtn.selected = NO;
                               }else{
                                   weakSelf.topView.recommendBtn.selected = YES;
                               }
                               if (isRefresh && weakSelf.model.list.count != 0) {
                                   [weakSelf.dataArr removeAllObjects];
                               }
                               
                               [weakSelf.dataArr addObjectsFromArray:weakSelf.model.list];
                               if (weakSelf.dataArr.count != 0 && weakSelf.isHave == NO) {
                                   [weakSelf upRefresh];
                                   weakSelf.isHave = YES;
                               }
                               [weakSelf.tableView.mj_header endRefreshing];
                               [weakSelf.tableView reloadData];

                               if (weakSelf.model.list.count < 10) {
                                   [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                                   weakSelf.tableView.mj_footer = nil;
                                   weakSelf.isHave = NO;
                               }else{
                                   [weakSelf.tableView.mj_footer endRefreshing];
                               }
                               
                           }
                           
                       }
                          fail:^(NSError *error) {
                              
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
#pragma mark - 刷新加载
- (void)addMjRefresh
{
    [self.tableView.mj_header endRefreshing];
    WS(weakSelf);
    self.tableView.mj_header = [YPCRefreshHeader headerWithRefreshingBlock:^{
       
        weakSelf.page = @"1";
        [weakSelf getData:weakSelf.page isRefresh:YES];
    }];
//    [self.tableView.mj_header beginRefreshing];

}
- (void)upRefresh{
    
    WS(weakself);
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakself.page = [NSString stringWithFormat:@"%zd",weakself.page.integerValue + 1];
        [weakself getData:weakself.page isRefresh:NO];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_topView == nil) {
        self.topView = [[TopView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 42)];
        self.topView.bgView.layer.borderColor = [Color colorWithHex:@"0xefefef"].CGColor;
        self.topView.bgView.layer.borderWidth = 1;
        self.topView.recommendBtn.selected = NO;
        WS(weakself);
        self.topView.didBtnClick = ^(UIButton *clickBtn,NSInteger tag){
            if (weakself.dataArr.count == 0) {
                return;
            }
            switch (tag) {
                case 1000:
                {
                    
                    clickBtn.selected = NO;
                    [weakself chooseHiden];
                    weakself.class_id =@"";
                    if (![weakself.listorder isEqualToString:@"0"]) {
                        weakself.listorder = @"0";
                        weakself.page = @"1";
                        [weakself getData:weakself.page isRefresh:YES];
                    }else{
                        weakself.listorder = @"0";
                    }
                    [weakself.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_unclicked") forState:UIControlStateNormal];
                    [weakself.topView.brandBtn setTitleColor:[Color colorWithHex:@"666666"] forState:UIControlStateNormal];
                }
                    break;
                case 1001:
                {
                    if (clickBtn.selected == NO) {
                        clickBtn.selected = YES;
                        if (weakself.dataArr.count > 1) {
                             weakself.bgView.backgroundColor = [UIColor blackColor];
                            if ([weakself.topStr isEqualToString:@"1"]) {
                                weakself.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                            }
                            weakself.isTop = YES;
                            [weakself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                            
                        }else{
                            if ([weakself.topStr isEqualToString:@"1"]) {
                                weakself.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                            }
                            weakself.bgView.backgroundColor = [UIColor clearColor];
                        }
                        clickBtn.selected = YES;
                        weakself.topView.brandBtn.selected = NO;
                        weakself.topView.priceBtn.selected = NO;
                        weakself.topView.recommendBtn.selected = YES;
                        [weakself chooseHiden];
                        [weakself segBrandViewHidenNo:weakself.sectionArr];
                        [weakself.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_unclicked") forState:UIControlStateNormal];
                        [weakself.topView.brandBtn setTitleColor:[Color colorWithHex:@"666666"] forState:UIControlStateNormal];
                    }else{
                        clickBtn.selected = NO;
                        [weakself chooseHiden];
                        weakself.topView.recommendBtn.selected = NO;
                        weakself.class_id =@"";
                    }
                }
                    break;
                case 1002:
                {
                    weakself.isTop = NO;
                    weakself.topView.priceBtn.selected = NO;
                    weakself.topView.otherBtn.selected = NO;
                    
                    if ([weakself.listorder isEqualToString:@"0"] || [weakself.listorder isEqualToString:@"3"]) {
                        weakself.listorder = @"1";
                        [weakself.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_clicked_ascending") forState:UIControlStateNormal];
                        [weakself.topView.brandBtn setTitleColor:[Color colorWithHex:@"#EC0024"] forState:UIControlStateNormal];
                        weakself.topView.recommendBtn.selected = YES;
                    }else if ([weakself.listorder isEqualToString:@"1"]){
                        weakself.listorder = @"2";
                        [weakself.topView.brandBtn setTitleColor:[Color colorWithHex:@"#EC0024"] forState:UIControlStateNormal];
                        [weakself.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_clicked_descending") forState:UIControlStateNormal];
                        weakself.topView.recommendBtn.selected = YES;
                    }else if ([weakself.listorder isEqualToString:@"2"]){
                        weakself.listorder = @"0";
                        [weakself.topView.brandBtn setTitleColor:[Color colorWithHex:@"#666666"] forState:UIControlStateNormal];
                        [weakself.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_unclicked") forState:UIControlStateNormal];
                        weakself.topView.recommendBtn.selected = NO;
                    }
                    weakself.page = @"1";
                    [weakself getData:weakself.page isRefresh:weakself];
                }
                    break;
                case 1003:
                {
                    weakself.isTop = NO;
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
                    [weakself.topView.brandBtn setTitleColor:[Color colorWithHex:@"666666"] forState:UIControlStateNormal];
                }
                    break;
                    
                default:
                    break;
            }
        };
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
    cell.shareBtn.tag = indexPath.row;
    [cell.shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LiveActivityModel *model = self.dataArr[indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[BranCell class]  contentViewWidth:[self cellContentViewWith]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WS(weakself);
    LiveActivityModel *model = self.dataArr[indexPath.row];
    DiscoverDetailVC *dic = [[DiscoverDetailVC alloc]init];
    dic.strace_id = model.strace_id;
    dic.backBlock = ^(NSString *likeCount,NSString *isLike,NSString *commentCount){
        model.strace_cool = likeCount;
        model.strace_comment = commentCount;
        [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    dic.typeStr = @"淘好货";
    [self.navigationController pushViewController:dic animated:YES];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y;
    self.offset = offset;
    if (self.dataArr.count > 0) {
        if (scrollView.contentOffset.y <= (self.KheaderViewHeight - 64) && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
        }else if(scrollView.contentOffset.y >= self.KheaderViewHeight - 64) {
           
          scrollView.contentInset  = UIEdgeInsetsMake(64, 0, 0, 0);
            
            
        }
        
    }
    if (offset > 175) {
        CGFloat alpha = MIN(1, 1 - ((175 - 64.f - offset) / 64));
        [[YPC_Tools getControllerWithView:self.view].navigationController.navigationBar mz_setBackgroundAlpha:alpha];
        self.navigationItem.title = self.titleStr;
    }else{
        [[YPC_Tools getControllerWithView:self.view].navigationController.navigationBar mz_setBackgroundAlpha:0];
         self.navigationItem.title = @"";
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < 0) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return YES;
}

- (void)followstore_add{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/brand/followbrand/add"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{@"brand_id":weakSelf.model.brand.brand_id
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                           }
                       }
                          fail:^(NSError *error) {
                              
                          }];
}
- (void)followstore_cancel{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/brand/followbrand/cancel"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{@"brand_id":weakSelf.model.brand.brand_id
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                           }
                           
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}

#pragma mark - 懒加载

- (BrandDetailHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [[BrandDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 103 + ScreenWidth * 150 / 375)];
        [_headerView.fllowBtn addTarget:self action:@selector(fllowBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.brandBtn addTarget:self action:@selector(brandClick) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [Color colorWithHex:@"0xe3e3e3"];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (ClassSegView *)classSegView{
    WS(weakSelf);
    if (_classSegView == nil) {
        _classSegView = [[ClassSegView alloc]init];
        [self.view addSubview:_classSegView];
        _classSegView.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .heightIs(0);
        _classSegView.hidden = YES;
        if (self.offset < self.KheaderViewHeight && self.offset > 0) {
            _classSegView.sd_layout.topSpaceToView(self.view,self.KheaderViewHeight + 42 - self.offset);
            self.isTop = NO;
            self.topStr = @"2";
        }else if (self.offset >= self.KheaderViewHeight){
            _classSegView.sd_layout.topSpaceToView(self.view,64 + 42);
            self.isTop = NO;
            self.topStr = @"2";
        }else{
            _classSegView.sd_layout.topSpaceToView(self.view,self.KheaderViewHeight + 42);
            self.isTop = YES;
            self.topStr = @"1";
        }
        _classSegView.classBackId = ^(NSString *class_id){
            weakSelf.class_id = class_id;
            weakSelf.page = @"1";
            if (weakSelf.isTop) {
                weakSelf.tableView.contentInset  = UIEdgeInsetsMake(0, 0, 0, 0);
                
                weakSelf.isTop = NO;
            }
            
            [weakSelf getData:weakSelf.page isRefresh:YES];
            [weakSelf segBrandViewHiden];
        };
    }
    return _classSegView;
}
- (UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.3;
        [self.view addSubview:_bgView];
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelClick:)];
        _bgView.sd_layout
        .topSpaceToView(self.view,64 + 42)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomEqualToView(self.view);
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
    self.classSegView = nil;
    self.btnType = @"0";
}
// 展示 筛选品牌
- (void)segBrandViewHidenNo:(NSArray *)arr{
    
    [self.bgView addGestureRecognizer:_tap];
    self.classSegView.dataDic = self.brandDic;
//    CGFloat height = 0;
//    if (arr.count * 80 > 282) {
//        height = 282;
//    }else{
//        height = arr.count * 80;
//    }
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bgView.hidden = NO;
        self.classSegView.hidden = NO;
        self.classSegView.sd_layout.heightIs(355);
        self.classSegView.tableView.sd_layout.heightIs(355);
        
    }];
    
    self.btnType = @"2";
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

- (void)fllowBtnClick:(UIButton *)sender{
    WS(weakself);
    [YPCRequestCenter isLoginAndPresentLoginVC:weakself success:^{        
        if ([weakself.model.brand.isfavor isEqualToString:@"1"]) {
            [weakself followstore_cancel];
            weakself.model.brand.isfavor = @"0";
            weakself.headerView.fllowBtn.selected = NO;
            weakself.headerView.fllowBtn.backgroundColor = [UIColor redColor];
        }else{
            [weakself followstore_add];
            weakself.model.brand.isfavor = @"1";
            weakself.headerView.fllowBtn.selected = YES;
            weakself.headerView.fllowBtn.backgroundColor = [UIColor clearColor];
        }
    }];
}

- (void)titleBtnClick:(UIButton *)sender{
    [self videoPlayActionWithURL:self.model.brand.live_video_url];
}

#pragma mark - 播放视频Method
- (void)videoPlayActionWithURL:(NSString *)urlStr
{
    if (![urlStr isEmpty]) {
        // 设置视频播放器
        self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:urlStr]];
        self.moviePlayer.allowsAirPlay = YES;
        [self.moviePlayer setControlStyle:MPMovieControlStyleNone];
        [self.moviePlayer.view setFrame:self.view.bounds];
        self.moviePlayer.repeatMode = MPMovieRepeatModeOne;
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows) {
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            if(windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                [window addSubview:self.moviePlayer.view];
                break;
            }
        }
        [self.moviePlayer play];
        self.movieCoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.movieCoverBtn.frame = self.view.bounds;
        self.movieCoverBtn.backgroundColor = [UIColor clearColor];
        [self.moviePlayer.view addSubview:self.movieCoverBtn];
        [self.movieCoverBtn addTarget:self action:@selector(dismissMoviePlayer) forControlEvents:UIControlEventTouchUpInside];
        
        [NotificationCenter addObserver:self selector:@selector(moviePlayerLoadStateDidChange) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
        
        self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.loadingView.center = self.movieCoverBtn.center;
        [self.movieCoverBtn addSubview:self.loadingView];
        [self.loadingView startAnimating];
        
        [YPC_Tools setStatusBarIsHidden:YES];
    }else {
        [YPC_Tools showSvpWithNoneImgHud:@"暂无视频,请稍等直播员上传~"];
    }
}

/**
 *  视频播放状态改变
 */
- (void)moviePlayerLoadStateDidChange
{
    switch (self.moviePlayer.loadState)
    {
        case MPMovieLoadStatePlayable:
        {
            /** 可播放 */;
            [self.loadingView stopAnimating];
        }
            break;
        case MPMovieLoadStatePlaythroughOK:
        {
            /** 状态为缓冲几乎完成，可以连续播放 */;
            [self.loadingView stopAnimating];
        }
            break;
        case MPMovieLoadStateStalled:
        {
            /** 缓冲中 */
            [self.loadingView startAnimating];
        }
            break;
        case MPMovieLoadStateUnknown:
        {
            /** 未知状态 */
            [self.loadingView startAnimating];
        }
            break;
    }
}

- (void)dismissMoviePlayer
{
    if (self.moviePlayer) {
        [YPC_Tools setStatusBarIsHidden:NO];
        [self.moviePlayer stop];
        [self.moviePlayer.view removeFromSuperview];
        [self.movieCoverBtn removeFromSuperview];
        self.moviePlayer = nil;
        self.movieCoverBtn = nil;
        
        [NotificationCenter removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    }
}

- (void)brandClick{
    WebViewController *web = [[WebViewController alloc]init];
    web.homeUrl =[NSString stringWithFormat: @"http://api.gongchangtemai.com/index.php?url=shop/showstore/brandinfo/%@",self.model.brand.brandstore_id];
    web.navTitle = @"品牌简介";
    [self.navigationController pushViewController:web animated:YES];

}
/*!
 *
 *    直播中动效
 *
 */
- (void)animationWithButton
{
    [self.headerView.LiveImg setImage:IMAGE(@"homepage_icon_live1_children")];
    NSArray *images = [[NSArray alloc] init];
    images = [NSArray arrayWithObjects:
              IMAGE(@"homepage_icon_live1"),
              IMAGE(@"homepage_icon_live2"),
              IMAGE(@"homepage_icon_live3"),
              nil];
    self.headerView.LiveImg.animationImages = images;
    self.headerView.LiveImg.animationDuration = .5f;
    self.headerView.LiveImg.animationRepeatCount = 0;
    [self.headerView.LiveImg startAnimating];
}

- (void)shareBtnClick:(UIButton *)sender{
    LiveActivityModel *model = self.dataArr[sender.tag];
    NSString *uid = [YPCRequestCenter shareInstance].model.user_id.length > 0 ? [YPCRequestCenter shareInstance].model.user_id : @"0";
    [YPCShare GoodsShareInWindowWithStraceName:model.strace_title StraceId:model.strace_id image:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:model.strace_content[0]] discount:model.goods_discount price:model.goods_price uid:uid viewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
