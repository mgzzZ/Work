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
#import "WebViewController.h"
#import "LivingVC.h"
#import "PreheatingVC.h"
#import "VideoPlayerVC.h"

@interface DiscoverDetailNewVC ()
@property (nonatomic,strong)BrandDetailHeaderView *headerView;
@property (nonatomic,strong)HHHorizontalPagingView *pagingView;
@property (nonatomic,strong)BrandDetailNewView *activityColl;
@property (nonatomic,strong)BrandDetailModel *model;

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation DiscoverDetailNewVC

- (void)dealloc
{
    [self stopTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar mz_setBackgroundImage:IMAGE(@"homepage_bar")];
    [self.navigationController.navigationBar mz_setBackgroundColor:[Color colorWithHex:@"#3B3B3B"]];
    [self.navigationController.navigationBar mz_setBackgroundAlpha:0.f];
    
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
                WebViewController *web = [[WebViewController alloc]init];
                web.homeUrl =[NSString stringWithFormat: @"http://api.gongchangtemai.com/index.php?url=shop/showstore/brandinfo/%@",weakself.model.brand.brandstore_id];
                web.navTitle = @"品牌简介";
                [weakself.navigationController pushViewController:web animated:YES];
                
            }
                break;
            case BrandFllowBtnTag:{
                 if ([YPCRequestCenter isLoginAndPresentLoginVC:weakself]) {
                     if ([weakself.model.brand.isfavor isEqualToString:@"1"]) {
                         [weakself followstore_cancel];
                         weakself.headerView.fllowBtn.selected = NO;
                     }else{
                         [weakself followstore_add];
                         weakself.headerView.fllowBtn.selected = YES;
                     }
                 }
            }
                break;
            case BrandDetailBtnTag:{
                if ([YPCRequestCenter isLoginAndPresentLoginVC:weakself]) {
                    if ([weakself.type isEqualToString:@"直播中"]) {
                        LivingVC *live= [[LivingVC alloc]init];
                        live.tempModel = weakself.tempModel;
                        
                        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:weakself.livingshowinitimg] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                            if (finished && !error) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    live.playerPHImg = image;
                                    [weakself.navigationController pushViewController:live animated:YES];
                                    [YPC_Tools dismissHud];
                                });
                            }else{
                                [YPC_Tools showSvpHudError:@"图片未下载成功"];
                            }
                            
                        }];
                        
                    }else if ([weakself.type isEqualToString:@"预告"]){
                        PreheatingVC *preheat = [[PreheatingVC alloc]init];
                        preheat.tempModel = weakself.tempModel;
                        [weakself.navigationController pushViewController:preheat animated:YES];
                        
                    }else{
                        VideoPlayerVC *video = [[VideoPlayerVC alloc]init];
                        video.tempModel = weakself.tempModel;
                        [weakself.navigationController pushViewController:video animated:YES];
                    }
                }
                
            }
                break;
            default:
                break;
        }
        
    };
    self.pagingView.scrollViewDidScrollBlock = ^(CGFloat offset){
        YPCAppLog(@"%.2f",offset);
        if (offset > -66) {
            CGFloat alpha = MIN(1, 1 - ((-66 - 64.f - offset) / 64));
            [[YPC_Tools getControllerWithView:weakself.view].navigationController.navigationBar mz_setBackgroundAlpha:alpha];
        }else{
            [[YPC_Tools getControllerWithView:weakself.view].navigationController.navigationBar mz_setBackgroundAlpha:0.f];
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
                               [weakSelf.headerView.bgimg sd_setImageWithURL:[NSURL URLWithString:weakSelf.model.brand.bgurl] placeholderImage:IMAGE(@"find_logo_placeholder")];
                               [weakSelf.headerView.brandBtn setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:weakSelf.model.brand.store_avatar]]] forState:UIControlStateNormal];
                               weakSelf.headerView.brandNameLab.text = weakSelf.model.brand.brand_name;
                               weakSelf.headerView.BrandTitleLab.text = weakSelf.message;
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
        _pagingView.segmentTopSpace = 64;
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
