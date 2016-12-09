//
//  LiveDtailLiveActivityVC.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LiveDtailLiveActivityVC.h"
#import "LiveDetailLiveActivityCell.h"
#import "LiveActivityModel.h"
#import "TopView.h"
@interface LiveDtailLiveActivityVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *collectView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)TopView *topView;
@end

@implementation LiveDtailLiveActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArr = [NSMutableArray array];
    [self setup];
    [self getData:@"1"];
}
- (void)setup{
    self.topView = [[TopView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 42)];
    self.topView.bgView.layer.borderColor = [Color colorWithHex:@"0xefefef"].CGColor;
    self.topView.bgView.layer.borderWidth = 1;
    [self.view addSubview:self.topView];
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    _collectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectView.delegate = self;
    _collectView.dataSource = self;
    _collectView.scrollEnabled = YES;
    _collectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectView];
    _collectView.sd_layout
    .topSpaceToView(self.view,42)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
    [self.collectView registerNib:[UINib nibWithNibName:NSStringFromClass([LiveDetailLiveActivityCell class]) bundle:nil] forCellWithReuseIdentifier:@"LiveDetailLiveActivityCell"];
}

#pragma mark- colllection delegate&dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return  self.dataArr.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = @"LiveDetailLiveActivityCell";
    LiveDetailLiveActivityCell *cell = (LiveDetailLiveActivityCell *)[_collectView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){(ScreenWidth) / 2,332 };
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 0, 20, 0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (void)getData:(NSString *)page{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/showstore/activitygoods"
                  refreshCache:YES
                        params:@{@"store_id":weakSelf.store_id,
                                 @"listorder":@"",
                                 @"brand":@"",
                                 @"bind":@"",
                                 @"pagination":@{
                                         @"page":page,
                                         @"count":@"10"
                                         }
                                 }
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                           }
                           weakSelf.dataArr = [LiveActivityModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                           [weakSelf.collectView reloadData];
                           
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
