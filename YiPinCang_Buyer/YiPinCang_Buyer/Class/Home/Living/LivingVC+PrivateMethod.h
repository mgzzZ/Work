//
//  LivingVC+PrivateMethod.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/29.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LivingVC.h"

@interface LivingVC (PrivateMethod) <AVIMClientDelegate>

/*!
 *
 *    加入聊天室
 *
 */
- (void)joinDanmakuChatroomWithConversationId:(NSString *)conversationId;
/*!
 *
 *    添加播放器到window
 *
 */
- (void)playVideoOnWindow;
/*!
 *
 *    从window隐藏播放器
 *
 */
- (void)hiddenVideoOnWindowWithViewController:(UIViewController *)vc;
/*!
 *
 *    移除window播放器
 *
 */
- (void)removeVideoOnWindow;
/*!
 *
 *    关注直播员
 *
 */
- (void)followLivingGroup;
/*!
 *
 *    点赞动画
 *
 */
- (void)showTheApplauseInView:(UIView *)view belowView:(UIButton *)btn;
@end
