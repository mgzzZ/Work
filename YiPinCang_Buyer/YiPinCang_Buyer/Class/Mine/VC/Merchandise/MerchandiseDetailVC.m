//
//  MerchandiseDetailVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/4.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "MerchandiseDetailVC.h"

@interface MerchandiseDetailVC ()
@property (strong, nonatomic) IBOutlet UIView *ContainVIew;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ContainViewHeight;

@end

@implementation MerchandiseDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商品详情";
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
