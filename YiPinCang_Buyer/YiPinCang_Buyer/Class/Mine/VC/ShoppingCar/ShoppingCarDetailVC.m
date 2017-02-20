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
#import "WebViewController.h"
#import "LiveDetailHHHVC.h"
@interface ShoppingCarDetailVC ()<ImagePlayerViewDelegate,MHFacebookImageViewerDatasource>
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)ShopCarView  *shopView;
@property (nonatomic,strong)ImagePlayerView *titleImg;
@property (nonatomic,strong)ShoppingCarDetailModel *model;
@property (nonatomic,strong)ChooseSizeModel *chooseModel;
@property (nonatomic,strong)ChooseSize *chooseSize;
@property (nonatomic,strong)UILabel *chooseLab;
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"商品详情";
    self.isChooseSize = NO;
    [self getData];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.isChooseSize) {
        [self chooseSizeHide];
    }
    
}
- (void)setup{
    WS(weakSelf);
    self.scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:self.scrollView];
    self.scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(64, 0, 58, 0));
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.shopView = [[ShopCarView alloc]init];
    [self.shopView.carBtn addTarget:self action:@selector(pushCarVC) forControlEvents:UIControlEventTouchUpInside];
    self.shopView.shopcar = ^{
        
        if (weakSelf.model.goodscommon_info.total_storage.integerValue > 0) {
            if (weakSelf.goods_id.length == 0 || weakSelf.payCount.length == 0) {
                [YPCRequestCenter isLoginAndPresentLoginVC:[YPC_Tools getControllerWithView:weakSelf.view] success:^{
                    weakSelf.payType = @"1";
                    [weakSelf chooseSizeShow];
                }];
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
                                           
                                           weakSelf.shopView.car.badgeValue = carNumber;

                                           [weakSelf.shopView openAnimation];
                                           [weakSelf chooseSizeHide];
                                           
                                           
                                       }
                                   }
                                      fail:^(NSError *error) {
                                          
                                      }];
            }
        }else{
            [YPC_Tools showSvpWithNoneImgHud:@"该商品已售空"];
        }
        
        
    };
    self.shopView.clearing = ^{
        if (weakSelf.model.goodscommon_info.total_storage.integerValue > 0) {
            if (weakSelf.goods_id.length == 0) {
                [YPCRequestCenter isLoginAndPresentLoginVC:[YPC_Tools getControllerWithView:weakSelf.view] success:^{
                    weakSelf.payType = @"2";
                    [weakSelf chooseSizeShow];
                }];
            }else{
                ClearingVC *clearing = [[ClearingVC alloc]init];
                NSString *str = [NSString stringWithFormat:@"%@|%@",weakSelf.goods_id,weakSelf.payCount];
                clearing.dataStr = str;
                [weakSelf.navigationController pushViewController:clearing animated:YES];
            }
            
        }else{
            [YPC_Tools showSvpWithNoneImgHud:@"该商品已售空"];
        }
        
    };
    
    [self.view addSubview:self.shopView];
    self.shopView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view,0)
    .heightIs(58);
    
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.textColor = [UIColor blackColor];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = [UIFont systemFontOfSize:15];
    [self.scrollView addSubview:titleLab];
    titleLab.text = self.model.goodscommon_info.goods_name;
    
    titleLab.sd_layout
    .leftSpaceToView(self.scrollView,15)
    .topSpaceToView(self.scrollView,10)
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
    
    self.chooseLab = [[UILabel alloc]init];
    self.chooseLab.text = @"选择尺码,颜色分类";
    self.chooseLab.font = [UIFont systemFontOfSize:15];
    self.chooseLab.textAlignment =  NSTextAlignmentLeft;
    self.chooseLab.tag = 1000;
    self.chooseLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
    [self.scrollView addSubview:self.chooseLab];
    self.chooseLab.sd_layout
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
    .centerYEqualToView(self.chooseLab);
    
    UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseBtn addTarget:self action:@selector(chooseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:chooseBtn];
    chooseBtn.sd_layout
    .leftEqualToView(self.chooseLab)
    .rightEqualToView(nextimg)
    .centerYEqualToView(self.chooseLab)
    .heightIs(52);
    
    UIView *lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = [Color colorWithHex:@"0xefefef"];
    [self.scrollView addSubview:lineView2];
    lineView2.sd_layout
    .leftSpaceToView(self.scrollView,15)
    .rightSpaceToView(self.scrollView,15)
    .topSpaceToView(self.chooseLab,0)
    .heightIs(1);
    
    
    
    
    UILabel *timeLab = [[UILabel alloc]init];
    [self.scrollView addSubview:timeLab];
    timeLab.textColor = [Color colorWithHex:@"0xbfbfbf"];
    timeLab.font = [UIFont systemFontOfSize:13];
    timeLab.textAlignment = NSTextAlignmentLeft;
    
    timeLab.text = self.model.goodscommon_info.goods_uptime;
    [timeLab sizeToFit];
    timeLab.sd_layout
    .leftSpaceToView(self.scrollView,15)
    .heightIs(45)
    .topSpaceToView(self.titleImg,0)
    .widthIs(timeLab.frame.size.width);
    
    
   
    UIImageView *txImg = [[UIImageView alloc]init];
    [self.scrollView addSubview:txImg];
    txImg.sd_layout
    .leftSpaceToView(self.scrollView,15)
    .topSpaceToView(lineView2,15)
    .widthIs(46)
    .heightIs(46);
    txImg.layer.cornerRadius = 23;
    txImg.layer.masksToBounds = YES;
    
    [txImg sd_setImageWithURL:[NSURL URLWithString:self.model.goodscommon_info.store_avatar] placeholderImage:YPCImagePlaceHolder];
    
    UIButton *txBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scrollView addSubview:txBtn];
    [txBtn addTarget:self action:@selector(pushDetail) forControlEvents:UIControlEventTouchUpInside];
    txBtn.sd_layout
    .leftEqualToView(txImg)
    .rightEqualToView(txImg)
    .topEqualToView(txImg)
    .bottomEqualToView(txImg);
    
    UILabel *nameLab = [[UILabel alloc]init];
    nameLab.textColor = [UIColor blackColor];
    nameLab.textAlignment = NSTextAlignmentLeft;
    nameLab.font = [UIFont systemFontOfSize:18];
    [self.scrollView addSubview:nameLab];
    nameLab.text = self.model.goodscommon_info.store_name;
    nameLab.sd_layout
    .centerYEqualToView(txImg)
    .leftSpaceToView(txImg,10)
    .rightSpaceToView(self.scrollView,15)
    .heightIs(20);

    [self.scrollView setupAutoContentSizeWithBottomView:txImg bottomMargin:10];
    self.bgView = [[UIView alloc]initWithFrame:self.view.bounds];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiden)];
    [self.bgView addGestureRecognizer:tap];
    self.bgView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.bgView];
    self.bgView.alpha = 0.3;
    self.bgView.hidden = YES;
    self.chooseSize =  [[ChooseSize alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 483) count:15 maxCount:20];
    self.chooseSize.did = ^(NSString *goods_id,NSString *count,NSString *payType){
        if (goods_id.length != 0 ) {
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
                                           
                                           weakSelf.shopView.car.badgeValue = carNumber;

                                           [weakSelf.shopView openAnimation];
                                           [weakSelf chooseSizeHide];
                                           
                                           if (payType.length != 0) {
                                            
                                               weakSelf.chooseLab.text = payType;
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
                weakSelf.payCount = count;
                weakSelf.goods_id = goods_id;
                if (payType.length == 0) {
                    weakSelf.chooseLab.text = @"您已选择该商品,请进行购买.";
                }else{
                    weakSelf.chooseLab.text = payType;
                }
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
    [self.view addSubview:self.chooseSize];
    if (self.model.goodscommon_info.total_storage.integerValue <= 0) {

        self.shopView.isSelected = NO;
    }else{
        self.shopView.isSelected = YES;
    }
}

- (void)getData{
    WS(weakSelf);
    if (weakSelf.is_goodsid.length == 0) {
        weakSelf.is_goodsid = @"";
    }
    [YPCNetworking postWithUrl:@"shop/goods/goodsdetail"
                  refreshCache:YES
                        params:@{
                                 @"goods_id":weakSelf.goods_id,
                                 @"is_goodsid":weakSelf.is_goodsid
                                }
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               
                               weakSelf.model = [ShoppingCarDetailModel mj_objectWithKeyValues:response[@"data"]];
                               
                               [weakSelf setup];
                               [weakSelf getDataChooseSize];
                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                   [weakSelf.titleImg reloadData];
                               });
                           }else{
                               if ([response[@"status"][@"error_code"] integerValue] == 1032) {
                                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                       [weakSelf.navigationController popViewControllerAnimated:YES];
                                   });
                               }
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
                                                                               @"goods_id":weakSelf.model.goodscommon_info.goods_commonid
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.chooseModel = [ChooseSizeModel mj_objectWithKeyValues:response[@"data"]];
                               NSInteger maxcount = weakSelf.model.goodscommon_info.total_storage.integerValue;
                               ShoppingImgsModel *model = weakSelf.model.image[0];
                               [weakSelf.chooseSize updateWithPrice:weakSelf.model.goodscommon_info.goods_price img:model.goods_image chooseMessage:@"请选择颜色和尺码" count:1 maxCount:maxcount model:weakSelf.chooseModel];
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
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.goods_image] placeholderImage:IMAGE(@"find_logo_placeholder")];
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
    return IMAGE(@"find_logo_placeholder");
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

- (void)pushDetail{
    LiveDetailHHHVC *live = [[LiveDetailHHHVC alloc]init];
    live.store_id = self.model.goodscommon_info.store_id;
    [self.navigationController pushViewController:live animated:YES];
}

- (void)pushCarVC{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hiden{
    [self chooseSizeHide];
    [self.chooseSize keyboredHiden];
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
