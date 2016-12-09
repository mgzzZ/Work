//
//  LiveDetailLiveNoteVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/3.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LiveDetailLiveNoteVC.h"
#import "LiveNoteModel.h"
#import "LiveDetailLiveNoteOfImgCell.h"
#import "LiveDetailLiveVideoCell.h"
#import "LiveDetailLiveVideoCell.h"

@interface LiveDetailLiveNoteVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation LiveDetailLiveNoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getData:@"1"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LiveNoteModel *model = self.dataArr[indexPath.row];
    if ([model.content_type isEqualToString:@"2"]) {
        return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[LiveDetailLiveVideoCell class]  contentViewWidth:[self cellContentViewWith]];
    }else{
         return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[LiveDetailLiveNoteOfImgCell class]  contentViewWidth:[self cellContentViewWith]];
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LiveNoteModel *model = self.dataArr[indexPath.row];
    if ([model.content_type isEqualToString:@"2"]) {
        
        static NSString *cellId = @"liveLisrtWithVideo";
        LiveDetailLiveVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[LiveDetailLiveVideoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.model = model;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else{
        static NSString *cellId = @"liveLisrtWithImg";
        LiveDetailLiveNoteOfImgCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[LiveDetailLiveNoteOfImgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.model = model;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    return nil;
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
- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (void)getData:(NSString *)page{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/showstore/strace"
                  refreshCache:YES
                        params:@{@"store_id":weakSelf.store_id,
                                 @"pagination":@{
                                         @"page":page,
                                         @"count":@"10"
                                         }
                                 }
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                           }
                           weakSelf.dataArr = [LiveNoteModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                           [weakSelf.tableView reloadData];
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
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
