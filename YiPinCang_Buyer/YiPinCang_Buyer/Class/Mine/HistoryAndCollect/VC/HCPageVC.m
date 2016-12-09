//
//  HCPageVC.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/4.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "HCPageVC.h"
#import "PageSubHistoryVC.h"
#import "PageSubCollectVC.h"

@interface HCPageVC ()

@property (nonatomic, assign) BOOL isCollectEdit;

@end

@implementation HCPageVC

- (instancetype)init {
    if (self = [super init]) {
        
        self.isCollectEdit = NO;
        self.menuViewStyle = WMMenuViewStyleFlood;
        self.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
        self.menuBGColor = [UIColor whiteColor];
        self.titleSizeNormal = 13.f;
        self.titleSizeSelected = 15.f;
        self.menuHeight = 35.f;
        self.progressColor = [Color colorWithHex:@"#3B3B3B"];
        self.titleColorSelected = [UIColor whiteColor];
        self.titleColorNormal = [Color colorWithHex:@"#3B3B3B"];
        self.titles = @[@"杰克·琼斯", @"Nike", @"Adidas", @"好孩子", @"JEEP", @"蔻驰啊啊啊啊"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configNavi];
}

- (void)configNavi
{
    self.navigationController.navigationBar.barTintColor = [Color colorWithHex:@"#3B3B3B"];
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:BoldFont(18),NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.subViewType == PageSubViewHistory) {
        [button setTitle:@"清空" forState:UIControlStateNormal];
    }else if (self.subViewType == PageSubViewCollect) {
        [button setTitle:@"编辑" forState:UIControlStateNormal];
    }
    button.frame = CGRectMake(0, 0, 35, 25);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = LightFont(15);
    [button addTarget:self
               action:@selector(naviRightAction:)
     forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = editItem;
}

- (void)naviRightAction:(UIButton *)sender
{
    if (self.subViewType == PageSubViewHistory) {
        
    }else if (self.subViewType == PageSubViewCollect) {
        sender.selected = !sender.selected;
        if (sender.selected) {
            [sender setTitle:@"完成" forState:UIControlStateNormal];
            self.isCollectEdit = YES;
        }else {
            [sender setTitle:@"编辑" forState:UIControlStateNormal];
            self.isCollectEdit = NO;
        }
        [self reloadData];
    }
}

#pragma mark - PageDelegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titles.count;
}
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    if (self.subViewType == PageSubViewHistory) {
        PageSubHistoryVC *subVC = [PageSubHistoryVC new];
        return subVC;
    }else if (self.subViewType == PageSubViewCollect) {
        PageSubCollectVC *subVC = [PageSubCollectVC new];
        subVC.isEditStatus = self.isCollectEdit;
        return subVC;
    }
    return nil;
}
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titles[index];
}
- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index
{
    return [self.titles[index] sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil]].width + 26;
}

#pragma mark - BackBtn
- (UIBarButtonItem *)customBackItemWithTarget:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:IMAGE(@"logon_icon_return") forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:target
               action:action
     forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
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
