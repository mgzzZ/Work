//
//  DiscoverSegView.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/8.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "DiscoverSegView.h"
#import "DiscoverHomeVC.h"


@interface DiscoverSegView ()
@property (nonatomic,strong)ZJScrollPageView *scrollPageView;
@end

@implementation DiscoverSegView





- (instancetype)init{
    self =  [super init];
    if (self) {
       
    }
    return self;
}


- (void)setUI{
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示滚动条
    style.showLine = NO;
    style.scrollTitle = NO;
    style.titleMargin = 15;//标题之间的间隙 默认为15.0
    style.titleFont = [UIFont systemFontOfSize:16];//标题的字体 默认为14
    style.normalTitleColor = [UIColor whiteColor];//标题一般状态的颜色
    style.selectedTitleColor = [UIColor whiteColor];//标题选中状态的颜色
    style.titleBigScale = 1.0;
    style.segmentHeight = 50;//segmentVIew的高度, 这个属性只在使用ZJScrollPageVIew的时候设置生效
    style.isHaveBorder = YES;
    style.bagTitleColor = [Color colorWithHex:@"0x444444"];
    // 颜色渐变
    style.marginH = 16;
    style.marginW = 15;
    style.gradualChangeTitleColor = NO;
    style.segNavColor = [Color colorWithHex:@"#CDCDCD"];
    // 初始化
    self.scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64.0 ) segmentStyle:style titles:self.titles parentViewController:self.supVC delegate:self];
    
    
    [self addSubview:self.scrollPageView];
    
}

- (void)setSupVC:(UIViewController *)supVC{
    [self setUI];
}
- (void)setIndex:(NSInteger)index{
    [self.scrollPageView setSelectedIndex:index animated:YES];
}

- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}
/*
 方法描述:
 1、设置每一栏的viewcontroller。
 2、一般在这个方法中传入一些属性参数，然后在不同的VC中请求网络。
 3、注意该VC需要继承一个代理。
 参数说明:
 index：判断第几个
 
 返回结果:
 <#返回结果#>
 
 */
- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    if (!childVc) {
        childVc = [[DiscoverHomeVC alloc] init];
        if ([childVc isKindOfClass:[DiscoverHomeVC class]]) {
            ((DiscoverHomeVC *)childVc).selectIndex = index;
            ((DiscoverHomeVC *)childVc).url = self.url;
            ((DiscoverHomeVC *)childVc).didcell = ^(NSString *strace_id,NSString *live_id){
                if (self.didcell) {
                    self.didcell(strace_id,live_id);
                }
                
            };
            ((DiscoverHomeVC *)childVc).didtx = ^(NSString *strace_id){
                if (self.didtx) {
                    self.didtx(strace_id);
                }
                
            };
            
        }
        
    }

    
    return childVc;
}


@end
