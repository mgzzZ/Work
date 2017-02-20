//
//  SetVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/4.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "SetVC.h"
#import "SetCell.h"
#import "LeanChatFactory.h"
#import "WebViewController.h"
@interface SetVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic, strong) NSArray *imgArr;
@property (nonatomic, strong) NSArray *nameArr;
@property (nonatomic, copy) NSString *sizeStr;
@end

@implementation SetVC
{
    NSInteger sectionCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = [Color colorWithHex:@"#EFEFEF"];
    
    self.imgArr = @[
                    @[@"mine_set_icon_delete"],
                    @[@"mine_set_icon_about"],
                    [YPCRequestCenter isLogin] ? @[@"mine_set_icon_close"] : @""
                    ];
    self.nameArr = @[
                     @[@"清除本地缓存"],
                     @[@"关于我们"],
                     [YPCRequestCenter isLogin] ? @[@"退出登录"] : @""
                     ];
    if ([YPCRequestCenter isLogin]) {
        sectionCount = 3;
    }else {
        sectionCount = 2;
    }
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return sectionCount;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.nameArr[section];
    return arr.count;
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
    
    [cell.icon setImage:[UIImage imageNamed:self.imgArr[indexPath.section][indexPath.row]]];
    cell.nameLab.text = self.nameArr[indexPath.section][indexPath.row];
    switch (indexPath.section) {
        case 0:
        {
            cell.nameLab.textColor = [UIColor blackColor];
            cell.nextImg.hidden = YES;
            cell.countLab.hidden = NO;
            cell.countLab.text = @"计算中...";
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                CGFloat size = [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtPath:NSTemporaryDirectory()];
                NSString *message = size > 1 ? [NSString stringWithFormat:@"%.2fM", size] : [NSString stringWithFormat:@"%.2fK", size * 1024.0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.countLab.text = message;
                    self.sizeStr = message;
                });
            });
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
                if (self.sizeStr.length == 0) {
                    return;
                }
                NSString *message = [NSString stringWithFormat:@"确定要清理手机中的缓存%@?", self.sizeStr];
                
                [YPC_Tools customAlertViewWithTitle:@"提示:" Message:message BtnTitles:@[@"确认"] CancelBtnTitle:@"取消" DestructiveBtnTitle:nil actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                    [self cleanCaches:NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject];
                    [self cleanCaches:NSTemporaryDirectory()];
                    [[SDImageCache sharedImageCache] cleanDisk];
                    [YPCNetworking clearCaches];
                    SetCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    cell.countLab.text = [NSString stringWithFormat:@"%.2fk",0.00];
                } cancelHandler:nil destructiveHandler:nil];
            }else if (indexPath.row == 2)
            {
                
            }else{
                
            }
        }
            break;
        case 1:{
            //关于我们
            WebViewController *web = [[WebViewController alloc]init];
            web.navTitle = @"关于我们";
            web.homeUrl = @"http://api.gongchangtemai.com/index.php?url=shop/help/aboutus";
            [self.navigationController pushViewController:web animated:YES];
        }
            break;
        case 2:
        {
            WS(weakSelf);
            [YPCNetworking postWithUrl:@"shop/user/signout"
                          refreshCache:YES
                                params:[YPCRequestCenter getUserInfo]
                               success:^(id response) {
                                   if ([YPC_Tools judgeRequestAvailable:response]) {
                                       [LeanChatFactory invokeThisMethodBeforeLogoutSuccess:^{
                                           [YPC_Tools showSvpWithNoneImgHud:@"退出成功"];
                                           [YPCRequestCenter removeCacheUserKeychain];
                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                               [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                                           });
                                       } failed:nil];
                                   }
                               } fail:^(NSError *error) {
                                   
                               }];
        }
            break;
        default:
            break;
    }
}




- (UITableView *)tableView{
    if (_tableView == nil   ) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:self.tableView];
        _tableView.scrollEnabled = NO;
        _tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [Color colorWithHex:@"#EFEFEF"];
    }
    return _tableView;
}


// 计算目录大小
- (CGFloat)folderSizeAtPath:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        // 获取该目录下的文件，计算其大小
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        size+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        size+=[YPCNetworking totalCacheSize];
        // 将大小转化为M
        return size / 1024.0 / 1024.0;
    }
    return 0;
}
// 根据路径删除文件
- (void)cleanCaches:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        // 获取该路径下面的文件名
        NSArray *childrenFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childrenFiles) {
            // 拼接路径
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            // 将文件删除
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
        
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
