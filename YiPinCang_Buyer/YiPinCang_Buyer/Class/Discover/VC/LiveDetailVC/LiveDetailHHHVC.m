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
#import "LivingVC.h"
#import "PreheatingVC.h"
#import "VideoPlayerVC.h"
#import "TempHomePushModel.h"
#import "LoginVC.h"
#import "Pre_stracesModel.h"
#import "PreheatingDetailVC.h"
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.subviews.firstObject.alpha = 0;
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.subviews.firstObject.alpha = 1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getData];
    [self pagingDelegate];
    UIButton *rightBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn1.frame = CGRectMake(0, 0, 25, 25);
    [rightBtn1 setImage:IMAGE(@"mine_productdetails_icon_share") forState:UIControlStateNormal];
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
                YPCAppLog(@"关注");
                if (weakself.headerView.leftBtn.selected) {
                    [weakself followstore_cancel];
                    weakself.headerView.leftBtn.selected = NO;
                }else{
                    weakself.headerView.leftBtn.selected = YES;
                    [weakself followstore_add];
                }
            }
                break;
            case MessageTag:{
                YPCAppLog(@"私信");
                [YPC_Tools openConversationWithCilentId:weakself.model.info.hx_uname andViewController:weakself];
            }
                break;
            default:
                break;
        }
        
    };
}

//分享
- (void)shareBtnClick:(UIButton *)sender{
    
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
                           weakSelf.headerView.bgImg.backgroundColor = [UIColor blueColor];
                           [weakSelf.headerView.txImg sd_setImageWithURL:[NSURL URLWithString:weakSelf.model.info.store_avatar] placeholderImage:YPCImagePlaceHolder];
                           weakSelf.headerView.nameLab.text = weakSelf.model.info.store_name;
                           weakSelf.headerView.likeLab.text = [NSString stringWithFormat:@"收到赞%@",weakSelf.model.info.likenum];
                           weakSelf.headerView.fansLab.text = [NSString stringWithFormat:@"粉丝%@人",weakSelf.model.info.store_collect];
                           weakSelf.headerView.leftBtn.tag = LikeBtnTag;
                           weakSelf.headerView.rightBtn.tag = MessageTag;
                           if ([weakSelf.model.info.isfollow isEqualToString:@"0"]) {
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

        _pagingView = [HHHorizontalPagingView pagingViewWithHeaderView:self.headerView headerHeight:265 segmentButtons:buttonArray segmentHeight:15 contentViews:@[self.listTab, self.activityColl,self.shareTab,self.noteTab]];
        
        
        _pagingView.segmentTopSpace = 0;
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
                // 先判断正在直播中
                if (![YPCRequestCenter isLogin]) {
                    [weakself login];
                }else{
                    LivingVC *live= [[LivingVC alloc]init];
                    TempHomePushModel *newmodel = [[TempHomePushModel alloc]init];
                    newmodel.live_id = model.live_id;
                    newmodel.announcement_id = model.announcement_id;
                    newmodel.store_avatar = weakself.model.info.store_avatar;
                    newmodel.store_name = weakself.model.info.store_name;
                    newmodel.store_id = weakself.model.info.store_id;
                    live.tempModel = newmodel;
                    [weakself.navigationController pushViewController:live animated:YES];
                }
                
            }else if ([typeStr isEqualToString:@"预告"]){
                PreheatingVC *preheat = [[PreheatingVC alloc]init];
                TempHomePushModel *newmodel = [[TempHomePushModel alloc]init];
                newmodel.live_id = model.live_id;
                newmodel.name = model.name;
                newmodel.store_avatar = weakself.model.info.store_avatar;
                newmodel.store_name = weakself.model.info.store_name;
                newmodel.starttime = model.starttime;
                newmodel.endtime = model.endtime;
                newmodel.activity_pic = model.activity_pic;
                newmodel.live_msg = model.message;
                newmodel.address = model.address;
                newmodel.start = model.start;
                newmodel.end = model.end;
                newmodel.live_state = model.live_state;
                preheat.tempModel = newmodel;

                [weakself.navigationController pushViewController:preheat animated:YES];
            }else if ([typeStr isEqualToString:@"回放"]){
                VideoPlayerVC *video = [[VideoPlayerVC alloc]init];
                TempHomePushModel *newmodel = [[TempHomePushModel alloc]init];
                newmodel.live_id = model.live_id;
                newmodel.store_id = weakself.model.info.store_id;
                newmodel.store_avatar = weakself.model.info.store_avatar;
                newmodel.store_name = weakself.model.info.store_name;
                newmodel.video = model.video;
        
                video.tempModel = newmodel;
                [weakself.navigationController pushViewController:video animated:YES];
            }else{
                //其他
            }
        };
    }
    return _listTab;
}

//好货分享
- (LiveSctivityView *)activityColl{
    WS(weakself);
    if (_activityColl == nil) {
        
        _activityColl = [LiveSctivityView contentTableView];
        _activityColl.store_id = self.store_id;
        _activityColl.didcell = ^(NSIndexPath *index,LiveActivityModel *model){
            DiscoverDetailVC *detail = [[DiscoverDetailVC alloc]init];
            detail.strace_id = model.strace_id;
            detail.live_id = model.live_id;
            detail.typeStr = @"淘好货";
            [weakself.navigationController pushViewController:detail animated:YES];
        };
    }
    return _activityColl;
}

//活动商品
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
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic = model.mj_keyValues;
            Pre_stracesModel *preModel = [Pre_stracesModel mj_objectWithKeyValues:dic];
            PreheatingDetailVC *detailVC = [PreheatingDetailVC new];
            detailVC.detailType = detailStyleUserCircle;
            detailVC.tempModel = preModel;
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
- (void)login{
    LoginVC *login = [[LoginVC alloc]init];
    UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:login];
    login.navigationController.navigationBar.hidden = YES;
    [self.navigationController presentViewController:loginNav animated:YES completion:nil];
}
#pragma mark - end


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
