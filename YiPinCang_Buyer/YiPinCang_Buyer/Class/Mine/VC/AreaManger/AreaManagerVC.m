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

- (void)setup{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.rowHeight = 143;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = [Color colorWithHex:@"0xefefef"];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(64, 0, 63, 0));
    self.tableView.tableFooterView = [UIView new];
    
    
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
                                   [weakSelf.tableView reloadData];
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
    cell.model = self.dataArr[indexPath.row];
    cell.setBtn.tag = indexPath.row;
    cell.deleteBtn.tag = indexPath.row;
    [cell.setBtn addTarget:self action:@selector(setBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_from isEqualToString:@"结算"]) {
        WS(weakself);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定选择这条收货地址吗?" preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            AreaListModel *model = self.dataArr[indexPath.row];
            if (self.backArea) {
                self.backArea([NSString stringWithFormat:@"%@ %@",model.true_name,model.tel_phone],[NSString stringWithFormat:@"%@ %@",model.area_info,model.address],model.is_default,model.address_id,model.area_id,model.city_id);
                
            }
            [weakself.navigationController popViewControllerAnimated:YES];
            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        [alert addAction:action];
        [alert addAction:cancel];
        [self showDetailViewController:alert sender:nil];
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
#pragma mark- 确认按钮

//确认
- (void)nextBtnClick{
    
        WS(weakself);

        AddAreaVC *add = [[AddAreaVC alloc]init];
        add.type = @"1";
        add.backreload = ^{
            [weakself getDataList];
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定删除这条收货地址吗?" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        AreaListModel *model = self.dataArr[sender.tag];
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
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alert addAction:action];
    [alert addAction:cancel];
    [self showDetailViewController:alert sender:nil];

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
    add.phone = model.mob_phone;
    add.type = @"2";
    add.is_default = model.is_default;
    add.area = model.area_info;
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
