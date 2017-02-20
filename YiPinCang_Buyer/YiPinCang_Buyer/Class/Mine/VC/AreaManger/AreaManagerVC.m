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
@interface AreaManagerVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)UIButton *btn;
@end

@implementation AreaManagerVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getDataList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"收货地址";
    
    self.view.backgroundColor = [Color colorWithHex:@"0xefefef"];
    self.dataArr = [[NSMutableArray alloc]init];
    UIButton *nextBtn = [[UIButton alloc]init];
    [self.view addSubview:nextBtn];
    nextBtn.backgroundColor = [UIColor redColor];
    [nextBtn setTitle:@"添加收货地址" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    nextBtn.layer.cornerRadius = 3;
    nextBtn.sd_layout
    .leftSpaceToView(self.view,15)
    .rightSpaceToView(self.view,15)
    .bottomSpaceToView(self.view,10)
    .heightIs(43);
    self.btn = nextBtn; 
    [self getDataList];
    
}

#pragma mark-- init

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.rowHeight = 143;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = [Color colorWithHex:@"0xefefef"];
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        [self.view addSubview:_tableView];
        _tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(64, 13, 63, 13));
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
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
                                   [weakSelf.tableView reloadData];
                               }else{
                                   [weakSelf.tableView reloadData];
                               }
                               if (weakSelf.dataArr.count == 1 && [weakSelf.from isEqualToString:@"结算添加第一个地址"] ) {
                                   
                                   [YPC_Tools customAlertViewWithTitle:@"提示" Message:@"确定选择这条收货地址吗?" BtnTitles:@[@"确认"] CancelBtnTitle:@"取消" DestructiveBtnTitle:nil actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                                       AreaListModel *model = self.dataArr[0];
                                       if (weakSelf.backArea) {
                                           weakSelf.backArea([NSString stringWithFormat:@"%@ %@",model.true_name,model.tel_phone],[NSString stringWithFormat:@"%@ %@",model.area_info,model.address],model.is_default,model.address_id,model.area_id,model.city_id);
                                           weakSelf.from = @"结算";
                                           
                                       }
                                       [weakSelf.navigationController popViewControllerAnimated:YES];
                                       
                                   } cancelHandler:^(LGAlertView *alertView) {
                                       //点击取消的时候还要继续出发cell点击方法
                                       if ([weakSelf.from isEqualToString:@"结算添加第一个地址"]) {
                                           weakSelf.from = @"结算";
                                       }
                                   } destructiveHandler:nil];
                               }else{
                                   if ([weakSelf.from isEqualToString:@"结算添加第一个地址"]) {
                                       weakSelf.from = @"结算";
                                   }
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

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 143;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"AreaCell";
    AreaCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AreaCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AreaListModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    cell.setBtn.tag = indexPath.row;
    cell.deleteBtn.tag = indexPath.row;
    [cell.setBtn addTarget:self action:@selector(setBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.chooseBtn.tag = indexPath.row;
    [cell.chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.address_id isEqualToString:model.address_id]) {
        cell.bgView.layer.borderColor = [Color colorWithHex:@"#F00E37"].CGColor;
        cell.bgView.layer.borderWidth = 1;
    }else{
        cell.bgView.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.bgView.layer.borderWidth = 1;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_from isEqualToString:@"结算"]) {
        WS(weakself);
        [YPC_Tools customAlertViewWithTitle:@"提示" Message:@"确定选择这条收货地址吗?" BtnTitles:@[@"确认"] CancelBtnTitle:@"取消" DestructiveBtnTitle:nil actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
            AreaListModel *model = self.dataArr[indexPath.row];
            if (self.backArea) {
                self.backArea([NSString stringWithFormat:@"%@ %@",model.true_name,model.tel_phone],[NSString stringWithFormat:@"%@ %@",model.area_info,model.address],model.is_default,model.address_id,model.area_id,model.city_id);
                
            }
            [weakself.navigationController popViewControllerAnimated:YES];

        } cancelHandler:nil destructiveHandler:nil];
    
    }else if ([_from isEqualToString:@"待付款"]){
        WS(weakself);
        [YPC_Tools customAlertViewWithTitle:@"提示:" Message:@"收货地址只能修改一次" BtnTitles:@[@"确定"] CancelBtnTitle:@"取消" DestructiveBtnTitle:nil actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
            AreaListModel *model = weakself.dataArr[indexPath.row];
            [YPCNetworking postWithUrl:@"shop/orders/alteraddr"
                          refreshCache:YES
                                params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                       @"pay_sn":weakself.pay_sn,
                                                                                       @"address_id":model.address_id
                                                                                       }]
                               success:^(id response) {
                                   if ([YPC_Tools judgeRequestAvailable:response]) {
                                       [YPC_Tools showSvpWithNoneImgHud:@"修改地址成功!"];
                                       if (weakself.backArea) {
                                           weakself.backArea([NSString stringWithFormat:@"%@ %@",model.true_name,model.tel_phone],[NSString stringWithFormat:@"%@ %@",model.area_info,model.address],model.is_default,model.address_id,model.area_id,model.city_id);
                                           
                                       }
                                       
                                       [weakself.navigationController popViewControllerAnimated:YES];
                                   }
                               }
                                  fail:^(NSError *error) {
                                      
                                  }];
            
            
            
        } cancelHandler:nil destructiveHandler:nil];
    }
    for (int i = 0; i < self.dataArr.count; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
        AreaCell *cell = [tableView cellForRowAtIndexPath:index];
        cell.bgView.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.bgView.layer.borderWidth = 1;
    }
   AreaCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.bgView.layer.borderColor = [Color colorWithHex:@"#F00E37"].CGColor;
    cell.bgView.layer.borderWidth = 1;
}

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    AreaCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.bgView.layer.borderColor = [UIColor whiteColor].CGColor;
//    cell.bgView.layer.borderWidth = 1;
//}
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
    
        WS(weakself);

        AddAreaVC *add = [[AddAreaVC alloc]init];
        add.type = @"1";
        add.backreload = ^{
            if ([weakself.from isEqualToString:@"结算"]) {
                weakself.from = @"结算添加第一个地址";
            }
           // [weakself getDataList];
           
        };
        [self.navigationController pushViewController:add animated:YES];
   
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
- (void)deleteBtnClick:(UIButton *)sender{
    WS(weakself);
    [YPC_Tools customAlertViewWithTitle:@"提示" Message:@"确认删除这条收货地址吗?" BtnTitles:@[@"确认"] CancelBtnTitle:@"取消" DestructiveBtnTitle:nil actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
        AreaListModel *model = weakself.dataArr[sender.tag];
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
    } cancelHandler:nil destructiveHandler:nil];

}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    
    return scrollView.frame.origin.y ;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"mine_address_icon"];
    
    
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return YES;
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"没有收货地址";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName: [Color colorWithHex:@"0x2c2c2c"]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
#pragma mark- 编辑地址(更改地址)

- (void)setBtnClick:(UIButton *)sender{
    AreaListModel *model = self.dataArr[sender.tag];
    WS(weakself);
    AddAreaVC *add = [[AddAreaVC alloc]init];
    add.name = model.true_name;
    add.address = model.address;
    add.areaid = model.address_id;
    add.area_id = model.area_id;
    add.city_id = model.city_id;
    add.phone = model.mob_phone;
    add.type = @"2";
    add.is_default = model.is_default;
    add.area = model.area_info;
    add.backreload = ^{
        [weakself getDataList];
    };
    [self.navigationController pushViewController:add animated:YES];
}

#pragma mark- 设置为默认

- (void)chooseBtnClick:(UIButton *)sender{
    WS(weakself);
    AreaListModel *model = weakself.dataArr[sender.tag];
    [YPC_Tools customAlertViewWithTitle:@"提示" Message:@"确认设置为默认地址吗?" BtnTitles:@[@"确认"] CancelBtnTitle:@"取消" DestructiveBtnTitle:nil actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
        [YPCNetworking postWithUrl:@"shop/address/setdefault"
                      refreshCache:YES
                            params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                   @"id":model.address_id
                                                                                   }]
                           success:^(id response) {
                               if ([YPC_Tools judgeRequestAvailable:response]) {
                                   for (int i = 0; i < self.dataArr.count; i++) {
                                       AreaListModel *newmodel = weakself.dataArr[i];
                                       if (i == sender.tag) {
                                           newmodel.is_default = @"1";
                                       }else{
                                           newmodel.is_default = @"0";
                                       }
                                   }
                                   [weakself.tableView reloadData];
                                   
                               }
                               
                           }
                              fail:^(NSError *error) {
                                  
                              }];
    } cancelHandler:nil destructiveHandler:nil];
    
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
