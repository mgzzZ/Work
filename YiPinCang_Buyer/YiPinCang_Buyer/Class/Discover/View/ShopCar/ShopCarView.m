//
//  ShopCarView.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/15.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "ShopCarView.h"

@interface ShopCarView ()

@property (nonatomic,strong)UILabel *timeLab;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UIView *leftView;
@property (nonatomic,assign)CGFloat centerX;
@property (nonatomic ,strong) dispatch_source_t timer;
@property (nonatomic,strong)UILabel *payLab;
@property (nonatomic,assign)int endTime;
@property (nonatomic,assign)BOOL isHave;
@property (nonatomic,assign)BOOL isFirst;
@end

@implementation ShopCarView


- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}
- (void)setup{
    WS(weakSelf);
    self.rightBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    [self.rightBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn.backgroundColor = [Color colorWithHex:@"#E4393C"];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.rightBtn];
    self.rightBtn.sd_layout
    .widthIs(kWidth(117))
    .rightSpaceToView(self,0)
    .topEqualToView(self)
    .bottomEqualToView(self);
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.leftBtn.backgroundColor = [Color colorWithHex:@"#FDA729"];
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.leftBtn];
    self.leftBtn.sd_layout
    .widthIs(kWidth(117))
    .rightSpaceToView(self.rightBtn,0)
    .topEqualToView(self)
    .bottomEqualToView(self);
    self.leftView = [[UIView alloc]init];
    self.leftView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.leftView];
    self.leftView.sd_layout
    .topEqualToView(self)
    .leftEqualToView(self)
    .bottomEqualToView(self)
    .rightSpaceToView(self.leftBtn,0);
    
    self.car = [[UIImageView alloc]initWithImage:IMAGE(@"productdetails_icon_cart")];
    
    [self addSubview:self.car];
    
    self.leftView.didFinishAutoLayoutBlock = ^(CGRect rect){
        weakSelf.car.sd_layout
        .widthIs(25)
        .heightIs(25)
        .centerXIs(weakSelf.leftView.frame.size.width / 2)
        .centerYEqualToView(weakSelf.leftView);
        weakSelf.centerX = weakSelf.leftView.frame.size.width / 2;
    };
    
    
    self.titleLab = [[UILabel alloc]init];
    self.titleLab.text = @"商品将保留";
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.font = [UIFont systemFontOfSize:13];
    self.titleLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
    self.titleLab.alpha = 0;
    [self.titleLab sizeToFit];
    [self.leftView addSubview:self.titleLab];
    [self.titleLab sizeToFit];
    self.titleLab.sd_layout
    .rightSpaceToView(self.leftView,10)
    .widthIs(self.titleLab.frame.size.width)
    .heightIs(15)
    .topSpaceToView(self.leftView,10);
    self.timeLab = [[UILabel alloc]init];
    self.timeLab.textColor = [Color colorWithHex:@"#E4393C"];
    self.timeLab.textAlignment = NSTextAlignmentCenter;
    self.timeLab.font = [UIFont systemFontOfSize:13];
    [self.leftView addSubview:self.timeLab];
    self.timeLab.alpha = 0;

    
    self.timeLab.sd_layout
    .rightEqualToView(self.titleLab)
    .leftEqualToView(self.titleLab)
    .topSpaceToView(self.titleLab,0)
    .bottomSpaceToView(self.leftView,0);
    
    
    UIView *leftView = [[UIView alloc]init];
    leftView.backgroundColor = [Color colorWithHex:@"0xefefef"];
    [self addSubview:leftView];
    leftView.sd_layout
    .topSpaceToView(self,0)
    .leftEqualToView(self)
    .rightSpaceToView(self.leftBtn,0)
    .heightIs(1);
    self.carBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.carBtn];
    self.carBtn.sd_layout
    .leftEqualToView(self)
    .rightSpaceToView(self.leftBtn,0)
    .topSpaceToView(self,0)
    .bottomEqualToView(self);
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[date timeIntervalSince1970]; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    if ([YPCRequestCenter shareInstance].carEndtime.integerValue - timeString.integerValue > 0) {
        self.endTime = [YPCRequestCenter shareInstance].carEndtime.intValue - timeString.intValue;
        self.isHave = YES;
        self.isFirst = YES;
        [self openAnimation];
    }else{
        self.isHave = NO;
        self.isFirst = YES;
    }
    
}

- (void)leftBtnClick{
    if (self.shopcar) {
     self.shopcar();
        
    }
    
}


- (void)openAnimation{
    _timer = nil;
    __block int timeout = [YPCRequestCenter shareInstance].cart_expire_time.intValue; //倒计时时间
    if (!_timer) {
        if (self.isHave && self.isFirst) {
            timeout = self.endTime;
           
        }
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout <= 0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.timeLab.text = @"倒计时结束";
                    [self closeAnimation];
                });
            }else{
                int minutes = timeout / 60;
                int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"00:%d:%.2d",minutes, seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.timeLab.text = strTime;
                    
                });
                timeout--;
                
            }
        });
        dispatch_resume(_timer);

    }
    
    if (self.isFirst) {
        POPSpringAnimation *sizeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
        sizeAnimation.springSpeed = 0.3f;
        sizeAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(20, 0, 25, 25)];
        [sizeAnimation setCompletionBlock:^(POPAnimation *ani, BOOL fin) {
            if (fin) {
                POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
                alphaAnimation.fromValue = @0;
                alphaAnimation.toValue = @1;
                [self.titleLab pop_addAnimation:alphaAnimation forKey:nil];
                POPBasicAnimation *timealphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
                timealphaAnimation.fromValue = @0;
                timealphaAnimation.toValue = @1;
                [self.timeLab pop_addAnimation:timealphaAnimation forKey:nil];
            }
        }];
        
        [self.car pop_addAnimation:sizeAnimation forKey:nil];
        self.isFirst = NO;
    }
    
    

}
- (void)closeAnimation{
    POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    [self.titleLab pop_addAnimation:alphaAnimation forKey:nil];
    POPBasicAnimation *timealphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    timealphaAnimation.fromValue = @1;
    timealphaAnimation.toValue = @0;
    [timealphaAnimation setCompletionBlock:^(POPAnimation *ani, BOOL fin) {
        if (fin) {
            POPSpringAnimation *sizeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
            sizeAnimation.springSpeed = 0.f;    // 动画的速度
            sizeAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(self.centerX, 0, 25, 25)];
             [self.car pop_addAnimation:sizeAnimation forKey:nil];
        }
    }];
    [self.timeLab pop_addAnimation:timealphaAnimation forKey:nil];
    
}
- (void)rightBtnClick{
    if (self.clearing) {
        self.clearing();
    }
}

- (void)setIsSelected:(BOOL)isSelected{
    if (_isSelected != isSelected) {
        _isSelected = isSelected;
    }
    if (_isSelected) {
        self.rightBtn.backgroundColor = [Color colorWithHex:@"#E4393C"];
        self.leftBtn.backgroundColor = [Color colorWithHex:@"#FDA729"];
        self.rightBtn.userInteractionEnabled = YES;
        self.leftBtn.userInteractionEnabled = YES;
    }else{
        self.rightBtn.userInteractionEnabled = NO;
        self.leftBtn.userInteractionEnabled = NO;
        self.rightBtn.backgroundColor = [Color colorWithHex:@"#bebebe"];
        self.leftBtn.backgroundColor = [Color colorWithHex:@"#afafaf"];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
