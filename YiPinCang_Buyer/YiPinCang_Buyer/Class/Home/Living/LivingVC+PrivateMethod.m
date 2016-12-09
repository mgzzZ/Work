//
//  LivingVC+PrivateMethod.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/29.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LivingVC+PrivateMethod.h"

@implementation LivingVC (PrivateMethod)

- (void)joinDanmakuChatroomWithConversationId:(NSString *)conversationId
{
    [NotificationCenter postNotificationName:DidReceiveDanmakuFormLeanCloudCusstomMessage object:@{@"message" : @"正在连接聊天室..."}];
    AVIMClient *client = [LCChatKit sharedInstance].client;
    [client openWithCallback:^(BOOL succeeded, NSError *error) {
        AVIMConversationQuery *query = [client conversationQuery];
        [query getConversationById:@"582be824da2f600063d5c28d" callback:^(AVIMConversation *conversation, NSError *error) {
            if (succeeded) {
                [conversation joinWithCallback:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        self.danmuconversation = conversation;
                        [NotificationCenter postNotificationName:DidReceiveDanmakuFormLeanCloudCusstomMessage object:@{@"message" : @"加入聊天室成功"}];
                    }else {
                        // TOTO 加入聊天室失败
                    }
                }];
            }else {
                // TOTO 加入聊天室失败
            }
        }];
    }];
}

- (void)followLivingGroup
{
    [YPCNetworking postWithUrl:@"shop/showstore/followstore/add"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"store_id" : self.tempModel.store_id
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               self.groupBgWidthC.constant = 52 + [self.livingNameL.text stringSizeWithFont:LightFont(15)].width;
                               self.followBtn.hidden = YES;
                           }
                       }
                          fail:^(NSError *error) {
                              YPCAppLog(@"%@", [error description]);
                          }];
}

- (void)playVideoOnWindow
{
    [self.player.playerView removeFromSuperview];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.player.playerView.transform = CGAffineTransformIdentity;
    self.itemContentView.hidden = YES;
    self.smallCloseBtn.hidden = NO;
    [window addSubview:self.player.playerView];
    [UIView animateWithDuration:.2f animations:^{
        [self.player.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(window.mas_right);
            make.bottom.equalTo(window.mas_bottom).offset(-70);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(160);
        }];
        [window layoutIfNeeded];
        
    }completion:^(BOOL finished) {
        [window bringSubviewToFront:self.player.playerView];
        self.playerIsOnWindow = YES;
        self.isRemoveFromWindow = NO;
    }];
}

- (void)hiddenVideoOnWindowWithViewController:(UIViewController *)vc
{
    [self.player.playerView removeFromSuperview];
    self.player.playerView.transform = CGAffineTransformIdentity;
    self.itemContentView.hidden = NO;
    self.smallCloseBtn.hidden = YES;
    [self.view insertSubview:self.player.playerView belowSubview:self.itemContentView];
    WS(weakself);
    CGFloat height = ScreenHeight - ScreenHeight / 5 * 3;
    CGFloat radio = ScreenWidth / ScreenHeight;
    [UIView animateWithDuration:.2f animations:^{
        [weakself.player.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
            make.left.equalTo(self.view.mas_left).offset((ScreenWidth - radio * height) / 2);
            make.width.mas_equalTo(radio * height);
            make.height.mas_equalTo(height);
        }];
        [weakself.view layoutIfNeeded];
        
        [self.navigationController popToViewController:vc animated:YES];
    }completion:^(BOOL finished) {
        self.playerIsOnWindow = NO;
        self.isRemoveFromWindow = NO;
    }];
}

- (void)removeVideoOnWindow
{
    [self.player stop];
    [self.player.playerView removeFromSuperview];
    self.player.playerView.transform = CGAffineTransformIdentity;
    self.itemContentView.hidden = NO;
    self.smallCloseBtn.hidden = YES;
    [self.view insertSubview:self.player.playerView belowSubview:self.itemContentView];
    
    CGFloat height = ScreenHeight - ScreenHeight / 5 * 3;
    CGFloat radio = ScreenWidth / ScreenHeight;
    [self.player.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left).offset((ScreenWidth - radio * height) / 2);
        make.width.mas_equalTo(radio * height);
        make.height.mas_equalTo(height);
    }];
    [self.view layoutIfNeeded];
    self.playerIsOnWindow = NO;
    self.isRemoveFromWindow = YES;
}

- (void)showTheApplauseInView:(UIView *)view belowView:(UIButton *)btn{
    NSInteger index = arc4random_uniform(7); //取随机图片
    NSString *image = [NSString stringWithFormat:@"live_likes_img%zd",index];
    UIImageView *applauseView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-15-50, self.view.frame.size.height - 150, 40, 40)];//增大y值可隐藏弹出动画
    [view insertSubview:applauseView belowSubview:btn];
    applauseView.image = [UIImage imageNamed:image];
    
    CGFloat AnimH = 350; //动画路径高度,
    applauseView.transform = CGAffineTransformMakeScale(0, 0);
    applauseView.alpha = 0;
    
    //弹出动画
    [UIView animateWithDuration:0.2 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
        applauseView.transform = CGAffineTransformIdentity;
        applauseView.alpha = 0.9;
    } completion:NULL];
    
    //随机偏转角度
    NSInteger i = arc4random_uniform(2);
    NSInteger rotationDirection = 1- (2*i);// -1 OR 1,随机方向
    NSInteger rotationFraction = arc4random_uniform(10); //随机角度
    //图片在上升过程中旋转
    [UIView animateWithDuration:4 animations:^{
        applauseView.transform = CGAffineTransformMakeRotation(rotationDirection * M_PI/(4 + rotationFraction*0.2));
    } completion:NULL];
    
    //动画路径
    UIBezierPath *heartTravelPath = [UIBezierPath bezierPath];
    [heartTravelPath moveToPoint:applauseView.center];
    
    //随机终点
    CGFloat ViewX = applauseView.center.x;
    CGFloat ViewY = applauseView.center.y;
    CGPoint endPoint = CGPointMake(ViewX + rotationDirection*10, ViewY - AnimH);
    
    //随机control点
    NSInteger j = arc4random_uniform(2);
    NSInteger travelDirection = 1- (2*j);//随机放向 -1 OR 1
    
    NSInteger m1 = ViewX + travelDirection*(arc4random_uniform(20) + 50);
    NSInteger n1 = ViewY - 60 + travelDirection*arc4random_uniform(20);
    NSInteger m2 = ViewX - travelDirection*(arc4random_uniform(20) + 50);
    NSInteger n2 = ViewY - 90 + travelDirection*arc4random_uniform(20);
    CGPoint controlPoint1 = CGPointMake(m1, n1);//control根据自己动画想要的效果做灵活的调整
    CGPoint controlPoint2 = CGPointMake(m2, n2);
    //根据贝塞尔曲线添加动画
    [heartTravelPath addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    
    //关键帧动画,实现整体图片位移
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrameAnimation.path = heartTravelPath.CGPath;
    keyFrameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    keyFrameAnimation.duration = 3 ;//往上飘动画时长,可控制速度
    [applauseView.layer addAnimation:keyFrameAnimation forKey:@"positionOnPath"];
    
    //消失动画
    [UIView animateWithDuration:3 animations:^{
        applauseView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [applauseView removeFromSuperview];
    }];
}


@end
