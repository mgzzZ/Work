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
#import "LivingVC.h"
#import "PreheatingVC.h"
#import "VideoPlayerVC.h"
#import "TopView.h"
#import "ClassSegView.h"
#import "FiterBrandView.h"
#import "BranCell.h"
#import "DiscoverBrandLiskModel.h"
@interface DiscoverDetailV2VC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic,strong)BrandDetailHeaderView *headerView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)BrandDetailModel *model;
@property (nonatomic, strong) dispatch_source_t timer;
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

@end

@implementation DiscoverDetailV2VC
- (void)dealloc
{
    [self stopTimer];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar mz_setBackgroundImage:IMAGE(@"homepage_bar")];
    [self.navigationController.navigationBar mz_setBackgroundColor:[Color colorWithHex:@"#3B3B3B"]];
    [self.navigationController.navigationBar mz_setBackgroundAlpha:0.f];
    self.view.backgroundColor = [Color colorWithHex:@"0xefefef"];
    self.navigationItem.title = @"品牌商品";
    self.btnType = @"0";
    self.class_id = @"";
    self.sectionStr = @"";
    self.page = @"1";
    self.listorder = @"0";
    [self getData:@"1" isRefresh:YES];
    [self getDataOfBrand];
}
- (void)getData:(NSString *)page isRefresh:(BOOL)isRefresh{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/showstore/brandgoodsv2"
                  refreshCache:YES
                        params:@{@"live_id":weakSelf.live_id,
                                 @"listorder":weakSelf.listorder,
                                 @"class_id":weakSelf.class_id,
                                 @"pagination":@{
                                         @"page":page,
                                         @"count":@"10"
                                         }
                                 }
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.model = [BrandDetailModel mj_objectWithKeyValues:response[@"data"]];
                               [weakSelf.headerView.bgimg sd_setImageWithURL:[NSURL URLWithString:weakSelf.model.brand.bgurl] placeholderImage:IMAGE(@"find_logo_placeholder")];
                               [weakSelf.headerView.brandBtn setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:weakSelf.model.brand.store_avatar]]] forState:UIControlStateNormal];
                               weakSelf.headerView.brandNameLab.text = weakSelf.model.brand.brand_name;
                               weakSelf.headerView.BrandTitleLab.text = weakSelf.message;
                               
                               if ([weakSelf.type isEqualToString:@"直播中"]) {
                                   weakSelf.headerView.liveView.hidden = NO;
                                   
                                   [weakSelf animationsStart];
                                   
                                   
                               }else{
                                   weakSelf.headerView.liveView.hidden = YES;
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
                                   [weakSelf addMjRefresh];
                                   weakSelf.isHave = YES;
                               }
                               [weakSelf.tableView reloadData];
                               if (weakSelf.model.list.count < 10) {
                                   [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                               }else{
                                   [weakSelf.tableView.mj_footer endRefreshing];
                               }
                               [weakSelf.tableView.mj_header endRefreshing];

                               
                               
                               
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
    WS(weakSelf);
    self.tableView.mj_header = [YPCRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.page = @"1";
        [weakSelf getData:weakSelf.page isRefresh:YES];
    }];
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
        [self.topView.priceBtn addTarget:self action:@selector(priceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView.brandBtn addTarget:self action:@selector(brandBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView.otherBtn addTarget:self action:@selector(otherBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView.recommendBtn addTarget:self action:@selector(recommendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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
    DiscoverDetailVC *dic = [[DiscoverDetailVC alloc]init];
    dic.strace_id = model.strace_id;
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
    CGPoint point = scrollView.contentOffset;
    if (self.dataArr.count > 0 ) {
        if (point.y <= 42.f) {
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }else if (point.y > 42.f){
            scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        }
    }else{
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if (offset > 215) {
        CGFloat alpha = MIN(1, 1 - ((215 - 64.f - offset) / 64));
        [[YPC_Tools getControllerWithView:self.view].navigationController.navigationBar mz_setBackgroundAlpha:alpha];
    }else{
        [[YPC_Tools getControllerWithView:self.view].navigationController.navigationBar mz_setBackgroundAlpha:0.f];
    }
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
        _headerView = [[BrandDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 325)];
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
        _tableView.backgroundColor = [Color colorWithHex:@"0xefefef"];
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
        if (self.offset < 260.00 && self.offset > 0) {
            _classSegView.sd_layout.topSpaceToView(self.view,325 + 42 - self.offset);
        }else if (self.offset > 260){
            _classSegView.sd_layout.topSpaceToView(self.view,64 + 42);
        }else{
            _classSegView.sd_layout.topSpaceToView(self.view,325 + 42);
        }
        _classSegView.classBackId = ^(NSString *class_id){
            weakSelf.class_id = class_id;
            weakSelf.page = @"1";
            [weakSelf getData:weakSelf.page isRefresh:YES];
            [weakSelf segBrandViewHiden];
        };
    }
    return _classSegView;
}
- (UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor clearColor];
        _bgView.alpha = 0.3;
        [self.view addSubview:_bgView];
        
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelClick:)];
        _bgView.sd_layout
        .topSpaceToView(self.view,60)
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

#pragma mark - 动画开始
- (void)animationsStart{
    WS(weakSelf);
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(1.5f * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        [weakSelf start];
    });
    dispatch_resume(self.timer);
}

- (void)start
{
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    animation.toValue = [NSNumber numberWithFloat:0.2];
    animation.fromValue = [NSNumber numberWithFloat:1];
    animation.duration= 1.5;
    [self.headerView.liveView pop_addAnimation:animation forKey:@"live"];
}

-(void)stopTimer{
    if(_timer){
        dispatch_source_cancel(_timer);
        _timer = nil;
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
    
    if ([self.listorder isEqualToString:@"0"] || [self.listorder isEqualToString:@"3"]) {
        self.listorder = @"1";
        [self.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_clicked_ascending") forState:UIControlStateNormal];
        self.topView.recommendBtn.selected = YES;
    }else if ([self.listorder isEqualToString:@"1"]){
        self.listorder = @"2";
        [self.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_clicked_descending") forState:UIControlStateNormal];
        self.topView.recommendBtn.selected = YES;
    }else if ([self.listorder isEqualToString:@"2"]){
        self.listorder = @"0";
        [self.topView.brandBtn setImage:IMAGE(@"find_button_pricesort_unclicked") forState:UIControlStateNormal];
        self.topView.recommendBtn.selected = NO;
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
    if ([YPCRequestCenter isLoginAndPresentLoginVC:weakself]) {
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
    }
}

- (void)titleBtnClick:(UIButton *)sender{
    if ([YPCRequestCenter isLoginAndPresentLoginVC:self]) {
        if ([self.type isEqualToString:@"直播中"]) {
            LivingVC *live= [[LivingVC alloc]init];
            live.tempModel = self.tempModel;
            
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.livingshowinitimg] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                if (finished && !error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        live.playerPHImg = image;
                        [self.navigationController pushViewController:live animated:YES];
                        [YPC_Tools dismissHud];
                    });
                }else{
                    [YPC_Tools showSvpHudError:@"图片未下载成功"];
                }
                
            }];
            
        }else if ([self.type isEqualToString:@"预告"]){
            PreheatingVC *preheat = [[PreheatingVC alloc]init];
            preheat.tempModel = self.tempModel;
            [self.navigationController pushViewController:preheat animated:YES];
            
        }else{
            VideoPlayerVC *video = [[VideoPlayerVC alloc]init];
            video.tempModel = self.tempModel;
            [self.navigationController pushViewController:video animated:YES];
        }
    }

}
- (void)brandClick{
    WebViewController *web = [[WebViewController alloc]init];
    web.homeUrl =[NSString stringWithFormat: @"http://api.gongchangtemai.com/index.php?url=shop/showstore/brandinfo/%@",self.model.brand.brandstore_id];
    web.navTitle = @"品牌简介";
    [self.navigationController pushViewController:web animated:YES];

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
