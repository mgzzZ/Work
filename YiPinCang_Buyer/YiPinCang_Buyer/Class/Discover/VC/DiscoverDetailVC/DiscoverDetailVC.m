//
//  DiscoverDetailVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/14.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "DiscoverDetailVC.h"
#import "DiscoverCommentCell.h"
#import "PhotoContainerView.h"
#import "ShopCarView.h"
#import "DiscoverDetailModel.h"
#import "LoginVC.h"
#import "ChooseSize.h"
#import "ChooseSizeModel.h"
#import "KeyboardTextView.h"
#import "ClearingVC.h"
@interface DiscoverDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)DiscoverDetailModel *model;
@property (nonatomic,strong)UIImageView *bottomImg;
@property (nonatomic,strong)KeyboardTextView *keyboardView;
@property (nonatomic,strong)UILabel *likeCountLab;
@property (nonatomic,copy)NSString *comment_type;//1评论 3 回复
@property (nonatomic,copy)NSString *replyto;//回复人uid comment_type 1 时不用传
@property (nonatomic,copy)NSString *replytoname;//回复人名字
@property (nonatomic,strong)ShopCarView *shopcarView;
@property (nonatomic,strong)ChooseSizeModel *chooseModel;
@property (nonatomic,strong)ChooseSize *chooseSize;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,assign)BOOL isChooseSize;
@property (nonatomic,copy)NSString *payType;//0是先选  1加入购物车  2立即购买

@end

@implementation DiscoverDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"商品详情";
    self.isChooseSize = NO;
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self getData:@"1"];
   
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.isChooseSize) {
        [self chooseSizeHide];
    }
    
}
- (void)setup{
    WS(weakSelf);
    self.tableView = [[UITableView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.sd_layout
    .topSpaceToView(self.view,0)
    .rightEqualToView(self.view)
    .leftEqualToView(self.view)
    .bottomSpaceToView(self.view,58);
    
    self.keyboardView = [[KeyboardTextView alloc] initWithTextViewFrame:CGRectMake(0, ScreenHeight - 58 , ScreenWidth ,58)];
    
    [self.keyboardView setButtonClickedBlock:^(NSString *message) {
        [YPCNetworking postWithUrl:@"shop/explore/livecomment"
                      refreshCache:YES
                            params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                   @"strace_id":weakSelf.strace_id,
                                                                                   @"message":message,
                                                                                   @"replyto":weakSelf.replyto,
                                                                                   @"comment_type":weakSelf.comment_type
                                                                                   }]
                           success:^(id response) {
                               if ([YPC_Tools judgeRequestAvailable:response]) {
                                   CommentListModel *model = [[CommentListModel alloc]init];
                                   model.scomm_content = message;
                                   model.scomm_memberid = [YPCRequestCenter shareInstance].model.user_id;
                                   model.scomm_memberavatar = [YPCRequestCenter shareInstance].model.member_avatar;
                                   model.comment_type = weakSelf.comment_type;
                                   model.reback_memberid = weakSelf.replyto;
                                   model.reback_membername = weakSelf.replytoname;
                                   NSDate *datenow = [NSDate date];
                                   NSString *timeSp = [NSString stringWithFormat:@"%zd", (long)[datenow timeIntervalSince1970]];
                                   model.scomm_time = timeSp;
                                   [weakSelf.model.commentlist addObject:model];
                                   [weakSelf.tableView reloadData];
                               }
                           }
                              fail:^(NSError *error) {
                                  
                              }];
    }];
    
    [self.view addSubview:self.keyboardView];
    self.shopcarView = [[ShopCarView alloc]init];
    
    self.shopcarView.shopcar = ^{
        weakSelf.payType = @"1";
        if (![YPCRequestCenter isLogin]) {
            [weakSelf login];
        }else{
            [weakSelf chooseSizeShow];
            
        }
    };
    self.shopcarView.clearing = ^{
        weakSelf.payType = @"2";
        if (![YPCRequestCenter isLogin]) {
            [weakSelf login];
        }else{
            [weakSelf chooseSizeShow];
            
        }
        
    };
    
    [self.view addSubview:self.shopcarView];
    self.shopcarView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view,0)
    .heightIs(58);
    self.bgView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.bgView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.bgView];
    self.bgView.alpha = 0.3;
    self.bgView.hidden = YES;
    
    self.chooseSize.did = ^(NSString *goods_id,NSString *count,NSString *payType){
        
        
        if ([weakSelf.payType isEqualToString:@"1"]) {
            [YPCNetworking postWithUrl:@"shop/cart/add"
                          refreshCache:YES
                                params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                       @"goods_id":goods_id,
                                                                                       @"count":count,
                                                                                       @"click_from_type":@"6"
                                                                                       }]
                               success:^(id response) {
                                   if ([YPC_Tools judgeRequestAvailable:response]) {
                                       weakSelf.shopcarView.car.badgeValue = @"1";
                                       [weakSelf.shopcarView openAnimation];
                                       [weakSelf chooseSizeHide];
                                       
                                       if (payType.length != 0) {
                                           UILabel *lab = [weakSelf.view viewWithTag:1000];
                                           lab.text = payType;
                                       }
                                       
                                   }
                               }
                                  fail:^(NSError *error) {
                                      
                                  }];
        }else if ([weakSelf.payType isEqualToString:@"2"]){
            ClearingVC *clearing = [[ClearingVC alloc]init];
            NSString *str = [NSString stringWithFormat:@"%@|%@",goods_id,count];
            clearing.dataStr = str;
            [weakSelf.navigationController pushViewController:clearing animated:YES];
        }else{
            [weakSelf chooseSizeHide];
            UILabel *lab = [weakSelf.view viewWithTag:1000];
            lab.text = payType;
        }
        
    };
    
    self.chooseSize.cancel = ^{
        [weakSelf chooseSizeHide];
    };
    

}
- (ChooseSize *)chooseSize{
    if (_chooseSize == nil) {
        _chooseSize =  [[ChooseSize alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 483) count:15 maxCount:20];
        [self.view addSubview:_chooseSize];
    }
    return _chooseSize;
}
- (void)setHeardView{
    [self setup];
    self.headerView = [[UIView alloc]init];
    self.headerView.sd_layout.widthIs(ScreenWidth);
    self.headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headerView];
    UIImageView *img = [[UIImageView alloc]init];
    img.layer.cornerRadius = 23;
    img.layer.masksToBounds = YES;
    UILabel *nameLab = [[UILabel alloc]init];
    nameLab.textAlignment = NSTextAlignmentLeft;
    nameLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
    nameLab.font = [UIFont boldSystemFontOfSize:18];
    UIImageView *typeImg = [[UIImageView alloc]initWithImage:IMAGE(@"homepage_trailer_icon_yushou")];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = [UIFont systemFontOfSize:16];
    PhotoContainerView *phptosView = [[PhotoContainerView alloc]init];
    UILabel *priceLab = [[UILabel alloc]init];
    priceLab.textColor = [Color colorWithHex:@"0xe4393c"];
    priceLab.textAlignment = NSTextAlignmentLeft;
    priceLab.font = [UIFont systemFontOfSize:15];
    UILabel *countLab = [[UILabel alloc]init];
    countLab.textAlignment = NSTextAlignmentLeft;
    countLab.textColor = [Color colorWithHex:@"0xBFBFBF"];
    countLab.font = [UIFont systemFontOfSize:15];
    [self.headerView sd_addSubviews:@[img,nameLab,titleLab,priceLab,countLab,phptosView,typeImg]];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(chooseSizeClick) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *nextImg = [[UIImageView alloc]initWithImage:IMAGE(@"mine_productdetails_icon_more")];
    UILabel *timeLab = [[UILabel alloc]init];
    timeLab.textAlignment = NSTextAlignmentLeft;
    timeLab.textColor = [Color colorWithHex:@"0xBFBFBF"];
    timeLab.font = [UIFont systemFontOfSize:13];
    UILabel *commentLab = [[UILabel alloc]init];
    commentLab.textAlignment = NSTextAlignmentRight;
    commentLab.textColor = [Color colorWithHex:@"0xBFBFBF"];
    commentLab.font = [UIFont systemFontOfSize:13];
    UIImageView *commentImg = [[UIImageView alloc]initWithImage:IMAGE(@"find_productdetails_icon_commentnumber")];
    self.likeCountLab = [[UILabel alloc]init];
    self.likeCountLab.textAlignment = NSTextAlignmentRight;
    self.likeCountLab.textColor = [Color colorWithHex:@"0xBFBFBF"];
    self.likeCountLab.font = [UIFont systemFontOfSize:13];
    UIImageView *likeImg = [[UIImageView alloc]initWithImage:IMAGE(@"find_productdetails_icon_likes")];
    UILabel *guding = [[UILabel alloc]init];
    guding.text = @"选择尺码,颜色分类";
    guding.tag = 1000;
    guding.textColor = [Color colorWithHex:@"0x2c2c2c"];
    guding.textAlignment = NSTextAlignmentLeft;
    guding.font = [UIFont systemFontOfSize:13];
    self.bottomImg = [[UIImageView alloc]initWithImage:IMAGE(@"find_productdetails_icon_dialogbox")];
    if ([self.model.strace_comment isEqualToString:@"0"]) {
        self.bottomImg.hidden = YES;
    }else{
        self.bottomImg.hidden = NO;
    }
    
    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.model.islike isEqualToString:@"1"]) {
        likeBtn.selected = YES;
    }else{
        likeBtn.selected = NO;
    }
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView sd_addSubviews:@[btn,nextImg,timeLab,commentLab,commentImg,likeImg,self.likeCountLab,guding,self.bottomImg,likeBtn,commentBtn]];
    img.sd_layout
    .widthIs(46)
    .heightIs(45)
    .leftSpaceToView(self.headerView,15)
    .topSpaceToView(self.headerView,15);
    nameLab.sd_layout
    .leftSpaceToView(img,10)
    .topEqualToView(img)
    .heightIs(20)
    .rightSpaceToView(self.headerView,15);
    titleLab.sd_layout
    .leftEqualToView(nameLab)
    .rightSpaceToView(self.headerView,15)
    .topSpaceToView(img,0)
    .autoHeightRatio(0);
    
    typeImg.sd_layout
    .leftEqualToView(titleLab)
    .topSpaceToView(img,3)
    .widthIs(35)
    .heightIs(15);
    [img sd_setImageWithURL:[NSURL URLWithString:self.model.strace_storelogo] placeholderImage:YPCImagePlaceHolder];
    nameLab.text = self.model.strace_storename;
    
    if ([self.model.prestate isEqualToString:@"1"]) {
        //预售
        typeImg.hidden = NO;
        titleLab.text = [NSString stringWithFormat:@"         %@",self.model.goods_name];
    }else{
        typeImg.hidden = YES;
        titleLab.text = self.model.goods_name;
    }
    
    
    phptosView.sd_layout
    .leftEqualToView(nameLab);
    phptosView.picPathStringsArray = self.model.strace_content;
    phptosView.sd_layout
    .topSpaceToView(titleLab,10);
    
    priceLab.text = [NSString stringWithFormat:@"¥%@",self.model.goods_price];
    
    [priceLab sizeToFit];
    priceLab.sd_layout
    .leftEqualToView(nameLab)
    .topSpaceToView(phptosView,10)
    .heightIs(20)
    .widthIs(priceLab.frame.size.width);
    countLab.text = [NSString stringWithFormat:@"已售%@件",self.model.goods_salenum];
    countLab.sd_layout
    .leftSpaceToView(priceLab,15)
    .centerYEqualToView(priceLab)
    .heightIs(20)
    .rightSpaceToView(self.headerView,15);
    
    nextImg.sd_layout
    .topSpaceToView(priceLab,10)
    .rightSpaceToView(self.headerView,15)
    .widthIs(25)
    .heightIs(25);
    
    guding.sd_layout
    .leftEqualToView(nameLab)
    .heightIs(30)
    .centerYEqualToView(nextImg)
    .rightSpaceToView(self.headerView,0);
    
    btn.sd_layout
    .leftEqualToView(nameLab)
    .heightIs(30)
    .centerYEqualToView(nextImg)
    .rightSpaceToView(self.headerView,0);
    
    NSString *time = [YPC_Tools timeWithTimeIntervalString:self.model.strace_time Format:@"YYYY-MM-dd"];
    timeLab.text = time;
    
    [timeLab sizeToFit];
    timeLab.sd_layout
    .leftEqualToView(nameLab)
    .topSpaceToView(btn,10)
    .widthIs(timeLab.frame.size.width)
    .heightIs(15);
    
    commentLab.text = self.model.strace_comment;
    [commentLab sizeToFit];
    commentLab.sd_layout
    .rightSpaceToView(self.headerView,15)
    .widthIs(commentLab.frame.size.width)
    .centerYEqualToView(timeLab)
    .heightIs(15);
    
    commentImg.sd_layout
    .rightSpaceToView(commentLab,5)
    .widthIs(25)
    .heightIs(25)
    .centerYEqualToView(commentLab);
    
    self.likeCountLab.text = self.model.strace_cool;
    [self.likeCountLab sizeToFit];
    self.likeCountLab.sd_layout
    .rightSpaceToView(commentImg,30)
    .centerYEqualToView(commentLab)
    .widthIs(self.likeCountLab.frame.size.width)
    .heightIs(15);
   
    likeImg.sd_layout
    .rightSpaceToView(self.likeCountLab,5)
    .widthIs(25)
    .heightIs(25)
    .centerYEqualToView(commentLab);
    
    likeBtn.sd_layout
    .leftEqualToView(likeImg)
    .centerYEqualToView(likeImg)
    .rightEqualToView(self.likeCountLab)
    .heightIs(15);
    commentBtn.sd_layout
    .leftEqualToView(commentImg)
    .centerYEqualToView(commentImg)
    .rightEqualToView(commentLab)
    .heightIs(15);
    self.bottomImg.backgroundColor = [UIColor whiteColor];
    self.bottomImg.sd_layout
    .leftSpaceToView(self.headerView,30)
    .widthIs(15)
    .heightIs(8)
    .topSpaceToView(timeLab,12);
    [self.headerView setupAutoHeightWithBottomView:self.bottomImg bottomMargin:0];
    WS(weakself);
    self.headerView.didFinishAutoLayoutBlock = ^(CGRect rect){
        weakself.tableView.tableHeaderView = weakself.headerView;
    };
    
}
- (void)getData:(NSString *)page{
    WS(weakSelf);
    if ([self.typeStr isEqualToString:@"淘好货"] || self.typeStr == nil) {
        [YPCNetworking postWithUrl:@"shop/explore/livegoodsdetail"
                      refreshCache:YES
                            params:@{@"pagination":@{
                                             @"page":page,
                                             @"count":@"10"
                                             },
                                     @"strace_id":weakSelf.strace_id,
                                     @"live_id":@""
                                     }
                           success:^(id response) {
                               if ([YPC_Tools judgeRequestAvailable:response]) {
                                   weakSelf.model = [DiscoverDetailModel mj_objectWithKeyValues:response[@"data"]];
                                   
                                   if (!weakSelf.tableView) {
                                       
                                       if (!weakSelf.headerView) {
                                           [weakSelf setHeardView];
                                           [weakSelf getDataChooseSize];
                                       }
                                       [weakSelf.tableView reloadData];
                                       
                                       
                                   }else{
                                       [weakSelf.tableView reloadData];
                                   }
                                   
                               }else{
                                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                       [weakSelf.navigationController popViewControllerAnimated:YES];
                                   });
                               }
                           }
                              fail:^(NSError *error) {
                                  
                              }];

    }else{
        if (![YPCRequestCenter isLogin]) {
            [YPCNetworking postWithUrl:@"shop/explore/stracegoodsdetail"
                          refreshCache:YES
                                params:@{@"pagination":@{
                                                 @"page":page,
                                                 @"count":@"10"
                                                 },
                                         @"strace_id":weakSelf.strace_id
                                         }
                               success:^(id response) {
                                   if ([YPC_Tools judgeRequestAvailable:response]) {
                                       weakSelf.model = [DiscoverDetailModel mj_objectWithKeyValues:response[@"data"]];
                                       
                                       if (!weakSelf.tableView) {
                                           
                                           if (!weakSelf.headerView) {
                                               [weakSelf setHeardView];
                                               [weakSelf getDataChooseSize];
                                           }
                                           [weakSelf.tableView reloadData];
                                           
                                           
                                       }else{
                                           [weakSelf.tableView reloadData];
                                       }
                                       
                                   }else{
                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                           [weakSelf.navigationController popViewControllerAnimated:YES];
                                       });
                                   }
                               }
                                  fail:^(NSError *error) {
                                      
                                  }];

        }else{
            [YPCNetworking postWithUrl:@"shop/explore/stracegoodsdetail"
                          refreshCache:YES
                                params:[YPCRequestCenter getUserInfoAppendDictionary:@{@"pagination":@{
                                                                                               @"page":page,
                                                                                               @"count":@"10"
                                                                                               },
                                                                                       @"strace_id":weakSelf.strace_id
                                                                                       }]
                               success:^(id response) {
                                   if ([YPC_Tools judgeRequestAvailable:response]) {
                                       weakSelf.model = [DiscoverDetailModel mj_objectWithKeyValues:response[@"data"]];
                                       
                                       if (!weakSelf.tableView) {
                                           
                                           if (!weakSelf.headerView) {
                                               [weakSelf setHeardView];
                                               [weakSelf getDataChooseSize];
                                           }
                                           [weakSelf.tableView reloadData];
                                           
                                           
                                       }else{
                                           [weakSelf.tableView reloadData];
                                       }
                                       
                                   }else{
                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                           [weakSelf.navigationController popViewControllerAnimated:YES];
                                       });
                                   }
                               }
                                  fail:^(NSError *error) {
                                      
                                  }];

        }
        
    }
    
}
- (void)getDataChooseSize{
    
    WS(weakSelf);
    [YPCNetworking postWithUrl:@"shop/cart/editinit"
                  refreshCache:YES
                        params:@{
                                 @"goods_id":weakSelf.model.goods_commonid
                                }
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.chooseModel = [ChooseSizeModel mj_objectWithKeyValues:response[@"data"]];
                               NSInteger maxcount = weakSelf.model.total_storage.integerValue;
                               [weakSelf.chooseSize updateWithPrice:weakSelf.model.goods_price img:weakSelf.model.strace_storelogo chooseMessage:@"请选择颜色和尺码" count:1 maxCount:maxcount model:weakSelf.chooseModel];
                           }
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}
#pragma mark- tableView deledata&datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.commentlist.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentListModel *model = self.model.commentlist[indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[DiscoverCommentCell class]  contentViewWidth:[self cellContentViewWith]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"celll";
    DiscoverCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[DiscoverCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.model = self.model.commentlist[indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![YPCRequestCenter isLogin]) {
        [self login];
    }else{
        CommentListModel *model = self.model.commentlist[indexPath.row];
        if ([model.scomm_memberid isEqualToString:[YPCRequestCenter shareInstance].model.user_id]) {
            return;
        }else{
//            [self.keyboardView keyboardShow];
            self.comment_type = @"3";
            self.replyto = model.reback_memberid;
            self.replytoname = model.reback_membername;
        }
    }
    
}

#pragma mark- btn action

- (void)likeBtnClick:(UIButton *)sender{
    WS(weakSelf);
    if (![YPCRequestCenter isLogin]) {
        [self login];
    }else{
        NSString *url= @"";
        if (sender.selected == NO) {
            sender.selected = YES;
            url = @"shop/explore/livegoodslike";
            
        }else{
            sender.selected = NO;
            url = @"shop/explore/livegoodsunlike";
            
        }
        [YPCNetworking postWithUrl:url
                      refreshCache:YES
                            params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                   @"strace_id":weakSelf.strace_id
                                                                                   }
]                           success:^(id response) {
                               NSString *strace_cool = response[@"data"][@"strace_cool"];
                               
                               weakSelf.likeCountLab.text = strace_cool;
                           }
                              fail:^(NSError *error) {
                                  
                              }];
    }
}
- (void)commentBtnClick:(UIButton *)sender{
    if (![YPCRequestCenter isLogin]) {
        [self login];
    }else{
        [self.keyboardView becomeFirstResponder];
        self.comment_type = @"1";
        self.replyto = @"";
    }
}

- (void)chooseSizeClick{
    if (self.isChooseSize) {
        return;
    }
    WS(weakSelf);
     self.payType = @"0";
   
    
    [weakSelf chooseSizeShow];
}

- (void)chooseSizeShow{
    WS(weakself);
    [UIView animateWithDuration:0.3 animations:^{
        weakself.chooseSize.frame = CGRectMake(0, ScreenHeight - 483, ScreenWidth, 483);
        weakself.bgView.hidden = NO;
        weakself.isChooseSize = YES;
    }];
}
- (void)chooseSizeHide{
    WS(weakself);
    [UIView animateWithDuration:0.3 animations:^{
        weakself.chooseSize.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 483);
        weakself.bgView.hidden = YES;
        weakself.isChooseSize = NO;
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

- (void)login{
    WS(weakself);
    LoginVC *login = [[LoginVC alloc]init];
    UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:login];
    login.navigationController.navigationBar.hidden = YES;
    [self.navigationController presentViewController:loginNav animated:YES completion:nil];
    login.back = ^{
         [weakself chooseSizeShow];
    };
    
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
