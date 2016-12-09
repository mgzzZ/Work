//
//  LoginSetPasswordVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/2.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LoginSetPasswordVC.h"
#import "LoginVC.h"
#import "RegistModel.h"
#import "JPUSHService.h"
#import "LeanChatFactory.h"

@interface LoginSetPasswordVC ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UILabel *titileLab;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;

@end

@implementation LoginSetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _nextBtn.userInteractionEnabled = NO;
    if ([_from isEqualToString:@"3"]) {
        _titileLab.text = @"设置密码";
        _nameLab.text = @"您以后还可以使用手机号+密码的形式登录壹品仓哦!";
    }else{
        _titileLab.text = @"输入新密码";
        _nameLab.text = @"";
    }
    
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if(toBeString.length >= 6){
        _nextBtn.userInteractionEnabled = YES;
        _nextBtn.backgroundColor = [Color colorWithHex:@"#36A74D"];
        return YES;
    }else if(toBeString.length > 18){
        _nextBtn.userInteractionEnabled = YES;
        _nextBtn.backgroundColor = [Color colorWithHex:@"#36A74D"];
        return NO;
    }else{
        _nextBtn.userInteractionEnabled = NO;
        _nextBtn.backgroundColor = [Color colorWithHex:@"#CDCDCD"];
        return YES;
    }
}
- (IBAction)nextBtnClick:(UIButton *)sender {
    WS(weakSelf);
    if (_passwordTextField.text.length < 6) {
        [YPC_Tools showSvpWithNoneImgHud:@"请设置最少6位密码"];
    }else if (_passwordTextField.text.length == 0){
        [YPC_Tools showSvpWithNoneImgHud:@"请输入密码"];
    }else{
        if ([_from isEqualToString:@"3"]) {
            [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
                if (!registrationID) {
                    return;
                }
                [YPCNetworking postWithUrl:@"shop/user/fastsignin"
                              refreshCache:YES
                                    params:@{
                                             @"token" : _token,
                                             @"password":_passwordTextField.text,
                                             @"registration_id" : registrationID
                                             }
                                   success:^(id response) {
                                       if ([YPC_Tools judgeRequestAvailable:response]) {
                                           [YPCRequestCenter setUserInfoWithResponse:response];
                                           [LeanChatFactory invokeThisMethodAfterLoginSuccessWithClientId:response[@"data"][@"user"][@"hx_uname"] success:^{
                                               [YPCRequestCenter cacheUserKeychainWithSID:response[@"data"][@"session"][@"sid"]];
                                               [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                                               [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                           } failed:^(NSError *error) {
                                               YPCAppLog(@"%@", [error description]);
                                           }];
                                       }
                                   }
                                      fail:^(NSError *error) {
                                          YPCAppLog(@"%@", [error description]);
                                      }];
            }];
        }else{
            [YPCNetworking postWithUrl:@"shop/user/resetpasswd"
                          refreshCache:YES
                                params:@{
                                         @"token" : _token,
                                         @"password":_passwordTextField.text
                                         }
                               success:^(id response1) {
                                   if ([YPC_Tools judgeRequestAvailable:response1]) {   
                                       [self.navigationController popToRootViewControllerAnimated:YES];
                                   }
                               }
                                  fail:^(NSError *error) {
                                      YPCAppLog(@"%@", [error description]);
                                  }];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.passwordTextField.isFirstResponder) {
        [self.view endEditing:YES];
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
