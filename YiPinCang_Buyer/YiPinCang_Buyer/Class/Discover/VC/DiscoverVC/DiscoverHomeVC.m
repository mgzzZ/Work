//
//  DiscoverHomeVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/8.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "DiscoverHomeVC.h"
#import "TopView.h"
#import "DiscoverCell.h"
#import "DiscoverLivegoodsModel.h"

#import "FilterView.h"
#import "FiterBrandView.h"
#import "DiscoverBrandLiskModel.h"
#import "DiscoverDetailVC.h"
@interface DiscoverHomeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)TopView *topView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)FilterView *filterView;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UITapGestureRecognizer *tap;
@property (nonatomic,copy)NSString *listorder;
@property (nonatomic,strong)FiterBrandView *fiterBrandView;
@property (nonatomic,copy)NSString *btnType;//记录点击筛选按钮0 是没有点击 1是点击筛选价格 2点击筛选品牌
@property (nonatomic,copy)NSMutableArray *brandListArr;
@property (nonatomic,copy)NSString *sectionStr;
@property (nonatomic,strong)NSMutableArray *sectionArr;
@property (nonatomic,strong)NSMutableDictionary *brandDic;
@property (nonatomic,strong)NSMutableArray *valueArr;//装model
@property (nonatomic,strong)NSMutableArray *bigValueArr;//装bigTValueArr
@property (nonatomic,strong)NSMutableArray *bigTValueArr;//装valueArr 和选中后的心分类
@property (nonatomic,copy)NSString *brand;
@property (nonatomic,copy)NSString *bind;
@property (nonatomic,copy)NSString *page;
@end

@implementation DiscoverHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnType = @"0";
    self.brand = @"";
    self.bind = @"";
    self.sectionStr = @"";
    self.page = @"1";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [Color colorWithHex:@"#EFEFEF"];
    self.navigationController.navigationBar.translucent = YES;
    self.dataArr = [[NSMutableArray alloc]init];
    self.brandListArr = [[NSMutableArray alloc]init];
    self.sectionArr = [[NSMutableArray alloc]init];
    self.listorder = @"0";
    [self setTopView];
    [self getData:self.listorder brand_id:self.brand bind:self.bind page:self.page isRefresh:NO];
    [self upRefresh];
    [self getDataOfBrand];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self chooseHiden];
}


- (void)setTopView{
    WS(weakSelf);
    self.topView = [[TopView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 47)];
    [self.view addSubview:self.topView];
  
  
    [self.topView.priceBtn addTarget:self action:@selector(priceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView.brandBtn addTarget:self action:@selector(brandBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView.otherBtn addTarget:self action:@selector(otherBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [Color colorWithHex:@"#EFEFEF"];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.sd_layout
    .topSpaceToView(self.view,47)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view,50)
    .leftEqualToView(self.view);
    [self.tableView registerClass:[DiscoverCell class] forCellReuseIdentifier:@"cell"];
    
    self.bgView = [[UIView alloc]init];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.3;
    [self.view addSubview:self.bgView];

    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelClick:)];
    self.bgView.sd_layout
    .topSpaceToView(self.topView,0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
    self.bgView.hidden = YES;
    self.filterView = [[FilterView alloc]init];
    [self.view addSubview:self.filterView];
    self.filterView.sd_layout
    .topSpaceToView(self.topView,0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(0);
    self.filterView.hidden = NO;
    self.filterView.didseleteCell = ^(NSIndexPath *indexPath){
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.filterView.tableView.sd_layout.heightIs(0);
            weakSelf.filterView.sd_layout.heightIs(0);
            weakSelf.bgView.hidden = YES;
        }];
        weakSelf.listorder = [NSString stringWithFormat:@"%zd",indexPath.row + 1 ];
        [weakSelf downRefresh];
    };
    
    self.fiterBrandView = [[FiterBrandView alloc]init];
    [self.view addSubview:self.fiterBrandView];
    self.fiterBrandView.sd_layout.topSpaceToView(self.topView,0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(0);
    self.fiterBrandView.hidden = YES;
    self.fiterBrandView.backId = ^(NSString *brand,NSString *bind){
        [weakSelf chooseHiden];
        if (bind.length != 0) {
            weakSelf.bind = bind;
        }else{
            weakSelf.bind = @"";
        }
        weakSelf.topView.priceBtn.selected = NO;
        weakSelf.brand = brand;
        [weakSelf downRefresh];
    };
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscoverLivegoodsModel *model = self.dataArr[indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[DiscoverCell class]  contentViewWidth:[self cellContentViewWith]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WS(weakself);
    static NSString *cellId = @"cell";
    DiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (self.dataArr.count != 0) {
        cell.model = self.dataArr[indexPath.row];
    }
    cell.txBtnClickBlock = ^(NSString *str){
        if (weakself.didtx) {
            weakself.didtx(str);
        }
    };
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscoverLivegoodsModel *model = self.dataArr[indexPath.row];
    if (self.didcell) {
        self.didcell(model.strace_id,model.live_id);
    }
    
    
}
#pragma mark- getdata
- (void)getData:(NSString *)listorder brand_id:(NSString *)brand_id bind:(NSString *)bind_id page:(NSString *)page isRefresh:(BOOL)isRefresh{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:self.url
                  refreshCache:YES
                        params:@{@"pagination":@{
                                         @"page":page,
                                         @"count":@"10"
                                         },
                                 @"listorder":listorder,
                                 @"brand":brand_id,
                                 @"bind":bind_id
                                 }
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               NSMutableArray *arr = [DiscoverLivegoodsModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                               [weakSelf.dataArr addObjectsFromArray:arr];
                               if (arr.count < 10) {
                                   [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                               }else{
                                   [weakSelf.tableView.mj_footer endRefreshing];
                               }
                               [weakSelf.tableView.mj_header endRefreshing];
                               
                               if (isRefresh == YES) {
                                   
                                   [weakSelf.tableView reloadData];
                               }else{
                                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                       [weakSelf.tableView reloadData];
                                   });
                               }
                           }
                           
                           
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
    
    
}
//刷新 加载
- (void)downRefresh{
    self.page = @"1";
    [self.dataArr removeAllObjects];
    WS(weakSelf);
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
       [weakSelf getData:weakSelf.listorder brand_id:weakSelf.brand bind:weakSelf.bind page:weakSelf.page isRefresh:YES];
    }];
}
- (void)upRefresh{
    self.page = [NSString stringWithFormat:@"%zd",self.page.integerValue + 1];
    WS(weakself);
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakself getData:weakself.listorder brand_id:weakself.brand bind:weakself.bind page:weakself.page isRefresh:YES];
    }];
}

- (void)getDataOfBrand{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/explore/brandlist"
                  refreshCache:YES
                        params:@{
                                 }
                       success:^(id response) {
                           
                           weakSelf.brandListArr = [DiscoverBrandLiskModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                           
                           [weakSelf segBrandData:weakSelf.brandListArr];
                           
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
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
- (void)priceBtnClick:(UIButton *)sender{
    sender.selected = YES;
    self.topView.brandBtn.selected = NO;
    self.topView.otherBtn.selected = NO;
    [self chooseHiden];
    [self segBrandViewHidenNo:self.sectionArr];
}

- (void)brandBtnClick:(UIButton *)sender{
    sender.selected = YES;
    self.topView.priceBtn.selected = NO;
    self.topView.otherBtn.selected = NO;
    [self chooseHiden];
    NSArray *arr = @[@"从低到高",@"从高到低"];
    [self segViewHidenNo:arr];
}

- (void)otherBtnClick:(UIButton *)sender{
    if (sender.selected == NO) {
        self.listorder = @"3";
        sender.selected = YES;
    }else{
        self.listorder = @"0";
        sender.selected = NO;
    }
    [self chooseHiden];
    
    [self downRefresh];
}

- (void)cancelClick:(UIGestureRecognizer *)sender{
    self.topView.otherBtn.selected = NO;
    self.topView.priceBtn.selected = NO;
    self.topView.brandBtn.selected = NO;
    [self chooseHiden];
}

#pragma mark-  筛选栏逻辑
//判断筛选栏是否在下拉状态

// 隐藏筛选价格
- (void)segViewhiden{
    if (self.bgView.hidden == YES) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.hidden = YES;
        self.filterView.tableView.sd_layout.heightIs(0);
        self.filterView.sd_layout.heightIs(0);
    }];
    [self.bgView removeGestureRecognizer:_tap];
    self.btnType = @"0";
}
// 展示筛选价格
- (void)segViewHidenNo:(NSArray *)arr{
    self.btnType = @"1";
    [self.bgView addGestureRecognizer:_tap];
    self.filterView.dataArr = [arr mutableCopy];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.hidden = NO;
        if (arr.count > 6) {
            self.filterView.sd_layout.heightIs(6 * 47);
            self.filterView.tableView.sd_layout.heightIs(6 * 47);
        }else{
            self.filterView.sd_layout.heightIs(arr.count * 47);
            self.filterView.tableView.sd_layout.heightIs(arr.count * 47);
        }
    }];
}
// 根据btnType 选择收回View
- (void)chooseHiden{
    if ([self.btnType isEqualToString:@"0"]) {
        return;
    }
    if ( [self.btnType isEqualToString:@"1"]) {
        [self segViewhiden];
    }else if( [self.btnType isEqualToString:@"2"]){
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
    }];
    [self.bgView removeGestureRecognizer:_tap];
     self.btnType = @"0";
}
// 展示 筛选品牌
- (void)segBrandViewHidenNo:(NSArray *)arr{
    
    [self.bgView addGestureRecognizer:_tap];
    self.fiterBrandView.dataDic = self.brandDic;
    CGFloat height = 0;
    if (arr.count * 80 > 282) {
        height = 282;
    }else{
        height = arr.count * 80;
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

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
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
