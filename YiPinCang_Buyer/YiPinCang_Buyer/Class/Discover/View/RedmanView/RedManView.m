//
//  RedManView.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/27.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "RedManView.h"
#import "RedManCell.h"
#import "RedManNodeImgCell.h"
#import "RedManVideoCell.h"
#import "RedManModel.h"
#import "RedListModel.h"
#import <SDCycleScrollView.h>
#import "BrandBannerModel.h"
#import "BannerModel.h"
#import "LiveDetailHHHVC.h"
@interface RedManView ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *manDataArr;
@property (nonatomic,strong)NSMutableArray *listArr;
@property (nonatomic,strong)BrandBannerModel *bannerModel;
@property (nonatomic,strong)NSMutableArray *bannerDataArr;
@property (nonatomic,strong)NSString *store_id;
@property (strong, nonatomic) SDCycleScrollView *bannerView;
@end

@implementation RedManView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.tableView];
        [self getDataOfStarlist];
        [self addMjRefresh];
        [self getBrandbanner];
    }
    return self;
}

- (void)getDataOfStarlist{
    WS(weakself);
    [YPCNetworking postWithUrl:@"shop/explore/starlist"
                  refreshCache:YES
                        params:@{
                                 }
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakself.manDataArr = [RedManModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                               NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
                               [weakself.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                               [weakself getDataOfStracelist:@"" isRefresh:NO];
                           }
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}

- (void)getDataOfStracelist:(NSString *)last_id isRefresh:(BOOL)isRefresh{
    WS(weakself);
    if ([YPCRequestCenter isLogin]) {
        [YPCNetworking postWithUrl:@"shop/explore/stracelist"
                      refreshCache:YES
                            params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                   @"pagination":@{
                                                                                           @"page":@"",
                                                                                           @"count":@"10"
                                                                                           },
                                                                                   @"last_id":last_id
                                                                                   }]
                           success:^(id response) {
                               if ([YPC_Tools judgeRequestAvailable:response]) {
                                   if (isRefresh) {
                                       [weakself.listArr removeAllObjects];
                                   }
                                   NSArray *arr = [RedListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                                   if (arr.count < 10) {
                                       [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                                       
                                   }else{
                                       if (weakself.tableView.mj_footer == nil) {
                                           [weakself upRefresh];
                                       }
                                       [weakself.tableView.mj_footer endRefreshing];
                                   }
                                   [weakself.listArr addObjectsFromArray:arr];
                                   [weakself.tableView reloadData];
                                   
                                   [weakself.tableView.mj_header endRefreshing];
                               }
                               
                           }
                              fail:^(NSError *error) {
                                  
                              }];
    }else{
        [YPCNetworking postWithUrl:@"shop/explore/stracelist"
                      refreshCache:YES
                            params:@{
                                     @"pagination":@{
                                             @"page":@"",
                                             @"count":@"10"
                                             },
                                     @"last_id":last_id
                                     }
                           success:^(id response) {
                               if ([YPC_Tools judgeRequestAvailable:response]) {
                                   if (isRefresh) {
                                       [weakself.listArr removeAllObjects];
                                   }
                                   NSArray *arr = [RedListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                                   if (arr.count < 10) {
                                       [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                                       
                                   }else{
                                       if (weakself.tableView.mj_footer == nil) {
                                           [weakself upRefresh];
                                       }
                                       [weakself.tableView.mj_footer endRefreshing];
                                   }
                                   [weakself.listArr addObjectsFromArray:arr];
                                   [weakself.tableView reloadData];
                                   
                                   [weakself.tableView.mj_header endRefreshing];
                               }
                               
                           }
                              fail:^(NSError *error) {
                                  
                              }];
    }
    
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
#pragma mark - 刷新加载
- (void)addMjRefresh
{
    WS(weakSelf);
    self.tableView.mj_header = [YPCRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf getDataOfStracelist:@"" isRefresh:YES];
    }];
}
- (void)upRefresh{
    WS(weakself);
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        RedListModel *model = [weakself.listArr lastObject];
        [weakself getDataOfStracelist:model.strace_id isRefresh:NO];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.listArr.count == 0) {
        return 1;
    }else if(self.listArr.count == 0 && self.manDataArr.count == 0){
        return 0;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            return self.manDataArr.count;
        }
            break;
        case 1:{
            return self.listArr.count;
        }
            break;
        default:
            break;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *nameArr = @[];
    if (self.listArr.count == 0 && self.manDataArr.count == 0) {
        return [UIView new];
    }else if (self.listArr.count == 0){
        nameArr = @[@"红人馆"];
    }else{
        nameArr = @[@"红人馆",@"动态"];
    }
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    view.backgroundColor = [Color colorWithHex:@"0xf2f2f2"];
  
    UILabel *nameLab = [[UILabel alloc]init];
    [view addSubview:nameLab];
    nameLab.text = nameArr[section];
    nameLab.textColor = [Color colorWithHex:@"0xF00E36"];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [nameLab sizeToFit];
    nameLab.sd_layout
    .centerXEqualToView(view)
    .centerYEqualToView(view)
    .widthIs(nameLab.frame.size.width)
    .heightIs(20);
    
    UIImageView *left = [[UIImageView alloc]initWithImage:IMAGE(@"find_left_icon")];
    [view addSubview:left];
    left.sd_layout
    .widthIs(15)
    .heightIs(17)
    .rightSpaceToView(nameLab,15)
    .centerYEqualToView(view);
    UIImageView *right = [[UIImageView alloc]initWithImage:IMAGE(@"find_left_icon")];
    [view addSubview:right];
    right.sd_layout
    .leftSpaceToView(nameLab,15)
    .centerYEqualToView(view)
    .widthIs(15)
    .heightIs(17);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.listArr.count == 0 && self.manDataArr.count == 0) {
        return 0;
    }else{
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        RedManModel *model = self.manDataArr[indexPath.row];
       return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[RedManCell class]  contentViewWidth:[self cellContentViewWith]];
    }else{
        RedListModel *model = self.listArr[indexPath.row];
        if ([model.content_type isEqualToString:@"1"]) {
            return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[RedManNodeImgCell class]  contentViewWidth:[self cellContentViewWith]];
        }else{
            return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[RedManVideoCell class]  contentViewWidth:[self cellContentViewWith]];
        }
       
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            static NSString *cellId = @"redMan";
            RedManCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[RedManCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            cell.model = self.manDataArr[indexPath.row];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
            
        }
            break;
        case 1:{
            RedListModel *model = self.listArr[indexPath.row];
            if ([model.content_type isEqualToString:@"1"]) {
                static NSString *cellID = @"redmanNote";
                RedManNodeImgCell *cell = (RedManNodeImgCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
                if (!cell) {
                    cell = [[RedManNodeImgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                cell.btn.tag = indexPath.row;
                cell.likeBtn.tag = indexPath.row;
                [cell.likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.txBtn.tag = indexPath.row;
                [cell.txBtn addTarget:self action:@selector(pushDetail:) forControlEvents:UIControlEventTouchUpInside];
                cell.model = model;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }else{
                static NSString *cellID = @"redmanVideo";
                RedManVideoCell *cell = (RedManVideoCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
                if (!cell) {
                    cell = [[RedManVideoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                cell.model = model;
                cell.likeBtn.tag = indexPath.row;
                [cell.likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.btn.tag = indexPath.row;
                [cell.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.txBtn.tag = indexPath.row;
                [cell.txBtn addTarget:self action:@selector(pushDetail:) forControlEvents:UIControlEventTouchUpInside];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
            
        }
            break;
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            RedManModel *model = self.manDataArr[indexPath.row];
            if (self.didcell) {
                self.didcell(model,RedManViewToMan);
            }
        }
            break;
            case 1:
        {
            RedListModel *model = self.listArr[indexPath.row];
            if ([model.strace_type isEqualToString:@"2"]) {
                if (self.didcell) {
                    self.didcell(model,RedManViewToNote);
                }
            }else if([model.strace_type isEqualToString:@"4"]){
                if (self.didcell) {
                    self.didcell(model,RedManViewToShop);
                }
            }
        }
            break;
        default:
            break;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 50;
    CGPoint point = scrollView.contentOffset;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }else if (scrollView.contentOffset.y >= sectionHeaderHeight){
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    if (self.didscroll) {
        self.didscroll(point.y);
    }

}

//- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
//{
//    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    return YES;
//}

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

- (void)btnClick:(UIButton *)sender{
    WS(weakSelf);
    [YPCRequestCenter isLoginAndPresentLoginVC:[YPC_Tools getControllerWithView:self] success:^{
        __block RedListModel *model = self.listArr[sender.tag];
        self.store_id = model.store_id;
        if ([model.is_follow isEqualToString:@"1"]) {
            //取消关注
            [YPC_Tools customAlertViewWithTitle:@"提示:" Message:@"是否取消关注" BtnTitles:@[@"确认"] CancelBtnTitle:@"取消" DestructiveBtnTitle:@"" actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                [weakSelf floowDataOfCancel];
                [weakSelf followstore_cancel:model.store_id];
            } cancelHandler:^(LGAlertView *alertView) {
                
            } destructiveHandler:nil];
        }else{
            [weakSelf floowDataOfAdd];
            [weakSelf followstore_add:model.store_id];
        }
    }];
}


- (void)likeBtnClick:(UIButton *)sender{
    RedListModel *model = self.listArr[sender.tag];
    NSIndexPath *index = [NSIndexPath indexPathForRow:sender.tag inSection:1];
    NSString *url= @"";
    
    if (sender.selected == NO) {
        
        model.islike = @"1";
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        url = @"shop/usercircle/like";
        
    }else{
        
        model.islike = @"0";
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        url = @"shop/usercircle/unlike";
        
    }
    [YPCNetworking postWithUrl:url
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"strace_id":model.strace_id
                                                                               }
                                ]                           success:^(id response) {
                            
                            
                            
                        }
                          fail:^(NSError *error) {
                              
                          }];
}

- (void)pushDetail:(UIButton *)sender{
    RedListModel *model = self.listArr[sender.tag];
    LiveDetailHHHVC *live = [[LiveDetailHHHVC alloc]init];
    live.store_id = model.store_id;
    [[YPC_Tools getControllerWithView:self].navigationController pushViewController:live animated:YES];
}

- (void)floowDataOfAdd{
    for (int i = 0 ; i < self.listArr.count; i++) {
        RedListModel *model = self.listArr[i];
        if ([model.store_id isEqualToString:self.store_id]) {
            model.is_follow = @"1";
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:1];
            [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}
- (void)floowDataOfCancel{
    for (int i = 0 ; i < self.listArr.count; i++) {
        RedListModel *model = [self.listArr objectAtIndex:i];
        if ([model.store_id isEqualToString:self.store_id]) {
            model.is_follow = @"0";
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:1];
            [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addSubview:_tableView];
        self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight / 100 * 29) delegate:self placeholderImage:IMAGE(@"homepage_banner_zhanweitu")];
        self.bannerView.backgroundColor = [UIColor whiteColor];
        self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        //    self.bannerView.titlesGroup = titles;
        self.bannerView.autoScrollTimeInterval = 4.f;
        self.bannerView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        [_tableView setTableHeaderView:self.bannerView];
        _tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    }
    return _tableView;
}

- (NSMutableArray *)manDataArr{
    if (_manDataArr == nil) {
        _manDataArr = [NSMutableArray array];
    }
    return _manDataArr;
}

- (NSMutableArray *)listArr{
    if (_listArr == nil) {
        _listArr = [[NSMutableArray alloc]init];
    }
    return _listArr;
}
- (NSMutableArray *)bannerDataArr{
    if (_bannerDataArr == nil) {
        _bannerDataArr = [NSMutableArray array];
    }
    return _bannerDataArr;
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
- (void)followstore_add:(NSString *)store_id{
    [YPCNetworking postWithUrl:@"shop/showstore/followstore/add"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{@"store_id":store_id
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               [YPC_Tools showSvpWithNoneImgHud:@"关注成功"];
                           }
                           
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}
- (void)followstore_cancel:(NSString *)store_id{
    
    [YPCNetworking postWithUrl:@"shop/showstore/followstore/cancel"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{@"store_id":store_id
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               
                               [YPC_Tools showSvpWithNoneImgHud:@"取消成功"];
                               
                           }
                           
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}
@end
