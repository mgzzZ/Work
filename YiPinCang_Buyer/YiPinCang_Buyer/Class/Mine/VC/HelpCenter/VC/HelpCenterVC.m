//
//  HelpCenterVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/7.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "HelpCenterVC.h"
#import "HelpCenterCell.h"
#import "FeedbackVC.h"
#import "HelpModel.h"
#import "HelpDetailVC.h"
#import "WebViewController.h"
@interface HelpCenterVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *nameArr;
@property (nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation HelpCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"帮助中心";
    self.view.backgroundColor = [Color colorWithHex:@"#EFEFEF"];
    self.nameArr = @[@[@"常见问题"],@[@"通知公告",@"商务合作",@"意见反馈"]];
    [self getData];
}


- (void)getData{
    WS(weakself);
    [YPCNetworking postWithUrl:@"shop/help/articlenav"
                  refreshCache:YES
                        params:@{
                               
                                 }
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakself.dataArr = [HelpModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                               [weakself.tableView reloadData];
                           }
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.nameArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 7)];
    view.backgroundColor = [Color colorWithHex:@"#efefef"];
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.nameArr[section];
    return arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 47;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId  = @"cell";
    HelpCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HelpCenterCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSArray *imgArr = @[@[@"mine_helpcenter_question_icon"],@[@"mine_helpcenter_notice_icon",@"mine_helpcenter_bineses_icon",@"mine_helpcenter_feedback_icon"]];
    NSArray *img = imgArr[indexPath.section];
    NSArray *arr = self.nameArr[indexPath.section];
    cell.titleLab.text = arr[indexPath.row];
    [cell.img setImage:[UIImage imageNamed:img[indexPath.row]]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            FeedbackVC *feed = [[FeedbackVC alloc]init];
            [self.navigationController pushViewController:feed animated:YES];
        }else{
            if (indexPath.row == 1) {
                //商务合作
                WebViewController *web = [[WebViewController alloc]init];
                web.navTitle = @"商务合作";
                web.homeUrl = [self returnUrl:@"商务合作"];
                [self.navigationController pushViewController:web animated:YES];
            }else{
                //通知公告
                HelpDetailVC *help = [[HelpDetailVC alloc]init];
                help.name = @"通知公告";
                help.ac_id = [self returnAcid:@"通知公告"];
                [self.navigationController pushViewController:help animated:YES];
            }
        }
    }else{
        //常见问题
        HelpDetailVC *help = [[HelpDetailVC alloc]init];
        help.name = @"常见问题";
        help.ac_id = [self returnAcid:@"常见问题"];
        [self.navigationController pushViewController:help animated:YES];
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

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        self.tableView.backgroundColor = [Color colorWithHex:@"0xefefef"];
        [self.view addSubview:_tableView];
        _tableView.tableFooterView = [UIView new];
        _tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    }
    return _tableView;
}

- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


- (NSString *)returnAcid:(NSString *)acName{
    NSString *ac_id = @"";
    for (int i = 0; i < self.dataArr.count; i++) {
        HelpModel *model = self.dataArr[i];
        if ([model.ac_name isEqualToString:acName]) {
            ac_id = model.ac_id;
        }
    }
    return ac_id;
}
- (NSString *)returnUrl:(NSString *)acName{
    NSString *url = @"";
    for (int i = 0; i < self.dataArr.count; i++) {
        HelpModel *model = self.dataArr[i];
        if ([model.ac_name isEqualToString:acName]) {
            url = model.url;
        }
    }
    return url;
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
