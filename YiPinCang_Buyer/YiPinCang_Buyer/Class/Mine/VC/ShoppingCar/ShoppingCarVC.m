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
static NSString *cellId = @"noedit";
static NSString *cellId2 = @"edit";
@interface ShoppingCarVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic,strong)UITableView *tableView;
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

@end

@implementation ShoppingCarVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getDataList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WS(weakSelf);
    self.navigationItem.title = @"购物车";
    self.index = 0;
    self.seleteCount = 0;
    self.maxPrice = 0.00;
    self.didCellArr = [[NSMutableArray alloc]init];
    self.guessLikeArr = [[NSMutableArray alloc]init];
    self.dataArr = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *rightBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.selected = NO;
    [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [rightBtn setTitle:@"完成" forState:UIControlStateSelected];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
    self.isChooseSize = NO;
    [self setup];
    [self getDataList];
    self.bgView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.bgView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.bgView];
    self.bgView.alpha = 0.3;
    self.bgView.hidden = YES;
    self.clearingView = [[ClearingView alloc]init];
    [self.view addSubview:self.clearingView];
    self.clearingView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view,0)
    .heightIs(58);
    //全选  全不选
    self.clearingView.seleteBtnBlock = ^(UIButton *sender){
        if (self.index == 0) {
            if (sender.selected) {
                weakSelf.clearingView.seleteLab.text = @"全选";
                weakSelf.seleteCount = 0;
                [weakSelf.clearingView.clearingBtn setTitle:[NSString stringWithFormat:@"结算"] forState:UIControlStateNormal];
                [weakSelf tableViewAllcells:weakSelf.tableView selete:NO];
                [weakSelf priceLabtext:weakSelf.maxPrice];
                
            }else{
                weakSelf.clearingView.seleteLab.text = @"全不选";
                NSInteger i = [weakSelf tableViewAllcells:weakSelf.tableView selete:YES];
                weakSelf.seleteCount = i;
                [weakSelf.clearingView.clearingBtn setTitle:[NSString stringWithFormat:@"结算(%zd)",weakSelf.seleteCount] forState:UIControlStateNormal];
                [weakSelf priceLabtext:weakSelf.maxPrice];
            }
        }else{
            if (sender.selected) {
                weakSelf.clearingView.seleteLab.text = @"全选";
                weakSelf.seleteCount = 0;
                [weakSelf.clearingView.clearingBtn setTitle:[NSString stringWithFormat:@"删除"] forState:UIControlStateNormal];
                [weakSelf tableViewAllcells:weakSelf.tableView selete:NO];
                [weakSelf priceLabtext:weakSelf.maxPrice];
                
            }else{
                weakSelf.clearingView.seleteLab.text = @"全不选";
                NSInteger i = [weakSelf tableViewAllcells:weakSelf.tableView selete:YES];
                weakSelf.seleteCount = i;
                [weakSelf.clearingView.clearingBtn setTitle:[NSString stringWithFormat:@"删除(%zd)",weakSelf.seleteCount] forState:UIControlStateNormal];
                [weakSelf priceLabtext:weakSelf.maxPrice];
            }
        }
    };
    //结算
    self.clearingView.cliearingBtnBlock = ^{
        if (self.index == 0) {
            //结算
            if (self.didCellArr.count == 0) {
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
            [weakSelf.tableView reloadData];
            
            NSMutableArray *data = [[NSMutableArray alloc]init];
            for (int i = 0; i < self.didCellArr.count; i++) {
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
    self.chooseSize =  [[ChooseSize alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 483) count:15 maxCount:20];
    self.chooseSize.did = ^(NSString *goods_id,NSString *count,NSString *payType){
        
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
                               ShoppongCarCell *cell = [weakSelf.tableView cellForRowAtIndexPath:index];
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
    self.chooseSize.cancel = ^{
        [weakSelf chooseSizeHide];
    };
    [self.view addSubview:self.chooseSize];
    
    
    
    
}

- (void)setup{
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.backgroundColor = [Color colorWithHex:@"0xefefef"];
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
}


- (void)getDataList{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/cart/list"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.dataArr = [ShoppingCarModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                               if (weakSelf.dataArr.count == 0) {
                                   weakSelf.tableView.tableHeaderView = weakSelf.noDataView;
                                   weakSelf.clearingView.hidden = YES;
                                   self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
                               }else{
                                   weakSelf.tableView.tableHeaderView = [UIView new];
                                   weakSelf.clearingView.hidden = NO;
                                   self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 58, 0));
                               }
                               [weakSelf.tableView reloadData];
                               [weakSelf getDataGuessUlike];
                           }
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}

- (void)getDataGuessUlike{
    WS(weakSelf);
    
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
                               
                               
                               GuessLikeView *guessLikeView = [[GuessLikeView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ((ScreenWidth - 46) / 2 * 182 / 137 +60 + 20) * weakSelf.guessLikeArr.count / 2 + 50)];
                               guessLikeView.dataArr = weakSelf.guessLikeArr;
                               guessLikeView.didSelect = ^(NSIndexPath *index){
                                   ShoppingCarDetailVC *shopping = [[ShoppingCarDetailVC alloc]init];
                                   GuessModel *model = weakSelf.guessLikeArr[index.row];
                                   shopping.goods_id = model.goods_commonid;
                                   [weakSelf.navigationController pushViewController:shopping animated:YES];

                               };
                               weakSelf.tableView.tableFooterView = guessLikeView;
                               
                           }
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
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
    titleLab.font = [UIFont boldSystemFontOfSize:18];
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
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 7)];
    view.backgroundColor = [Color colorWithHex:@"0xefefef"];
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ShoppingCarModel *model = self.dataArr[section];
    return model.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.index == 0) {
        return 110;
    }else{
        return 97;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 42;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WS(weakSelf);
    if (self.index == 0) {
        ShoppongCarCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShoppongCarCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ShoppingCarModel *model = self.dataArr[indexPath.section];
        Shoppingcar_dataModel *dataModel = model.data[indexPath.row];
        cell.model = dataModel;
        cell.deleteBlock = ^{
            weakSelf.object = indexPath;
            [YPCNetworking postWithUrl:@"shop/cart/delete"
                          refreshCache:YES
                                params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                       @"cart_id":dataModel.cart_id
                                                                                       }]
                               success:^(id response) {
                                   [model.data removeObjectAtIndex:indexPath.row];
                                   [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                   
                                   //[weakSelf.tableView reloadData];
                                   
                               }
                                  fail:^(NSError *error) {
                                      
                                  }];
        };
        //左边按钮选择
        cell.seleteBlock = ^(UIButton *sender){
            dataModel.seleted = !sender.selected;
            if (sender.selected) {
                weakSelf.seleteCount--;
                weakSelf.maxPrice -= dataModel.goods_price.floatValue * dataModel.goods_num.integerValue;
                [weakSelf priceLabtext:weakSelf.maxPrice];
                [weakSelf.didCellArr removeObject:dataModel];
            }else{
                weakSelf.seleteCount++;
                weakSelf.maxPrice += dataModel.goods_price.floatValue * dataModel.goods_num.integerValue;
                
                [weakSelf priceLabtext:weakSelf.maxPrice];
                [weakSelf.didCellArr addObject:dataModel];
            }
            
            
            if (weakSelf.seleteCount == weakSelf.didCellArr.count) {
                weakSelf.clearingView.seleteBtn.selected = YES;
                weakSelf.clearingView.seleteLab.text = @"全不选";
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
        };
        
        cell.payCountBlock = ^(NSString *num){
            NSString *oldNum = dataModel.goods_num;
            //小于0 代表增加购物数量
            //大于0 代表较少数量
            if (oldNum.integerValue - num.integerValue < 0) {
                if (weakSelf.maxPrice != 0.00) {
                    weakSelf.maxPrice += (num.integerValue - oldNum.integerValue) * dataModel.goods_price.floatValue;
                    [weakSelf priceLabtext:weakSelf.maxPrice];
                }
            }else{
                if (weakSelf.maxPrice != 0.00) {
                    weakSelf.maxPrice -= (oldNum.integerValue - num.integerValue ) * dataModel.goods_price.floatValue;
                    [weakSelf priceLabtext:weakSelf.maxPrice];
                }
            }
            dataModel.goods_num = num;
            [YPCNetworking postWithUrl:@"shop/cart/update"
                          refreshCache:YES
                                params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                       @"cart_id":dataModel.cart_id,
                                                                                       @"goods_id":dataModel.goods_id,
                                                                                       @"count":num
                                                                                       }]
                               success:^(id response) {
                                   
                               }
                                  fail:^(NSError *error) {
                                      
                                  }];
            
            
        };
        return cell;
    }else{
        ShoppongCarCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShoppongCarCell" owner:self options:nil];
            cell = [nib objectAtIndex:1];
        }
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
            
            if (weakSelf.seleteCount == weakSelf.didCellArr.count) {
                weakSelf.clearingView.seleteBtn.selected = YES;
                weakSelf.clearingView.seleteLab.text = @"全不选";
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
        };
        cell.payCountBlock = ^(NSString *num){
            NSString *oldNum = dataModel.goods_num;
            //小于0 代表增加购物数量
            //大于0 代表较少数量
            if (oldNum.integerValue - num.integerValue < 0) {
                if (weakSelf.maxPrice != 0.00) {
                    weakSelf.maxPrice += (num.integerValue - oldNum.integerValue) * dataModel.goods_price.floatValue;
                    [weakSelf priceLabtext:weakSelf.maxPrice];
                }
            }else{
                if (weakSelf.maxPrice != 0.00) {
                    weakSelf.maxPrice -= (oldNum.integerValue - num.integerValue ) * dataModel.goods_price.floatValue;
                    [weakSelf priceLabtext:weakSelf.maxPrice];
                }
            }
            dataModel.goods_num = num;
        };
        return cell;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.index == 0) {
        for (ShoppongCarCell *cell in [self.tableView visibleCells]) {
            [cell.payCount1.textField resignFirstResponder];
            [cell.payCount2.textField resignFirstResponder];
        }
        ShoppingCarDetailVC *shopping = [[ShoppingCarDetailVC alloc]init];
        ShoppingCarModel *model = self.dataArr[indexPath.section];
        Shoppingcar_dataModel *dataModel = model.data[indexPath.row];
        shopping.goods_id = dataModel.goods_commonid;
        [self.navigationController pushViewController:shopping animated:YES];
    }
}
- (UIView *)noDataView{
    if (_noDataView == nil) {
        _noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - kHeight(260))];
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

#pragma mark- 编辑按钮

- (void)rightBtnClick:(UIButton *)sender{
    if (sender.selected == NO) {
        sender.selected = YES;
        self.index = 1;
        [self.clearingView.clearingBtn setTitle:[NSString stringWithFormat:@"删除(%zd)",self.seleteCount]forState:UIControlStateNormal];
        self.clearingView.priceLab.hidden = YES;
    }else{
        sender.selected = NO;
        self.index = 0;
        [self.clearingView.clearingBtn setTitle:[NSString stringWithFormat:@"结算(%zd)",self.seleteCount]forState:UIControlStateNormal];
        self.clearingView.priceLab.hidden = NO;
    }
    [self.tableView reloadData];
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
    }];
}


#pragma mark - 遍历tableview所有cell 不是可见cell
//遍历所有cell
- (NSInteger )tableViewAllcells:(UITableView *)tableView selete:(BOOL)seleted{
    
    int k = 0; // 记录cell个数
    for (int i = 0; i<self.dataArr.count; i++) {
        ShoppingCarModel *model = self.dataArr[i];
        for (int j = 0; j< model.data.count; j++) {
            
            NSIndexPath *newIndex = [NSIndexPath indexPathForRow:j inSection:i];
            ShoppongCarCell *cell = [tableView cellForRowAtIndexPath:newIndex];
            Shoppingcar_dataModel *dataModel = model.data[j];
            //遍历所有能点击的
            if ([dataModel.type isEqualToString:@"1"]) {
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
                        self.tableView.tableHeaderView = self.noDataView;
                        self.clearingView.hidden = YES;
                        self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
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
