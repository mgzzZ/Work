//
//  ClassSegView.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/9.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "ClassSegView.h"
#import "FiterBrandCell.h"
#import "DiscoverBrandLiskModel.h"
#import "FiterBrandTypeCell.h"
@implementation ClassSegView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.keysArr = [NSArray array];
        self.oldSection = -1;
        self.oldRow = -1;
        [self setup];
    }
    return self;
}

- (void)setup{
    if (!self.tableView) {
        
        self.tableView = [[UITableView alloc]init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = NO;
        [self addSubview:self.tableView];
        self.tableView.tableFooterView = [UIView new];
        self.tableView.sd_layout
        .topSpaceToView(self,0)
        .leftEqualToView(self)
        .rightEqualToView(self)
        .heightIs(0);
    }
}
- (void)setDataDic:(NSMutableDictionary *)dataDic{
    if (_dataDic != dataDic) {
        _dataDic = dataDic;
    }
    NSArray *oldArray = [dataDic allKeys];
    self.keysArr = [oldArray sortedArrayUsingSelector:@selector(compare:)];
    [self.tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    view.backgroundColor = [Color colorWithHex:@"0xffffff"];
    UILabel *lab = [[UILabel alloc]init];
    [view addSubview:lab];
    lab.textColor = [Color colorWithHex:@"0x2c2c2c"];
    lab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.text = self.keysArr[section];
    lab.sd_layout
    .leftSpaceToView(view,15)
    .topEqualToView(view)
    .rightEqualToView(view)
    .bottomEqualToView(view);
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.keysArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString * key = self.keysArr[section];
    NSArray *arr = [self.dataDic valueForKey:key];
    return arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * key = self.keysArr[indexPath.section];
    NSArray *arr = [self.dataDic valueForKey:key][indexPath.row];
    NSInteger row = 0;
    if (arr.count % 3 == 0) {
        row = arr.count / 3;
    }else{
        row = arr.count / 3 + 1;
    }
    
    return row * 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WS(weakSelf);
    static NSString *cellId = @"cell";
    FiterBrandCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[FiterBrandCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSString * key = self.keysArr[indexPath.section];
    NSMutableArray *arr = [self.dataDic valueForKey:key];
    
    cell.dataArr = [arr mutableCopy][indexPath.row];
    cell.typeEnum = FindCell;
    cell.backIdCell = ^(NSString *type,NSString *cid){
        if ([type isEqualToString:@"brand"]) {
            weakSelf.brand = cid;
        }else{
            weakSelf.bind = cid;
        }
        if (weakSelf.classBackId) {
            weakSelf.classBackId(cid);
        }
    };
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
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

@end
