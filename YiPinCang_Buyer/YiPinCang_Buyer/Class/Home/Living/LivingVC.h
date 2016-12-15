//
//  LivingVC.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/15.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "BaseNaviConfigVC.h"
#import <PLPlayerKit.h>
#import "TempHomePushModel.h"
#import "RTMPModel.h"
#import "DanmakuView.h"
#import "LivingGoodsView.h"
#import "AudienceView.h"

@interface LivingVC : BaseNaviConfigVC

@property (nonatomic, strong) TempHomePushModel *tempModel;
@property (nonatomic, strong) UIImage *playerPHImg;

@property (nonatomic, strong) RTMPModel *rtmpModel; // 推流相关初试数据

@property (nonatomic, strong) PLPlayer  *player; // 拉流播放器对象

@property (strong, nonatomic) IBOutlet UIView *itemContentView; // 控件父view
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *groupBgWidthC; // 直播组背景view宽约束
@property (strong, nonatomic) IBOutlet UIImageView *avatorImgV; // 直播组头像
@property (strong, nonatomic) IBOutlet UILabel *livingNameL; // 直播组名称
@property (strong, nonatomic) IBOutlet UIButton *followBtn; // 关注按钮
@property (strong, nonatomic) IBOutlet AudienceView *audienceView; // 观众view
@property (strong, nonatomic) IBOutlet UILabel *audienceCountL; // 观众总人数


@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet DanmakuView *danmakuView; // 弹幕view
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *danmakuViewBottomC;
@property (strong, nonatomic) IBOutlet UILabel *likeCountL; // 点赞数Label
@property (nonatomic, assign) NSInteger likeCount; // 点赞数
@property (nonatomic, assign) NSInteger localLikeCount; // 本地点赞数
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tfBottomC; // tf底部约束
@property (strong, nonatomic) IBOutlet UITextField *danmakuTF; // 发弹幕TF
@property (strong, nonatomic) IBOutlet UIButton *goodsBtn; // 商品按钮

@property (nonatomic, strong) AVIMConversation *danmuconversation; // 弹幕聊天室实例

@property (strong, nonatomic) IBOutlet LivingGoodsView *goodsView; // 商品
@property (strong, nonatomic) IBOutlet UIButton *smallCloseBtn; // 小窗口拉流时的关闭按钮
@property (strong, nonatomic) IBOutlet UIView *livingTopGoodsView; // 直播弹出商品
@property (strong, nonatomic) IBOutlet UIImageView *topGoodsImgV;
@property (strong, nonatomic) IBOutlet UILabel *topGoodsTitleL;
@property (strong, nonatomic) IBOutlet UILabel *topGoodPriceL;

// 是否在window上播放
@property (nonatomic, assign) BOOL playerIsOnWindow;
// 是否已经在window上移除
@property (nonatomic, assign) BOOL isRemoveFromWindow;

@end
