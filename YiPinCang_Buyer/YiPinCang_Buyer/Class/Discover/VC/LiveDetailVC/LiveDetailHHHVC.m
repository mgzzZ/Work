//
//  LiveDetailHHHVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/6.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LiveDetailHHHVC.h"
#import "HHHorizontalPagingView.h"
#import "LiveListView.h"
#import "LiveSctivityView.h"
#import "LiveShareView.h"
#import "LiveNoteView.h"
#import "LiveHeaderView.h"
#import "LiveDetailDefaultModel.h"
#import "LiveDetailListDataModel.h"
#import "LiveActivityModel.h"
#import "LiveNoteModel.h"
#import "LiveShareModel.h"
#import "DiscoverDetailVC.h"
#import "Pre_stracesModel.h"
#import "PreheatingDetailVC.h"
#import "LiveListVC.h"
#import "PhotoLivingVC.h"
#import "LivingVC.h"
#import "PreheatingVC.h"
#import "VideoPlayerVC.h"
@interface LiveDetailHHHVC ()
@property (nonatomic,strong)HHHorizontalPagingView *pagingView;
@property (nonatomic,strong)LiveListView *listTab;
@property (nonatomic,strong)LiveSctivityView *activityColl;
@property (nonatomic,strong)LiveShareView *shareTab;
@property (nonatomic,strong)LiveNoteView *noteTab;
@property (nonatomic,strong)LiveHeaderView *headerView;
@property (nonatomic,strong)LiveDetailDefaultModel *model;
@end

@implementation LiveDetailHHHVC

- (void)dealloc
{
    YPCAppLog(@"%@ ------> Dealloc", NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar mz_setBackgroundImage:IMAGE(@"homepage_bar")];
    [self.navigationController.navigationBar mz_setBackgroundColor:[Color colorWithHex:@"#3B3B3B"]];
    [self.navigationController.navigationBar mz_setBackgroundAlpha:0.f];
    [self getData];
    [self pagingDelegate];
    UIButton *rightBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn1.frame = CGRectMake(0, 0, 25, 25);
    [rightBtn1 setImage:IMAGE(@"mshare_button") forState:UIControlStateNormal];
    [rightBtn1 addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *message = [[UIBarButtonItem alloc]initWithCustomView:rightBtn1];
    self.navigationItem.rightBarButtonItem= message;
}

#pragma mark - 方法

- (void)pagingDelegate{
    WS(weakself);
    self.pagingView.clickEventViewsBlock = ^(UIView *eventView){
        switch (eventView.tag) {
            case LikeBtnTag:
            {
                [YPCRequestCenter isLoginAndPresentLoginVC:[YPC_Tools getControllerWithView:weakself.view] success:^{
                    YPCAppLog(@"关注");
                    if (weakself.headerView.leftBtn.selected) {
                        [weakself followstore_cancel];
                        weakself.headerView.leftBtn.selected = NO;
                    }else{
                        weakself.headerView.leftBtn.selected = YES;
                        [weakself followstore_add];
                    }
                }];
                
            }
                break;
            case MessageTag:{
                YPCAppLog(@"私信");
                [YPCRequestCenter isLoginAndPresentLoginVC:[YPC_Tools getControllerWithView:weakself.view] success:^{
                    [YPC_Tools openConversationWithCilentId:weakself.model.info.hx_uname ViewController:weakself andOrderId:nil andOrderIndex:nil];
                }];
                
            }
                break;
            default:
                break;
        }
        
    };
}

//分享
- (void)shareBtnClick:(UIButton *)sender{
    NSString *uid = [YPCRequestCenter shareInstance].model.user_id.length > 0 ? [YPCRequestCenter shareInstance].model.user_id : @"0";
    [YPCShare StoreShareInWindowWithStoreName:self.model.info.store_name
                                      StoreId:self.model.info.store_id
                                        image:self.headerView.txImg
                                          uid:uid
                               viewController:self];
}

#pragma mark - 获取头部试图数据

- (void)getData{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/showstore/default"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{@"store_id":weakSelf.store_id
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                           }
                           weakSelf.model = [LiveDetailDefaultModel mj_objectWithKeyValues:response[@"data"]];
                           [weakSelf.headerView.bgImg sd_setImageWithURL:[NSURL URLWithString:weakSelf.model.info.store_banner] placeholderImage:IMAGE(@"find_logo_placeholder")];
                           [weakSelf.headerView.txImg sd_setImageWithURL:[NSURL URLWithString:weakSelf.model.info.store_avatar] placeholderImage:YPCImagePlaceHolder];
                           weakSelf.headerView.nameLab.text = weakSelf.model.info.store_name;
                           weakSelf.headerView.likeLab.text = [NSString stringWithFormat:@"收到赞%@",weakSelf.model.info.likenum];
                           weakSelf.headerView.fansLab.text = [NSString stringWithFormat:@"粉丝%@人",weakSelf.model.info.store_collect];
                           weakSelf.headerView.leftBtn.tag = LikeBtnTag;
                           weakSelf.headerView.rightBtn.tag = MessageTag;
                           if ([weakSelf.model.info.isfollow isEqualToString:@"0"] || weakSelf.model.info.isfollow.length == 0) {
                               weakSelf.headerView.leftBtn.selected = NO;
                           }else{
                               weakSelf.headerView.leftBtn.selected = YES;
                           }
                           if (weakSelf.model.info.store_description.length == 0) {
                               weakSelf.headerView.titleLab.text = @"暂无签名";
                           }else{
                               weakSelf.headerView.titleLab.text = [NSString stringWithFormat:@"个人签名:%@",weakSelf.model.info.store_description];
                           }
      
                       }
                          fail:^(NSError *error) {
                              
                          }];
}

- (void)followstore_add{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/showstore/followstore/add"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{@"store_id":weakSelf.store_id
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               
                               NSString *count = response[@"data"][@"follower_count"];
                               weakSelf.headerView.fansLab.text = [NSString stringWithFormat:@"粉丝%@人",count];
                           }
                          
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}
- (void)followstore_cancel{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/showstore/followstore/cancel"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{@"store_id":weakSelf.store_id
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               NSString *count = response[@"data"][@"follower_count"];
                               weakSelf.headerView.fansLab.text = [NSString stringWithFormat:@"粉丝%@人",count];
                           }
                           
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}

#pragma mark - 懒加载


- (HHHorizontalPagingView *)pagingView{
    if (_pagingView == nil) {
        NSMutableArray *buttonArray = [NSMutableArray array];
        NSArray *nameStr = @[@"直播列表",@"活动商品",@"好货分享",@"我的笔记"];
        for(int i = 0; i < nameStr.count; i++) {
            UIButton *segmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
            segmentButton.backgroundColor = [UIColor whiteColor];
            segmentButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [segmentButton setTitle:[NSString stringWithFormat:@"%@",nameStr[i]] forState:UIControlStateNormal];
            [segmentButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [segmentButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [buttonArray addObject:segmentButton];
        }
        WS(weakself);
        _pagingView = [HHHorizontalPagingView pagingViewWithHeaderView:self.headerView headerHeight:265 segmentButtons:buttonArray segmentHeight:15 contentViews:@[self.listTab, self.activityColl,self.shareTab,self.noteTab]];
        _pagingView.segmentTopSpace = 64;
        _pagingView.scrollViewDidScrollBlock = ^(CGFloat offset){
            if (offset > -100) {
            CGFloat alpha = MIN(1, 1 - ((-110 + 64 - offset) / 64));
               [[YPC_Tools getControllerWithView:weakself.view].navigationController.navigationBar mz_setBackgroundAlpha:alpha];
                weakself.navigationItem.title = weakself.model.info.store_name;
            }else{
                [[YPC_Tools getControllerWithView:weakself.view].navigationController.navigationBar mz_setBackgroundAlpha:0];
                weakself.navigationItem.title = @"";
            }

        };
        [self.view addSubview:_pagingView];
    }
    return _pagingView;
}

//直播列表
- (LiveListView *)listTab{
    WS(weakself);
    if (_listTab == nil) {
        _listTab = [LiveListView contentTableView];
        _listTab.store_id = self.store_id;
        _listTab.didcell = ^(NSIndexPath *index,LiveDetailListDataModel *model, NSString *typeStr){
            if ([typeStr isEqualToString:@"直播中"]) {
                [weakself pushToLivingViewControllerWithIndexPath:index model:model];
                
            }else if ([typeStr isEqualToString:@"预告"]){
                [weakself pushToPreHeartingViewControllerWithIndexPath:index model:model];
            }else if ([typeStr isEqualToString:@"回放"]){
                [weakself pushToEndActivityViewControllerWithIndexPath:index model:model];
            }else{
                //其他
            }
        };
    }
    return _listTab;
}

//活动商品
- (LiveSctivityView *)activityColl{
    WS(weakself);
    if (_activityColl == nil) {
        
        _activityColl = [LiveSctivityView contentTableView];
        _activityColl.store_id = self.store_id;
        _activityColl.didcell = ^(NSIndexPath *index,LiveActivityModel *model){
            DiscoverDetailVC *detail = [[DiscoverDetailVC alloc]init];
            detail.strace_id = model.strace_id;
       
            detail.typeStr = @"淘好货";
            [weakself.navigationController pushViewController:detail animated:YES];
        };
        _activityColl.backgroundColor = [UIColor redColor];
    }
    return _activityColl;
}

//好货分享
- (LiveShareView *)shareTab{
     WS(weakself);
    if (_shareTab == nil) {
        _shareTab = [LiveShareView contentTableView];
        _shareTab.store_id = self.store_id;
        _shareTab.shareDidcell = ^(NSIndexPath *index,LiveShareModel *model){
            DiscoverDetailVC *detail = [[DiscoverDetailVC alloc]init];
            detail.strace_id = model.strace_id;
            detail.live_id = model.live_id;
            detail.typeStr = @"动态";
            [weakself.navigationController pushViewController:detail animated:YES];
        };
    }
    return _shareTab;
}

//我的笔记
- (LiveNoteView *)noteTab{
     WS(weakself);
    if (_noteTab == nil) {
        _noteTab = [LiveNoteView contentTableView];
        _noteTab.store_id = self.store_id;
        _noteTab.notedidcell = ^(NSIndexPath *index,LiveNoteModel *model){
            PreheatingDetailVC *detailVC = [PreheatingDetailVC new];
            detailVC.detailType = detailStyleUserCircle;
            detailVC.tempStrace_ID = model.strace_id;
            [weakself.navigationController pushViewController:detailVC animated:YES];
        };
    }
    return _noteTab;
}

- (LiveHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [[LiveHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 265)];
    }
    return _headerView;
}


#pragma mark - ParviteMethod
- (void)pushToLivingViewControllerWithIndexPath:(NSIndexPath *)indexPath model:(LiveDetailListDataModel *)model
{
    if (model.activity_type.integerValue == 0) {
        // 图文直播
        PhotoLivingVC *pVC = [PhotoLivingVC new];
        pVC.liveId = model.live_id;
        [self.navigationController pushViewController:pVC animated:YES];
        
    }else if (model.activity_type.integerValue == 1) {
        // 实时直播
        WS(weakSelf);
        [[SDWebImageDownloader sharedDownloader]
         downloadImageWithURL:[NSURL URLWithString:model.livingshowinitimg]
         options:SDWebImageDownloaderUseNSURLCache
         progress:nil
         completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
             if (finished && !error) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     LivingVC *lVC = [LivingVC new];
                     lVC.liveId = model.live_id;
                     lVC.playerPHImg = image;
                     [weakSelf.navigationController pushViewController:lVC animated:YES];
                     [YPC_Tools dismissHud];
                 });
             }else {
                 [YPC_Tools showSvpHudError:@"加载失败, 请重试"];
             }
         }];
    }
}

- (void)pushToPreHeartingViewControllerWithIndexPath:(NSIndexPath *)indexPath model:(LiveDetailListDataModel *)model
{
    PreheatingVC *pVC = [PreheatingVC new];
    pVC.liveId = model.live_id;
    [self.navigationController pushViewController:pVC animated:YES];
}

- (void)pushToEndActivityViewControllerWithIndexPath:(NSIndexPath *)indexPath model:(LiveDetailListDataModel *)model
{
    VideoPlayerVC *vVC = [VideoPlayerVC new];
    vVC.liveId = model.live_id;
    [self.navigationController pushViewController:vVC animated:YES];
}


#pragma mark - end


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
