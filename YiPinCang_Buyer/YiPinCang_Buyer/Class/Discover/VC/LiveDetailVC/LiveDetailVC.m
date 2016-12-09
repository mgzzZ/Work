//
//  LiveDetailVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LiveDetailVC.h"
#import "ZJScrollPageView.h"
#import "LiveDetailLivelistVC.h"
#import "LiveDetailLiveNoteVC.h"
#import "LiveDetailLiveShareVC.h"
#import "LiveDtailLiveActivityVC.h"
#import "LiveHeaderView.h"
#import "LiveDetailDefaultModel.h"
@interface LiveDetailVC ()<ZJScrollPageViewDelegate,UIScrollViewDelegate>
@property(strong, nonatomic)NSArray<NSString *> *titles;
@property (nonatomic,strong)ZJScrollPageView *scrollPageView;
@property (nonatomic,assign)CGFloat yyy;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)LiveHeaderView *headerView;
@property (nonatomic,strong)LiveDetailDefaultModel *model;
@end

@implementation LiveDetailVC


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.subviews.firstObject.alpha = 0;
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.subviews.firstObject.alpha = 1;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
    [self getData];
    self.yyy = 0.;
    self.view.backgroundColor = [UIColor whiteColor];
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        [self.view addSubview:_scrollView];
        _scrollView.delegate = self;
        _scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        _scrollView.contentSize = CGSizeMake(0, 256 + ScreenHeight);
    }
    return _scrollView;
}
- (void)getData{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/showstore/default"
                  refreshCache:YES
                        params:@{@"store_id":weakSelf.store_id
                                 }
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                           }
                           weakSelf.model = [LiveDetailDefaultModel mj_objectWithKeyValues:response[@"data"]];
                           weakSelf.headerView.bgImg.backgroundColor = [UIColor blueColor];
                           [weakSelf.headerView.txImg sd_setImageWithURL:[NSURL URLWithString:weakSelf.model.info.store_avatar] placeholderImage:YPCImagePlaceHolder];
                           weakSelf.headerView.nameLab.text = weakSelf.model.info.store_name;
                           weakSelf.headerView.likeLab.text = [NSString stringWithFormat:@"收到赞%@",weakSelf.model.info.likenum];
                           weakSelf.headerView.fansLab.text = [NSString stringWithFormat:@"粉丝%@人",weakSelf.model.info.store_collect];
                           if (weakSelf.model.info.store_description.length == 0) {
                               weakSelf.headerView.titleLab.text = @"暂无签名";
                           }else{
                               weakSelf.headerView.titleLab.text = [NSString stringWithFormat:@"个人签名:%@",weakSelf.model.info.store_description];
                           }
                           
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}
- (void)setup{
    self.headerView = [[LiveHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 265)];
    [self.view addSubview:self.headerView];
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示滚动条
    style.showLine = YES;
    style.scrollTitle = NO;
    style.scrollLineHeight = 2;//滚动条粗细
    style.scrollLineColor = [UIColor redColor];//滚动条颜色
    style.titleMargin = 15;//标题之间的间隙 默认为15.0
    style.titleFont = [UIFont systemFontOfSize:15];//标题的字体 默认为14
    style.normalTitleColor = [Color colorWithHex:@"#BFBFBF"];//标题一般状态的颜色
    style.selectedTitleColor = [Color colorWithHex:@"#2c2c2c"];//标题选中状态的颜色
    style.segmentHeight = 37;//segmentVIew的高度, 这个属性只在使用ZJScrollPageVIew的时候设置生效
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    
    self.titles = @[@"直播列表",
                    @"活动商品",
                    @"好货分享",
                    @"我的笔记",
                    ];
    // 初始化
    self.scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 265, ScreenWidth, ScreenHeight - 265) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    
    [self.view  addSubview:self.scrollPageView];
    

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
    WS(weakself);
    if (!childVc) {
        switch (index) {
            case 0:
            {
                childVc = [[LiveDetailLivelistVC alloc] init];
                if ([childVc isKindOfClass:[LiveDetailLivelistVC class]]) {
                    ((LiveDetailLivelistVC *)childVc).selectIndex = index;
                    ((LiveDetailLivelistVC *)childVc).yyy = weakself.yyy;
                    ((LiveDetailLivelistVC *)childVc).store_id = weakself.store_id;
                    //            ((LiveDetailLivelistVC *)childVc).tableView.scrollEnabled = NO;
                }
//                ((LiveDetailLivelistVC *)childVc).didscroll = ^(CGFloat y){
//                    weakself.yyy = y;
//                    
//                    if (weakself.yyy <= 256 - 57 && weakself.yyy > 0 ) {
//                        weakself.scrollPageView.frame = CGRectMake(0, 256 - weakself.yyy, ScreenWidth, ScreenHeight );
//                    }else if (weakself.yyy > 256 - 57){
//                        weakself.yyy = 256 - 57;
//                        weakself.scrollPageView.frame = CGRectMake(0, 57, ScreenWidth, ScreenHeight);
//                        
//                    }else{
//                        weakself.yyy = 0.;
//                        weakself.scrollPageView.frame = CGRectMake(0, 265, ScreenWidth, ScreenHeight );
//                    }
//                    
//                };
            }
                break;
            case 1:
            {
                childVc = [[LiveDtailLiveActivityVC alloc] init];
                if ([childVc isKindOfClass:[LiveDtailLiveActivityVC class]]) {
                    ((LiveDtailLiveActivityVC *)childVc).store_id = weakself.store_id;
                }
               
            }
                break;
            case 2:
            {
                childVc = [[LiveDetailLiveShareVC alloc] init];
                if ([childVc isKindOfClass:[LiveDetailLiveShareVC class]]) {
                   ((LiveDetailLiveShareVC *)childVc).store_id = weakself.store_id;
                }
               
            }
                break;
            case 3:
            {
                childVc = [[LiveDetailLiveNoteVC alloc] init];
                if ([childVc isKindOfClass:[LiveDetailLiveNoteVC class]]) {
                    ((LiveDetailLiveNoteVC *)childVc).store_id = weakself.store_id;
                }
               
            }
                break;
                
            default:
                break;
        }
    }
    
    
   
    
    return childVc;
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
