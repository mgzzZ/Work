//
//  FeedbackVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/11.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "FeedbackVC.h"

@interface FeedbackVC ()<UITextViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIImageView *textImg;
@property (strong, nonatomic) IBOutlet UILabel *textLab;
@property (strong, nonatomic) IBOutlet UITextField *textfield;

@end

@implementation FeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"意见反馈";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [btn addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *mesItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = mesItem;
}
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        _textLab.text = @"请输入您的反馈内容";
        _textImg.hidden = NO;
    }else{
        _textLab.text = @"";
        _textImg.hidden = NO;
    }

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.textfield.isFirstResponder || self.textView.isFirstResponder) {
        [self.view endEditing:YES];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)saveClick:(UIButton *)sender{
    WS(weakSelf);
    if (self.textView.text.length == 0) {
        [YPC_Tools showSvpWithNoneImgHud:@"请输入反馈意见"];
    }else if (self.textfield.text.length == 0){
        [YPC_Tools showSvpWithNoneImgHud:@"请输入联系方式"];
    }else{
        [YPCNetworking postWithUrl:@"shop/help/feedback"
                      refreshCache:YES
                            params:@{
                                     @"content":weakSelf.textView.text,
                                     @"type":@"ios",
                                     @"contact":weakSelf.textfield.text
                                     }
                           success:^(id response) {
                               if ([YPC_Tools judgeRequestAvailable:response]) {
                                   [YPC_Tools showSvpWithNoneImgHud:@"反馈成功"];
                                   [weakSelf.navigationController popViewControllerAnimated:YES];
                                   
                               }
                               
                           }
                              fail:^(NSError *error) {
                                  
                              }];
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
