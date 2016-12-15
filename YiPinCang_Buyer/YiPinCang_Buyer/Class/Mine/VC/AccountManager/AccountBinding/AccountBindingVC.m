//
//  AccountBindingVC.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/12/9.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "AccountBindingVC.h"
#import "RegistVC.h"

static NSString *Identifier = @"identifier";
@interface AccountBindingVC () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSArray *imgArr;
@property (nonatomic, strong) NSArray *titleArr;

@end

@implementation AccountBindingVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"账号绑定";
    
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:Identifier];
    self.imgArr = @[IMAGE(@"mine_phone"), IMAGE(@"mine_wechat")];
    self.titleArr = @[@"手机", @"微信"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = self.imgArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.accessoryView = [self createAccessoryInfoLabel:indexPath.row andCell:cell];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakSelf);
    switch (indexPath.row) {
        case 0: {
            [YPC_Tools customSheetViewWithTitle:nil
                                        Message:nil
                                      BtnTitles:nil
                                 CancelBtnTitle:@"取消"
                            DestructiveBtnTitle:[[YPCRequestCenter shareInstance].model.member_mobile isEqual:[NSNull null]] || [YPCRequestCenter shareInstance].model.member_mobile == nil ? @"更换手机号码" : @"绑定手机号码"
                                  actionHandler:nil
                                  cancelHandler:nil
                             destructiveHandler:^(LGAlertView *alertView) {
                                 RegistVC *regVC = [RegistVC new];
                                 regVC.from = @"4";
                                 UINavigationController *regNav = [[UINavigationController alloc]initWithRootViewController:regVC];
                                 regVC.navigationController.navigationBar.hidden = YES;
                                 [weakSelf presentViewController:regNav animated:YES completion:nil];
                             }];
        }
            break;
        case 1:
            if (![YPCRequestCenter shareInstance].model.weixin_info) {
                WS(weakSelf);
                [[UMSocialManager defaultManager] authWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
                    if (!error) {
                        UMSocialAuthResponse *authresponse = result;
                        NSDictionary *dic = @{
                                              @"unionid" : authresponse.uid,
                                              @"access_token" : authresponse.accessToken,
                                              @"openid" : authresponse.openid,
                                              };
                        [YPCNetworking postWithUrl:@"shop/user/setwechat"
                                      refreshCache:YES
                                            params:[YPCRequestCenter getUserInfoAppendDictionary:dic]
                                           success:^(id response) {
                                               if ([YPC_Tools judgeRequestAvailable:response]) {
                                                   [YPC_Tools showSvpWithNoneImgHud:@"绑定成功"];
                                                   [[YPCRequestCenter shareInstance].model setWeixin_info:response[@"data"][@"weixin_info"]];
                                                   [weakSelf.tableview reloadData];
                                               }
                                           } fail:^(NSError *error) {
                                               YPCAppLog(@"%@", [error description]);
                                           }];
                    }else {
                        if ([error code] == 2009) {
                            [YPC_Tools showSvpWithNoneImgHud:@"登录取消授权"];
                        }
                    }
                }];
            }
            break;
        default:
            break;
    }
}

- (UIView *)createAccessoryInfoLabel:(NSInteger)index andCell:(UITableViewCell *)cell
{
    UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 60)];
    
    UIImageView *arrowV = [UIImageView new];
    arrowV.image = IMAGE(@"mine_icon_more");
    [accessoryView addSubview:arrowV];
    [arrowV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(accessoryView.mas_centerY);
        make.right.equalTo(accessoryView.mas_right).offset(12);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    
    UILabel *lbl = [UILabel new];
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.textColor = [Color colorWithHex:@"#999999"];
    lbl.textAlignment = NSTextAlignmentRight;
    [accessoryView addSubview:lbl];
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(arrowV.mas_centerY);
        make.right.equalTo(arrowV.mas_right).offset(-20);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(20);
    }];
    
    if (index == 0) {
        if ([[YPCRequestCenter shareInstance].model.member_mobile isEqual:[NSNull null]] || [YPCRequestCenter shareInstance].model.member_mobile == nil) {
            lbl.text = @"未绑定";
        }else {
            lbl.text = [YPCRequestCenter shareInstance].model.member_mobile;
        }
        return accessoryView;
    }else if (index == 1) {
        if ([[YPCRequestCenter shareInstance].model.weixin_info isEqual:[NSNull null]] || [YPCRequestCenter shareInstance].model.weixin_info == nil) {
            lbl.text = @"未绑定";
        }else {
            lbl.text = [YPCRequestCenter shareInstance].model.weixin_info;
        }
        return accessoryView;
    }else {
        return nil;
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
