//
//  LiveNoteView.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/6.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LiveNoteView.h"

#import "LiveDetailLiveNoteOfImgCell.h"
#import "LiveDetailLiveVideoCell.h"
#import "LiveDetailLiveVideoCell.h"
@interface LiveNoteView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSString *page;
@end

@implementation LiveNoteView

+ (LiveNoteView *)contentTableView{
    LiveNoteView *contentTV = [[LiveNoteView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    contentTV.backgroundColor = [UIColor clearColor];
    contentTV.separatorStyle = NO;
    contentTV.dataSource = contentTV;
    contentTV.delegate = contentTV;
    contentTV.tableFooterView = [UIView new];
    return contentTV;
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
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    }else{
        static NSString *cellId = @"liveLisrtWithImg";
        LiveDetailLiveNoteOfImgCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[LiveDetailLiveNoteOfImgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.model = model;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LiveNoteModel *model = self.dataArr[indexPath.row];
    if (self.notedidcell) {
        self.notedidcell(indexPath,model);
    }
}


- (void)setStore_id:(NSString *)store_id{
    if (![_store_id isEqualToString:store_id]) {
        _store_id = store_id;
    }
    self.page = @"1";
    [self getData:self.page isRefresh:YES];
    [self upRefresh];
    
}
- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (void)getData:(NSString *)page isRefresh:(BOOL)isRefresh{
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
                           
                           NSMutableArray *arr = [LiveNoteModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                           
                           
                           if (arr.count < 10) {
                               [weakSelf.mj_footer endRefreshingWithNoMoreData];
                           }else{
                               [weakSelf.mj_footer endRefreshing];
                           }
                           [weakSelf.mj_header endRefreshing];
                           if (isRefresh) {
                               [weakSelf.dataArr removeAllObjects];
                               [weakSelf.dataArr addObjectsFromArray:arr];
                               [weakSelf reloadData];
                           }else{
                               [weakSelf.dataArr addObjectsFromArray:arr];
                               [weakSelf reloadDataWithExistedHeightCache];
                           }
                           
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
