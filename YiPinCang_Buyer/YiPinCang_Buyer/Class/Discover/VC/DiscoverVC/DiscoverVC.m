//
//  DiscoverVC.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/10/31.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "DiscoverVC.h"
#import "DiscoverSegView.h"
#import "DiscoverDetailVC.h"
#import "LiveDetailVC.h"
#import "LiveDetailHHHVC.h"

#import "BrandnewView.h"

@interface DiscoverVC ()

@property (nonatomic,strong)UIView *topView;

@property (nonatomic,strong)DiscoverSegView *leftView;

@property (nonatomic,strong)DiscoverSegView *rightView;

@property (nonatomic,strong)UIButton *leftBtn;

@property (nonatomic,strong)UIButton *rightBtn;

@property (nonatomic,strong)NSMutableArray *nameArr;
@end

@implementation DiscoverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [Color colorWithHex:@"#EFEFEF"];
    self.nameArr = [[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self getData];
    [self setTopView];
    
}
- (void)setTopView{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 75, 20);
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn addTarget:self action:@selector(leftBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:@"淘好货" forState:UIControlStateNormal];
    btn.selected = YES;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(75, 0, 75, 20);
    [btn1 addTarget:self action:@selector(rightBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    btn1.backgroundColor = [UIColor clearColor];
    btn1.titleLabel.font = [UIFont systemFontOfSize:17];
    btn1.selected = NO;
    [btn1 setTitle:@"动态" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
     [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
    [_topView addSubview:btn];
    [_topView addSubview:btn1];
    _leftBtn = btn;
    _rightBtn = btn1;
    self.navigationItem.titleView = _topView;
}
- (void)setUI{
    WS(weakSelf);
    self.leftView = [[DiscoverSegView alloc]init];
    self.leftView.titles = [self.nameArr mutableCopy];
    self.leftView.url = @"shop/explore/livegoods";
    self.leftView.supVC = self;
    self.leftView.index = 0;
    [self.view addSubview:self.leftView];
    self.leftView.didcell = ^(NSString *strace_id,NSString *live_id){
        DiscoverDetailVC *dic = [[DiscoverDetailVC alloc]init];
        dic.strace_id = strace_id;
        dic.live_id = live_id;
        dic.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:dic animated:YES];
    };
    self.leftView.didtx = ^(NSString *str){
        LiveDetailHHHVC *live = [[LiveDetailHHHVC alloc]init];
        live.store_id = str;
        live.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:live animated:YES];
    };
    self.leftView.hidden = NO;
    self.leftView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.rightView = [[DiscoverSegView alloc]init];
    self.rightView.url = @"shop/explore/stracegoods";
    self.rightView.titles = [self.nameArr mutableCopy];
    self.rightView.didcell = ^(NSString *strace_id,NSString *live_id){
        DiscoverDetailVC *dic = [[DiscoverDetailVC alloc]init];
        dic.strace_id = strace_id;
        dic.live_id = live_id;
        dic.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:dic animated:YES];
    };
    self.rightView.didtx = ^(NSString *str){
        LiveDetailHHHVC *live = [[LiveDetailHHHVC alloc]init];
        live.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:live animated:YES];
    };
    self.rightView.supVC = self;
    self.rightView.index = 0;
    [self.view addSubview:self.rightView];
    self.rightView.hidden = YES;
    self.rightView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
}
- (void)leftBtnClcik{
    self.leftView.hidden = NO;
    self.rightView.hidden = YES;
    self.leftBtn.selected = YES;
    self.rightBtn.selected = NO;
}
- (void)rightBtnClcik{
    self.leftView.hidden = YES;
    self.rightView.hidden = NO;
    self.leftBtn.selected = NO;
    self.rightBtn.selected = YES;
}
- (void)getData{
    WS(weakSelf);
    [YPCNetworking postWithUrl:@"shop/explore/category"
                  refreshCache:YES
                        params:@{}
                       success:^(id response) {
                           for (NSDictionary *dic in response[@"data"]) {
                               NSString *name = dic[@"name"];
                               [weakSelf.nameArr addObject:name];
                           }
                           
                           [weakSelf setUI];
                           
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
