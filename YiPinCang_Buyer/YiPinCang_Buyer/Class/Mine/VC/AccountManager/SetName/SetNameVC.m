//
//  SetNameVC.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/12/9.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "SetNameVC.h"

@interface SetNameVC () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UILabel *nameLenghLabel;
@end

@implementation SetNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改昵称";
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self setExtendedLayoutIncludesOpaqueBars:NO];
    
    self.nameTF.text = [YPCRequestCenter shareInstance].model.member_truename;
    self.nameLenghLabel.text = [NSString stringWithFormat:@"%ld/16", self.nameTF.text.length];
    
    [self.nameTF addTarget:self action:@selector(textFieldChangeVaule:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldChangeVaule:(UITextField *)TF
{
//    self.nameTF.text = [TF.text clearSpaceAndReturn];
    self.nameLenghLabel.text = [NSString stringWithFormat:@"%ld/16", self.nameTF.text.length];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.nameTF) {
        if (textField.text.length > 16) {
            textField.text = [textField.text substringToIndex:16];
        }
    }
    self.nameTF.text = [textField.text clearSpaceAndReturn];
    self.nameLenghLabel.text = [NSString stringWithFormat:@"%ld/16", self.nameTF.text.length];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) return YES;
    
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > 16) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    if (![textField.text isEmpty]) {
        WS(weakSelf);
        [YPCNetworking postWithUrl:@"shop/user/editinfo"
                      refreshCache:YES
                            params:[YPCRequestCenter getUserInfoAppendDictionary:@{@"member_truename" : textField.text}]
                           success:^(id response) {
                               if ([YPC_Tools judgeRequestAvailable:response]) {
                                   [YPC_Tools showSvpWithNoneImgHud:@"修改成功"];
                                   weakSelf.NameSavedBlock(textField.text);
                                   [[YPCRequestCenter shareInstance].model setMember_truename:textField.text];
                                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                       [weakSelf.navigationController popViewControllerAnimated:YES];
                                   });
                               }
                           }
                              fail:^(NSError *error) {
                                  [YPC_Tools showSvpWithNoneImgHud:@"修改昵称失败"];
                              }];
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.nameTF.isFirstResponder) {
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
