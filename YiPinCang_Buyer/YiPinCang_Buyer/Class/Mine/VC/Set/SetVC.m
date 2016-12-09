//
//  SetVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/4.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "SetVC.h"
#import "SetCell.h"
@interface SetVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation SetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = [Color colorWithHex:@"#EFEFEF"];
    [self setUp];
}
- (void)setUp{
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [Color colorWithHex:@"#EFEFEF"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            return 4;
        }
            break;
            case 1:
        {
            return 1;
        }
            break;
            case 2:
        {
            return 1;
        }
            break;
        default:
            break;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 7)];
    view.backgroundColor = [Color colorWithHex:@"#EFEFEF"];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 47;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    SetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSArray *imgArr = @[
                    @[@"mine_set_icon_news",@"mine_set_icon_pic",@"mine_set_icon_delete",@"mine_set_icon_touchid"],
                        @[@"mine_set_icon_about"],
                        @[@"mine_set_icon_close"]
                        ];
    NSArray *nameArr = @[
                         @[@"推送消息设置",@"非WiFi环境下手动下载图片",@"清除本地缓存",@"使用Touch ID登录"],
                         @[@"关于我们"],
                         @[@"退出登录"]
                         ];
    [cell.icon setImage:[UIImage imageNamed:imgArr[indexPath.section][indexPath.row]]];
    cell.nameLab.text = nameArr[indexPath.section][indexPath.row];
    switch (indexPath.section) {
        case 0:
        {
            cell.nameLab.textColor = [UIColor blackColor];
            if (indexPath.row == 0) {
                cell.nextImg.hidden = NO;
            }else{
                cell.nextImg.hidden = YES;
                if (indexPath.row == 1 || indexPath.row == 3) {
                    cell.switchBtn.hidden = NO;
                }else{
                    cell.countLab.hidden = NO;
                    cell.countLab.text = @"5.6M";
                }
            }
            
        }
            break;
            case 1:
        {
            cell.nameLab.textColor = [UIColor blackColor];
        }
            break;
            case 2:
        {
            cell.nameLab.textColor = [Color colorWithHex:@"#E4393C"];
            cell.nextImg.hidden = YES;
        }
            break;
            
        default:
            break;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                
            }else if (indexPath.row == 2)
            {
                
            }else{
                
            }
        }
            break;
        case 1:{
            
        }
            break;
        case 2:
        {
            
        }
            break;
        default:
            break;
    }
}
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
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
