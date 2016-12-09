//
//  AccounManagerVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/7.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "AccounManagerVC.h"
#import "AccountMangerCell.h"
#import "HelpCenterCell.h"
@interface AccounManagerVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *nameArr;
@end

@implementation AccounManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"账号管理";
    self.view.backgroundColor = [Color colorWithHex:@"#EFEFEF"];
    self.nameArr = @[@"会员等级",@"我的二维码",@"收货地址管理",@"账号绑定"];
    [self setup];
}
- (void)setup{
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [Color colorWithHex:@"#EFEFEF"];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 7)];
    view.backgroundColor = [Color colorWithHex:@"#efefef"];
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return 1;
        }
            break;
        case 2:
        {
            return 4;
        }
            break;
            
        default:
            break;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 83;
    }else{
        return 47;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellId = @"one";
        AccountMangerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"AccountMangerCell" owner:self options:nil];
            cell = nib[0];
        }
        [cell.txImg sd_setImageWithURL:[NSURL URLWithString:[YPCRequestCenter shareInstance].model.member_avatar] placeholderImage:YPCImagePlaceHolder];
        cell.nameLab.text = [YPCRequestCenter shareInstance].model.name;
        cell.titleLab.text = [YPCRequestCenter shareInstance].model.rank_level;

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else if (indexPath.section == 1){
        static NSString *cellId = @"two";
        AccountMangerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"AccountMangerCell" owner:self options:nil];
            cell = nib[1];
        }
        [cell.leftBtn addTarget:self action:@selector(sizeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.rightBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else{
        static NSString *cellId = @"three";
        HelpCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"HelpCenterCell" owner:self options:nil];
            cell = nib[0];
        }
        if (indexPath.row == 1) {
            UIImageView *img = [[UIImageView alloc]initWithImage:IMAGE(@"mine_accountmanagement_icon_qrcode")];
            [cell.contentView addSubview:img];
            img.sd_layout.centerYEqualToView(cell.contentView)
            .widthIs(25)
            .heightIs(25)
            .rightSpaceToView(cell.contentView,45);
        }
        cell.titleLab.text = self.nameArr[indexPath.row];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


/**
 尺码助手
 */
- (void)sizeBtnClick{
    
}

/**
 添加档案
 */
- (void)addBtnClick{
    
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
