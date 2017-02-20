//
//  ShoppingCarVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/16.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "ShoppingCarVC.h"
#import "ShoppongCarCell.h"
#import "ShoppingCarModel.h"
#import "ChooseSize.h"
#import "ChooseSizeModel.h"
#import "ClearingView.h"
#import "ShoppingCarDetailVC.h"
#import "ClearingVC.h"
#import "GuessLikeView.h"
#import "GuessModel.h"
#import "WebViewController.h"
static NSString *cellId = @"noedit";
static NSString *cellId2 = @"edit";
@interface ShoppingCarVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic,strong)UITableView *effectTab;//有效的
@property (nonatomic,strong)UITableView *invalidTab;//无效的
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)ChooseSize *chooseSize;
@property (nonatomic,assign)BOOL isChooseSize;
@property (nonatomic,strong)ChooseSizeModel *model;
@property (nonatomic,strong)ClearingView *clearingView;
@property (nonatomic,assign)NSInteger seleteCount;
@property (nonatomic,assign)id object;
@property (nonatomic,assign)CGFloat maxPrice;
@property (nonatomic,strong)NSMutableArray *didCellArr;//选择的cell
@property (nonatomic,strong)NSMutableArray *guessLikeArr;//推荐商品
@property (nonatomic,strong)UIView *noDataView;
@property (nonatomic,strong)GuessLikeView *guessLikeView;
@property (nonatomic,strong)UIBarButtonItem *rightItem;
@property (nonatomic ,strong) dispatch_source_t timer;
@property (nonatomic,strong)NSMutableArray *invalid_cartArr;
@property (nonatomic,strong)UIView *footerView;
@end

@implementation ShoppingCarVC

- (void)dealloc{
    YPCAppLog(@"销毁");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getDataList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[date timeIntervalSince1970]; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    if ([YPCRequestCenter shareInstance].carEndtime.integerValue - timeString.integerValue > 0) {
        __block int timeout = [YPCRequestCenter shareInstance].carEndtime.intValue - timeString.intValue; //倒计时时间
        if (!_timer) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout <= 0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.navigationItem.title = @"购物车";
                    });
                }else{
                    int minutes = timeout / 60;
                    int seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"购物车 %.2d:%.2d",minutes, seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.navigationItem.title = strTime;
                        
                    });
                    timeout--;
                    
                }
            });
            dispatch_resume(_timer);
            
        }
        

    }else{
        self.navigationItem.title = @"购物车";
    }

    
    self.index = 0;
    self.seleteCount = 0;
    self.maxPrice = 0.00;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *rightBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.selected = NO;
    [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [rightBtn setTitle:@"完成" forState:UIControlStateSelected];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 44, 44);
    self.rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    self.isChooseSize = NO;
   
    
}

#pragma mark - getdata

- (void)getDataList{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/cart/list"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.dataArr = [ShoppingCarModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"store_cart"]];
                               weakSelf.invalid_cartArr = [Shoppingcar_dataModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"invalid_cart"]];
                               if (weakSelf.dataArr.count == 0) {
                                   weakSelf.effectTab.tableHeaderView = weakSelf.noDataView;
                                   weakSelf.clearingView = nil;
                                   weakSelf.effectTab.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
                                   self.navigationItem.rightBarButtonItem = nil;
                               }else{
                                   weakSelf.effectTab.tableHeaderView = [UIView new];
                                   [weakSelf.view addSubview:weakSelf.clearingView];
                                   weakSelf.effectTab.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 58, 0));
                                   [weakSelf.didCellArr removeAllObjects];
                                   weakSelf.seleteCount = 0;
                                   weakSelf.maxPrice = 0.00;
                                   [weakSelf.clearingView.clearingBtn setTitle:[NSString stringWithFormat:@"结算"] forState:UIControlStateNormal];
                                   [weakSelf priceLabtext:weakSelf.maxPrice];
                                   self.navigationItem.rightBarButtonItem = self.rightItem;
                               }
                               
                               if (weakSelf.guessLikeArr.count == 0) {
                                   [weakSelf getDataGuessUlike];
                               }
                               
                               [weakSelf.effectTab reloadData];
                              
                               
                           }
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}

- (void)getDataGuessUlike{
    WS(weakSelf);
    if (self.guessLikeArr.count != 0) {
        return;
    }
    [YPCNetworking postWithUrl:@"shop/goods/guesslist"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"pagination":@{
                                                                                       @"count":@"24",
                                                                                       @"page":@"1"
                                                                                       }
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.guessLikeArr = [GuessModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                              
                                   weakSelf.effectTab.tableFooterView = weakSelf.footerView;
                               
                           }
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}


#pragma mark - delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.effectTab) {
        return self.dataArr.count ;
    }else{
        return 1;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView == self.effectTab) {
        ShoppingCarModel *model = self.dataArr[section];
        UIView *hearderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 42)];
        hearderView.backgroundColor = [UIColor whiteColor];
        UIImageView *img = [[UIImageView alloc]init];
        [hearderView addSubview:img];
        img.sd_layout.leftSpaceToView(hearderView,15)
        .centerYEqualToView(hearderView)
        .widthIs(30)
        .heightIs(30);
        [img setSd_cornerRadiusFromWidthRatio:@0.5];
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.text = model.store.store_name;
        [img sd_setImageWithURL:[NSURL URLWithString:model.store.store_avatar] placeholderImage:YPCImagePlaceHolder];
        titleLab.font = YPCPFFont(16);
        titleLab.textAlignment = NSTextAlignmentLeft;
        [hearderView addSubview:titleLab];
        titleLab.sd_layout.leftSpaceToView(img,15)
        .topEqualToView(hearderView)
        .rightEqualToView(hearderView)
        .bottomEqualToView(hearderView);
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 41.5, ScreenWidth, 0.5)];
        lineView.backgroundColor = [Color colorWithHex:@"0xefefef"];
        [hearderView addSubview:lineView];
        return hearderView;
    }else{
        UIView *view = [[UIView alloc]init];
        
        return view;
    }
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == self.effectTab) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 7)];
        view.backgroundColor = [Color colorWithHex:@"0xefefef"];
        return view;
    }else{
        return [UIView new];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.effectTab == tableView) {
        ShoppingCarModel *model = self.dataArr[section];
        return model.data.count;
    }else{
        return self.invalid_cartArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.effectTab == tableView) {
        if (self.index == 0) {
            return 110;
        }else{
            return 110;
        }
    }else{
        return 110;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.effectTab) {
        return 42;
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.effectTab) {
        return 7;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WS(weakSelf);
    
    if (tableView == self.effectTab) {
        if (self.index == 0) {
            
            
            ShoppongCarCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShoppongCarCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.type = @"0";
            __block ShoppongCarCell *blockCell = cell;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            ShoppingCarModel *model = self.dataArr[indexPath.section];
            Shoppingcar_dataModel *dataModel = model.data[indexPath.row];
            cell.model = dataModel;
            //左边按钮选择
            cell.seleteBlock = ^(UIButton *sender){
                [weakSelf cellSelecte:sender model:dataModel];
            };
            //改变购买数量
            cell.payCountBlock = ^(NSString *num){
                [weakSelf changePayCount:blockCell model:dataModel count:num];
            };
            return cell;
        }else{
            ShoppongCarCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
            if (!cell) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShoppongCarCell" owner:self options:nil];
                cell = [nib objectAtIndex:1];
            }
            cell.type = @"1";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            ShoppingCarModel *model = self.dataArr[indexPath.section];
            Shoppingcar_dataModel *dataModel = model.data[indexPath.row];
            cell.model = dataModel;
            cell.chooseBlock = ^{
                weakSelf.object = indexPath;
                [YPCNetworking postWithUrl:@"shop/cart/editinit"
                              refreshCache:YES
                                    params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                           
                                                                                           @"goods_id":dataModel.goods_commonid
                                                                                           }]
                                   success:^(id response) {
                                       weakSelf.model = [ChooseSizeModel mj_objectWithKeyValues:response[@"data"]];
                                       
                                       [weakSelf.chooseSize updateWithPrice:dataModel.goods_price img:dataModel.goods_image chooseMessage:dataModel.goods_spec count:dataModel.goods_num.integerValue maxCount:dataModel.goods_storage.integerValue model:weakSelf.model];
                                       
                                       [weakSelf chooseSizeShow];
                                       
                                   }
                                      fail:^(NSError *error) {
                                          
                                      }];
                
            };
            
            cell.seleteBlock = ^(UIButton *sender){
                [weakSelf cellSelecte:sender model:dataModel];
            };
            return cell;
        }

    }else if(tableView == self.invalidTab){
        ShoppongCarCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShoppongCarCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.type = @"0";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Shoppingcar_dataModel *dataModel = self.invalid_cartArr[indexPath.row];
        cell.model = dataModel;
        return cell;
    }else{
        return nil;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.effectTab) {
        YPCAppLog(@"111");
    }else{
        
    }
}

-(void)viewDidLayoutSubviews
{
    if ([self.effectTab respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.effectTab setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.effectTab respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.effectTab setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    if (_invalidTab) {
        if ([self.invalidTab respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.invalidTab setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        if ([self.invalidTab respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.invalidTab setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.effectTab) {
        if (self.index == 0) {
            for (ShoppongCarCell *cell in [self.effectTab visibleCells]) {
                [cell.payCount1.textField resignFirstResponder];
                [cell.payCount2.textField resignFirstResponder];
            }
            ShoppingCarDetailVC *shopping = [[ShoppingCarDetailVC alloc]init];
            ShoppingCarModel *model = self.dataArr[indexPath.section];
            Shoppingcar_dataModel *dataModel = model.data[indexPath.row];
            shopping.goods_id = dataModel.goods_commonid;
            shopping.payCount = dataModel.goods_num;
            [self.navigationController pushViewController:shopping animated:YES];
        }
    }else{
        
            for (ShoppongCarCell *cell in [self.effectTab visibleCells]) {
                [cell.payCount1.textField resignFirstResponder];
                [cell.payCount2.textField resignFirstResponder];
            }
            ShoppingCarDetailVC *shopping = [[ShoppingCarDetailVC alloc]init];
            Shoppingcar_dataModel *dataModel = self.invalid_cartArr[indexPath.row];
            shopping.goods_id = dataModel.goods_commonid;
            shopping.payCount = dataModel.goods_num;
            [self.navigationController pushViewController:shopping animated:YES];
        
    }
   
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    
    return scrollView.frame.origin.y - 50.f;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"blankpage_cart_nofindgoods_icon"];
    
    
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return YES;
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"购物车空空如也,快去添加商品吧";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName: [Color colorWithHex:@"0x2c2c2c"]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - 清空失效购物车

- (void)clearCar{
    WS(weakself);
    [YPCNetworking postWithUrl:@"shop/cart/delete"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"cart_id" : @"clear"
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               [weakself.invalid_cartArr removeAllObjects];
                               weakself.footerView = nil;
                               weakself.effectTab.tableFooterView = weakself.guessLikeView;
                               [YPC_Tools showSvpWithNoneImgHud:@"清除成功"];
                           }
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}

#pragma mark- 编辑按钮

- (void)rightBtnClick:(UIButton *)sender{
    if (sender.selected == NO) {
        sender.selected = YES;
        self.index = 1;
        [self.clearingView.clearingBtn setTitle:[NSString stringWithFormat:@"删除(%zd)",self.seleteCount]forState:UIControlStateNormal];
        self.clearingView.priceLab.hidden = YES;
        self.effectTab.tableFooterView = self.guessLikeView;
        self.footerView = nil;
        self.guessLikeView = nil;
    }else{
        sender.selected = NO;
        self.index = 0;
        [self.clearingView.clearingBtn setTitle:[NSString stringWithFormat:@"结算(%zd)",self.seleteCount]forState:UIControlStateNormal];
        self.clearingView.priceLab.hidden = NO;
    
        self.effectTab.tableFooterView = self.footerView;
        
    }
    [self.effectTab reloadData];
}

#pragma mark- 选择尺码展示

- (void)chooseSizeShow{
    WS(weakself);
    [UIView animateWithDuration:0.3 animations:^{
        weakself.chooseSize.frame = CGRectMake(0, ScreenHeight - 483, ScreenWidth, 483);
        weakself.bgView.hidden = NO;
        weakself.isChooseSize = YES;
    }];
}

#pragma mark- 选择尺码消失

- (void)chooseSizeHide{
    WS(weakself);
    [UIView animateWithDuration:0.3 animations:^{
        weakself.chooseSize.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 483);
        weakself.bgView.hidden = YES;
        weakself.isChooseSize = NO;
    }completion:^(BOOL finished) {
        if (finished) {
            weakself.chooseSize = nil;
            weakself.bgView = nil;
        }
    }];
    
}


#pragma mark - cell左边按钮选择逻辑

- (void)cellSelecte:(UIButton *)sender model:(Shoppingcar_dataModel *)dataModel{
    WS(weakSelf);
    NSInteger maxCount = [self tableViewMayAllcells:self.effectTab];
    __block NSInteger blockMacCount = maxCount;
    dataModel.seleted = !sender.selected;
    if (sender.selected) {
        weakSelf.seleteCount--;
        
        weakSelf.maxPrice -= dataModel.goods_price.floatValue * dataModel.goods_num.integerValue;
        
        [weakSelf priceLabtext:weakSelf.maxPrice];
        [weakSelf.didCellArr removeObject:dataModel];
        
    }else{
        weakSelf.seleteCount++;
        
        weakSelf.maxPrice += dataModel.goods_price.floatValue * dataModel.goods_num.integerValue;
        
        [weakSelf.didCellArr addObject:dataModel];
        [weakSelf priceLabtext:weakSelf.maxPrice];
    }
    
    if (weakSelf.seleteCount == blockMacCount) {
        weakSelf.clearingView.seleteBtn.selected = YES;
        weakSelf.clearingView.seleteLab.text = @"取消全选";
        if (weakSelf.index == 0) {
            [weakSelf.clearingView.clearingBtn setTitle:[NSString stringWithFormat:@"结算(%zd)",weakSelf.seleteCount] forState:UIControlStateNormal];
        }else{
            [weakSelf.clearingView.clearingBtn setTitle:[NSString stringWithFormat:@"删除(%zd)",weakSelf.seleteCount] forState:UIControlStateNormal];
        }
    }else if(weakSelf.seleteCount == 0){
        
        if (weakSelf.index == 0) {
            [weakSelf.clearingView.clearingBtn setTitle:[NSString stringWithFormat:@"结算"] forState:UIControlStateNormal];
        }else{
            [weakSelf.clearingView.clearingBtn setTitle:[NSString stringWithFormat:@"删除"] forState:UIControlStateNormal];
        }
        weakSelf.clearingView.seleteBtn.selected = NO;
        weakSelf.clearingView.seleteLab.text = @"全选";
        
    }else{
        if (weakSelf.index == 0) {
            [weakSelf.clearingView.clearingBtn setTitle:[NSString stringWithFormat:@"结算(%zd)",weakSelf.seleteCount] forState:UIControlStateNormal];
        }else{
            [weakSelf.clearingView.clearingBtn setTitle:[NSString stringWithFormat:@"删除(%zd)",weakSelf.seleteCount] forState:UIControlStateNormal];
        }
        weakSelf.clearingView.seleteBtn.selected = NO;
        weakSelf.clearingView.seleteLab.text = @"全选";
    }

}

#pragma mark - 变动购买数量的逻辑

- (void)changePayCount:(ShoppongCarCell *)cell model:(Shoppingcar_dataModel *)dataModel count:(NSString *)num{
    WS(weakSelf);
    NSString *oldNum = dataModel.goods_num;
    //小于0 代表增加购物数量
    //大于0 代表较少数量
    
    dataModel.goods_num = num;
    [YPCNetworking postWithUrl:@"shop/cart/update"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"cart_id":dataModel.cart_id,
                                                                               @"goods_id":dataModel.goods_id,
                                                                               @"count":num
                                                                               }]
                       success:^(id response) {
                           NSString *newnum = response[@"data"][@"current_num"];
                           [cell.payCount1 setCurrentNumber:newnum];
                           dataModel.goods_num = newnum;
                           if (oldNum.integerValue - newnum.integerValue < 0) {
                               if (weakSelf.maxPrice != 0.00) {
                                   weakSelf.maxPrice += (newnum.integerValue - oldNum.integerValue) * dataModel.goods_price.floatValue;
                                   [weakSelf priceLabtext:weakSelf.maxPrice];
                               }
                           }else{
                               if (weakSelf.maxPrice != 0.00) {
                                   weakSelf.maxPrice -= (oldNum.integerValue - newnum.integerValue ) * dataModel.goods_price.floatValue;
                                   [weakSelf priceLabtext:weakSelf.maxPrice];
                               }
                           }
                       }
                          fail:^(NSError *error) {
                              
                          }];

}


#pragma mark - 遍历tableview所有cell 不是可见cell
//遍历所有cell
- (NSInteger )tableViewAllcellsNO:(UITableView *)tableView selete:(BOOL)seleted{
    
    int k = 0; // 记录cell个数
    for (int i = 0; i<self.dataArr.count; i++) {
        ShoppingCarModel *model = self.dataArr[i];
        for (int j = 0; j< model.data.count; j++) {
            
            NSIndexPath *newIndex = [NSIndexPath indexPathForRow:j inSection:i];
            ShoppongCarCell *cell = [tableView cellForRowAtIndexPath:newIndex];
            Shoppingcar_dataModel *dataModel = model.data[j];
            //遍历所有能点击的
            if ([dataModel.type isEqualToString:@"1"] || [dataModel.type isEqualToString:@"2"] ) {
                k++;
                cell.choose2Btn.selected = seleted;
                cell.Choose1Btn.selected = seleted;
                dataModel.seleted = seleted;
              
            }
            
            
        }
    }
    
    
    return k;
}
- (NSInteger )tableViewAllcells:(UITableView *)tableView selete:(BOOL)seleted{
    
    int k = 0; // 记录cell个数
    for (int i = 0; i<self.dataArr.count; i++) {
        ShoppingCarModel *model = self.dataArr[i];
        for (int j = 0; j< model.data.count; j++) {
            
            NSIndexPath *newIndex = [NSIndexPath indexPathForRow:j inSection:i];
            ShoppongCarCell *cell = [tableView cellForRowAtIndexPath:newIndex];
            Shoppingcar_dataModel *dataModel = model.data[j];
            //遍历所有能点击的
            if ([dataModel.type isEqualToString:@"1"]|| [dataModel.type isEqualToString:@"2"] ) {
                k++;
                cell.choose2Btn.selected = seleted;
                cell.Choose1Btn.selected = seleted;
                dataModel.seleted = seleted;
                if (seleted == YES) {
                    [self.didCellArr addObject:dataModel];
                    self.maxPrice += dataModel.goods_price.floatValue * dataModel.goods_num.integerValue;
                }else{
                    [self.didCellArr removeObject:dataModel];
                    self.maxPrice = 0.00;
                }
            }
            
            
        }
    }
    
    
    return k;
}

- (NSInteger )tableViewMayAllcells:(UITableView *)tableView{
    
    int k = 0; // 记录cell个数
    for (int i = 0; i<self.dataArr.count; i++) {
        ShoppingCarModel *model = self.dataArr[i];
        for (int j = 0; j< model.data.count; j++) {
            Shoppingcar_dataModel *dataModel = model.data[j];
            //遍历所有能点击的
            if ([dataModel.type isEqualToString:@"1"]|| [dataModel.type isEqualToString:@"2"] ) {
                k++;
            }
            
            
        }
    }
    
    
    return k;
}
//删除选中的cell 多选
- (void)tableViewDeletaCell:(NSMutableArray *)data{
    
    for (int k = 0; k < data.count ; k++) {
        Shoppingcar_dataModel *didModel = data[k];
        for (int i = 0; i<self.dataArr.count; i++) {
            ShoppingCarModel *model = self.dataArr[i];
            for (int j = 0; j< model.data.count; j++) {
                
                Shoppingcar_dataModel *dataModel = model.data[j];
                if ([dataModel.cart_id isEqualToString:didModel.cart_id]) {
                    [model.data removeObject:dataModel];
                    self.seleteCount--;
                    self.maxPrice -= dataModel.goods_price.floatValue * dataModel.goods_num.integerValue;
                    if (model.data.count == 0) {
                        [self.dataArr removeObject:model];
                    }
                    if (self.dataArr.count == 0) {
                        self.effectTab.tableHeaderView = self.noDataView;
                        self.clearingView.hidden = YES;
                        self.effectTab.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
                    }
                }
            }
        }
    }
    
}

#pragma mark- 根据不同变化,合计价格及时变化
//合计价格的显示
- (void)priceLabtext:(CGFloat )str{
    NSString *price = [NSString stringWithFormat:@"合计: ¥%.2f",str];
    NSMutableAttributedString * mutabStr = [[NSMutableAttributedString alloc]initWithString:price];
    [mutabStr addAttribute:NSForegroundColorAttributeName value:[Color colorWithHex:@"#2C2C2C"] range:NSMakeRange(0, 3)];
    [mutabStr addAttribute:NSForegroundColorAttributeName value:[Color colorWithHex:@"#E4393C"] range:NSMakeRange(3, price.length - 3)];
    self.clearingView.priceLab.attributedText = mutabStr;
}

#pragma mark - 懒加载

- (UITableView *)effectTab{
    if (_effectTab == nil) {
        _effectTab = [[UITableView alloc]init];
        _effectTab.delegate = self;
        _effectTab.dataSource = self;
        _effectTab.emptyDataSetDelegate = self;
        _effectTab.emptyDataSetSource = self;
        _effectTab.backgroundColor = [Color colorWithHex:@"0xefefef"];
      
         [self.view addSubview:_effectTab];
    }
    return _effectTab;
}

- (UITableView *)invalidTab{
    if (_invalidTab == nil) {
        _invalidTab = [[UITableView alloc]init];
        _invalidTab.delegate = self;
        _invalidTab.dataSource = self;
        _invalidTab.backgroundColor = [Color colorWithHex:@"0xefefef"];
        _invalidTab.scrollEnabled = NO;
    }
    return _invalidTab;
}

- (GuessLikeView *)guessLikeView{
    if (_guessLikeView == nil) {
        WS(weakself);
        NSInteger row = 0;
        if (self.guessLikeArr.count % 2 == 0) {
            row  = self.guessLikeArr.count / 2;
        }else{
            row = self.guessLikeArr.count / 2 + 1;
        }
        CGFloat y = 0;
        if (self.invalid_cartArr.count == 0 ) {
            y = 0;
        }else{
            y = self.invalid_cartArr.count * 110 + 48 + 72;
        }
        _guessLikeView = [[GuessLikeView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, ((ScreenWidth - 46) / 2 * 182 / 137 +60 + 20) * row + 50)];
        _guessLikeView.dataArr = weakself.guessLikeArr;
        _guessLikeView.didSelect = ^(NSIndexPath *index){
            ShoppingCarDetailVC *shopping = [[ShoppingCarDetailVC alloc]init];
            GuessModel *model = weakself.guessLikeArr[index.row];
            shopping.goods_id = model.goods_commonid;
            [weakself.navigationController pushViewController:shopping animated:YES];
        };
    }
    return _guessLikeView;
}

- (UIView *)footerView{
    
    if (_footerView == nil) {
        _footerView = [[UIView alloc]init];
        CGFloat height = 0;
        if (self.invalid_cartArr.count > 0) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 48)];
            view.backgroundColor = [Color colorWithHex:@"0xefefef"];
            [_footerView addSubview:view];
            UILabel *titleLab = [[UILabel alloc]init];
            titleLab.text = @"以下商品为失效商品";
            titleLab.font = YPCPFFont(15);
            titleLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
            titleLab.textAlignment = NSTextAlignmentLeft;
            titleLab.backgroundColor = [Color colorWithHex:@"0xefefef"];
            [titleLab sizeToFit];
            [view addSubview:titleLab];
            titleLab.sd_layout
            .leftSpaceToView(view,15)
            .centerYEqualToView(view)
            .widthIs(titleLab.frame.size.width)
            .heightIs(15);
            height = self.invalid_cartArr.count * 110 + 48 + 72;
            self.invalidTab.frame = CGRectMake(0, 48, ScreenWidth, self.invalid_cartArr.count * 110);
            [_footerView addSubview:self.invalidTab];
            UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, height - 72, ScreenWidth, 62)];
            
            bottomView.backgroundColor = [UIColor whiteColor];
            [_footerView addSubview:bottomView];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"清空失效商品" forState:UIControlStateNormal];
            btn.titleLabel.font = YPCPFFont(13);
            [btn setTitleColor:[Color colorWithHex:@"#F00D36"] forState:UIControlStateNormal];
            [bottomView addSubview:btn];
            btn.sd_layout
            .centerXEqualToView(bottomView)
            .centerYEqualToView(bottomView)
            .widthIs(110)
            .heightIs(30);
            btn.layer.borderColor = [Color colorWithHex:@"#F00D36"].CGColor;
            btn.layer.borderWidth = 1;
            btn.layer.cornerRadius = 15;
            [btn addTarget:self action:@selector(clearCar) forControlEvents:UIControlEventTouchUpInside];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, height - 10, ScreenWidth, 10)];
            lineView.backgroundColor = [Color colorWithHex:@"0xefefef"];
            [_footerView addSubview:lineView];
            
            [self.invalidTab reloadData];
            
        }
        if (self.guessLikeArr.count > 0) {
            NSInteger row = 0;
            if (self.guessLikeArr.count % 2 == 0) {
                row  = self.guessLikeArr.count / 2;
            }else{
                row = self.guessLikeArr.count / 2 + 1;
            }
            height = height + ((ScreenWidth - 46) / 2 * 182 / 137 +60 + 20) * row + 50;
            
            [_footerView addSubview:self.guessLikeView];
            
        }
        _footerView.frame = CGRectMake(0, 0, ScreenWidth, height);
    }
    [self.invalidTab reloadData];
    return _footerView;
}


- (ClearingView *)clearingView{
    WS(weakSelf);
    if (_clearingView == nil) {
        _clearingView = [[ClearingView alloc]init];
        [self.view addSubview:_clearingView];
        self.clearingView.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomSpaceToView(self.view,0)
        .heightIs(58);
        //全选  取消全选
        _clearingView.seleteBtnBlock = ^(UIButton *sender){
            if (weakSelf.index == 0) {
                if (sender.selected) {
                    weakSelf.clearingView.seleteLab.text = @"全选";
                    weakSelf.seleteCount = 0;
                    [weakSelf.clearingView.clearingBtn setTitle:[NSString stringWithFormat:@"结算"] forState:UIControlStateNormal];
                    [weakSelf tableViewAllcells:weakSelf.effectTab selete:NO];
                    [weakSelf priceLabtext:weakSelf.maxPrice];
                    
                }else{
                    weakSelf.clearingView.seleteLab.text = @"取消全选";
                    NSInteger i = [weakSelf tableViewAllcells:weakSelf.effectTab selete:YES];
                    weakSelf.seleteCount = i;
                    [weakSelf.clearingView.clearingBtn setTitle:[NSString stringWithFormat:@"结算(%zd)",weakSelf.seleteCount] forState:UIControlStateNormal];
                    [weakSelf priceLabtext:weakSelf.maxPrice];
                }
            }else{
                if (sender.selected) {
                    weakSelf.clearingView.seleteLab.text = @"全选";
                    weakSelf.seleteCount = 0;
                    [weakSelf.clearingView.clearingBtn setTitle:[NSString stringWithFormat:@"删除"] forState:UIControlStateNormal];
                    [weakSelf tableViewAllcells:weakSelf.effectTab selete:NO];
                    [weakSelf priceLabtext:weakSelf.maxPrice];
                    
                }else{
                    weakSelf.clearingView.seleteLab.text = @"取消全选";
                    NSInteger i = [weakSelf tableViewAllcells:weakSelf.effectTab selete:YES];
                    weakSelf.seleteCount = i;
                    [weakSelf.clearingView.clearingBtn setTitle:[NSString stringWithFormat:@"删除(%zd)",weakSelf.seleteCount] forState:UIControlStateNormal];
                    [weakSelf priceLabtext:weakSelf.maxPrice];
                }
            }
        };
        //结算
        _clearingView.cliearingBtnBlock = ^{
            if (weakSelf.index == 0) {
                //结算
                if (weakSelf.didCellArr.count == 0) {
                    return ;
                }
                NSMutableArray *data = [[NSMutableArray alloc]init];
                for (int i = 0; i < self.didCellArr.count; i++) {
                    Shoppingcar_dataModel *dataModel = weakSelf.didCellArr[i];
                    NSString *str = [NSString stringWithFormat:@"%@|%@",dataModel.cart_id,dataModel.goods_num];
                    [data addObject:str];
                }
                if (data.count == self.didCellArr.count) {
                    ClearingVC *clear = [[ClearingVC alloc]init];
                    clear.dataArr = data;
                    [weakSelf.navigationController pushViewController:clear animated:YES];
                }
                
                
            }else{
                //删除
                [weakSelf tableViewDeletaCell:weakSelf.didCellArr];
                [weakSelf.effectTab reloadData];
                
                NSMutableArray *data = [[NSMutableArray alloc]init];
                for (int i = 0; i < weakSelf.didCellArr.count; i++) {
                    Shoppingcar_dataModel *dataModel = weakSelf.didCellArr[i];
                    NSString *str = [NSString stringWithFormat:@"%@",dataModel.cart_id];
                    [data addObject:str];
                }
                [weakSelf priceLabtext:weakSelf.maxPrice];
                if(weakSelf.seleteCount == 0){
                    
                    if (weakSelf.index == 0) {
                        [weakSelf.clearingView.clearingBtn setTitle:[NSString stringWithFormat:@"结算"] forState:UIControlStateNormal];
                    }else{
                        [weakSelf.clearingView.clearingBtn setTitle:[NSString stringWithFormat:@"删除"] forState:UIControlStateNormal];
                    }
                    weakSelf.clearingView.seleteBtn.selected = NO;
                    weakSelf.clearingView.seleteLab.text = @"全选";
                }else{
                    if (weakSelf.index == 0) {
                        [weakSelf.clearingView.clearingBtn setTitle:[NSString stringWithFormat:@"结算(%zd)",weakSelf.seleteCount] forState:UIControlStateNormal];
                    }else{
                        [weakSelf.clearingView.clearingBtn setTitle:[NSString stringWithFormat:@"删除(%zd)",weakSelf.seleteCount] forState:UIControlStateNormal];
                    }
                    weakSelf.clearingView.seleteBtn.selected = NO;
                    weakSelf.clearingView.seleteLab.text = @"全选";
                }
                
                if (data.count == self.didCellArr.count) {
                    [YPCNetworking postWithUrl:@"shop/cart/delete"
                                  refreshCache:YES
                                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                               @"cart_id":data
                                                                                               }]
                                       success:^(id response) {
                                           
                                           
                                       }
                                          fail:^(NSError *error) {
                                              
                                          }];
                }
            }
            
        };
        
    }
    return _clearingView;
}

- (ChooseSize *)chooseSize{
    if (_chooseSize == nil) {
        WS(weakSelf);
        [self.view addSubview:self.bgView];
        _chooseSize =  [[ChooseSize alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 483) count:15 maxCount:20];
        _chooseSize.did = ^(NSString *goods_id,NSString *count,NSString *payType){
            
            NSIndexPath *index = (NSIndexPath *)weakSelf.object;
            ShoppingCarModel *model = weakSelf.dataArr[index.section];
            Shoppingcar_dataModel *dataModel = model.data[index.row];
            dataModel.goods_num = count;
            [YPCNetworking postWithUrl:@"shop/cart/update"
                          refreshCache:YES
                                params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                       @"cart_id":dataModel.cart_id,
                                                                                       @"goods_id":goods_id,
                                                                                       @"count":count
                                                                                       }]
                               success:^(id response) {
                                   ShoppongCarCell *cell = [weakSelf.effectTab cellForRowAtIndexPath:index];
                                   if (payType.length != 0) {
                                       dataModel.goods_spec = payType;
                                       cell.sizeLab.text = payType;
                                       cell.sizeLab2.text = payType;
                                   }
                                   dataModel.goods_id = goods_id;
                                   
                               }
                                  fail:^(NSError *error) {
                                      
                                  }];
            [weakSelf chooseSizeHide];
        };
        _chooseSize.cancel = ^{
            [weakSelf chooseSizeHide];
        };
        _chooseSize.push = ^{
            WebViewController *web = [[WebViewController alloc]init];
            web.navTitle = @"尺码助手";
            web.homeUrl = weakSelf.model.specdesc_url;
            [weakSelf.navigationController pushViewController:web animated:YES];
        };
        [self.view addSubview:_chooseSize];
    }
    return _chooseSize;
}

- (UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [[UIView alloc]initWithFrame:self.view.bounds];
        _bgView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancel)];
        [_bgView addGestureRecognizer:tap];
        [self.view addSubview:_bgView];
        _bgView.alpha = 0.3;
        _bgView.hidden = YES;
    }
    return _bgView;
}

- (UIView *)noDataView{
    if (_noDataView == nil) {
        _noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 400)];
  
        _noDataView.backgroundColor = [Color colorWithHex:@"0xefefef"];
        UIImageView *img = [[UIImageView alloc]initWithImage:IMAGE(@"blankpage_cart_nofindgoods_icon")];
        [_noDataView addSubview:img];
        img.sd_layout
        .widthIs(110)
        .heightIs(110)
        .centerXEqualToView(_noDataView)
        .centerYEqualToView(_noDataView);
        UILabel *nameLab = [[UILabel alloc]init];
        nameLab.text = @"购物车空空如也,快去添加商品";
        nameLab.font = [UIFont systemFontOfSize:15];
        nameLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
        nameLab.textAlignment = NSTextAlignmentCenter;
        [_noDataView addSubview:nameLab];
        nameLab.sd_layout
        .leftEqualToView(_noDataView)
        .rightEqualToView(_noDataView)
        .topSpaceToView(img,50)
        .heightIs(20);
    }
    
    return _noDataView;
}

- (void)cancel{
    [self chooseSizeHide];
}


- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}

- (NSMutableArray *)invalid_cartArr{
    if (_invalid_cartArr == nil) {
        _invalid_cartArr = [[NSMutableArray alloc]init];
    }
    return _invalid_cartArr;
}

- (NSMutableArray *)guessLikeArr{
    if (_guessLikeArr == nil) {
        _guessLikeArr = [[NSMutableArray alloc]init];
    }
    return _guessLikeArr;
}

- (NSMutableArray *)didCellArr{
    if (_didCellArr == nil) {
        _didCellArr = [[NSMutableArray alloc]init];
    }
    return _didCellArr;
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
