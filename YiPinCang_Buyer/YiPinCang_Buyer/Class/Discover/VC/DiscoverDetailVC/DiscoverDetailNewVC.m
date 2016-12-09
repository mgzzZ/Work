//
//  DiscoverDetailNewVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/8.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "DiscoverDetailNewVC.h"
#import "BrandDetailHeaderView.h"
#import "HHHorizontalPagingView.h"
#import "LiveSctivityView.h"
#import "BrandDetailNewView.h"
#import "BrandDetailModel.h"
#import "LiveDetailHHHVC.h"
#import "DiscoverDetailVC.h"

@interface DiscoverDetailNewVC ()
@property (nonatomic,strong)BrandDetailHeaderView *headerView;
@property (nonatomic,strong)HHHorizontalPagingView *pagingView;
@property (nonatomic,strong)BrandDetailNewView *activityColl;
@property (nonatomic,strong)BrandDetailModel *model;
@end

@implementation DiscoverDetailNewVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.subviews.firstObject.alpha = 0;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.subviews.firstObject.alpha = 1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"品牌商品";
    [self getData:@"1" isRefresh:YES];
    [self pagingDelegate];
}

#pragma mark - 方法

- (void)pagingDelegate{
    WS(weakself);
    self.pagingView.clickEventViewsBlock = ^(UIView *eventView){
        switch (eventView.tag) {
            case BrandBtnTag:
            {
                YPCAppLog(@"直播组详情");
                LiveDetailHHHVC *live = [[LiveDetailHHHVC alloc]init];
                live.store_id = weakself.model.brand.brandstore_id;
                [weakself.navigationController pushViewController:live animated:YES];
                
            }
                break;
            case BrandFllowBtnTag:{
                YPCAppLog(@"私信");
                if ([weakself.model.brand.isfavor isEqualToString:@"1"]) {
                    [weakself followstore_cancel];
                    weakself.headerView.fllowBtn.selected = NO;
                }else{
                    [weakself followstore_add];
                    weakself.headerView.fllowBtn.selected = YES;
                }
                
            }
                break;
            case BrandDetailBtnTag:{
                YPCAppLog(@"私信");
                
            }
                break;
            default:
                break;
        }
        
    };
}

- (void)getData:(NSString *)page isRefresh:(BOOL)isRefresh{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/showstore/brandgoods"
                  refreshCache:YES
                        params:@{@"live_id":weakSelf.live_id,
                                 @"listorder":@"0",
                                 @"class_id":@"",
                                 @"pagination":@{
                                         @"page":page,
                                         @"count":@"10"
                                         }
                                 }
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.model = [BrandDetailModel mj_objectWithKeyValues:response[@"data"]];
                               [weakSelf.headerView.bgimg sd_setImageWithURL:[NSURL URLWithString:weakSelf.model.brand.bgurl] placeholderImage:YPCImagePlaceHolder];
                               [weakSelf.headerView.brandBtn setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:weakSelf.model.brand.store_avatar]]] forState:UIControlStateNormal];
                               weakSelf.headerView.brandNameLab.text = weakSelf.model.brand.brand_name;
                               weakSelf.headerView.BrandTitleLab.text = weakSelf.model.brand.store_description;
                               weakSelf.headerView.brandBtn.tag = BrandBtnTag;
                               weakSelf.headerView.fllowBtn.tag = BrandFllowBtnTag;
                               weakSelf.headerView.titleBtn.tag = BrandDetailBtnTag;
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

                           }
                          
                                                  }
                          fail:^(NSError *error) {
                              
                          }];
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


- (HHHorizontalPagingView *)pagingView{
    if (_pagingView == nil) {
        NSMutableArray *buttonArray = [NSMutableArray array];
        _pagingView = [HHHorizontalPagingView pagingViewWithHeaderView:self.headerView headerHeight:325 segmentButtons:buttonArray segmentHeight:-60 contentViews:@[self.activityColl]];
        _pagingView.segmentTopSpace = 0;
        [self.view addSubview:_pagingView];
    }
    return _pagingView;
}


- (BrandDetailHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [[BrandDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 325)];
    }
    return _headerView;
}



- (BrandDetailNewView *)activityColl{
    WS(weakself);
    if (_activityColl == nil) {
        _activityColl = [BrandDetailNewView contentTableView];
        _activityColl.live_id = weakself.live_id;
        _activityColl.didcell = ^(NSIndexPath *index,LiveActivityModel *model){
            DiscoverDetailVC *dic = [[DiscoverDetailVC alloc]init];
            dic.strace_id = model.strace_id;
            dic.live_id = model.live_id;
            dic.typeStr = @"淘好货";
            [weakself.navigationController pushViewController:dic animated:YES];
        };
        
    }
    return _activityColl;
}




#pragma mark - 动画开始
- (void)animationsStart{
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    animation.toValue = [NSNumber numberWithFloat:0.2];
    animation.fromValue = [NSNumber numberWithFloat:1];
    animation.duration= 1.5;
    animation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        if (finished) {
            [self animationsStart];
        }
    };
    [self.headerView.liveView pop_addAnimation:animation forKey:@"live"];
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
