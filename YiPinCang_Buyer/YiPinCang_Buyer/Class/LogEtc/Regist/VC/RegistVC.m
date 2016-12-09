//
//  RegistVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "RegistVC.h"
#import "WriteCodeVC.h"
@interface RegistVC ()
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation RegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_from isEqualToString:@"1"]) {
        _titleLab.text = @"注册壹品仓";
    }else if([_from isEqualToString:@"2"]){
        _titleLab.text = @"请输入手机号";
    }else{
        _titleLab.text = @"手机快捷登录";
    }
    _nextBtn.userInteractionEnabled = NO;
}
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)NextBtnClick:(UIButton *)sender {
    if (![_phoneTextField.text isValidPhone]) {
        [YPC_Tools showSvpWithNoneImgHud:@"请输入正确手机号"];
    }else{
        [YPCNetworking postWithUrl:@"shop/user/smscodesend"
                      refreshCache:YES
                            params:@{@"tel" : _phoneTextField.text,
                                     @"type":_from
                                     }
                           success:^(id response) {
                               if ([YPC_Tools judgeRequestAvailable:response]) {
                                   WriteCodeVC *write = [[WriteCodeVC alloc]init];
                                   write.phoneNumber = _phoneTextField.text;
                                   write.sign = response[@"data"][@"sign"];
                                   write.from = _from;
                                   [self.navigationController pushViewController:write animated:YES];
                               }
                           }
                              fail:^(NSError *error) {
                                  
                              }];
        
        
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > 11) {
        _nextBtn.userInteractionEnabled = YES;
        _nextBtn.backgroundColor = [Color colorWithHex:@"#36A74D"];
        return NO;
    }else if(toBeString.length == 11){
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
    if (self.phoneTextField.isFirstResponder) {
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
