//
//  LiveDetailLivelistVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LiveDetailLivelistVC.h"
#import "LiveDetailListCell.h"
#import "LiveDetailDefaultModel.h"
#import "LiveDetailListDataModel.h"
@interface LiveDetailLivelistVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)LiveDetailDefaultModel *model;

@end

@implementation LiveDetailLivelistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getData];
   
}
//- (void)setYyy:(CGFloat)yyy{
//    if (_yyy != yyy) {
//        _yyy = yyy;
//        self.tableView.scrollEnabled = YES;
//    }
//
//}
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
    if ([model.type isEqualToString:@"start_activity"]) {
        //直播中
        [cell.typeImg setImage:IMAGE(@"livemembers_details_icon_live")];
        [cell.leftImg setImage:IMAGE(@"homepage_yure_live_icon")];
        [cell.rightImg setImage:IMAGE(@"find_productdetails_icon_likes")];
        cell.leftLab.text = [NSString stringWithFormat:@"%@人观看中",listModel.live_users];
        cell.rightLab.text = listModel.live_like;
        cell.titleLab.text = listModel.name;
        cell.rightImg.hidden = NO;
        cell.rightLab.hidden = NO;
    }else if ([model.type isEqualToString:@"will_activity"]){
        //预告
        [cell.typeImg setImage:IMAGE(@"livemembers_details_icon_trailer")];
        [cell.leftImg setImage:IMAGE(@"homepage_yure_hot_icon")];
        [cell.rightImg setImage:IMAGE(@"homepage_follow_icon")];
        cell.leftLab.text = [NSString stringWithFormat:@"%@热度",listModel.live_users];
        cell.rightLab.text = [NSString stringWithFormat:@"%@人关注",listModel.live_like];
        cell.titleLab.text = [NSString stringWithFormat:@" %@",listModel.name];
        cell.rightImg.hidden = NO;
        cell.rightLab.hidden = NO;
    }else if ([model.type isEqualToString:@"end_activity"]){
        //回放
        [cell.typeImg setImage:IMAGE(@"livemembers_details_icon_playback")];
        [cell.leftImg setImage:IMAGE(@"homepage_wathchnumber_icon")];
        cell.rightImg.hidden = YES;
        cell.leftLab.text = [NSString stringWithFormat:@"%@人观看",listModel.live_users];
        cell.rightLab.hidden = YES;
        cell.titleLab.text = [NSString stringWithFormat:@" %@",listModel.name];
    }else{
        
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        _tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat offset = scrollView.contentOffset.y + self.yyy;
//    if (offset > 256 - 57) {
//        
//        if (self.didscroll) {
//            self.didscroll(256 - 57);
//        }
//        
//    }else if(offset < 0){
//        
//        if (self.didscroll) {
//            self.didscroll(0);
//        }
//    }else{
//        if (self.didscroll) {
//            self.didscroll(offset);
//        }
//    }
//    
//    YPCAppLog(@"%.2f -----",scrollView.contentOffset.y);
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
- (void)getData{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/showstore/default"
                  refreshCache:YES
                        params:@{@"store_id":weakSelf.store_id
                                 }
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                                                        }
                           weakSelf.model = [LiveDetailDefaultModel mj_objectWithKeyValues:response[@"data"]];
                           [weakSelf.tableView reloadData];
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
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
