//
//  LoginVC.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/10/31.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LoginVC.h"
#import "AppDelegate.h"
#import "RegistVC.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UserModel.h"
#import "JPUSHService.h"
#import "LeanChatFactory.h"

@interface LoginVC () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textFieldTopConstraint;

@property (strong, nonatomic) IBOutlet UIImageView *logoImgV;
@property (strong, nonatomic) IBOutlet UITextField *phoneTF;
@property (strong, nonatomic) IBOutlet UITextField *pwdTF;
@property (strong, nonatomic) IBOutlet UIButton *LoginBtn;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *actitityV;
@property (strong, nonatomic) IBOutlet UIButton *wechatLoginBtn;
@property (strong, nonatomic) IBOutlet UILabel *otherLoginLbl;
@property (strong, nonatomic) IBOutlet UIView *lineView1;
@property (strong, nonatomic) IBOutlet UIView *lineView2;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.subviews.firstObject.alpha = 0;
    [self.phoneTF addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
    [self.pwdTF addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
    
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
        self.wechatLoginBtn.hidden = NO;
        self.otherLoginLbl.hidden = NO;
        self.lineView1.hidden = NO;
        self.lineView2.hidden = NO;
    }else {
        self.wechatLoginBtn.hidden = YES;
        self.otherLoginLbl.hidden = YES;
        self.lineView1.hidden = YES;
        self.lineView2.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.resetPwdPhone) {
        self.phoneTF.text = self.resetPwdPhone;
    }
}

#pragma mark - textFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self textFieldDidEditStatus];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self textFieldDidEndEditStatus];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.phoneTF) {
        [self.pwdTF becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
    }
    return YES;
}

- (void)textFieldChanged
{
    if (self.phoneTF.text.length > 0 && self.pwdTF.text.length > 0) {
        [self.LoginBtn setBackgroundImage:IMAGE(@"logon_verificationcode_button_next") forState:UIControlStateNormal];
        self.LoginBtn.enabled = YES;
    }else {
        [self.LoginBtn setBackgroundImage:IMAGE(@"logon_button_gray_signin") forState:UIControlStateNormal];
        self.LoginBtn.enabled = NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.phoneTF.isFirstResponder || self.pwdTF.isFirstResponder) {
        [self.view endEditing:YES];
    }
}

#pragma mark - Animation
- (void)textFieldDidEditStatus
{
    self.topConstraint.constant = 10;
    self.textFieldTopConstraint.constant = 0;
    WS(weakSelf);
    [UIView animateWithDuration:.3f animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:nil];
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(.5, .5)];
    animation.springBounciness = 20.0;
    animation.springSpeed = 20.0;
    [self.logoImgV.layer pop_addAnimation:animation forKey:@"changesize"];
    animation.completionBlock = ^(POPAnimation *anim, BOOL finish) {
        if (finish) {
        }
    };
}

- (void)textFieldDidEndEditStatus
{
    self.topConstraint.constant = 70;
    self.textFieldTopConstraint.constant = 70;
    WS(weakSelf);
    [UIView animateWithDuration:.3f animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:nil];
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    animation.springBounciness = 20.0;
    animation.springSpeed = 20.0;
    [self.logoImgV.layer pop_addAnimation:animation forKey:@"changesize"];
    animation.completionBlock = ^(POPAnimation *anim, BOOL finish) {
        if (finish) {
        }
    };
}

#pragma mark - 登录
- (IBAction)loginAction:(UIButton *)sender {
    if (self.phoneTF.isFirstResponder || self.pwdTF.isFirstResponder) {
        [self.view endEditing:YES];
    }
    if (![self.phoneTF.text isValidPhone]) {
        [YPC_Tools showSvpWithNoneImgHud:@"请输入正确手机号"];
        return;
    }
    [self startLoging];
    WS(weakSelf);
//    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
    [YPCNetworking postWithUrl:@"shop/user/signin"
                  refreshCache:YES
                        params:@{
                                 @"username" : self.phoneTF.text,
                                 @"password" : self.pwdTF.text,
                                 @"registration_id" : [JPUSHService registrationID] != nil ? [JPUSHService registrationID] : @"0"
                                 } success:^(id response) {
                                     if ([YPC_Tools judgeRequestAvailable:response]) {
                                         [YPCRequestCenter setUserInfoWithResponse:response];
                                         [LeanChatFactory invokeThisMethodAfterLoginSuccessWithClientId:response[@"data"][@"user"][@"hx_uname"] success:^{
                                             [YPCRequestCenter cacheUserKeychainWithSID:response[@"data"][@"session"][@"sid"]];
                                             if (weakSelf.SuccessLoginBlock) {
                                                 weakSelf.SuccessLoginBlock();
                                             }
                                             [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                         } failed:^(NSError *error) {
                                             YPCAppLog(@"%@", [error description]);
                                             [weakSelf failedLogin];
                                         }];
                                     }else {
                                         [weakSelf failedLogin];
                                     }
                                 }
                          fail:^(NSError *error) {
                              if ([error code] == -1009) {
                                  [YPC_Tools showSvpWithNoneImgHud:@"请检查网络连接"];
                              }
                              [weakSelf failedLogin];
                          }];
//    }];
}

- (void)startLoging
{
    [self.LoginBtn setTitle:@"" forState:UIControlStateNormal];
    [self.actitityV startAnimating];
}

- (void)failedLogin
{
    [self.LoginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.actitityV stopAnimating];
}

- (IBAction)pwdShowAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setBackgroundImage:IMAGE(@"logon_signin_icon_hidepassword") forState:UIControlStateNormal];
        self.pwdTF.secureTextEntry = NO;
    }else {
        [sender setBackgroundImage:IMAGE(@"logon_signin_icon_showpassword") forState:UIControlStateNormal];
        self.pwdTF.secureTextEntry = YES;
    }
}

#pragma mark - 手机号快捷登录
- (IBAction)phoneQuickLoginAction:(UIButton *)sender {
    [self.view endEditing:YES];
    RegistVC *regist = [[RegistVC alloc]init];
    regist.from = @"3";
    [self.navigationController pushViewController:regist animated:YES];
}

#pragma mark - 忘记密码
- (IBAction)forgetPwdAction:(UIButton *)sender {
    [self.view endEditing:YES];
    WS(weakSelf);
    [YPC_Tools customAlertViewWithTitle:nil
                                Message:@"通过手机号找回密码"
                              BtnTitles:nil
                         CancelBtnTitle:@"取消"
                    DestructiveBtnTitle:@"确定" actionHandler:nil
                          cancelHandler:^(LGAlertView *alertView) {
                              
                          }
                     destructiveHandler:^(LGAlertView *alertView) {
                        
                         RegistVC *regist = [[RegistVC alloc]init];
                         regist.from = @"2";
                         [weakSelf.navigationController pushViewController:regist animated:YES];
                    }];
    
}

#pragma mark - 微信登录
- (IBAction)weChatLoginAction:(UIButton *)sender {
    WS(weakSelf);
    [[UMSocialManager defaultManager] authWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        if (!error) {
            [YPC_Tools showSvpHud];
//            [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
                UMSocialAuthResponse *authresponse = result;
                NSDictionary *dic = @{
                                      @"unionid" : authresponse.uid,
                                      @"access_token" : authresponse.accessToken,
                                      @"openid" : authresponse.openid,
                                      @"registration_id" : [JPUSHService registrationID] != nil ? [JPUSHService registrationID] : @"0"
                                      };
                [YPCNetworking postWithUrl:@"shop/user/wechatlogin"
                              refreshCache:YES
                                    params:dic
                                   success:^(id response) {
                                       if ([YPC_Tools judgeRequestAvailable:response]) {
                                           [YPCRequestCenter setUserInfoWithResponse:response];
                                           [LeanChatFactory invokeThisMethodAfterLoginSuccessWithClientId:response[@"data"][@"user"][@"hx_uname"] success:^{
                                               [YPCRequestCenter cacheUserKeychainWithSID:response[@"data"][@"session"][@"sid"]];
                                               if (weakSelf.SuccessLoginBlock) {
                                                   weakSelf.SuccessLoginBlock();
                                               }
                                               [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                               [YPC_Tools dismissHud];
                                           } failed:^(NSError *error) {
                                               YPCAppLog(@"%@", [error description]);
                                               [weakSelf failedLogin];
                                               [YPC_Tools dismissHud];
                                           }];
                                       }else {
                                           [weakSelf failedLogin];
                                           [YPC_Tools dismissHud];
                                       }
                                   } fail:^(NSError *error) {
                                       [weakSelf failedLogin];
                                       [YPC_Tools showSvpHudError:@"登录失败"];
                                   }];
//            }];
        }else {
            if ([error code] == 2009) {
                [YPC_Tools showSvpWithNoneImgHud:@"登录取消授权"];
            }
            [weakSelf failedLogin];
        }
    }];
    
}

#pragma mark - 注册
- (IBAction)registAction:(UIButton *)sender {
    RegistVC *regist = [[RegistVC alloc]init];
    regist.from = @"1";
    [self.navigationController pushViewController:regist animated:YES];
}

#pragma mark - 关闭
- (IBAction)closeAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
