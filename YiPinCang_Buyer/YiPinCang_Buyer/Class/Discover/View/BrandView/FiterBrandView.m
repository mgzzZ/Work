//
//  FiterBrandView.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/11.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "FiterBrandView.h"
#import "FiterBrandCell.h"
#import "DiscoverBrandLiskModel.h"
#import "FiterBrandTypeCell.h"
@implementation FiterBrandView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.keysArr = [NSArray array];
        self.oldSection = -1;
        self.oldRow = -1;
        [self addSubview:self.tableView];
    }
    return self;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        _tableView.tableFooterView = [UIView new];
        _tableView.sd_layout
        .topSpaceToView(self,0)
        .leftEqualToView(self)
        .rightEqualToView(self)
        .heightIs(0);
    }
    return _tableView;
}

- (UIView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bottomView];
        _bottomView.sd_layout
        .topSpaceToView(self.tableView,0)
        .leftEqualToView(self)
        .rightEqualToView(self)
        .heightIs(0);
    }
    return _bottomView;
}

- (UIButton *)finishBtn{
    if (_finishBtn == nil) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishBtn.backgroundColor = [Color colorWithHex:@"0xe4393c"];
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_finishBtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _finishBtn.layer.cornerRadius = 2;
        [self.bottomView addSubview:_finishBtn];
        _finishBtn.sd_layout
        .centerYEqualToView(self.bottomView)
        .rightSpaceToView(self.bottomView,15)
        .widthIs(107)
        .heightIs(35);
        _finishBtn.hidden = YES;
    }
    return _finishBtn;
}

- (UIButton *)resetBtn{
    if (_resetBtn == nil) {
        _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetBtn.layer.cornerRadius = 2;
        _resetBtn.layer.borderWidth = 1;
        [_resetBtn addTarget:self action:@selector(resetClick) forControlEvents:UIControlEventTouchUpInside];
        _resetBtn.layer.borderColor = [Color colorWithHex:@"0x2c2c2c"].CGColor;
        [_resetBtn setTitleColor:[Color colorWithHex:@"0x2c2c2c"] forState:UIControlStateNormal];
        [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        [self.bottomView addSubview:_resetBtn];
        _resetBtn.sd_layout
        .rightSpaceToView(self.finishBtn,20)
        .centerYEqualToView(self.finishBtn)
        .widthIs(107)
        .heightIs(35);
        
        _resetBtn.hidden = YES;
    }
    return _resetBtn;
}

- (void)setDataDic:(NSMutableDictionary *)dataDic{
    [_dataDic removeAllObjects];
    if (_dataDic != dataDic) {
        _dataDic = dataDic;
    }
    NSArray *oldArray = [dataDic allKeys];
    self.keysArr = [oldArray sortedArrayUsingSelector:@selector(compare:)];
    [self.tableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 15)];
    view.backgroundColor = [Color colorWithHex:@"0xefefef"];
    UILabel *lab = [[UILabel alloc]init];
    [view addSubview:lab];
    lab.textColor = [Color colorWithHex:@"0x2c2c2c"];
    lab.font = [UIFont systemFontOfSize:13];
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
    
    return row * 47;
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
    if (indexPath.row == 0) {
        if (self.type == Brand) {
            cell.typeEnum = BrandCell;
        }else{
            cell.typeEnum = FindCell;
            
        }
        
        cell.bgColor = [Color colorWithHex:@"0xf0f0f0"];
        cell.didseleteCell = ^(NSIndexPath *indexPath1){
           weakSelf.oldRow = indexPath1.row;
            
            //同cell 删除
            [weakSelf deleteOldCell:indexPath];
            //插入
            NSString * key = weakSelf.keysArr[indexPath.section];
            NSMutableArray *arr = [weakSelf.dataDic valueForKey:key];
            if (arr.count != 1) {
                
                [arr removeObjectAtIndex:1];
                NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
                [weakSelf.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
            }
            DiscoverBrandLiskModel *model = arr[0][indexPath1.row];
            NSArray *arr1 = model.typelist;
            [arr addObject:arr1];
            NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
            [weakSelf.tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
            
        };
        //跨cell删除
        cell.diddeleteCell = ^(NSIndexPath *indepathN){
            if (weakSelf.oldRow != -1 && indepathN.row != weakSelf.oldRow) {
                //NSIndexPath *index = [NSIndexPath indexPathForRow:weakSelf.oldRow inSection:weakSelf.oldSection];
                weakSelf.oldRow = indepathN.row;
            }
            
            [weakSelf deleteOldCell:indexPath];
        };
    }else{
        cell.typeEnum = BindCell;
        cell.bgColor = [UIColor whiteColor];
    }
    cell.backIdCell = ^(NSString *type,NSString *cid){
        if ([type isEqualToString:@"brand"]) {
            weakSelf.brand = cid;
        }else{
            weakSelf.bind = cid;
        }
    };
    if (self.type == Find) {
        if (self.backId) {
            self.backId(self.brand,self.bind);
        }
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
//判断是否有新增的cell
- (void)deleteOldCell:(NSIndexPath *)indexPath{
    WS(weakSelf);
    if (self.oldSection != -1 && self.oldSection != indexPath.section) {
        NSString * key = weakSelf.keysArr[self.oldSection];
        NSMutableArray *arr = [weakSelf.dataDic valueForKey:key];
        if (arr.count != 1) {
            
            [arr removeObjectAtIndex:1];
            NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:self.oldSection];
            NSIndexPath *index2 = [NSIndexPath indexPathForRow:0 inSection:self.oldSection];
            [weakSelf.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[index2] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }
    self.oldSection = indexPath.section;
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

- (void)resetClick{
    if (self.backId) {
        self.backId(@"",@"");
    }

}
- (void)finishBtnClick{
    if (self.backId) {
        self.backId(self.brand,self.bind);
    }
}
@end
