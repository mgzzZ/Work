//
//  PageSubCollectVC.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/5.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "PageSubHistoryVC.h"
#import "PageSubHistoryCell.h"

static NSString *Identifier = @"historyIdentifier";
@interface PageSubHistoryVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableV;

@end

@implementation PageSubHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tableV registerNib:[UINib nibWithNibName:NSStringFromClass([PageSubHistoryCell class]) bundle:nil] forCellReuseIdentifier:Identifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PageSubHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92.f;
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
