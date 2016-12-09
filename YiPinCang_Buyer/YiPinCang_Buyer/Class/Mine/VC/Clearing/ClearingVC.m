//
//  ClearingVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/22.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "ClearingVC.h"
#import "ShoppongCarCell.h"
#import "MineClearingAreaCell.h"
#import "MineClearingOtherCell.h"
#import "MineClearingDistributionCell.h"
#import "CliearingModel.h"
#import "CleaingOrderCell.h"
#import "AreaManagerVC.h"
#import "InvVC.h"
#import "ChoosePayVC.h"
static NSString *cellId = @"noedit";
static NSString *AreacellId = @"Area";
static NSString *OthercellId = @"Other";
static NSString *DistributioncellId = @"Distribution";

@interface ClearingVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UILabel *priceLab;
@property (nonatomic ,strong) dispatch_source_t timer;
@property (nonatomic,strong)CliearingModel *model;
@property (nonatomic,strong)id data;
@property (nonatomic,strong)NSString *invoice_id;
@property (nonatomic,strong)NSString *text;
@property (nonatomic,strong)NSString *freight;
@property (nonatomic,strong)NSString *oldfreight;
@end

@implementation ClearingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!_timer) {
        __block int timeout = 1200; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout <= 0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.navigationItem.title = @"订单确认";
                });
            }else{
                int minutes = timeout / 60;
                int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"订单确认(%.2d:%.2d)",minutes, seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.navigationItem.title = strTime;
                    
                });
                timeout--;
                
            }
        });
        dispatch_resume(_timer);
    }

    
    self.view.backgroundColor = [Color colorWithHex:@"0xefefef"];
    self.text = @"";
    self.invoice_id = @"";
    self.click_from_type = @"6";
}

#pragma mark- getter setter

- (void)setDataArr:(NSMutableArray *)dataArr{
    if (_dataArr != dataArr) {
        _dataArr = dataArr;
    }
    self.data = _dataArr;
    [self getDataWithLikt:self.data];
}

- (void)setDataStr:(NSString *)dataStr{
    if(![_dataStr isEqualToString:dataStr]){
        _dataStr =dataStr;
    }
    self.data = _dataStr;
    [self getDataWithLikt:self.data];
}

#pragma mark- init

- (void)setup{
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [Color colorWithHex:@"0xefefef"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 58, 0));
    self.tableView.tableFooterView = [UIView new];
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    bgView.sd_layout
    .topSpaceToView(self.tableView,0)
    .leftEqualToView(self.tableView)
    .rightEqualToView(self.tableView)
    .bottomEqualToView(self.view);
    
    self.priceLab = [[UILabel alloc]init];
    self.priceLab.textAlignment = NSTextAlignmentLeft;
    self.priceLab.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:self.priceLab];
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.backgroundColor = [Color colorWithHex:@"#E4393C"];
    [payBtn setTitle:@"结算" forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(clearBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:payBtn];
    payBtn.sd_layout
    .rightEqualToView(bgView)
    .topEqualToView(bgView)
    .bottomEqualToView(bgView)
    .widthIs(116);
    self.priceLab.sd_layout
    .leftSpaceToView(bgView,15)
    .topEqualToView(bgView)
    .bottomEqualToView(bgView)
    .rightSpaceToView(payBtn,10);
    
}

#pragma mark- getdata

- (void)getDataWithLikt:(id)data{
    WS(weakself);
    [YPCNetworking postWithUrl:@"shop/flow/checkorder"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"cart_id":data
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakself.model = [CliearingModel mj_objectWithKeyValues:response[@"data"]];
                               weakself.oldfreight = weakself.model.freight;
                               if (!weakself.tableView) {
                                   [weakself setup];
                               }
                               [weakself.tableView reloadData];
                               NSString *str = [NSString stringWithFormat:@"合计:¥%@",self.model.total_price];
                               [weakself priceLabtext:str];
                           }
                       }
                          fail:^(NSError *error) {
                              
                          }];
}

#pragma mark- delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.model.store_cart_list.count + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section < self.model.store_cart_list.count) {
        ShoppingCarModel *model = self.self.model.store_cart_list[section];
        return model.data.count;
    }else{
        return 6;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section < self.model.store_cart_list.count) {
        ShoppingCarModel *model = self.model.store_cart_list[section];
        
        
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
    }else{
        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(0, 0, ScreenWidth, 1);
        view.backgroundColor = [UIColor whiteColor];
        return view;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 7)];
    view.backgroundColor = [Color colorWithHex:@"0xefefef"];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section < self.model.store_cart_list.count) {
        
        return 42;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < self.model.store_cart_list.count) {
        return 89;
    }else{
        if (indexPath.row == 0) {
            
            return 80;
            
        }else if (indexPath.row == 1){
            return 69;
            
        }else{
            if (indexPath.row == 3 && ![self.model.inv_info.content isEqualToString:@"不需要发票"]) {
                return 69;
            }else{
                return 42;
            }
        }
        
    }
}
- (CGFloat )tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == self.model.store_cart_list.count) {
        if (indexPath.row == 0) {
            
            return 80;
            
        }
    }
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < self.model.store_cart_list.count) {
        CleaingOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CleaingOrderCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        ShoppingCarModel *model = self.model.store_cart_list[indexPath.section];
        Shoppingcar_dataModel *dataModel = model.data[indexPath.row];
        cell.model = dataModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        if (indexPath.row == 0) {
            MineClearingAreaCell *cell = [tableView dequeueReusableCellWithIdentifier:AreacellId];
            if (!cell) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MineClearingAreaCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.phoneLab.text = self.model.address_info.mob_phone;
            cell.areaLab.text = self.model.address_info.address;
            if ([self.model.address_info.is_default isEqualToString:@"1"]) {
                cell.typeLab.hidden = NO;
            }else{
                cell.typeLab.hidden = YES;
            }
            return cell;

        }else if (indexPath.row == 1){
            MineClearingDistributionCell *cell = [tableView dequeueReusableCellWithIdentifier:DistributioncellId];
            if (!cell) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MineClearingDistributionCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.areaLab.text = [NSString stringWithFormat:@"运费¥%@",self.model.freight];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }else{
            if (indexPath.row == 4 && ![self.model.inv_info.content isEqualToString:@"不需要发票"]) {
                MineClearingDistributionCell *cell = [tableView dequeueReusableCellWithIdentifier:DistributioncellId];
                if (!cell) {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MineClearingDistributionCell" owner:self options:nil];
                    cell = [nib objectAtIndex:0];
                }
                cell.phoneLab.textColor = [UIColor redColor];
                cell.phoneLab.text = [NSString stringWithFormat:@"¥%@",self.model.store_goods_total];
                cell.areaLab.font = [UIFont systemFontOfSize:10];
                cell.areaLab.text = [NSString stringWithFormat:@"商品总额¥%@;运费¥%@;发票人民币%@",self.model.store_goods_total,self.model.freight,self.model.inv_price];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else{
                MineClearingOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:OthercellId];
                if (!cell) {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MineClearingOtherCell" owner:self options:nil];
                    cell = [nib objectAtIndex:0];
                }
                
                NSArray *nameArr = @[@"支付方式",@"发票",@"应付总额",@"备注"];
                NSArray *rightArr = @[@"在线支付",self.model.inv_info.content,[NSString stringWithFormat:@"¥%@(含运费¥%@)",self.model.store_goods_total,self.model.freight],@""];
                cell.titleLab.text = nameArr[indexPath.row - 2];
                cell.textField.text = rightArr[indexPath.row - 2];
                cell.typeImg.hidden = YES;
                if (indexPath.row == 5) {
                    cell.textField.userInteractionEnabled = YES;
                     cell.textField.placeholder = @"请输入备注信息";
                    self.text = cell.textField.text;
                }else if (indexPath.row == 3) {
                    cell.typeImg.hidden = NO;
                    cell.textField.userInteractionEnabled = NO;
                }else{
                    cell.textField.userInteractionEnabled = NO;
                   
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WS(weakself);
    if (indexPath.section < self.model.store_cart_list.count) {
        return;
    }else{
        if (indexPath.row == 3) {
            //开发票
            MineClearingOtherCell *cell = (MineClearingOtherCell *)[tableView cellForRowAtIndexPath:indexPath];
            InvVC *inv = [[InvVC alloc]init];
            inv.backname = ^(NSString *str,NSString *inv_id){
                cell.textField.text = str;
                weakself.invoice_id = inv_id;
            };
            [self.navigationController pushViewController:inv animated:YES];
        }else if (indexPath.row == 0){
            //地址管理
            AreaManagerVC *areaManager = [[AreaManagerVC alloc]init];
            areaManager.backArea = ^(NSString *name,NSString *area,NSString *isDefault,NSString *address_id,NSString *area_id,NSString *city_id){
                MineClearingAreaCell *cell = (MineClearingAreaCell *)[tableView cellForRowAtIndexPath:indexPath];
                if ([isDefault isEqualToString:@"1"]) {
                    cell.typeLab.hidden = NO;
                }else{
                    cell.typeLab.hidden = YES;
                }
                cell.phoneLab.text = name;
                cell.areaLab.text = area;
                weakself.model.address_info.address_id = address_id;
                [weakself changeAddress:city_id area_id:area_id];
                
            };
            [self.navigationController pushViewController:areaManager animated:YES];
        }else{
            return;
        }
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



#pragma mark-  --- 总计价格显示

- (void)priceLabtext:(NSString *)str{
    NSMutableAttributedString *mutuStr = [[NSMutableAttributedString alloc]initWithString:str];
    [mutuStr addAttribute:NSForegroundColorAttributeName value:[Color colorWithHex:@"#2C2C2C"] range:NSMakeRange(0, 3)];
    [mutuStr addAttribute:NSForegroundColorAttributeName value:[Color colorWithHex:@"#E4393C"] range:NSMakeRange(3, str.length - 3)];
    self.priceLab.attributedText = mutuStr;
}

- (void)clearBtnClcik{
    WS(weakself);
    [YPCNetworking postWithUrl:@"shop/flow/createorder"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"cart_id":self.data,
                                                                               @"pay_message":weakself.text,
                                                                               @"vat_hash":weakself.model.vat_hash,
                                                                               @"address_id":weakself.model.address_info.address_id,
                                                                               @"click_from_type":weakself.click_from_type,
                                                                               @"invoice_id":weakself.invoice_id
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               ChoosePayVC *choose = [[ChoosePayVC alloc]init];
                               choose.pay_sn = response[@"data"][@"pay_sn"];
                               choose.price = @"123";
                               [weakself.navigationController pushViewController:choose animated:YES];
                           }
                       }
                          fail:^(NSError *error) {
                              
                          }];
}
- (void)changeAddress:(NSString *)city_id area_id:(NSString *)area_id{
    
    WS(weakself);
    [YPCNetworking postWithUrl:@"shop/flow/changeaddr"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"freight_hash":weakself.model.freight_list,
                                                                               @"city_id":city_id,
                                                                               @"area_id":area_id
                                                                               
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakself.freight = response[@"data"][@"freight"];
                               NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:weakself.model.store_cart_list.count];
                               MineClearingDistributionCell *cell1 = [weakself.tableView cellForRowAtIndexPath:index];
                               cell1.areaLab.text = [NSString stringWithFormat:@"运费¥%@",weakself.freight];
                               NSIndexPath *index4 = [NSIndexPath indexPathForRow:4 inSection:weakself.model.store_cart_list.count];
                               if ([[weakself.tableView cellForRowAtIndexPath:index4] isKindOfClass:[MineClearingDistributionCell class]]) {
                                   MineClearingDistributionCell *cell4 = [weakself.tableView cellForRowAtIndexPath:index4];
                                   
                                   CGFloat price = weakself.model.total_price.floatValue - weakself.oldfreight.floatValue + weakself.freight.floatValue;
                                   cell4.areaLab.text = [NSString stringWithFormat:@"商品总额¥%.2f;运费¥%@;发票人民币%@",price,weakself.freight,weakself.model.inv_price];
                                   weakself.oldfreight = weakself.freight;
                                   NSString *str = [NSString stringWithFormat:@"合计:¥%.2f",price];
                                   [weakself priceLabtext:str];
                                   weakself.model.total_price = [NSString stringWithFormat:@"%.2f",price];
                               }else{
                                   MineClearingOtherCell *cell4 = [weakself.tableView cellForRowAtIndexPath:index4];
                                   cell4.typeImg.hidden = YES;
                                   CGFloat price = weakself.model.total_price.floatValue - weakself.oldfreight.floatValue + weakself.freight.floatValue;
                                   cell4.textField.text = [NSString stringWithFormat:@"¥%.2f(含运费¥%@)",price,weakself.freight];
                                   weakself.oldfreight = weakself.freight;
                                   NSString *str = [NSString stringWithFormat:@"合计:¥%.2f",price];
                                   [weakself priceLabtext:str];
                                   weakself.model.total_price = [NSString stringWithFormat:@"%.2f",price];
                               }

                           }
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
