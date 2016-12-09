//
//  PageSubVC.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/4.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "PageSubCollectVC.h"
#import "PageSubCollectCell.h"

static NSString *Identifier = @"pageIdentifier";
@interface PageSubCollectVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionV;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation PageSubCollectVC

- (NSMutableArray *)dataArr
{
    if (_dataArr) {
        return _dataArr;
    }
    _dataArr = [NSMutableArray array];
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.collectionV registerNib:[UINib nibWithNibName:NSStringFromClass([PageSubCollectCell class]) bundle:nil] forCellWithReuseIdentifier:Identifier];
}

- (void)setIsEditStatus:(BOOL)isEditStatus
{
    _isEditStatus = isEditStatus;
    [self.collectionV reloadData];
    
}

#pragma mark - collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 30;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PageSubCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    cell.editStatus = _isEditStatus;
    [cell setButtonClickedBlock:^(id object) {
        if ([object isEqualToString:@"delete"]) {
            [YPC_Tools customAlertViewWithTitle:nil
                                        Message:@"确定删除该收藏"
                                      BtnTitles:nil
                                 CancelBtnTitle:@"取消"
                            DestructiveBtnTitle:@"确定"
                                  actionHandler:nil
                                  cancelHandler:nil
                             destructiveHandler:^(LGAlertView *alertView) {
                                 
                                 #pragma mark - TODO: 删除
//                                 [self.dataArr removeObjectAtIndex:indexPath.row];
//                                 [collectionView deleteItemsAtIndexPaths:@[indexPath]];
                                 
                             }];
        }else if ([object isEqualToString:@"similar"]) {
            // TODO: 查看相似
        }
    }];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ScreenWidth - 36) / 2, (ScreenWidth - 36) / 2 + 87.f);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 6.f;
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
