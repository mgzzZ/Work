//
//  ShoppingCarDetailVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/21.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "ShoppingCarDetailVC.h"
#import "ShopCarView.h"
#import <ImagePlayerView.h>
#import "ShoppingCarDetailModel.h"
#import "MHFacebookImageViewer.h"
#import "UIImageView+MHFacebookImageViewer.h"
#import "ChooseSize.h"
#import "ChooseSizeModel.h"
#import "ClearingVC.h"

@interface ShoppingCarDetailVC ()<ImagePlayerViewDelegate,MHFacebookImageViewerDatasource>
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)ShopCarView  *shopView;
@property (nonatomic,strong)ImagePlayerView *titleImg;
@property (nonatomic,strong)ShoppingCarDetailModel *model;
@property (nonatomic,strong)ChooseSizeModel *chooseModel;
@property (nonatomic,strong)ChooseSize *chooseSize;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,assign)BOOL isChooseSize;
@property (nonatomic,copy)NSString *payType;//0是先选  1加入购物车  2立即购买
@end

@implementation ShoppingCarDetailVC
- (void)dealloc
{
    // clear
    [self.titleImg stopTimer];
    self.titleImg.imagePlayerViewDelegate = nil;
    self.titleImg = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"商品详情";
    self.isChooseSize = NO;
    [self getData];
}
- (void)setup{
    WS(weakSelf);
    self.scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:self.scrollView];
    self.scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 58, 0));
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.shopView = [[ShopCarView alloc]init];
    if (![YPCRequestCenter isLogin]) {
    }else{
        self.shopView.shopcar = ^{
            
        };
        self.shopView.clearing = ^{
           
        };
    }
    [self.view addSubview:self.shopView];
    self.shopView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view,0)
    .heightIs(58);
    
    UIImageView *txImg = [[UIImageView alloc]init];
    [self.scrollView addSubview:txImg];
    txImg.sd_layout
    .leftSpaceToView(self.scrollView,15)
    .topSpaceToView(self.scrollView,15)
    .widthIs(46)
    .heightIs(46);
    [txImg sd_setImageWithURL:[NSURL URLWithString:self.model.goodscommon_info.store_avatar] placeholderImage:YPCImagePlaceHolder];
    UILabel *nameLab = [[UILabel alloc]init];
    nameLab.textColor = [UIColor blackColor];
    nameLab.textAlignment = NSTextAlignmentLeft;
    nameLab.font = [UIFont systemFontOfSize:18];
    [self.scrollView addSubview:nameLab];
    nameLab.text = self.model.goodscommon_info.store_name;
    nameLab.sd_layout
    .topEqualToView(txImg)
    .leftSpaceToView(txImg,10)
    .rightSpaceToView(self.scrollView,15)
    .heightIs(20);
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.textColor = [UIColor blackColor];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = [UIFont systemFontOfSize:15];
    [self.scrollView addSubview:titleLab];
    titleLab.text = self.model.goodscommon_info.goods_name;
    
    titleLab.sd_layout
    .leftEqualToView(txImg)
    .topSpaceToView(txImg,10)
    .rightSpaceToView(self.scrollView,15)
    .autoHeightRatio(0);
    self.titleImg = [[ImagePlayerView alloc]initWithFrame:CGRectZero];
    self.titleImg.imagePlayerViewDelegate = self;
    self.titleImg.scrollInterval = 3.0f;
    self.titleImg.backgroundColor = [UIColor whiteColor];
    self.titleImg.pageControlPosition = ICPageControlPosition_BottomCenter;
    self.titleImg.hidePageControl = NO;
    
    [self.scrollView addSubview:self.titleImg];
    
    titleLab.didFinishAutoLayoutBlock = ^(CGRect rect){
        weakSelf.titleImg.frame = CGRectMake(15, rect.origin.y + rect.size.height + 10, ScreenWidth - 30, ScreenWidth - 30);
    };
    
    
    
    UILabel *priceLab = [[UILabel alloc]init];
    [self.scrollView addSubview:priceLab];
    priceLab.textColor = [Color colorWithHex:@"0xe4394c"];
    priceLab.textAlignment = NSTextAlignmentRight;
    priceLab.font = [UIFont systemFontOfSize:15];
    
    
    priceLab.text = [NSString stringWithFormat:@"¥%@",self.model.goodscommon_info.goods_price];
    [priceLab sizeToFit];
    priceLab.sd_layout
    .rightSpaceToView(self.scrollView,15)
    .heightIs(20)
    .widthIs(priceLab.frame.size.width)
    .topSpaceToView(self.titleImg,15);
    
    UILabel *countLab = [[UILabel alloc]init];
    [self.scrollView addSubview:countLab];
    countLab.textAlignment = NSTextAlignmentRight;
    countLab.textColor = [Color colorWithHex:@"#BFBFBF"];
    countLab.font = [UIFont systemFontOfSize:15];
    
    countLab.text = [NSString stringWithFormat:@"已售%@件",self.model.goodscommon_info.goods_salenum];
    [countLab sizeToFit];
    countLab.sd_layout
    .rightSpaceToView(priceLab,15)
    .centerYEqualToView(priceLab)
    .heightIs(20)
    .widthIs(countLab.frame.size.width);
    
    UIView *lineView1 = [[UIView alloc]init];
    lineView1.backgroundColor = [Color colorWithHex:@"0xefefef"];
    [self.scrollView addSubview:lineView1];
    lineView1.sd_layout
    .leftSpaceToView(self.scrollView,15)
    .rightSpaceToView(self.scrollView,15)
    .heightIs(1)
    .topSpaceToView(priceLab,15);
    
    UILabel *chooseLab = [[UILabel alloc]init];
    chooseLab.text = @"选择尺码,颜色分类";
    chooseLab.font = [UIFont systemFontOfSize:15];
    chooseLab.textAlignment =  NSTextAlignmentLeft;
    chooseLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
    [self.scrollView addSubview:chooseLab];
    chooseLab.sd_layout
    .leftSpaceToView(self.scrollView,10)
    .rightSpaceToView(self.scrollView,60)
    .topSpaceToView(lineView1,0)
    .heightIs(52);
    
    UIImageView *nextimg = [[UIImageView alloc]initWithImage:IMAGE(@"find_cart_detai_button_specifications_dropdown")];
    [self.scrollView addSubview:nextimg];
    nextimg.sd_layout
    .widthIs(20)
    .heightIs(20)
    .rightSpaceToView(self.scrollView,15)
    .centerYEqualToView(chooseLab);
    
    UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseBtn addTarget:self action:@selector(chooseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:chooseBtn];
    chooseBtn.sd_layout
    .leftEqualToView(chooseLab)
    .rightEqualToView(nextimg)
    .centerYEqualToView(chooseLab)
    .heightIs(52);
    
    UIView *lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = [Color colorWithHex:@"0xefefef"];
    [self.scrollView addSubview:lineView2];
    lineView2.sd_layout
    .leftSpaceToView(self.scrollView,15)
    .rightSpaceToView(self.scrollView,15)
    .topSpaceToView(chooseLab,0)
    .heightIs(1);
    
    
    
    
    UILabel *timeLab = [[UILabel alloc]init];
    [self.scrollView addSubview:timeLab];
    timeLab.textColor = [Color colorWithHex:@"0xbfbfbf"];
    timeLab.font = [UIFont systemFontOfSize:13];
    timeLab.textAlignment = NSTextAlignmentLeft;
    
    NSString *time = [YPC_Tools timeWithTimeIntervalString:self.model.goodscommon_info.goods_uptime Format:@"YYYY-MM-DD"];
    timeLab.text = time;
    [timeLab sizeToFit];
    timeLab.sd_layout
    .leftSpaceToView(self.scrollView,15)
    .heightIs(42)
    .topSpaceToView(lineView2,0)
    .widthIs(timeLab.frame.size.width);
    
    
    UIView *lineView3 = [[UIView alloc]init];
    lineView3.backgroundColor = [Color colorWithHex:@"0xefefef"];
    [self.scrollView addSubview:lineView3];
    lineView3.sd_layout
    .leftEqualToView(self.scrollView)
    .rightSpaceToView(self.scrollView,0)
    .heightIs(1)
    .topSpaceToView(lineView2,42);

    [self.scrollView setupAutoContentSizeWithBottomView:lineView3 bottomMargin:0];
    self.bgView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.bgView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.bgView];
    self.bgView.alpha = 0.3;
    self.bgView.hidden = YES;
    self.chooseSize =  [[ChooseSize alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 483) count:15 maxCount:20];
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
                                       weakSelf.shopView.car.badgeValue = @"1";
                                       [weakSelf.shopView openAnimation];
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
            
        }
        
    };
    self.chooseSize.cancel = ^{
        [weakSelf chooseSizeHide];
    };
    [self.view addSubview:self.chooseSize];
}

- (void)getData{
    WS(weakSelf);
    [YPCNetworking postWithUrl:@"shop/goods/goodsdetail"
                  refreshCache:YES
                        params:@{
                                 @"goods_id":weakSelf.goods_id
                                }
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               
                               weakSelf.model = [ShoppingCarDetailModel mj_objectWithKeyValues:response[@"data"]];
                               
                               [weakSelf setup];
                               [weakSelf getDataChooseSize];
                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                   [weakSelf.titleImg reloadData];
                               });
                           }
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}
- (void)getDataChooseSize{
    WS(weakSelf);
    [YPCNetworking postWithUrl:@"shop/cart/editinit"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"goods_id":weakSelf.goods_id
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.chooseModel = [ChooseSizeModel mj_objectWithKeyValues:response[@"data"]];
                               NSInteger maxcount = weakSelf.model.goodscommon_info.total_storage.integerValue;
                               [weakSelf.chooseSize updateWithPrice:weakSelf.model.goodscommon_info.goods_price img:weakSelf.model.goodscommon_info.store_avatar chooseMessage:@"请选择颜色和尺码" count:1 maxCount:maxcount model:weakSelf.chooseModel];
                           }
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}
#pragma mark - ImagePlayerViewDelegate
- (NSInteger)numberOfItems
{
    return self.model.image.count;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    // recommend to use SDWebImage lib to load web image

    imageView.contentMode = UIViewContentModeScaleAspectFill;
    if (self.model.image.count == 0) {
       
    }else{
         ShoppingImgsModel *model = self.model.image[index];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:YPCImagePlaceHolder];
    }
    [imageView setupImageViewerWithDatasource:self initialIndex:index onOpen:^{
        NSLog(@"OPEN!");
    } onClose:^{
        NSLog(@"CLOSE!");
    }];
    imageView.clipsToBounds = YES;

}
- (NSInteger) numberImagesForImageViewer:(MHFacebookImageViewer *)imageViewer {
    return self.model.image.count;
}
-  (NSURL*) imageURLAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer {
    ShoppingImgsModel *model = self.model.image[index];
    return [NSURL URLWithString:model.goods_image];
}

- (UIImage*) imageDefaultAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer{
    return YPCImagePlaceHolder;
}


- (void)chooseBtnClick{
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
