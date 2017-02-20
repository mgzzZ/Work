//
//  AccounManagerVC.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/12/9.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "AccounManagerVC.h"
#import "AccountMangerCell.h"
#import "AreaManagerVC.h"
#import "SetNameVC.h"
#import "AccountBindingVC.h"

static NSString *Identifier = @"identifier";
@interface AccounManagerVC () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSDateFormatter *formatter;
@end

@implementation AccounManagerVC

#pragma mark - 懒加载
- (UIImagePickerController *)imagePicker
{
    if (_imagePicker) {
        return _imagePicker;
    }
    _imagePicker = [UIImagePickerController new];
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    return _imagePicker;
}
- (UIDatePicker *)datePicker
{
    if (_datePicker) {
        return _datePicker;
    }
    _datePicker = [UIDatePicker new];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    NSDate* minDate = [NSDate dateWithTimeIntervalSince1970:-1577952000];;
    NSDate* maxDate = [NSDate date];
    _datePicker.minimumDate = minDate;
    _datePicker.maximumDate = maxDate;
    _datePicker.frame = CGRectMake(0.f, 0.f, self.view.frame.size.width, 110.f);
    return _datePicker;
}
- (NSDateFormatter *)formatter {
    if (_formatter) {
        return _formatter;
    }
    _formatter =[[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy-MM-dd"];
    return _formatter;
}

#pragma mark - VC声明周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    
    self.titleArr = @[
                      @[@"头像", @"昵称", @"性别", @"出生日期"],
                      @[@"收货地址", @"账号绑定"]
                      ];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AccountMangerCell class]) bundle:nil] forCellReuseIdentifier:Identifier];
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountMangerCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    cell.indexPath = indexPath;
    cell.tempStr = [self.titleArr[indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerV = [UIView new];
    footerV.backgroundColor = [Color colorWithHex:@"F1F1F1"];
    return footerV;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    // 设置头像
                    [self setAvatarImage];
                    break;
                case 1:
                    // 设置昵称
                    [self setUserName];
                    break;
                case 2:
                    // 设置性别
                    [self setUserSex];
                    break;
                case 3:
                    // 出生日期
                    [self setUserBirthday];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:{
                    // 收货地址
                    AreaManagerVC *vc = [AreaManagerVC new];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 1:{
                    // 账号绑定
                    AccountBindingVC *vc = [AccountBindingVC new];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - Prviate Method
- (void)setAvatarImage
{
    WS(weakSelf);
    [YPC_Tools customSheetViewWithTitle:nil
                                Message:nil
                              BtnTitles:@[@"拍照", @"从相册选择"]
                         CancelBtnTitle:@"取消"
                    DestructiveBtnTitle:nil
                          actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                              switch (index) {
                                  case 0:{
                                      weakSelf.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                      [weakSelf presentViewController:_imagePicker animated:YES completion:nil];
                                  }
                                      break;
                                  case 1:{
                                      weakSelf.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                      [weakSelf presentViewController:_imagePicker animated:YES completion:nil];
                                  }
                                      break;
                                      
                                  default:
                                      break;
                              }
                          } cancelHandler:nil
                     destructiveHandler:nil];
}

- (void)setUserName
{
    WS(weakSelf);
    SetNameVC *nameVC = [SetNameVC new];
    [nameVC setNameSavedBlock:^(NSString *str) {
        if (str) {
            [weakSelf.tableView reloadData];
        }
    }];
    [self.navigationController pushViewController:nameVC animated:YES];
}

- (void)setUserSex
{
    WS(weakSelf);
    [YPC_Tools customSheetViewWithTitle:nil
                                Message:nil
                              BtnTitles:@[@"男", @"女"]
                         CancelBtnTitle:@"取消"
                    DestructiveBtnTitle:nil
                          actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                              [weakSelf sexWithIndex:index];
                          } cancelHandler:nil
                     destructiveHandler:nil];
}
- (void)sexWithIndex:(NSInteger)idx
{
    NSString *member_sex = nil;
    if (idx == 0) {
        member_sex = @"1";
    }else if (idx == 1) {
        member_sex = @"2";
    }
    [YPCNetworking postWithUrl:@"shop/user/editinfo"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{@"member_sex" : member_sex}]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               [YPC_Tools showSvpWithNoneImgHud:@"修改成功"];
                               [[YPCRequestCenter shareInstance].model setMember_sex:member_sex];
                               [self.tableView reloadData];
                           }
                       }
                          fail:^(NSError *error) {
                              [YPC_Tools showSvpWithNoneImgHud:@"修改性别失败"];
                          }];
}

- (void)setUserBirthday
{
    WS(weakSelf);
    LGAlertView *alertV = [[LGAlertView alloc] initWithViewAndTitle:nil
                                                            message:nil
                                                              style:LGAlertViewStyleActionSheet
                                                               view:self.datePicker
                                                       buttonTitles:nil
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:@"完成"
                                                      actionHandler:nil
                                                      cancelHandler:nil
                                                 destructiveHandler:^(LGAlertView *alertView) {
                                                     
                                                     [YPCNetworking postWithUrl:@"shop/user/editinfo"
                                                                   refreshCache:YES
                                                                         params:[YPCRequestCenter getUserInfoAppendDictionary:@{@"member_birthday" : [weakSelf.formatter stringFromDate:_datePicker.date]}]
                                                                        success:^(id response) {
                                                                            if ([YPC_Tools judgeRequestAvailable:response]) {
                                                                                [YPC_Tools showSvpWithNoneImgHud:@"修改成功"];
                                                                                [[YPCRequestCenter shareInstance].model setMember_birthday:[weakSelf.formatter stringFromDate:weakSelf.datePicker.date]];
                                                                                [weakSelf.tableView reloadData];
                                                                            }
                                                                        }
                                                                           fail:^(NSError *error) {
                                                                               [YPC_Tools showSvpWithNoneImgHud:@"修改生日失败"];
                                                                           }];
                                                 }];
    alertV.cancelButtonFont = LightFont(16);
    alertV.cancelButtonTitleColor = [Color colorWithHex:@"#3B3B3B"];
    alertV.cancelButtonTitleColorHighlighted = [UIColor whiteColor];
    alertV.cancelButtonBackgroundColor = [UIColor whiteColor];
    alertV.cancelButtonBackgroundColorHighlighted = [Color colorWithHex:@"#3B3B3B"];
    alertV.cancelButtonTextAlignment = NSTextAlignmentCenter;
    
    alertV.destructiveButtonFont = LightFont(16);
    alertV.destructiveButtonTitleColor = [Color colorWithHex:@"#3B3B3B"];
    alertV.destructiveButtonTitleColorHighlighted = [UIColor whiteColor];
    alertV.destructiveButtonBackgroundColor = [UIColor whiteColor];
    alertV.destructiveButtonBackgroundColorHighlighted = [Color colorWithHex:@"#3B3B3B"];
    alertV.destructiveButtonTextAlignment = NSTextAlignmentCenter;
    
    [alertV showAnimated:YES completionHandler:nil];

}

#pragma mark - UIImagePickerControllerDeleagte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    if (image) {
        WS(weakSelf);
        [YPCNetworking uploadImage:image
                          progress:^(NSString *key, float percent) {
                              [YPC_Tools showSvpWithPercentWithProgress:percent];
                          } success:^(NSString *url) {
                              [YPCNetworking postWithUrl:@"shop/user/editinfo"
                                            refreshCache:YES
                                                  params:[YPCRequestCenter getUserInfoAppendDictionary:@{@"member_avatar" : url}]
                                                 success:^(id response) {
                                                     if ([YPC_Tools judgeRequestAvailable:response]) {
                                                         [YPC_Tools showSvpWithNoneImgHud:@"修改成功"];
                                                         [weakSelf.tableView reloadData];
                                                         [[YPCRequestCenter shareInstance].model setMember_avatar:url];
                                                         [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                                     }
                                                 }
                                                    fail:^(NSError *error) {
                                                        [YPC_Tools showSvpWithNoneImgHud:@"修改头像失败"];
                                                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                                    }];
                          } failure:^{
                              [YPC_Tools showSvpWithNoneImgHud:@"修改头像失败"];
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
