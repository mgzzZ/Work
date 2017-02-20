//
//  LiveBottomView.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/14.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LiveBottomView.h"
#import "LiveSimpleCell.h"
#import "LiveSimpleModel.h"

@interface LiveBottomView ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)UIImageView *txImg;
@property (nonatomic,strong)UILabel *nameLab;
@property (nonatomic,strong)UILabel *likeLab;
@property (nonatomic,strong)UILabel *funsLab;
@property (nonatomic,strong)UIButton *fllowBtn;
@property (nonatomic,strong)UIButton *messageBtn;
@property (nonatomic,strong)UIButton *txBtn;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)LiveSimpleModel *model;
@end

@implementation LiveBottomView


- (instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
    }
    return self;
}


- (void)setStore_id:(NSString *)store_id{
    WS(weakself);
    if (![_store_id isEqualToString:store_id]) {
        _store_id = store_id;
    }
    [YPCNetworking postWithUrl:@"shop/showstore/breif"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"store_id" : store_id,
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakself.model = [LiveSimpleModel mj_objectWithKeyValues:response[@"data"]];
                               [weakself.txImg sd_setImageWithURL:[NSURL URLWithString:weakself.model.info.store_avatar] placeholderImage:YPCImagePlaceHolder];
                               weakself.nameLab.text = weakself.model.info.store_name;
                               weakself.likeLab.text = [NSString stringWithFormat:@"%@人气",weakself.model.info.goods_count];
                               weakself.funsLab.text = [NSString stringWithFormat:@"%@粉丝",weakself.model.info.likenum];
                               if ([weakself.model.info.isfollow isEqualToString:@"1"]) {
                                   weakself.fllowBtn.selected = YES;
                               }else{
                                   weakself.fllowBtn.selected = NO;
                               }
                               [weakself.tableView reloadData];
                               
                           }
                       }
                          fail:^(NSError *error) {
                              
                          }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.list.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    LiveSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"LiveSimpleCell" owner:self options:nil][0];
    }
    cell.model = self.model.list.data[indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LiveSimpleData *model = self.model.list.data[indexPath.row];
    if (self.didcell) {
        [self animationHiden];
        self.didcell(model.live_id);
    }
}

- (void)viewDidLayoutSubviews{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    
    return 50;
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
    NSString *text = @"暂无往期回放";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName: [Color colorWithHex:@"0x2c2c2c"]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        [self addSubview:_tableView];
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.frame = CGRectMake(0, ScreenHeight * 2 / 5, ScreenWidth, ScreenHeight * 3 / 5);
    }
    return _tableView;
}

-  (UIView *)headerView{
    
    if (_headerView == nil) {
        _headerView = [[UIView alloc]init];
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerView.sd_layout
        .leftEqualToView(self)
        .heightIs(168)
        .rightEqualToView(self)
        .topEqualToView(self);
        
        UIView *bottomView = [[UIView alloc]init];
        bottomView.backgroundColor = [Color colorWithHex:@"0xefefef"];
        [_headerView addSubview:bottomView];
        bottomView.sd_layout
        .leftEqualToView(_headerView)
        .bottomEqualToView(_headerView)
        .rightEqualToView(_headerView)
        .heightIs(1);
        
        _txImg = [[UIImageView alloc]init];
        [_headerView addSubview:_txImg];
        _txImg.sd_layout
        .centerXEqualToView(_headerView)
        .topSpaceToView(_headerView,14)
        .widthIs(44)
        .heightIs(44);
        _txImg.layer.cornerRadius = 22;
        _txImg.layer.masksToBounds = YES;
        _txImg.userInteractionEnabled = YES;
        _txBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headerView addSubview:_txBtn];
        [_txBtn addTarget:self action:@selector(txBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _txBtn.sd_layout
        .centerXEqualToView(_headerView)
        .topSpaceToView(_headerView,14)
        .widthIs(44)
        .heightIs(44);
        
        _nameLab = [[UILabel alloc]init];
        [_headerView addSubview:_nameLab];
        _nameLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
        _nameLab.textAlignment = NSTextAlignmentCenter;
        _nameLab.font = [UIFont systemFontOfSize:18];
        _nameLab.sd_layout
        .leftEqualToView(_headerView)
        .rightEqualToView(_headerView)
        .topSpaceToView(_txImg,10)
        .heightIs(20);
        
        UIView *midView = [[UIView alloc]init];
        [_headerView addSubview:midView];
        midView.backgroundColor = [Color colorWithHex:@"0xefefef"];
        midView.sd_layout
        .centerXEqualToView(_headerView)
        .widthIs(1)
        .heightIs(12)
        .topSpaceToView(_nameLab,14);
        _likeLab = [[UILabel alloc]init];
        [_headerView addSubview:_likeLab];
        _likeLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
        _likeLab.font = [UIFont systemFontOfSize:13];
        _likeLab.textAlignment = NSTextAlignmentRight;
        _likeLab.sd_layout
        .rightSpaceToView(midView,30)
        .leftEqualToView(_headerView)
        .heightIs(13)
        .centerYEqualToView(midView);
        _funsLab = [[UILabel alloc]init];
        [_headerView addSubview:_funsLab];
        _funsLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
        _funsLab.font = [UIFont systemFontOfSize:13];
        _funsLab.textAlignment = NSTextAlignmentLeft;
        _funsLab.sd_layout
        .leftSpaceToView(midView,30)
        .rightEqualToView(_headerView)
        .heightIs(13)
        .centerYEqualToView(midView);
        
        _fllowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fllowBtn setImage:IMAGE(@"follow_button") forState:UIControlStateNormal];
        [_fllowBtn setImage:IMAGE(@"follow_button_clicked") forState:UIControlStateSelected];
        [_fllowBtn addTarget:self action:@selector(fllowBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:_fllowBtn];
        _fllowBtn.sd_layout
        .rightSpaceToView(midView,15)
        .widthIs(67)
        .heightIs(24)
        .topSpaceToView(_likeLab,15);
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_messageBtn setImage:IMAGE(@"sixin_button") forState:UIControlStateNormal];
        [_messageBtn addTarget:self action:@selector(pushMessageClick) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:_messageBtn];
        _messageBtn.sd_layout
        .leftSpaceToView(midView,15)
        .widthIs(67)
        .heightIs(24)
        .topSpaceToView(_likeLab,15);
        
        
    }
    return _headerView;
}

- (UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [[UIView alloc]init];
         [self.window addSubview:_bgView];
        _bgView.backgroundColor = [UIColor clearColor];
        _bgView.hidden = YES;
        _bgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight * 2 / 5);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(animationHiden)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}
- (void)animationShow{

    [UIView animateWithDuration:0.3 animations:^{
        CGFloat height = ScreenHeight * 3  /  5;
        self.bgView.hidden = NO;
        self.tableView.frame = CGRectMake(0, ScreenHeight - height, ScreenWidth, height);
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
     
    }];
    
}

- (void)animationHiden{
    
    [UIView animateWithDuration:0.3 animations:^{
         CGFloat height = ScreenHeight * 3  /  5;
        self.tableView.frame = CGRectMake(0, ScreenHeight  + ScreenHeight - height, ScreenWidth, height);
        self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
        self.bgView.hidden = YES;
    } completion:^(BOOL finished) {
        if (finished) {
        }
    }];
}

- (void)txBtnClick:(UIButton *)sender{
    if (self.didTxBtnClick) {
        self.didTxBtnClick(self.model.info.store_id);
    }
}

- (void)fllowBtnClick:(UIButton *)sender{

    [YPCRequestCenter isLoginAndPresentLoginVC:[YPC_Tools getControllerWithView:self] success:^{
        if (sender.selected) {
            //取消关注
            sender.selected = NO;
            [self followstore_cancel];
        }else{
            //关注
            sender.selected = YES;
            [self followstore_add];
        }
    }];
}
- (void)pushMessageClick{
   
    [YPCRequestCenter isLoginAndPresentLoginVC:[YPC_Tools getControllerWithView:self] success:^{
        if (self.pushMessage) {
            [self animationHiden];
            self.pushMessage(self.model.info.hx_uname);
        }
    }];
    
}
- (void)followstore_add{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/showstore/followstore/add"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{@"store_id":weakSelf.store_id
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                           }
                           
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}
- (void)followstore_cancel{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/showstore/followstore/cancel"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{@"store_id":weakSelf.store_id
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                           }
                           
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}
@end
