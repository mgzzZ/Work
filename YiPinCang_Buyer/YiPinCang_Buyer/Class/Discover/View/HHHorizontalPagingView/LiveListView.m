//
//  LiveListView.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/6.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LiveListView.h"
#import "LiveDetailListCell.h"
#import "LiveDetailDefaultModel.h"

@interface LiveListView ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic,strong)LiveDetailDefaultModel *model;
@end

@implementation LiveListView

+ (LiveListView *)contentTableView{
    LiveListView *contentTV = [[LiveListView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    contentTV.backgroundColor = [UIColor clearColor];
    contentTV.separatorStyle = NO;
    contentTV.dataSource = contentTV;
    contentTV.backgroundColor = [Color colorWithHex:@"0xefefef"];
    contentTV.delegate = contentTV;
    contentTV.emptyDataSetSource = contentTV;
    contentTV.emptyDataSetDelegate= contentTV;
    contentTV.tableFooterView = [UIView new];
    return contentTV;
}

//直播组详情
- (void)setStore_id:(NSString *)store_id{
    if (![_store_id isEqualToString:store_id]) {
        _store_id = store_id;
    }
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/showstore/default"
                  refreshCache:YES
                        params:@{@"store_id":weakSelf.store_id
                                 }
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.model = [LiveDetailDefaultModel mj_objectWithKeyValues:response[@"data"]];
                               
                               [weakSelf json];
                               
                               [weakSelf reloadData];
                               
                           }
                          
                       }
                          fail:^(NSError *error) {
                              
                          }];
    
    
    
}

- (void)json{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[self.model.list mutableCopy]];
    for (int i = 0; i < self.model.list.count; i++) {
        LiveDetailSectionModel *model = self.model.list[i];
        if (model.data.count == 0) {
            [arr removeObject:model];
        }
    }
    self.model.list = [NSMutableArray arrayWithArray:[arr mutableCopy]];;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.model.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    LiveDetailSectionModel *model = self.model.list[section];
    return model.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 42;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 81;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 42)];
    view.layer.borderWidth = 1;
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderColor = [Color colorWithHex:@"0xefefef"].CGColor;
    LiveDetailSectionModel *model = self.model.list[section];
    UILabel *nameLab = [[UILabel alloc]init];
    [view addSubview:nameLab];
    
    nameLab.font = [UIFont systemFontOfSize:16];
    nameLab.textAlignment = NSTextAlignmentCenter;
    UIView *leftView = [[UIView alloc]init];
    leftView.backgroundColor = [Color colorWithHex:@"0x2c2c2c"];
    [view addSubview:leftView];
    UIView *rightView = [[UIView alloc]init];
    rightView.backgroundColor = [Color colorWithHex:@"0x2c2c2c"];
    [view addSubview:rightView];
    if ([model.type isEqualToString:@"start_activity"]) {
        //直播中
        
        nameLab.text = @"直播中";
        [nameLab sizeToFit];
        nameLab.sd_layout
        .centerXEqualToView(view)
        .centerYEqualToView(view)
        .widthIs(nameLab.size.width)
        .heightIs(42);
    }else if ([model.type isEqualToString:@"will_activity"]){
        //预告
        nameLab.text = @"直播预告";
        [nameLab sizeToFit];
        nameLab.sd_layout
        .centerXEqualToView(view)
        .centerYEqualToView(view)
        .widthIs(nameLab.size.width)
        .heightIs(42);
    }else if ([model.type isEqualToString:@"end_activity"]){
        //回放
        nameLab.text = @"往期直播";
        [nameLab sizeToFit];
        
        nameLab.sd_layout
        .centerXEqualToView(view)
        .centerYEqualToView(view)
        .widthIs(nameLab.size.width)
        .heightIs(42);
        
    }else{
        
    }
    leftView.sd_layout
    .rightSpaceToView(nameLab,5)
    .widthIs(18)
    .heightIs(2)
    .centerYEqualToView(view);
    rightView.sd_layout
    .leftSpaceToView(nameLab,5)
    .widthIs(18)
    .heightIs(2)
    .centerYEqualToView(view);
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"liveLisrt";
    LiveDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"LiveDetailListCell" owner:self options:nil][0];
    }
    LiveDetailSectionModel *model = self.model.list[indexPath.section];
    LiveDetailListDataModel *listModel = model.data[indexPath.row];
    cell.model = listModel;
    cell.playImg.hidden = NO;
    if ([model.type isEqualToString:@"start_activity"]) {
        //直播中
        [cell.typeImg setImage:IMAGE(@"livemembers_details_icon_live")];
        [cell.leftImg setImage:IMAGE(@"livememberdetails_list_numbers_icon")];
        [cell.rightImg setImage:IMAGE(@"livememberdetails_list_zan_icon")];
        cell.leftLab.text = [NSString stringWithFormat:@"%@人观看中",listModel.live_users];
        cell.rightLab.text = listModel.live_like;
        cell.titleLab.text = listModel.name;
        cell.rightImg.hidden = NO;
        cell.rightLab.hidden = NO;
    }else if ([model.type isEqualToString:@"will_activity"]){
        //预告
        [cell.typeImg setImage:IMAGE(@"livemembers_details_icon_trailer")];
        [cell.leftImg setImage:IMAGE(@"homepage_yure_hot_icon")];
        [cell.rightImg setImage:IMAGE(@"livememberdetails_list_follow_icon")];
        cell.leftLab.text = [NSString stringWithFormat:@"%@热度",listModel.live_users];
        cell.rightLab.text = [NSString stringWithFormat:@"%@人关注",listModel.live_like];
        cell.titleLab.text = [NSString stringWithFormat:@" %@",listModel.name];
        cell.rightImg.hidden = NO;
        cell.rightLab.hidden = NO;
    }else if ([model.type isEqualToString:@"end_activity"]){
        //回放
        [cell.typeImg setImage:IMAGE(@"livemembers_details_icon_playback")];
        [cell.leftImg setImage:IMAGE(@"livememberdetails_list_numbers_icon")];
        cell.rightImg.hidden = YES;
        cell.leftLab.text = [NSString stringWithFormat:@"%@人观看",listModel.live_users];
        cell.rightLab.hidden = YES;
        cell.titleLab.text = [NSString stringWithFormat:@" %@",listModel.name];
    }else{
        
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LiveDetailSectionModel *model = self.model.list[indexPath.section];
    LiveDetailListDataModel *listModel = model.data[indexPath.row];
    NSString *typeStr = @"";
    if ([model.type isEqualToString:@"start_activity"]) {
        //直播中
        typeStr = @"直播中";
       
    }else if ([model.type isEqualToString:@"will_activity"]){
        //预告
        typeStr = @"预告";
    }else if ([model.type isEqualToString:@"end_activity"]){
        //回放
      typeStr = @"回放";
    }else{
        typeStr = @"其他";
    }
    if (self.didcell) {
        self.didcell(indexPath,listModel,typeStr);
    }
}

-(void)viewDidLayoutSubviews
{
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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
-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    
    return scrollView.frame.origin.y +50;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"blankpage_livememberinformation_icon"];
    
    
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return YES;
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂时没有可回放的直播观看";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName: [Color colorWithHex:@"0x2c2c2c"]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
@end
