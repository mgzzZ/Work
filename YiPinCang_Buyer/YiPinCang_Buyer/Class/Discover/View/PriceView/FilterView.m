//
//  FilterView.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/10.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "FilterView.h"
#import "DiscoverFiterCell.h"
@implementation FilterView

- (instancetype)init{
    self = [super init];
    if (self) {
         [self setup];
    }
    return self;
}
- (void)setup{
    if (!self.tableView) {
        self.tableView = [[UITableView alloc]init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self addSubview:self.tableView];
        self.tableView.tableFooterView = [UIView new];
        self.tableView.sd_layout
        .topSpaceToView(self,0)
        .leftEqualToView(self)
        .rightEqualToView(self)
        .heightIs(0);
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setDataArr:(NSMutableArray *)dataArr{
   
    if (_dataArr != dataArr) {
        if (_dataArr.count != dataArr.count) {
            _dataArr = dataArr;
            [self.tableView reloadData];
        }
        _dataArr = dataArr;
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 47;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    DiscoverFiterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[DiscoverFiterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.titleLab.text = self.dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didseleteCell) {
        DiscoverFiterCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.seleteImg.hidden = NO;
        self.didseleteCell(indexPath);
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscoverFiterCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.seleteImg.hidden = YES;
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
