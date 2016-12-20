//
//  InvVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/23.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "InvVC.h"

@interface InvVC ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *personBtn;//个人
@property (strong, nonatomic) IBOutlet UIButton *InvTypeBtn;//普通发票
@property (strong, nonatomic) IBOutlet UIButton *saveBrn;//确认

@property (strong, nonatomic) IBOutlet UIButton *unitsBtn;//单位
@property (strong, nonatomic) IBOutlet UITextField *textField;//抬头
@property (strong, nonatomic) IBOutlet UIButton *detailsBtn;//明细
@property (nonatomic,strong)NSString *inv_title;
@end

@implementation InvVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"开具发票";
    self.InvTypeBtn.selected = YES;
    self.detailsBtn.selected = YES;
    
    if ([self.str isEqualToString:@"个人"]) {
        self.inv_title = @"个人";
        self.personBtn.selected = YES;
    }else if ([self.str isEqualToString:@"不需要发票"]){
         self.personBtn.selected = YES;
        self.inv_title = @"个人";
    }else{
        self.unitsBtn.selected = YES;
        self.textField.text = self.str;
        self.inv_title = self.textField.text;
    }
    
}


//普通发票
- (IBAction)invTypeBtnClick:(UIButton *)sender {
    
}
//确认
- (IBAction)saveBtnClick:(UIButton *)sender {
    
    if (self.unitsBtn.selected) {
        self.inv_title = self.textField.text;
    }
    
    [YPCNetworking postWithUrl:@"shop/flow/addinv"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"inv_title":self.inv_title
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               NSString *inv_id = response[@"data"][@"inv_id"];
                               [self.navigationController popViewControllerAnimated:YES];
                               if (self.backname) {
                                   self.backname(self.inv_title,inv_id);
                               }
                           }

                       }
                          fail:^(NSError *error) {
                              
                          }];
    
}
//明细
- (IBAction)DetailsBtnClick:(UIButton *)sender {
    sender.selected =!sender.selected;
}
//个人
- (IBAction)personBtnClick:(UIButton *)sender {
    sender.selected = YES;
    self.unitsBtn.selected =! sender.selected;
    self.inv_title = @"个人";
}
//单位
- (IBAction)unitsBtnClick:(UIButton *)sender {
    sender.selected = YES;
    self.personBtn.selected =! sender.selected;
    
}

- (void)textFieldChanged
{
    if (self.textField.text.length > 0 && self.inv_title.length != 0) {
        self.saveBrn.backgroundColor = [Color colorWithHex:@"#E4393C"];
        self.saveBrn.enabled = YES;
    }else {
        self.saveBrn.backgroundColor = [Color colorWithHex:@"#BFBFBF"];
        self.saveBrn.enabled = NO;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textField resignFirstResponder];
    return YES;
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
