//
//  AreaManagerVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/23.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "AreaManagerVC.h"
#import "AreaCell.h"
#import "AreaListModel.h"
#import "AddAreaVC.h"
@interface AreaManagerVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,assign)NSInteger row;
@end

@implementation AreaManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"收货地址管理";
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArr = [[NSMutableArray alloc]init];
    UIButton *nextBtn = [[UIButton alloc]init];
    [self.view addSubview:nextBtn];
    nextBtn.backgroundColor = [UIColor redColor];
    [nextBtn setTitle:@"确认" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    nextBtn.layer.cornerRadius = 3;
    nextBtn.sd_layout
    .leftSpaceToView(self.view,15)
    .rightSpaceToView(self.view,15)
    .bottomSpaceToView(self.view,10)
    .heightIs(43);
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 44, 44);
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"删除" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(deleteAreaClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
    
    [self getDataList];
    
}

#pragma mark-- init

- (void)setup{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(64, 0, 63, 0));
    UIView *foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 47)];
    foot.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = foot;
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.text = @"添加新地址";
    titleLab.font = [UIFont systemFontOfSize:15];
    [foot addSubview:titleLab];
    titleLab.sd_layout
    .leftSpaceToView(foot,15)
    .topEqualToView(foot)
    .bottomEqualToView(foot)
    .widthIs(200);
    UIImageView *img = [[UIImageView alloc]initWithImage:IMAGE(@"find_cart_button_addadress")];
    [foot addSubview:img];
    img.sd_layout
    .rightSpaceToView(foot,15)
    .widthIs(25)
    .heightIs(25)
    .centerYEqualToView(foot);
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [Color colorWithHex:@"0xefefef"];
    [foot addSubview:lineView];
    lineView.sd_layout
    .leftEqualToView(foot)
    .rightEqualToView(foot)
    .bottomEqualToView(foot)
    .heightIs(1);
    UIView *lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = [Color colorWithHex:@"0xefefef"];
    [foot addSubview:lineView2];
    lineView2.sd_layout
    .leftEqualToView(foot)
    .rightEqualToView(foot)
    .topEqualToView(foot)
    .heightIs(1);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [foot addSubview:btn];
    btn.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    [btn addTarget:self action:@selector(addAreaClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}

#pragma mark-- getdata

- (void)getDataList{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/address/list"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.dataArr = [AreaListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                               if (!weakSelf.tableView) {
                                   [weakSelf setup];
                               }else{
                                   [weakSelf.tableView reloadData];
                               }
                               
                           }
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}

#pragma mark- delegate;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 42;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 42)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text = @"收货地址";
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textAlignment = NSTextAlignmentLeft;
    [view addSubview:titleLab];
    titleLab.sd_layout
    .leftSpaceToView(view,15)
    .topEqualToView(view)
    .bottomEqualToView(view)
    .rightSpaceToView(view,10);
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [Color colorWithHex:@"0xefefef"];
    [view addSubview:lineView];
    lineView.sd_layout
    .leftEqualToView(view)
    .rightEqualToView(view)
    .bottomEqualToView(view)
    .heightIs(1);
    return view;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"AreaCell";
    AreaCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AreaCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArr[indexPath.row];
    cell.setBtn.tag = indexPath.row;
    [cell.setBtn addTarget:self action:@selector(setBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AreaCell *cell = (AreaCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.chooseBtn.selected =! cell.chooseBtn.selected;
    self.row = indexPath.row;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AreaCell *cell = (AreaCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.chooseBtn.selected = NO;
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
#pragma mark- 确认按钮

//确认
- (void)nextBtnClick{
    NSIndexPath *index = [NSIndexPath indexPathForRow:self.row inSection:0];
    AreaCell *cell = (AreaCell *)[self.tableView cellForRowAtIndexPath:index];
    
    if (cell.chooseBtn.selected == YES) {
        AreaListModel *model = self.dataArr[self.row];
        if (self.backArea) {
            self.backArea(cell.nameLab.text,cell.areaLab.text,model.is_default,model.address_id,model.area_id,model.city_id);
            
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
    }
}

#pragma mark- 添加新地址

//添加新地址
- (void)addAreaClick{
    WS(weakself);
    AddAreaVC *add = [[AddAreaVC alloc]init];
    add.type = @"1";
    add.backreload = ^{
        [weakself getDataList];
    };
    [self.navigationController pushViewController:add animated:YES];
    
}

#pragma mark- 删除新地址

//删除新地址
- (void)deleteAreaClick{
    WS(weakself);
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:self.row inSection:0];
    AreaListModel *model = self.dataArr[self.row];
    AreaCell *cell = (AreaCell *)[self.tableView cellForRowAtIndexPath:index];
    
    if (cell.chooseBtn.selected == YES) {
        [YPCNetworking postWithUrl:@"shop/address/delete"
                      refreshCache:YES
                            params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                   @"id":model.address_id
                                                                                   }]
                           success:^(id response) {
                               if ([YPC_Tools judgeRequestAvailable:response]) {
                                   
                                   [weakself.dataArr removeObject:model];
                                   [weakself.tableView reloadData];
                               }
                               
                           }
                              fail:^(NSError *error) {
                                  
                              }];
    }
    
}

#pragma mark- 编辑地址(更改地址)

- (void)setBtnClick:(UIButton *)sender{
    AreaListModel *model = self.dataArr[sender.tag];
    WS(weakself);
    AddAreaVC *add = [[AddAreaVC alloc]init];
    add.name = model.true_name;
    add.address = model.address;
    add.areaid = model.address_id;
    add.phone = model.mob_phone;
    add.type = @"2";
    add.backreload = ^{
        [weakself getDataList];
    };
    [self.navigationController pushViewController:add animated:YES];
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
