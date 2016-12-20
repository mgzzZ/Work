//
//  FloatingViewController.m
//  Unity-iPhone
//
//  Created by Xinhou Jiang on 6/13/16.
//
//
#define floatSize 91.5
#import "FloatingViewController.h"
#import "UIDragButton.h"
#import "FloatWindow.h"
#import "GoodsMessage.h"

@interface FloatingViewController ()<UIDragButtonDelegate>

/**
 *  悬浮的window
 */
@property(strong,nonatomic) FloatWindow *window;

/**
 *  悬浮的按钮
 */
@property(strong,nonatomic)UIDragButton *button;

@end

@implementation FloatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 将视图尺寸设置为0，防止阻碍其他视图元素的交互
    self.view.frame = CGRectZero;
    // 延时显示悬浮窗口
    [self performSelector:@selector(createButton) withObject:nil afterDelay:1];
    self.isHiddenOnWindow = NO;
}

- (void)dealloc
{
    
}

- (void)setIsHiddenOnWindow:(BOOL)isHiddenOnWindow
{
    _isHiddenOnWindow = isHiddenOnWindow;
    if (self.window && self.button) {        
        if (_isHiddenOnWindow) {
            self.window.hidden = YES;
        }else {
            self.window.hidden = NO;
        }
    }
}

/**
 *  创建悬浮窗口
 */
- (void)createButton
{
    _button = [UIDragButton buttonWithType:UIButtonTypeCustom];
    [_button setImage:[UIImage imageNamed:@"chat_button"] forState:UIControlStateNormal];
    _button.imageView.contentMode = UIViewContentModeScaleToFill;
    _button.frame = CGRectMake(0, 0, floatSize, floatSize);
    [_button addTarget:self action:@selector(floatBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _button.selected = NO;
    _button.adjustsImageWhenHighlighted = NO;
    _button.rootView = self.view.superview;
    _button.btnDelegate = self;
    _button.imageView.alpha = 0.8;
    
    // 悬浮窗
    _window = [[FloatWindow alloc]init];
    _window.floatFrame = CGRectMake(ScreenWidth - floatSize, ScreenHeight - 150, floatSize, floatSize);
    _window.windowLevel = UIWindowLevelAlert+1;
    _window.backgroundColor = [UIColor clearColor];
//    _window.layer.cornerRadius = floatSize/2;
//    _window.layer.masksToBounds = YES;
    [_window addSubview:_button];
    //显示window
    [_window makeKeyAndVisible];
}

/**
 *  悬浮按钮点击
 */
- (void)floatBtnClicked:(UIButton *)sender
{
    // 点击方法无效
}

// 通过touchdown touchmove实现点击方法
- (void)dragButtonClicked:(UIButton *)sender {
    WS(weakSelf);
    [YPC_Tools customAlertViewWithTitle:nil
                                Message:@"是否发送订单消息"
                              BtnTitles:nil
                         CancelBtnTitle:@"取消"
                    DestructiveBtnTitle:@"确定"
                          actionHandler:nil
                          cancelHandler:nil
                     destructiveHandler:^(LGAlertView *alertView) {
                         
                         GoodsMessage *gMessage = [GoodsMessage GoodsMessageWithOrderId:self.orderId index:self.index conversationType:LCCKConversationTypeSingle];
                         [self.conversationVC sendCustomMessage:gMessage progressBlock:^(NSInteger percentDone) {
                         } success:^(BOOL succeeded, NSError *error) {
                             [weakSelf.conversationVC sendLocalFeedbackTextMessge:@"商品订单发送成功"];
                         } failed:^(BOOL succeeded, NSError *error) {
                             [weakSelf.conversationVC sendLocalFeedbackTextMessge:@"商品订单发送失败"];
                         }];
                     }];
}

- (void)removeFromWindow
{
    [_window resignKeyWindow];
    _window = nil;
}

@end
