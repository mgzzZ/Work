//
//  WriteCodeVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "WriteCodeVC.h"
#import "SetPasswordVC.h"
#import "LoginSetPasswordVC.h"
#import "LeanChatFactory.h"
#import "JPUSHService.h"
#import "LoginVC.h"

static int countDown = 59;
@interface WriteCodeVC ()
@property (strong, nonatomic) IBOutlet UILabel *phoneLab;
@property (strong, nonatomic) IBOutlet UILabel *codeLab;
@property (strong, nonatomic) IBOutlet UITextField *codeTextfield;

@property (strong, nonatomic) IBOutlet UIButton *sendBtn;

@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic,copy)NSString *token;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (retain, nonatomic) NSTimer *t;//验证码倒计时定时器
@end

@implementation WriteCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _titleLab.text = @"输入验证码";
    NSString *priceStr = [NSString stringWithFormat:@"验证码已发送至  +86 %@",_phoneNumber];
    
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:priceStr];
    //更改字体颜色
    [mutableString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 7)];
    [mutableString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(7, priceStr.length - 7)];
    [mutableString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 7)];
    [mutableString addAttribute:NSForegroundColorAttributeName value:[Color colorWithHex:@"#7AC0FF"] range:NSMakeRange(7, priceStr.length - 7)];
    _phoneLab.attributedText = mutableString;
    if (_t) {
        [_t invalidate];
        _t = nil;
    }
    _t = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
    _sendBtn.userInteractionEnabled = NO;
    _nextBtn.userInteractionEnabled = NO;
}
- (void)countTime
{
    NSString *strCountDown = [NSString stringWithFormat:@"重新发送(%d秒)",countDown--];
    _codeLab.text = strCountDown;
    if (countDown ==-1) {
        countDown = 59;
        [_t invalidate];
        _t = nil;
        _sendBtn.userInteractionEnabled = YES;
        _codeLab.text = @"点击重新发送";
    }
}
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 重新发送

 @param sender 重新发送
 */
- (IBAction)sendBtnClick:(UIButton *)sender {
    
    [YPCNetworking postWithUrl:@"shop/user/smscodesend"
                  refreshCache:YES
                        params:@{
                       @"tel" : _phoneNumber,
                       @"type": _from
                                }
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               _sign = response[@"data"][@"sign"];
                               if (_t) {
                                   [_t invalidate];
                                   _t = nil;
                               }
                               _t = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
                               _sendBtn.userInteractionEnabled = NO;
                           }else{
                               
                           }
                       }
                          fail:^(NSError *error) {
                              
                          }];
}

/**
 下一步

 @param sender 下一步按钮
 */
- (IBAction)nextBtnClick:(id)sender {
    
    WS(weakSelf);
    [YPC_Tools showSvpHud];
    if (_codeTextfield.text.length == 0) {
        [YPC_Tools showSvpWithNoneImgHud:@"请输入验证码"];
    }else{
        [YPCNetworking postWithUrl:@"shop/user/smscodecheck"
                      refreshCache:YES
                            params:@{
                                     @"sign" : _sign,
                                     @"code":_codeTextfield.text
                                     }
                           success:^(id response) {
                               if ([YPC_Tools judgeRequestAvailable:response]) {
                                   _token = response[@"data"][@"token"];
                                   if ([_from isEqualToString:@"1"]) {
                                       SetPasswordVC *setpassword = [[SetPasswordVC alloc]init];
                                       setpassword.token = _token;
                                       [YPC_Tools dismissHud];
                                       [weakSelf.navigationController pushViewController:setpassword animated:YES];
                                   }else if ([_from isEqualToString:@"2"]) {
                                       LoginSetPasswordVC *Login = [[LoginSetPasswordVC alloc]init];
                                       Login.from = _from;
                                       Login.token = _token;
                                       Login.phoneNum = self.phoneNumber;
                                       [YPC_Tools dismissHud];
                                       [weakSelf.navigationController pushViewController:Login animated:YES];
                                   }else if ([_from isEqualToString:@"3"]) { // 快速登录
                                       if ([response[@"data"][@"ismemeber"] integerValue] == 0) {
                                           SetPasswordVC *setpassword = [[SetPasswordVC alloc]init];
                                           setpassword.token = _token;
                                           [YPC_Tools dismissHud];
                                           [weakSelf.navigationController pushViewController:setpassword animated:YES];
                                       }else {
                                           [weakSelf fastSignin];
                                       }
                                   }else if ([_from isEqualToString:@"4"]) { // 更换&绑定手机号
                                       [weakSelf setPhone];
                                   }
                               }
                           }
                              fail:^(NSError *error) {
                                  
                              }];
    }
}

#pragma mark - 快速登录
- (void)fastSignin
{
    WS(weakSelf);
//    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        [YPCNetworking postWithUrl:@"shop/user/fastsignin"
                      refreshCache:YES
                            params:@{
                                     @"token" : _token,
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
                                       [YPC_Tools showSvpWithNoneImgHud:@"登录失败"];
                                       [YPC_Tools dismissHud];
                                   }];
                               }
                           } fail:^(NSError *error) {
                               YPCAppLog(@"%@", [error description]);
                               [YPC_Tools showSvpWithNoneImgHud:@"登录失败"];
                               [YPC_Tools dismissHud];
                           }];
//    }];
}

#pragma mark - 设置手机号
- (void)setPhone
{
    WS(weakSelf);
    [YPCNetworking postWithUrl:@"shop/user/setphone"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{@"token" : _token}]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               if ([YPCRequestCenter shareInstance].model.member_mobile) { // 更换手机号
                                   [YPC_Tools showSvpWithNoneImgHud:@"更换手机号成功"];
                                   [[YPCRequestCenter shareInstance].model setMember_mobile:response[@"data"][@"phone"]];
                                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                       [YPC_Tools dismissHud];
                                       [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                   });
                               }else { // 绑定手机号
                                   SetPasswordVC *setpassword = [[SetPasswordVC alloc]init];
                                   setpassword.setType = SetPasswordBinding;
                                   setpassword.token = _token;
                                   [YPC_Tools dismissHud];
                                   [weakSelf.navigationController pushViewController:setpassword animated:YES];
                               }
                           }
                       } fail:^(NSError *error) {
                           [YPC_Tools showSvpWithNoneImgHud:@"设置失败"];
                           YPCAppLog(@"%@", [error description]);
                       }];
}

/**
 在线客服

 @param sender 在线客服按钮
 */
- (IBAction)onlineBtnClick:(UIButton *)sender {
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > 6) {
        _nextBtn.userInteractionEnabled = YES;
        _nextBtn.backgroundColor = [Color colorWithHex:@"#36A74D"];
        return NO;
    }else if(toBeString.length == 6){
        _nextBtn.userInteractionEnabled = YES;
        _nextBtn.backgroundColor = [Color colorWithHex:@"#36A74D"];
        return YES;
    }else{
        _nextBtn.userInteractionEnabled = NO;
        _nextBtn.backgroundColor = [Color colorWithHex:@"#CDCDCD"];
        return YES;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.codeTextfield.isFirstResponder) {
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
