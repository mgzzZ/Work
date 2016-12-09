//
//  LiveShareView.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/6.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LiveShareView.h"
#import "LiveDetailLiveShareCell.h"
#import "LiveShareModel.h"
@interface LiveShareView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,copy)NSString *page;
@end

@implementation LiveShareView

+ (LiveShareView *)contentTableView{
    LiveShareView *contentTV = [[LiveShareView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    contentTV.backgroundColor = [UIColor clearColor];
    contentTV.separatorStyle = NO;
    contentTV.dataSource = contentTV;
    contentTV.delegate = contentTV;
    contentTV.tableFooterView = [UIView new];
    return contentTV;
}





- (void)setStore_id:(NSString *)store_id{
    if (![_store_id isEqualToString:store_id]) {
        _store_id = store_id;
    }
    self.page = @"1";
    [self getData:self.page isRefresh:YES];
    
    [self upRefresh];
}





- (void)getData:(NSString *)page isRefresh:(BOOL)isRefresh{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/showstore/sharegoods"
                  refreshCache:YES
                        params:@{@"store_id":weakSelf.store_id,
                                 @"listorder":@"",
                                 @"brand":@"",
                                 @"bind":@"",
                                 @"pagination":@{
                                         @"page":page,
                                         @"count":@"10"
                                         }
                                 }
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                           }
                           if (isRefresh) {
                               [weakSelf.dataArr removeAllObjects];
                               [weakSelf reloadData];
                           }else{
                               [weakSelf reloadDataWithExistedHeightCache];
                           }
                           NSMutableArray *arr = [LiveShareModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                           [weakSelf.dataArr addObjectsFromArray:arr];
                           [weakSelf reloadData];
                           if (arr.count < 10) {
                               [weakSelf.mj_footer endRefreshingWithNoMoreData];
                           }else{
                               [weakSelf.mj_footer endRefreshing];
                           }
                           [weakSelf.mj_header endRefreshing];
                       }
                          fail:^(NSError *error) {
                              
                          }];
}


- (void)upRefresh{
   
    WS(weakself);
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
         weakself.page = [NSString stringWithFormat:@"%zd",weakself.page.integerValue + 1];
        [weakself getData:weakself.page isRefresh:NO];
        
    }];
}






- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LiveShareModel *model = self.dataArr[indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[LiveDetailLiveShareCell class]  contentViewWidth:[self cellContentViewWith]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"liveLisrt";
    LiveDetailLiveShareCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[LiveDetailLiveShareCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (indexPath.row == 0) {
        cell.toplineView.hidden = YES;
        cell.timeImg.backgroundColor = [Color colorWithHex:@"#E4393C"];
    }else{
        cell.toplineView.hidden = NO;
        cell.timeImg.backgroundColor = [Color colorWithHex:@"#BFBFBF"];
    }
    cell.model = self.dataArr[indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LiveShareModel *model = self.dataArr[indexPath.row];
    if (self.shareDidcell) {
        self.shareDidcell(indexPath,model);
    }
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
@end
