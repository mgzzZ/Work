//
//  OrderDetailView.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/29.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "OrderDetailView.h"

@interface OrderDetailView ()
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UIButton *leftBtn;
@property (strong, nonatomic) IBOutlet UIButton *rightBtn;
@property (strong, nonatomic) IBOutlet UIImageView *timeImg;
@property (nonatomic ,strong) dispatch_source_t timer;

@end


@implementation OrderDetailView

- (instancetype)initWithFrame:(CGRect)frame orderType:(OrderType)orderType{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
        switch (orderType) {
            case OrderTypeOfState_pay:
            {
                [self.rightBtn setTitle:@"立即付款" forState:UIControlStateNormal];
                [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.rightBtn.backgroundColor = [UIColor redColor];
                self.rightBtn.layer.cornerRadius = 3;
                
                [self.leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                [self.leftBtn setTitleColor:[Color colorWithHex:@"0x2c2c2c"] forState:UIControlStateNormal];
                self.leftBtn.layer.borderColor = [Color colorWithHex:@"0x2c2c2c"].CGColor;
                self.leftBtn.layer.borderWidth = 1;
                self.leftBtn.layer.cornerRadius = 3;
                self.leftBtn.backgroundColor = [UIColor whiteColor];
            
                [self.rightBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
                [self.leftBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
                
            }
                break;
            case OrderTypeOfState_sent:
            {
                [self.rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                [self.rightBtn setTitleColor:[Color colorWithHex:@"0x2c2c2c"] forState:UIControlStateNormal];
                self.rightBtn.layer.borderColor = [Color colorWithHex:@"0x2c2c2c"].CGColor;
                self.rightBtn.layer.borderWidth = 1;
                self.rightBtn.layer.cornerRadius = 3;
                self.rightBtn.backgroundColor = [UIColor whiteColor];
                self.leftBtn.hidden = YES;
                self.titleLab.hidden = YES;
                self.timeLab.hidden = YES;
                self.timeImg.hidden = YES;
                [self.rightBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
                
            }
                break;
            case OrderTypeOfSent:
            {
                [self.rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.rightBtn.backgroundColor = [UIColor redColor];
                self.rightBtn.layer.cornerRadius = 3;
                
                [self.leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                [self.leftBtn setTitleColor:[Color colorWithHex:@"0x2c2c2c"] forState:UIControlStateNormal];
                self.leftBtn.layer.borderColor = [Color colorWithHex:@"0x2c2c2c"].CGColor;
                self.leftBtn.layer.borderWidth = 1;
                self.leftBtn.layer.cornerRadius = 3;
                self.leftBtn.backgroundColor = [UIColor whiteColor];
                self.titleLab.hidden = YES;
                self.timeLab.hidden = YES;
                self.timeImg.hidden = YES;
                [self.rightBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
                [self.leftBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case OrderTypeOfFinish:
            {
                [self.rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                [self.rightBtn setTitleColor:[Color colorWithHex:@"0x2c2c2c"] forState:UIControlStateNormal];
                self.rightBtn.layer.borderColor = [Color colorWithHex:@"0x2c2c2c"].CGColor;
                self.rightBtn.layer.borderWidth = 1;
                self.rightBtn.layer.cornerRadius = 3;
                self.rightBtn.backgroundColor = [UIColor whiteColor];
                self.leftBtn.hidden = YES;
                self.titleLab.hidden = YES;
                self.timeLab.hidden = YES;
                self.timeImg.hidden = YES;
                [self.rightBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                
            default:
                break;
        }
    }
    
    
    return self;
}

- (void)setTime:(NSString *)time{
    WS(weakself);
    if (!_timer) {
        __block int timeout = time.intValue; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout <= 0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakself.titleLab.hidden = YES;
                    weakself.timeLab.text = @"订单失效";
                    weakself.timeImg.hidden = YES;
                    weakself.rightBtn.enabled = NO;
                    weakself.leftBtn.enabled = NO;
                    weakself.leftBtn.hidden = YES;
                    weakself.rightBtn.hidden = YES;
                });
            }else{
                int minutes = timeout / 60;
                int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"%.2d:%.2d",minutes, seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakself.timeLab.text = strTime;
                    
                });
                timeout--;
                
            }
        });
        dispatch_resume(_timer);
    }
}


- (void)click:(UIButton *)sender{
    if (self.btnClick) {
        self.btnClick(sender.titleLabel.text);
    }
}

@end
