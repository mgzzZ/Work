//
//  LivingGoodsView.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/12/1.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LivingGoodsView.h"
#import "CommendGoodsCvCell.h"
#import "AllGoodsTvCell.h"
#import "ChooseSizeModel.h"
#import "ChooseSize.h"

static NSString *CommendIdentifier = @"hotIdentifier";
static NSString *AllIdentifier = @"allIdentifier";

@interface LivingGoodsView ()

@property (nonatomic,strong)ChooseSize *chooseSize;
@property (nonatomic,assign)BOOL isChooseSize;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)ChooseSizeModel *chooseModel;

@end

@implementation LivingGoodsView
#pragma mark - Init
- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LivingGoodsView class]) owner:self options:nil];
    [self addSubview:self.contentView];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AllGoodsTvCell class]) bundle:nil] forCellReuseIdentifier:AllIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CommendGoodsCvCell class]) bundle:nil] forCellWithReuseIdentifier:CommendIdentifier];
    
    // 设置tableview头部视图高度
    [self.tvHeaderView setHeight:80 + ScreenWidth * .4];
    [self.tableView setTableHeaderView:self.tvHeaderView];
}
#pragma mark - 购物车初始化
- (ChooseSize *)chooseSize
{
    if (_chooseSize) {
        return _chooseSize;
    }
    WS(weakSelf);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    weakSelf.bgView = [[UIView alloc]initWithFrame:window.bounds];
    weakSelf.bgView.backgroundColor = [UIColor blackColor];
    [window addSubview:self.bgView];
    weakSelf.bgView.alpha = 0.3;
    weakSelf.bgView.hidden = YES;
    weakSelf.isChooseSize = NO;
    _chooseSize =  [[ChooseSize alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 483) count:15 maxCount:20];
    _chooseSize.did = ^(NSString *goods_id, NSString *count, NSString *payType){
        [YPCNetworking postWithUrl:@"shop/cart/add"
                      refreshCache:YES
                            params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                   @"goods_id" : goods_id,
                                                                                   @"count" : count,
                                                                                   @"click_from_type" : @"6"
                                                                                   }]
                           success:^(id response) {
                               if ([YPC_Tools judgeRequestAvailable:response]) {
                                   [YPC_Tools showSvpWithNoneImgHud:@"添加成功"];
                                   [weakSelf chooseSizeHide];
                               }
                           }
                              fail:^(NSError *error) {
                                  
                              }];
    };
    _chooseSize.cancel = ^{
        // 取消
        [weakSelf chooseSizeHide];
    };
    [window addSubview:_chooseSize];
    return _chooseSize;
}
#pragma mark - SETTER方法
- (void)setCommendDataArr:(NSMutableArray *)commendDataArr
{
    _commendDataArr = [NSMutableArray array];
    _commendDataArr = commendDataArr;
    [self.collectionView reloadData];
}
- (void)setAllGoodsDataArr:(NSMutableArray *)allGoodsDataArr
{
    _allGoodsDataArr = [NSMutableArray array];
    _allGoodsDataArr = allGoodsDataArr;
    
    if (self.allGoodsDataArr.count == 0) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(0, 30, ScreenWidth, 110);
        
        UIImageView *noDataImg = [UIImageView new];
        noDataImg.image = IMAGE(@"blankpage_goods_img");
        noDataImg.frame = CGRectMake(ScreenWidth / 2 - 55, 30, 110, 80);
        [view addSubview:noDataImg];
        [self.tableView setTableFooterView:view];
    }else {
        [self.tableView setTableFooterView:[UIView new]];
    }
    
    [self.tableView reloadData];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.countOfAllGoods.text = [NSString stringWithFormat:@"全部宝贝（%ld）", self.allGoodsDataArr.count];
    return self.allGoodsDataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllGoodsTvCell *cell = [tableView dequeueReusableCellWithIdentifier:AllIdentifier];
    cell.tempModel = self.allGoodsDataArr[indexPath.row];
    WS(weakSelf);
    [cell setButtonClickedBlock:^(id object) {
        if ([object isEqualToString:@"joinShopCar"]) {
            
            if ([YPCRequestCenter isLoginAndPresentLoginVC:[YPC_Tools getControllerWithView:self]]) {
                AllGoodsModel *model = weakSelf.allGoodsDataArr[indexPath.row];
                [weakSelf getDataChooseSize:model.goods_commonid price:model.goods_price count:@"1" maxCount:model.total_storage img:model.goods_image];
            }
        }
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.CellSelectedBlock([self.allGoodsDataArr[indexPath.row] strace_id]);
}

#pragma mark - collectionviewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.countOfHotGoods.text = [NSString stringWithFormat:@"热销推荐（%ld）", self.commendDataArr.count];
    return self.commendDataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CommendGoodsCvCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CommendIdentifier forIndexPath:indexPath];
    cell.tempModel = self.commendDataArr[indexPath.row];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake((ScreenWidth - 10) / 3, self.tvHeaderView.height - 80);
    return size;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.CellSelectedBlock([self.commendDataArr[indexPath.row] strace_id]);
}

#pragma mark - NO DATA IMAGE SET
-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return scrollView.frame.origin.y - 50.f;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (scrollView == self.collectionView) {
        return [UIImage imageNamed:@"blankpage_Sellinggoods_img"];
    }else {
        return [UIImage imageNamed:@"blankpage_goods_img"];
    }
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (void)getDataChooseSize:(NSString *)str price:(NSString *)price count:(NSString *)count maxCount:(NSString *)maxCount img:(NSString *)img{
    WS(weakSelf);
    [YPCNetworking postWithUrl:@"shop/cart/editinit"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"goods_id":str
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.chooseModel = [ChooseSizeModel mj_objectWithKeyValues:response[@"data"]];
                               
                               [weakSelf.chooseSize updateWithPrice:price img:img chooseMessage:@"请选择颜色和尺码" count:1 maxCount:10 model:weakSelf.chooseModel];
                               [weakSelf chooseSizeShow];
                           }
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}

#pragma mark - 购物车弹出隐藏
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

- (void)layoutSubviews
{
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}

@end
