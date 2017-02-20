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
#import "PushModel.h"
#import "WebViewController.h"
#import "LiveDetailHHHVC.h"
#import "ShoppingCarVC.h"
#import "LiveDetailHHHVC.h"
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
@property (nonatomic,copy)NSString *carNumber;//该商品在购物车的数量
@property (nonatomic,strong)UILabel *commentLab;
@property (nonatomic,strong)UIButton *messageBtn;
@property (nonatomic,assign)BOOL isSelete;//记录悬浮按钮
@property (nonatomic,copy)NSString *goods_id;
@property (nonatomic,copy)NSString *payCount;
@property (nonatomic,copy)NSString *likeCount;
@property (nonatomic,copy)NSString *isLike;
@end

@implementation DiscoverDetailVC
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    if (self.backBlock) {
        self.backBlock(self.likeCount,self.isLike,[NSString stringWithFormat:@"%zd",self.model.commentlist.count]);
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"商品详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isChooseSize = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.carNumber = @"0";
    self.goods_id = @"";
    self.payCount = @"";
    self.isSelete =NO;
    [self getData:@"1"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addComment:) name:@"comment" object:nil];
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.acceptEventInterval = 1.f;
    shareBtn.frame = CGRectMake(0, 0, 25, 25);
    [shareBtn setImage:IMAGE(@"mshare_button") forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(messageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItems = @[share];
    [self.navigationController.navigationBar mz_setBackgroundImage:IMAGE(@"homepage_bar")];
    [self.navigationController.navigationBar mz_setBackgroundColor:[Color colorWithHex:@"#3B3B3B"]];
    [self.navigationController.navigationBar mz_setBackgroundAlpha:1];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.isChooseSize) {
        [self chooseSizeHide];
    }
    
}
- (void)setup{
    WS(weakSelf);
    _tableView = [[UITableView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
    
    _tableView.tableFooterView = [UIView new];
    _tableView.sd_layout
    .topSpaceToView(self.view,64)
    .rightEqualToView(self.view)
    .leftEqualToView(self.view)
    .bottomSpaceToView(self.view,58);
    
    [self.view addSubview:self.keyboardView];
    [self.keyboardView setButtonClickedBlock:^(NSString *message) {
        
        NSString *url = @"";
        NSDictionary *dic = @{};
        if ([weakSelf.typeStr isEqualToString:@"淘好货"] || weakSelf.typeStr == nil) {
            url = @"shop/activity/sendcomment";
            dic = [YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                  @"strace_id":weakSelf.strace_id,
                                                                  @"message":message,
                                                                  @"replyto":weakSelf.replyto,
                                                                  @"comment_type":weakSelf.comment_type
                                                                  }];
        }else{
            url = @"shop/usercircle/storecirclecomment";
            dic = [YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                  @"strace_id":weakSelf.strace_id,
                                                                  @"message":message,
                                                                  @"comment_type":@""
                                                                  }];
        }
        [YPCNetworking postWithUrl:url
                      refreshCache:YES
                            params:dic
                           success:^(id response) {
                               if ([YPC_Tools judgeRequestAvailable:response]) {
                                   CommentListModel *model = [[CommentListModel alloc]init];
                                   model.scomm_content = [message stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                   model.scomm_memberid = [YPCRequestCenter shareInstance].model.user_id;
                                   model.scomm_memberavatar = [YPCRequestCenter shareInstance].model.member_avatar;
                                   model.comment_type = weakSelf.comment_type;
                                   model.reback_memberid = weakSelf.replyto;
                                   model.reback_membername = weakSelf.replytoname;
                                   model.scomm_membername = [YPCRequestCenter shareInstance].model.member_truename;
                                   NSDate *datenow = [NSDate date];
                                   NSString *timeSp = [NSString stringWithFormat:@"%zd", (long)[datenow timeIntervalSince1970]];
                                   model.scomm_time = timeSp;
                                   [weakSelf.model.commentlist addObject:model];
                                   NSIndexPath *index = [NSIndexPath indexPathForRow:weakSelf.model.commentlist.count - 1 inSection:0];
                                   [weakSelf.tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
                                   weakSelf.commentLab.text = [NSString stringWithFormat:@"%zd",weakSelf.model.commentlist.count];
                                   [YPC_Tools showSvpWithNoneImgHud:@"评论成功"];
                               }
                           }
                              fail:^(NSError *error) {
                                  
                              }];
        
        
    }];

   

    self.shopcarView = [[ShopCarView alloc]init];
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[date timeIntervalSince1970]; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    if ([YPCRequestCenter shareInstance].carEndtime.integerValue - timeString.integerValue > 0 ) {
        self.shopcarView.car.badgeValue =  [YPCRequestCenter shareInstance].carNumber;
    }
    [self.shopcarView.carBtn addTarget:self action:@selector(pushCarVC) forControlEvents:UIControlEventTouchUpInside];
    self.shopcarView.shopcar = ^{
        if (weakSelf.model.total_storage.integerValue > 0) {
            weakSelf.payType = @"1";
            if (![YPCRequestCenter isLogin]) {
                [weakSelf login];
            }else{
                if (weakSelf.goods_id.length == 0) {
                   [weakSelf chooseSizeShow];
                }else{
                    [YPCNetworking postWithUrl:@"shop/cart/add"
                                  refreshCache:YES
                                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                               @"goods_id":weakSelf.goods_id,
                                                                                               @"count":weakSelf.payCount,
                                                                                               @"click_from_type":@"6"
                                                                                               }]
                                       success:^(id response) {
                                           if ([YPC_Tools judgeRequestAvailable:response]) {
                                               NSString *carNumber = response[@"data"][@"num"];
                                               NSString *cart_add_time = response[@"data"][@"cart_add_time"];
                                               NSString *cart_expire_time = response[@"data"][@"cart_expire_time"];
                                               NSString *timeEnd = [NSString stringWithFormat:@"%zd",cart_add_time.integerValue + cart_expire_time.integerValue];
                                               
                                               [YPCRequestCenter shareInstance].carEndtime = timeEnd;
                                               [YPCRequestCenter shareInstance].cart_expire_time = cart_expire_time;
                                               [YPCRequestCenter shareInstance].carNumber = carNumber;
                                               
                                               weakSelf.shopcarView.car.badgeValue = carNumber;
                                               [weakSelf.shopcarView openAnimation];
                                               [weakSelf chooseSizeHide];
                                           }
                                       }
                                          fail:^(NSError *error) {
                                              
                                          }];
                }
            }
        }else{
            [YPC_Tools showSvpWithNoneImgHud:@"该商品已售光"];
        }
        
    };
    self.shopcarView.clearing = ^{
        if (weakSelf.model.total_storage.integerValue > 0) {
            weakSelf.payType = @"2";
            if (![YPCRequestCenter isLogin]) {
                [weakSelf login];
            }else{
                if (weakSelf.goods_id.length == 0) {
                    [weakSelf chooseSizeShow];
                }else{
                    ClearingVC *clearing = [[ClearingVC alloc]init];
                    NSString *str = [NSString stringWithFormat:@"%@|%@",weakSelf.goods_id,weakSelf.payCount];
                    clearing.dataStr = str;
                    [weakSelf.navigationController pushViewController:clearing animated:YES];
                }
            }
        }else{
            [YPC_Tools showSvpWithNoneImgHud:@"该商品已售光"];
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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiden)];
    [self.bgView addGestureRecognizer:tap];
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
                                       NSString *carNumber = response[@"data"][@"num"];
                                       NSString *cart_add_time = response[@"data"][@"cart_add_time"];
                                       NSString *cart_expire_time = response[@"data"][@"cart_expire_time"];
                                       NSString *timeEnd = [NSString stringWithFormat:@"%zd",cart_add_time.integerValue + cart_expire_time.integerValue];
                                 
                                       [YPCRequestCenter shareInstance].carEndtime = timeEnd;
                                       [YPCRequestCenter shareInstance].cart_expire_time = cart_expire_time;
                                       [YPCRequestCenter shareInstance].carNumber = carNumber;
                                       
                                       weakSelf.shopcarView.car.badgeValue = carNumber;
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
            weakSelf.payCount = count;
            weakSelf.goods_id = goods_id;
            if (payType.length == 0) {
                lab.text = @"您已选择该商品,请进行购买.";
            }else{
                lab.text = payType;
            }
            
        }
        
    };
    
    self.chooseSize.cancel = ^{
        [weakSelf chooseSizeHide];
    };
    
    self.chooseSize.push = ^{
        WebViewController *web = [[WebViewController alloc]init];
        web.navTitle = @"尺码助手";
        web.homeUrl = weakSelf.chooseModel.specdesc_url;
        [weakSelf.navigationController pushViewController:web animated:YES];
    };
    self.messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.messageBtn];
    [self.messageBtn setImage:IMAGE(@"buypage_reminder_backgound") forState:UIControlStateNormal];
    self.messageBtn.sd_layout
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,130 + 58)
    .widthIs(80)
    .heightIs(40);
    [self.view bringSubviewToFront:self.messageBtn];
    [self.messageBtn addTarget:self action:@selector(messageClick) forControlEvents:UIControlEventTouchUpInside];
    self.messageBtn.hidden = YES;
    if (self.model.total_storage.integerValue <= 0) {
     
        self.shopcarView.isSelected = NO;
    }else{
        self.shopcarView.isSelected = YES;
    }
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
    img.layer.cornerRadius = 20;
    img.layer.masksToBounds = YES;
    
    UIButton *txbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [txbtn addTarget:self action:@selector(pushDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:txbtn];
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
    phptosView.modeType = PhotoContainerModeTypeHave;
    UILabel *priceLab = [[UILabel alloc]init];
    priceLab.textColor = [Color colorWithHex:@"0xe4393c"];
    priceLab.textAlignment = NSTextAlignmentLeft;
    priceLab.font = [UIFont systemFontOfSize:15];
    UILabel *countLab = [[UILabel alloc]init];
    countLab.textAlignment = NSTextAlignmentRight;
    countLab.textColor = [Color colorWithHex:@"0xBFBFBF"];
    countLab.font = [UIFont systemFontOfSize:15];
    
    OriginalPriceLab *orig = [[OriginalPriceLab alloc]init];
    orig.textAlignment = NSTextAlignmentLeft;
    orig.textColor = [Color colorWithHex:@"0xbfbfbf"];
    orig.font = YPCPFFont(10);
    
    [self.headerView sd_addSubviews:@[img,nameLab,titleLab,priceLab,countLab,phptosView,typeImg,orig]];
    UILabel *timeLab = [[UILabel alloc]init];
    timeLab.textAlignment = NSTextAlignmentLeft;
    timeLab.textColor = [Color colorWithHex:@"0xBFBFBF"];
    timeLab.font = [UIFont systemFontOfSize:13];
    self.commentLab = [[UILabel alloc]init];
    self.commentLab.textAlignment = NSTextAlignmentRight;
    self.commentLab.textColor = [Color colorWithHex:@"0xBFBFBF"];
    self.commentLab.font = [UIFont systemFontOfSize:14];
    UIImageView *commentImg = [[UIImageView alloc]initWithImage:IMAGE(@"find_pinglun_button")];
    self.likeCountLab = [[UILabel alloc]init];
    self.likeCountLab.textAlignment = NSTextAlignmentRight;
    self.likeCountLab.textColor = [Color colorWithHex:@"0xBFBFBF"];
    self.likeCountLab.font = [UIFont systemFontOfSize:14];
    UIImageView *likeImg = [[UIImageView alloc]initWithImage:IMAGE(@"find_like_button")];
    likeImg.tag = 10000;
    
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [Color colorWithHex:@"0xefefef"];
    [self.headerView addSubview:topView];
    
    
    self.bottomImg = [[UIImageView alloc]initWithImage:IMAGE(@"find_productdetails_icon_dialogbox")];
    if ([self.model.strace_comment isEqualToString:@"0"]) {
        self.bottomImg.hidden = YES;
    }else{
        self.bottomImg.hidden = NO;
    }
    
    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.isLike = self.model.islike;
    if ([self.model.islike isEqualToString:@"1"]) {
        likeBtn.selected = YES;
        [likeImg setImage:IMAGE(@"find_like_button_clicked")];
        self.likeCountLab.textColor = [Color colorWithHex:@"#e4393c"];
    }else{
        likeBtn.selected = NO;
        self.likeCountLab.textColor = [Color colorWithHex:@"#bfbfbf"];
    }
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView sd_addSubviews:@[timeLab,self.commentLab,commentImg,likeImg,self.likeCountLab,self.bottomImg,likeBtn,commentBtn]];
    img.sd_layout
    .widthIs(40)
    .heightIs(40)
    .leftSpaceToView(self.headerView,15)
    .topSpaceToView(self.headerView,15);
    
    txbtn.sd_layout
    .leftEqualToView(img)
    .topEqualToView(img)
    .bottomEqualToView(img)
    .rightEqualToView(img);
    
    
    
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
    orig.text = [NSString stringWithFormat:@"¥%@",self.model.goods_marketprice];
    
    phptosView.sd_layout
    .leftEqualToView(nameLab);
    phptosView.thumbPicPathStringsArray = self.model.strace_content_thumb;
    phptosView.picPathStringsArray = self.model.strace_content;
    phptosView.sd_layout
    .topSpaceToView(titleLab,10);
    
    priceLab.text = [NSString stringWithFormat:@"¥%@",self.model.goods_price];
    
    [priceLab sizeToFit];
    priceLab.sd_layout
    .leftEqualToView(nameLab)
    .topSpaceToView(phptosView,13.5)
    .heightIs(20)
    .widthIs(priceLab.frame.size.width);
    
    [orig sizeToFit];
    orig.sd_layout
    .leftSpaceToView(priceLab,10)
    .centerYEqualToView(priceLab)
    .widthIs(orig.frame.size.width)
    .heightIs(15);
    
    
    countLab.text = [NSString stringWithFormat:@"已售%@件",self.model.goods_salenum];
    countLab.sd_layout
    .rightEqualToView(self.bgView)
    .centerYEqualToView(priceLab)
    .heightIs(20)
    .rightSpaceToView(self.headerView,15);
    
    
    topView.sd_layout
    .leftEqualToView(nameLab)
    .topSpaceToView(phptosView,47)
    .heightIs(1)
    .rightSpaceToView(self.headerView,15);
    

    
    NSString *time = [YPC_Tools timeWithTimeIntervalString:self.model.strace_time Format:@"YYYY-MM-dd"];
    timeLab.text = time;
    [timeLab sizeToFit];
    
    timeLab.sd_layout
    .leftEqualToView(nameLab)
    .topSpaceToView(topView,10)
    .widthIs(timeLab.frame.size.width)
    .heightIs(15);
    
    self.commentLab.text = self.model.strace_comment;
    [self.commentLab sizeToFit];
    self.commentLab.sd_layout
    .rightSpaceToView(self.headerView,15)
    .widthIs(self.commentLab.frame.size.width)
    .centerYEqualToView(timeLab)
    .heightIs(15);
    
    commentImg.sd_layout
    .rightSpaceToView(self.commentLab,5)
    .widthIs(19)
    .heightIs(19)
    .centerYEqualToView(self.commentLab);
    self.likeCount =self.model.strace_cool;
    self.likeCountLab.text = self.model.strace_cool;
    [self.likeCountLab sizeToFit];
    self.likeCountLab.sd_layout
    .rightSpaceToView(commentImg,30)
    .centerYEqualToView(self.commentLab)
    .widthIs(self.likeCountLab.frame.size.width)
    .heightIs(15);
   
    likeImg.sd_layout
    .rightSpaceToView(self.likeCountLab,5)
    .widthIs(19)
    .heightIs(19)
    .centerYEqualToView(self.commentLab);
    
    likeBtn.sd_layout
    .leftEqualToView(likeImg)
    .centerYEqualToView(likeImg)
    .rightEqualToView(self.likeCountLab)
    .heightIs(15);
    commentBtn.sd_layout
    .leftEqualToView(commentImg)
    .centerYEqualToView(commentImg)
    .rightEqualToView(self.commentLab)
    .heightIs(19);
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
    NSDictionary *params = @{};
    NSString *url = @"";
    if ([YPCRequestCenter isLogin]) {
        if ([self.typeStr isEqualToString:@"淘好货"] || self.typeStr == nil) {
            
            url = @"shop/explore/livegoodsdetail";
        }else{
            url = @"shop/explore/stracegoodsdetail";
        }
        params = [YPCRequestCenter getUserInfoAppendDictionary:@{@"pagination":@{
                                                                         @"page":page,
                                                                         @"count":@"1000"
                                                                         },
                                                                 @"strace_id":weakSelf.strace_id,
                                                                 @"live_id":@""
                                                                 }];
    }else{
        if ([self.typeStr isEqualToString:@"淘好货"] || self.typeStr == nil) {
            
            url = @"shop/explore/livegoodsdetail";
        }else{
            url = @"shop/explore/stracegoodsdetail";
        }
        params = @{@"pagination":@{
                           @"page":page,
                           @"count":@"10"
                           },
                   @"strace_id":weakSelf.strace_id,
                   @"live_id":@""
                   };
        
    }
    [YPCNetworking postWithUrl:url
                  refreshCache:YES
                        params:params
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
                              YPCAppLog(@"%zd",error.code);
                          }];
    
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
                               [weakSelf.chooseSize updateWithPrice:weakSelf.model.goods_price img:weakSelf.model.strace_content_thumb[0] chooseMessage:@"请选择颜色和尺码" count:1 maxCount:maxcount model:weakSelf.chooseModel];
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
    if (indexPath.row == self.model.commentlist.count - 1 && self.isSelete) {
        self.messageBtn.hidden = YES;
    }
    cell.model = self.model.commentlist[indexPath.row];
    cell.txBtn.tag = indexPath.row;
    [cell.txBtn addTarget:self action:@selector(txBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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
        if ([self.typeStr isEqualToString:@"淘好货"] || _typeStr == nil) {
            NSString *url= @"";
            UIImageView *img = [self.view viewWithTag:10000];
            if (sender.selected == NO) {
                [img setImage:IMAGE(@"find_like_button_clicked")];
                sender.selected = YES;
                url = @"shop/explore/livegoodslike";
                self.isLike = @"1";
                self.likeCountLab.textColor = [Color colorWithHex:@"#e4393c"];
            }else{
                [img setImage:IMAGE(@"find_like_button")];
                sender.selected = NO;
                url = @"shop/explore/livegoodsunlike";
                self.isLike = @"0";
                self.likeCountLab.textColor = [Color colorWithHex:@"0xBFBFBF"];
            }
            [YPCNetworking postWithUrl:url
                          refreshCache:YES
                                params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                       @"strace_id":weakSelf.strace_id
                                                                                       }
                                        ]                           success:^(id response) {
                                    NSString *strace_cool = response[@"data"][@"strace_cool"];
                                    
                                    weakSelf.likeCountLab.text = strace_cool;
                                    weakSelf.likeCount = strace_cool;
                                    [weakSelf.likeCountLab sizeToFit];
                                    weakSelf.likeCountLab.sd_layout.widthIs(weakSelf.likeCountLab.frame.size.width);
                                }
                                  fail:^(NSError *error) {
                                      
                                  }];
        }else{
            NSString *url= @"";
            UIImageView *img = [self.view viewWithTag:10000];
            if (sender.selected == NO) {
                [img setImage:IMAGE(@"find_like_button_clicked")];
                sender.selected = YES;
                self.isLike = @"1";
                url = @"shop/usercircle/like";
                self.likeCountLab.textColor = [Color colorWithHex:@"#e4393c"];
            }else{
                [img setImage:IMAGE(@"find_like_button")];
                sender.selected = NO;
                self.isLike = @"0";
                url = @"shop/usercircle/unlike";
                self.likeCountLab.textColor = [Color colorWithHex:@"0xBFBFBF"];
            }
            [YPCNetworking postWithUrl:url
                          refreshCache:YES
                                params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                       @"strace_id":weakSelf.strace_id
                                                                                       }
                                        ]                           success:^(id response) {
                                    NSString *strace_cool = response[@"data"][@"strace_cool"];
                                    weakSelf.likeCount = strace_cool;
                                    weakSelf.likeCountLab.text = strace_cool;
                                    [weakSelf.likeCountLab sizeToFit];
                                    weakSelf.likeCountLab.sd_layout.widthIs(weakSelf.likeCountLab.frame.size.width);
                                }
                                  fail:^(NSError *error) {
                                      
                                  }];
        }
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
    [YPCRequestCenter isLoginAndPresentLoginVC:self success:^{
        [weakself chooseSizeShow];
    }];
}
- (void)addComment:(NSNotification *)notification{
    NSDictionary *dic = [notification object];
    
    PushModel *model = [PushModel mj_objectWithKeyValues:dic];
    if ([model.extras.strace_id isEqualToString:self.strace_id]) {
        self.messageBtn.hidden = NO;
        self.isSelete = YES;
        CommentListModel *commentlistModel = [[CommentListModel alloc]init];
        commentlistModel.scomm_memberavatar = model.extras.avatar;
        commentlistModel.scomm_content = model.title;
        commentlistModel.comment_type = model.extras.comment_type;
        commentlistModel.scommto_memberid = model.extras.replyto;
        commentlistModel.scomm_membername = model.extras.scomm_membername;
        commentlistModel.scomm_time = model.extras.scomm_time;
        commentlistModel.scommto_membername = model.extras.scommto_membername;
        [self.model.commentlist addObject:commentlistModel];
        NSIndexPath *index = [NSIndexPath indexPathForRow:self.model.commentlist.count - 1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        self.commentLab.text = [NSString stringWithFormat:@"%zd",self.model.commentlist.count];
    }
    

}
- (void)txBtnClick:(UIButton *)sender{
    LiveDetailHHHVC *live = [[LiveDetailHHHVC alloc]init];
    live.store_id = self.model.store_id;
    [self.navigationController pushViewController:live animated:YES];
}

- (void)pushCarVC{
    WS(weakSelf);
    [YPCRequestCenter isLoginAndPresentLoginVC:self success:^{
        ShoppingCarVC *car = [[ShoppingCarVC alloc]init];
        [weakSelf.navigationController pushViewController:car animated:YES];
    }];
}

- (void)pushDetail{
    LiveDetailHHHVC *live = [[LiveDetailHHHVC alloc]init];
    live.store_id = self.model.store_id;
    [self.navigationController pushViewController:live animated:YES];
}

- (void)hiden{
    [self chooseSizeHide];
    [self.chooseSize keyboredHiden];
}


#pragma mark - 分享
- (void)messageBtnClick{
    NSString *uid = [YPCRequestCenter shareInstance].model.user_id.length > 0 ? [YPCRequestCenter shareInstance].model.user_id : @"0";
    [YPCShare GoodsShareInWindowWithStraceName:self.model.goods_name StraceId:self.model.strace_id image:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.model.strace_content[0]] discount:self.model.goods_discount price:self.model.goods_price uid:uid viewController:self];
}
- (void)messageClick{
    
//    self.messageBtn.hidden = YES;
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.model.commentlist.count - 1 inSection:0]
                                animated:YES
                          scrollPosition:UITableViewScrollPositionBottom];
}

#pragma mark - 懒加载

- (KeyboardTextView *)keyboardView{
    if (_keyboardView) {
        return _keyboardView;
    
    }
    WS(weakSelf);
     _keyboardView = [[KeyboardTextView alloc] initWithTextViewFrame:CGRectMake(0, ScreenHeight - 49 , ScreenWidth , 49)];
    
    
    return _keyboardView;
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
