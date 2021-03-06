//
//  SetPasswordVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "SetPasswordVC.h"
#import "UserModel.h"
#import "JPUSHService.h"
#import "LeanChatFactory.h"
#import "LoginVC.h"

@interface SetPasswordVC ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *oldTextField;
@property (strong, nonatomic) IBOutlet UITextField *noOldPassword;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@end

@implementation SetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _titleLab.text = @"设置密码";
    _nextBtn.userInteractionEnabled = NO;
    [self.oldTextField addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
    [self.noOldPassword addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
}
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 注册

 @param sender 确定按钮
 */
- (IBAction)registBtnClick:(UIButton *)sender {
    WS(weakSelf);
    if (![_oldTextField.text isEqualToString:_noOldPassword.text]) {
        [YPC_Tools showSvpWithNoneImgHud:@"两次输入的密码不一致"];
    }else if (_oldTextField.text.length == 0){
        [YPC_Tools showSvpWithNoneImgHud:@"请输入密码"];
    }else{
        if (weakSelf.setType == SetPasswordBinding) {
            [YPC_Tools showSvpHud];
//            [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
                [YPCNetworking postWithUrl:@"shop/user/setpassword"
                              refreshCache:YES
                                    params:[YPCRequestCenter getUserInfoAppendDictionary:@{@"password":_oldTextField.text,}]
                                   success:^(id response) {
                                       if ([YPC_Tools judgeRequestAvailable:response]) {
                                           [YPC_Tools showSvpWithNoneImgHud:@"绑定手机号成功"];
                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                               [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                           });
                                       }
                                   }
                                      fail:^(NSError *error) {
                                          YPCAppLog(@"%@", [error description]);
                                      }];
//            }];
        }else {
            [YPC_Tools showSvpHud];
//            [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
                [YPCNetworking postWithUrl:@"shop/user/signup"
                              refreshCache:YES
                                    params:@{
                                             @"token" : _token,
                                             @"password":_oldTextField.text,
                                             @"registration_id" : [JPUSHService registrationID] != nil ? [JPUSHService registrationID] : @"0"
                                             }
                                   success:^(id response) {
                                       if ([YPC_Tools judgeRequestAvailable:response]) {
                                           [YPCRequestCenter setUserInfoWithResponse:response];
                                           [LeanChatFactory invokeThisMethodAfterLoginSuccessWithClientId:response[@"data"][@"user"][@"hx_uname"] success:^{
                                               [weakSelf.navigationController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                   if ([[obj class] isEqual:[LoginVC class]]) {
                                                       __block LoginVC *vc = obj;
                                                       if (vc.SuccessLoginBlock) {
                                                           vc.SuccessLoginBlock();
                                                       }
                                                       [YPCRequestCenter cacheUserKeychainWithSID:response[@"data"][@"session"][@"sid"]];
                                                       [YPC_Tools dismissHud];
                                                       [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                                       
                                                       *stop = YES;
                                                   }
                                               }];
                                           } failed:^(NSError *error) {
                                               YPCAppLog(@"%@", [error description]);
                                               [YPC_Tools showSvpWithNoneImgHud:@"注册失败"];
                                           }];
                                       }
                                   }
                                      fail:^(NSError *error) {
                                          YPCAppLog(@"%@", [error description]);
                                          [YPC_Tools showSvpWithNoneImgHud:@"注册失败"];
                                      }];
//            }];
        }
    }
}
- (IBAction)oldBtnClick:(UIButton *)sender {
    if (sender.selected == NO) {
        _oldTextField.secureTextEntry = NO;
    }else{
        _oldTextField.secureTextEntry = YES;
    }
    sender.selected =! sender.selected;
}
- (IBAction)noOldBtnClick:(UIButton *)sender {
    if (sender.selected == NO) {
        _noOldPassword.secureTextEntry = NO;
    }else{
        _noOldPassword.secureTextEntry = YES;
    }
    sender.selected =! sender.selected;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if(toBeString.length > 18){
        _nextBtn.userInteractionEnabled = YES;
        _nextBtn.backgroundColor = [Color colorWithHex:@"#36A74D"];
        return NO;
    }else{
        _nextBtn.userInteractionEnabled = NO;
        _nextBtn.backgroundColor = [Color colorWithHex:@"#CDCDCD"];
        return YES;
    }
}
- (void)textFieldChanged{
    if(_oldTextField.text.length == _noOldPassword.text.length && _oldTextField.text.length >= 6){
        _nextBtn.userInteractionEnabled = YES;
        _nextBtn.backgroundColor = [Color colorWithHex:@"#36A74D"];
        
    }else{
        _nextBtn.userInteractionEnabled = NO;
        _nextBtn.backgroundColor = [Color colorWithHex:@"#CDCDCD"];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.oldTextField.isFirstResponder || self.noOldPassword.isFirstResponder) {
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
