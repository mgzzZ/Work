//
//  BrandnewView.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/8.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "BrandnewView.h"
#import "LiveDetailListCell.h"
#import "LiveDetailSectionModel.h"
#import "GuessLikeView.h"
#import "BannerModel.h"
#import "BrandBannerModel.h"
#import <SDCycleScrollView.h>
@interface BrandnewView ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *guessLikeArr;//推荐商品
@property (strong, nonatomic) SDCycleScrollView *bannerView;
@property (nonatomic,strong)BrandBannerModel *bannerModel;
@property (nonatomic,strong)NSMutableArray *bannerDataArr;
@property (nonatomic,strong)NSString *page;
@property (nonatomic,strong)GuessLikeView *guessLikeView;
@end


@implementation BrandnewView

- (instancetype)initWithFrame:(CGRect)frame{
   self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.page = @"1";
    self.dataArr = [NSMutableArray array];
    self.guessLikeArr = [NSMutableArray array];
    self.bannerDataArr = [NSMutableArray array];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self addSubview:self.tableView];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight / 40 * 13) delegate:self placeholderImage:IMAGE(@"homepage_banner_zhanweitu")];
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    //    self.bannerView.titlesGroup = titles;
    self.bannerView.autoScrollTimeInterval = 4.f;
    self.bannerView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [self.tableView setTableHeaderView:self.bannerView];
    [self getData];
    [self addMjRefresh];
    [self getDataGuessUlike];
    [self getBrandbanner];
}
- (void)reload{
    [self addMjRefresh];
    [self getDataGuessUlike];
    [self getBrandbanner];
}

//发现品牌首页
- (void)getData{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/showstore/brandnew"
                  refreshCache:YES
                        params:@{@"pagination":@{
                                         @"page":@"1",
                                         @"count" : @"1000"
                                         }
                                 }
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.dataArr = [LiveDetailSectionModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                               [weakSelf json];
                               [weakSelf.tableView reloadData];
                               [weakSelf.tableView.mj_header endRefreshing];
                           }
                           
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}
#pragma mark - 刷新加载
- (void)addMjRefresh
{
    WS(weakSelf);
    self.tableView.mj_header = [YPCRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
}

- (void)getDataGuessUlike{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/goods/guesslist"
                  refreshCache:YES
                        params:@{
                                 @"pagination":@{
                                         @"count":@"10",
                                         @"page":weakSelf.page
                                         }
                                 }
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               
                               NSMutableArray *arr = [GuessModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                               if (arr.count < 10) {
                                   [weakSelf.guessLikeView.collectView.mj_footer endRefreshingWithNoMoreData];
                               }else{
                                   [weakSelf.guessLikeView.collectView.mj_footer endRefreshing];
                               }
                               [weakSelf.guessLikeArr addObjectsFromArray:arr];
                               if (_guessLikeView == nil) {
                                   weakSelf.guessLikeView = [[GuessLikeView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ((ScreenWidth - 46) / 2 * 182 / 137 +60 + 20) * weakSelf.guessLikeArr.count / 2 + 70)];
                                   weakSelf.guessLikeView.dataArr = weakSelf.guessLikeArr;
                                   weakSelf.guessLikeView.didSelect = ^(NSIndexPath *index){
                                       GuessModel *model = weakSelf.guessLikeArr[index.row];
                                       if (weakSelf.didlike) {
                                           weakSelf.didlike(index,model);
                                       }
                                       
                                   };
                                   weakSelf.guessLikeView.collectView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                                       weakSelf.page = [NSString stringWithFormat:@"%zd",weakSelf.page.integerValue + 1];
                                       [weakSelf getDataGuessUlike];
                                   }];
//                                   weakSelf.guessLikeView.refresh = ^{
//                                       weakSelf.page = [NSString stringWithFormat:@"%zd",weakSelf.page.integerValue + 1];
//                                       [weakSelf getDataGuessUlike];
//                                   };
                                   weakSelf.tableView.tableFooterView = weakSelf.guessLikeView;

                               }
                               weakSelf.guessLikeView.frame = CGRectMake(0, 0, ScreenWidth, ((ScreenWidth - 46) / 2 * 182 / 137 +60 + 20) * weakSelf.guessLikeArr.count / 2 + 140);
                               weakSelf.tableView.tableFooterView = weakSelf.guessLikeView;
                               weakSelf.guessLikeView.dataArr = weakSelf.guessLikeArr;
                              
                               
                           }
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}

- (void)getBrandbanner{
  
    WS(weakSelf);
    [YPCNetworking getWithUrl:@"shop/home/data"
                 refreshCache:YES
                       params:@{@"type":@"5"}
                      success:^(id response) {
                          if ([YPC_Tools judgeRequestAvailable:response]) {
                              weakSelf.bannerDataArr = [BannerModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"banners"]];
                              NSMutableArray *bannerImgArr = [NSMutableArray array];
                              for (BannerModel *model in weakSelf.bannerDataArr) {
                                  [bannerImgArr addObject:model.pic];
                              }
                              weakSelf.bannerView.imageURLStringsGroup = bannerImgArr;
                          }
                      } fail:^(NSError *error) {
                          YPCAppLog(@"%@", [error description]);
                      }];
 
}
- (void)json{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[self.dataArr mutableCopy]];
    for (int i = 0; i < self.dataArr.count; i++) {
        LiveDetailSectionModel *model = self.dataArr[i];
        if (model.data.count == 0) {
            [arr removeObject:model];
        }
    }
    self.dataArr = [NSMutableArray arrayWithArray:[arr mutableCopy]];;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    LiveDetailSectionModel *model = self.dataArr[section];
    return model.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 42;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 81;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 42)];
    view.layer.borderWidth = 1;
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderColor = [Color colorWithHex:@"0xefefef"].CGColor;
    LiveDetailSectionModel *model = self.dataArr[section];
    UILabel *nameLab = [[UILabel alloc]init];
    [view addSubview:nameLab];
    
    nameLab.font = [UIFont systemFontOfSize:16];
    nameLab.textAlignment = NSTextAlignmentCenter;
    UIView *leftView = [[UIView alloc]init];
    leftView.backgroundColor = [Color colorWithHex:@"0x2c2c2c"];
    [view addSubview:leftView];
    UIView *rightView = [[UIView alloc]init];
    rightView.backgroundColor = [Color colorWithHex:@"0x2c2c2c"];
    [view addSubview:rightView];
    if ([model.type isEqualToString:@"start_activity"]) {
        //直播中
        
        nameLab.text = @"直播中";
        [nameLab sizeToFit];
        nameLab.sd_layout
        .centerXEqualToView(view)
        .centerYEqualToView(view)
        .widthIs(nameLab.size.width)
        .heightIs(42);
    }else if ([model.type isEqualToString:@"will_activity"]){
        //预告
        nameLab.text = @"直播预告";
        [nameLab sizeToFit];
        nameLab.sd_layout
        .centerXEqualToView(view)
        .centerYEqualToView(view)
        .widthIs(nameLab.size.width)
        .heightIs(42);
    }else if ([model.type isEqualToString:@"end_activity"]){
        //回放
        nameLab.text = @"往期直播";
        [nameLab sizeToFit];
        
        nameLab.sd_layout
        .centerXEqualToView(view)
        .centerYEqualToView(view)
        .widthIs(nameLab.size.width)
        .heightIs(42);
        
    }else{
        
    }
    leftView.sd_layout
    .rightSpaceToView(nameLab,5)
    .widthIs(18)
    .heightIs(2)
    .centerYEqualToView(view);
    rightView.sd_layout
    .leftSpaceToView(nameLab,5)
    .widthIs(18)
    .heightIs(2)
    .centerYEqualToView(view);
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"liveLisrt";
    LiveDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"LiveDetailListCell" owner:self options:nil][0];
    }
    LiveDetailSectionModel *model = self.dataArr[indexPath.section];
    LiveDetailListDataModel *listModel = model.data[indexPath.row];
    cell.model = listModel;
    if ([model.type isEqualToString:@"start_activity"]) {
        //直播中
        [cell.typeImg setImage:IMAGE(@"livemembers_details_icon_live")];
        [cell.leftImg setImage:IMAGE(@"livememberdetails_list_numbers_icon")];
        [cell.rightImg setImage:IMAGE(@"livememberdetails_list_zan_icon")];
        cell.leftLab.text = [NSString stringWithFormat:@"%@人观看中",listModel.live_users];
        cell.rightLab.text = listModel.live_like;
        cell.titleLab.text = listModel.name;
        cell.rightImg.hidden = NO;
        cell.rightLab.hidden = NO;
    }else if ([model.type isEqualToString:@"will_activity"]){
        //预告
        [cell.typeImg setImage:IMAGE(@"livemembers_details_icon_trailer")];
        [cell.leftImg setImage:IMAGE(@"homepage_yure_hot_icon")];
        [cell.rightImg setImage:IMAGE(@"livememberdetails_list_follow_icon")];
        cell.leftLab.text = [NSString stringWithFormat:@"%@热度",listModel.live_users];
        cell.rightLab.text = [NSString stringWithFormat:@"%@人关注",listModel.live_like];
        cell.titleLab.text = [NSString stringWithFormat:@" %@",listModel.name];
        cell.rightImg.hidden = NO;
        cell.rightLab.hidden = NO;
    }else if ([model.type isEqualToString:@"end_activity"]){
        //回放
        [cell.typeImg setImage:IMAGE(@"livemembers_details_icon_playback")];
        [cell.leftImg setImage:IMAGE(@"livememberdetails_list_numbers_icon")];
        cell.rightImg.hidden = YES;

        cell.leftLab.text = [NSString stringWithFormat:@"%@人观看",listModel.live_users];
        cell.rightLab.hidden = YES;
        cell.titleLab.text = [NSString stringWithFormat:@" %@",listModel.name];
    }else{
        
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LiveDetailSectionModel *model = self.dataArr[indexPath.section];
    LiveDetailListDataModel *listModel = model.data[indexPath.row];
    TempHomePushModel *tempModel = [[TempHomePushModel alloc]init];
    NSString *typeStr = @"";
    if ([model.type isEqualToString:@"start_activity"]) {
        //直播中
        typeStr = @"直播中";
        tempModel.live_id = listModel.live_id;
        tempModel.announcement_id = listModel.announcement_id;
        tempModel.store_avatar = listModel.store_avatar;
        tempModel.store_name = listModel.store_name;
        tempModel.store_id = listModel.store_id;
    }else if ([model.type isEqualToString:@"will_activity"]){
        //预告
        typeStr = @"预告";
        tempModel.live_id = listModel.live_id;
        tempModel.name = listModel.name;
        tempModel.store_avatar = listModel.store_avatar;
        tempModel.store_name = listModel.store_name;
        tempModel.starttime = listModel.starttime;
        tempModel.endtime = listModel.endtime;
        tempModel.activity_pic = listModel.activity_pic;
        tempModel.live_msg = listModel.message;
        tempModel.address = listModel.address;
        tempModel.start = listModel.start;
        tempModel.end = listModel.end;
        tempModel.live_state = listModel.live_state;
    }else if ([model.type isEqualToString:@"end_activity"]){
        //回放
        tempModel.live_id = listModel.live_id;
        tempModel.store_id = listModel.store_id;
        tempModel.store_avatar = listModel.store_avatar;
        tempModel.store_name = listModel.store_name;
        tempModel.video = listModel.video;
        typeStr = @"回放";
    }else{
        typeStr = @"其他";
    }
    if (self.didcell) {
        self.didcell(indexPath,listModel,typeStr,tempModel,listModel.livingshowinitimg);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    if (self.dataArr.count > 0) {
        if (point.y <= 42.f) {
            scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        }else if (point.y >= 42.f) {
            scrollView.contentInset = UIEdgeInsetsMake(128, 0, 0, 0);
        }
    }
    if (self.didscroll) {
        self.didscroll(point.y);
    }
    
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return YES;
}

-(void)viewDidLayoutSubviews
{
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    BannerModel *model = self.bannerDataArr[index];
    BannerDetailModel *detailModel = model.param;
    switch ([YPC_Tools judgementUrlSechmeTypeWithUrlString:(NSString *)[self.bannerDataArr[index] url]]) {
        case urlSechmeWebView:
        {
            if (self.didbanner) {
                self.didbanner(model.url,urlSechmeWebView,model.adv_title);
            }
        }
            
            break;
        case urlSechmeGoodsDetail:
        {
            
            
            if ([detailModel.type isEqualToString:@"livegoods"]) {
                if (self.didbanner) {
                    self.didbanner(detailModel.data.strace_id,urlSechmeGoodsDetail,@"淘好货");
                }
            }else{
                if (self.didbanner) {
                    self.didbanner(detailModel.data.strace_id,urlSechmeGoodsDetail,@"品牌");
                }
            }
            
        }
            
            break;
        case urlSechmeActivityDeatail:
            [YPC_Tools customAlertViewWithTitle:@"Tip"
                                        Message:@"活动详情"
                                      BtnTitles:nil
                                 CancelBtnTitle:nil
                            DestructiveBtnTitle:@"确定"
                                  actionHandler:nil
                                  cancelHandler:nil
                             destructiveHandler:nil];
            break;
        case urlSechmeLivingGroupDetail:
        {
            if (self.didbanner) {
                self.didbanner(detailModel.data.store_id,urlSechmeLivingGroupDetail,@"");
            }
        }
            break;
        case urlSechmeBrandDetail:
        {
            if (self.didbanner) {
                self.didbanner(detailModel.data.live_id,urlSechmeLivingGroupDetail,@"");
            }
        }
            break;
            
        default:
            break;
    }

}

@end
