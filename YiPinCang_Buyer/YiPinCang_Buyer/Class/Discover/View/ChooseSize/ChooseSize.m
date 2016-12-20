//
//  ChooseSize.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/17.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "ChooseSize.h"
#import "ChooseSizeHeaderView.h"
#import "ChooseSizeCell.h"
#import "PPNumberButton.h"
#import "Choose_spModel.h"

@interface ChooseSize ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)UICollectionView *collection;
@property (nonatomic,strong)UIButton *closeBtn;
@property (nonatomic,strong)UIButton *nextBtn;
@property (nonatomic,strong)UIButton *sizeHelpBtn;
@property (nonatomic,strong)UILabel *priceLab;
@property (nonatomic,strong)UILabel *countLab;//库存
@property (nonatomic,strong)UILabel *titleLab;//提示选择的尺码和颜色
@property (nonatomic,strong)UILabel *payCountLab;//购买数量
@property (nonatomic,strong)PPNumberButton *payNumberBtn;
@property (nonatomic,assign)NSInteger maxCount;//最多
@property (nonatomic,assign)NSInteger count;//输入框中的数字
@property (nonatomic,assign)NSInteger oldSection;
@property (nonatomic,assign)NSInteger oldRow;
@property (nonatomic,strong)NSMutableArray *didDataArr;
@property (nonatomic,strong)NSMutableSet *didSet;
@property (nonatomic,strong)NSMutableArray *chooseDataArr;

@property (nonatomic,strong)NSMutableArray *indexPathArr;
@property (nonatomic,assign)BOOL isDelete;
@property (nonatomic,copy)NSString *goods_id;

@end

@implementation ChooseSize


- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboredHiden)];
        [self addGestureRecognizer:tap];
        [self setup];
    }
    return self;
}
- (instancetype)initWith:(NSInteger)count maxCount:(NSInteger)maxCount{
    self.count = count;
    self.maxCount = maxCount;
    return [self init];
}
- (instancetype)initWithFrame:(CGRect)frame count:(NSInteger)count maxCount:(NSInteger)maxCount{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.count = count;
        self.maxCount = maxCount;
        [self setup];
    }
    return self;
}
- (void)updateWith:(NSInteger)count maxCount:(NSInteger)maxCount{
    
    self.count = count;
    self.maxCount = maxCount;
}
- (void)updateWithPrice:(NSString *)price img:(NSString *)img chooseMessage:(NSString *)chooseMessage count:(NSInteger)count maxCount:(NSInteger)maxCount model:(ChooseSizeModel *)model{
    self.goods_id = @"A";

    self.chooseDataArr = [[NSMutableArray alloc]init];
    self.indexPathArr = [[NSMutableArray alloc]init];
    self.oldRow = -1;
    self.oldSection = 0;
    self.isDelete = NO;
    
    self.count = count;
    self.maxCount = maxCount;
    self.payNumberBtn.currentNumber = [NSString stringWithFormat:@"%zd",count];
    self.payNumberBtn.maxValue = maxCount;
    self.countLab.text = [NSString stringWithFormat:@"库存:%zd",maxCount];
    if (_model != model) {
        _model = model;
    }
    [self.img sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:YPCImagePlaceHolder];
    self.priceLab.text =  [NSString stringWithFormat:@"¥%@",price];
    self.titleLab . text =  chooseMessage;
    [self.collection reloadData];
}
- (void)setup{
    self.goods_id = @"A";
    self.didDataArr = [[NSMutableArray alloc]init];
    self.chooseDataArr = [[NSMutableArray alloc]init];
    self.indexPathArr = [[NSMutableArray alloc]init];
    self.oldRow = -1;
    self.oldSection = 0;
    self.isDelete = NO;
    self.img = [[UIImageView alloc]init];
    self.img.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.img];
    self.img.sd_layout
    .leftSpaceToView(self,15)
    .topSpaceToView(self,15)
    .widthIs(100)
    .heightIs(100);
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:IMAGE(@"find_cart_icon_close") forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeBtn];
    self.closeBtn.sd_layout
    .rightEqualToView(self)
    .topEqualToView(self)
    .widthIs(44)
    .heightIs(44);
    
    self.priceLab = [[UILabel alloc]init];
    [self addSubview:self.priceLab];
    self.priceLab.textColor = [Color colorWithHex:@"#E4393C"];
    self.priceLab.font = [UIFont systemFontOfSize:18];
    self.priceLab.textAlignment = NSTextAlignmentLeft;
    self.priceLab.sd_layout
    .topEqualToView(self.img)
    .heightIs(20)
    .rightSpaceToView(self.closeBtn,15)
    .leftSpaceToView(self.img,15);
    
    self.countLab = [[UILabel alloc]init];
    [self addSubview:self.countLab];
    self.countLab.textAlignment = NSTextAlignmentLeft;
    self.countLab.textColor = [UIColor blackColor];
    self.countLab.font = [UIFont systemFontOfSize:15];
    self.countLab.sd_layout
    .topSpaceToView(self.priceLab,5)
    .leftEqualToView(self.priceLab)
    .widthRatioToView(self.priceLab,1)
    .heightIs(15);
    self.titleLab = [[UILabel alloc]init];
    [self addSubview:self.titleLab];
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    self.titleLab.textColor = [UIColor blackColor];
    self.titleLab.font = [UIFont systemFontOfSize:15];
    self.titleLab.sd_layout
    .topSpaceToView(self.countLab,5)
    .leftEqualToView(self.priceLab)
    .widthRatioToView(self.priceLab,1)
    .heightIs(15);
    
    self.sizeHelpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.sizeHelpBtn];
    [self.sizeHelpBtn setImage:IMAGE(@"chimazhushou_button") forState:UIControlStateNormal];
    [self.sizeHelpBtn addTarget:self action:@selector(sizeHelpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.sizeHelpBtn.sd_layout
    .topSpaceToView(self.titleLab,15)
    .leftEqualToView(self.titleLab)
    .widthIs(74)
    .heightIs(21);
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [Color colorWithHex:@"0xefefef"];
    [self addSubview:lineView];
    lineView.sd_layout
    .leftSpaceToView(self,15)
    .rightSpaceToView(self,15)
    .heightIs(0.5)
    .topSpaceToView(self,126);
    UIView *lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = [Color colorWithHex:@"0xefefef"];
    [self addSubview:lineView2];
    lineView2.sd_layout
    .leftSpaceToView(self,15)
    .rightSpaceToView(self,15)
    .heightIs(0.5)
    .bottomSpaceToView(self,116);
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.headerReferenceSize = CGSizeMake(ScreenWidth, 30);
    self.collection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collection.delegate = self;
    self.collection.dataSource = self;
    self.collection.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.collection];
    self.collection.sd_layout
    .topSpaceToView(lineView,0)
    .bottomSpaceToView(lineView2,0)
    .leftEqualToView(self)
    .rightEqualToView(self);
    [self.collection registerClass:[ChooseSizeCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collection registerClass:[ChooseSizeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    
    
    self.payCountLab = [[UILabel alloc]init];
    self.payCountLab.textColor = [UIColor blackColor];
    self.payCountLab.font = [UIFont systemFontOfSize:15];
    self.payCountLab.textAlignment = NSTextAlignmentLeft;
    self.payCountLab.text = @"购买数量";
    [self addSubview:self.payCountLab];
    self.payCountLab.sd_layout
    .leftSpaceToView(self,15)
    .widthIs(75)
    .topSpaceToView(lineView2,20)
    .heightIs(15);
    self.payNumberBtn = [PPNumberButton numberButtonWithFrame:CGRectMake(ScreenWidth / 2 - 118 / 2, 379, 118, 33)];
    self.payNumberBtn.borderColor = [UIColor grayColor];
    // 开启抖动动画
    self.payNumberBtn.shakeAnimation = YES;
    // 设置最小值
    self.payNumberBtn.minValue = 1;
    // 设置最大值
    self.payNumberBtn.maxValue = 12;
    // 设置输入框中的字体大小
    self.payNumberBtn.inputFieldFont = 15;
    self.payNumberBtn.currentNumber = @"";
    self.payNumberBtn.increaseTitle = @"＋";
    self.payNumberBtn.decreaseTitle = @"－";
    
    self.payNumberBtn.numberBlock = ^(NSString *num){
        _count = num.integerValue;
    };
    [self addSubview:self.payNumberBtn];
    
    
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextBtn.backgroundColor = [UIColor redColor];
    [self.nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.nextBtn.layer.cornerRadius = 1;
    [self.nextBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.nextBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:self.nextBtn];
    self.nextBtn.sd_layout
    .bottomSpaceToView(self,10)
    .leftSpaceToView(self,15)
    .rightSpaceToView(self,15)
    .heightIs(42);
    
    
}
#pragma mark- colllection delegate&dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    ChooseSize_groupModel *model = self.model.group[section];
    return  model.data.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.model.group.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakSelf);
    NSString *identifier = @"cell";
    ChooseSizeCell *cell = (ChooseSizeCell *)[self.collection dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    ChooseSize_groupModel *model = self.model.group[indexPath.section];
    Choose_spModel *titleModel = model.data[indexPath.row];
    cell.titleLab.text = [NSString stringWithFormat:@"%@",titleModel.sp_value_name];
    cell.bgView.layer.borderColor = [Color colorWithHex:@"0xefefef"].CGColor;
    cell.bgView.layer.borderWidth = 2;
    cell.success = ^(NSIndexPath *index){
        
        [weakSelf.indexPathArr addObject:index];
        weakSelf.isDelete = NO;
    };
    cell.error = ^(NSIndexPath *index){
        ChooseSize_groupModel *model = self.model.group[indexPath.section];
        Choose_spModel *titleModel = model.data[indexPath.row];
        [self.didDataArr removeObject:titleModel];
        
        NSString *str = [self returnPaystring:self.didDataArr];
        if (str.length == 0) {
            self.titleLab.text = @"请选择规格";
        }else{
            self.titleLab.text = str;
        }
        weakSelf.isDelete = YES;
        [weakSelf.indexPathArr removeObject:index];
    };
    if (titleModel.isSelete == YES) {
        cell.titleLab.textColor = [UIColor grayColor];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ChooseSizeCell *cell = (ChooseSizeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    ChooseSize_groupModel *model = self.model.group[indexPath.section];
    Choose_spModel *titleModel = model.data[indexPath.row];
    if (self.model.group.count == 1) {
        
        cell.index = indexPath;
        if (titleModel.isSelete == NO) {
            [self.didDataArr removeAllObjects];
            [self.didDataArr addObject:titleModel];
            NSString *str = [self returnPaystring:self.didDataArr];
            if (str.length == 0) {
                self.titleLab.text = @"请选择规格";
            }else{
                self.titleLab.text = str;
            }
            
        }
        
        
    }else{
        if (titleModel.isSelete == NO) {
            cell.index  = indexPath;
            if (self.model.group.count == 1) {
                
            }else{
                //将选择的规格添加到数组
                if (self.isDelete == NO) {
                    [self.didDataArr addObject:titleModel];
                    NSString *str = [self returnPaystring:self.didDataArr];
                    if (str.length == 0) {
                        self.titleLab.text = @"请选择规格";
                    }else{
                        self.titleLab.text = str;
                    }
                }
               
                for (int i = 0; i < self.model.info.count; i++) {
                    ChooseSize_dataModel *model = self.model.info[i];
                    //两个数组进行比较 返回符合情况的数组组合
                    NSArray * arr = [self contrast:self.didDataArr arrb:model.goods_spec];
                    //将所有组合数组 添加至一个大数组
                    [self.chooseDataArr addObject:arr];
                }
                //去掉重复数组  返回一个集合
                self.didSet = [self removeRepeat:self.chooseDataArr];
                
                //根据集合判断 至于符合集合内情况的数据允许点击 否则不让点击
                for (NSInteger i = 0; i < self.model.group.count ; i++) {
                    ChooseSize_groupModel *model1 = self.model.group[i];
                    for (int j = 0; j < model1.data.count; j++) {
                        Choose_spModel *titleModel1 = model1.data[j];
                        
                        for (NSObject *obj in self.didSet) {
                            if ([titleModel1.sp_value_id isEqual:obj] ) {
                                titleModel1.isSelete = NO;
                                NSIndexPath *index = [NSIndexPath indexPathForRow:j inSection:i];
                                
                                ChooseSizeCell *cell = (ChooseSizeCell *)[collectionView cellForItemAtIndexPath:index];
                                
                                cell.bgView.backgroundColor = [UIColor whiteColor];
                                cell.titleLab.textColor = [UIColor blackColor];
                                break;
                            }else{
                                
                                NSIndexPath *index = [NSIndexPath indexPathForRow:j inSection:i];
                                ChooseSizeCell *cell = (ChooseSizeCell *)[collectionView cellForItemAtIndexPath:index];
                                
                                for (NSIndexPath *oldIndex in self.indexPathArr) {
                                    if ([index isEqual:oldIndex]) {
                                        cell.titleLab.textColor = [UIColor whiteColor];
                                        cell.bgView.backgroundColor = [UIColor redColor];
                                        titleModel1.isSelete = NO;
                                        break;
                                    }else{
                                        
                                        if (i == indexPath.section) {
                                            if (self.didDataArr.count == 1) {
                                                if ([index isEqual:indexPath]) {
                                                    cell.titleLab.textColor = [UIColor whiteColor];
                                                    titleModel1.isSelete = NO;
                                                    cell.bgView.backgroundColor = [UIColor redColor];
                                                    break;
                                                }else{
                                                    //                                                    cell.titleLab.textColor = [UIColor blackColor];
                                                    //                                                    titleModel1.isSelete = NO;
                                                    //                                                    cell.bgView.backgroundColor = [UIColor whiteColor];
                                                    //                                                    break;
                                                }
                                            }else{
                                                cell.titleLab.textColor = [UIColor grayColor];
                                                cell.bgView.backgroundColor = [UIColor whiteColor];
                                                titleModel1.isSelete = YES;
                                                
                                            }
                                            
                                            
                                        }else{
                                            
                                            cell.titleLab.textColor = [UIColor grayColor];
                                            cell.bgView.backgroundColor = [UIColor whiteColor];
                                            titleModel1.isSelete = YES;
                                            
                                            
                                        }
                                        
                                    }
                                }
                                
                            }
                            
                        }
                        
                        
                        
                    }
                    
                    
                }
                
                
                
            }
        }
        
    }
    
    if (self.didDataArr.count == self.model.group.count) {
        
        for (NSInteger i = 0; i < self.model.info.count ; i++) {
            ChooseSize_dataModel *model1 = self.model.info[i];
            
            NSInteger j = [self equalToArray:self.didDataArr arrB:model1.goods_spec];
            if (j != 0) {
                self.goods_id = model1.goods_id;
                self.countLab.text = [NSString stringWithFormat:@"库存:%@",model1.goods_storage];
                self.maxCount = model1.goods_storage.integerValue;
                self.payNumberBtn.maxValue = self.maxCount;
            }else{
                
            }
        }
    }
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (self.model.group.count == 1) {

        ChooseSizeCell *cell = (ChooseSizeCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.bgView.backgroundColor = [UIColor whiteColor];
        cell.titleLab.textColor = [UIColor blackColor];
        cell.bgView.layer.borderColor = [Color colorWithHex:@"0xefefef"].CGColor;
        
    }
    
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    ChooseSize_groupModel *model = self.model.group[indexPath.section];
    if (kind == UICollectionElementKindSectionHeader)
    {
        ChooseSizeHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        if (!headerView.titleLab) {
            headerView.titleLab = [[UILabel alloc]init];
            headerView.titleLab.frame = CGRectMake(15, 0, ScreenWidth - 15, 30);
            headerView.titleLab.text = model.sp_name;
            headerView.titleLab.textColor = [UIColor blackColor];
            headerView.titleLab.font = [UIFont systemFontOfSize:15];
            [headerView addSubview:headerView.titleLab];
            
        }
        reusableview = headerView;
    }
    reusableview.backgroundColor = [UIColor whiteColor];
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){91,31};
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 14, 10, 14);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 10.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat margin = (ScreenWidth - 30 - 91 * 3) / 2;
    return margin;
}

- (void)setModel:(ChooseSizeModel *)model{
    if (_model != model) {
        _model = model;
    }
    [self.collection reloadData];
}

- (void)closeBtnClick{
    if (self.cancel) {
        [self.didDataArr removeAllObjects];
        [self.chooseDataArr removeAllObjects];;
        [self.indexPathArr removeAllObjects];
        self.isDelete = NO;
        
        self.cancel();
    }
    [self keyboredHiden];
}
- (void)nextBtnClick{
    if (self.model.group.count == 0) {
        [self.chooseDataArr removeAllObjects];;
        [self.indexPathArr removeAllObjects];
        self.isDelete = NO;
        ChooseSize_dataModel *dataModel = self.model.info[0];
        self.did(dataModel.goods_id,[NSString stringWithFormat:@"%zd",_count],@"");
    }else if (self.didDataArr.count == self.model.group.count) {
        if (self.did && ![_goods_id isEqualToString:@"A"]) {
            NSString *str = [self returnPaystring:self.didDataArr];
            [self.chooseDataArr removeAllObjects];;
            [self.indexPathArr removeAllObjects];
            self.isDelete = NO;
            self.did(_goods_id,[NSString stringWithFormat:@"%zd",_count],str);
        }
    }
    
}

- (void)sizeHelpBtnClick{
    if (self.push) {
        self.push();
    }
}

- (NSArray *)contrast:(NSMutableArray *)arrA arrb:(NSMutableArray *)arrB{
    NSArray *arr = @[];
    int k = 0;
    for (int i = 0; i < arrA.count; i++) {
        Choose_spModel *titleModel = arrA[i];
        
        NSString *strA = titleModel.sp_value_id;
        for (int j = 0; j< arrB.count; j++) {
            NSNumber *strB = arrB[j];
            if ([strA isEqualToString:strB.stringValue]) {
                
                k++;
                if (k == arrA.count) {
                    arr = arrB;
                }
                
                
            }else{
                //arr = arrB;
            }
        }
    }
    return arr;
    
}
//返回选中的型号
- (NSString *)returnPaystring:(NSMutableArray *)dataArr{
    NSString *str = @"";
    NSMutableString *titleText = [[NSMutableString alloc]initWithString:str];
    
    
    for (int i = 0; i < self.model.group.count; i++) {
        ChooseSize_groupModel *model = self.model.group[i];
        Choose_spModel *titleModel = dataArr[i];
        NSString * str1 = titleModel.sp_value_name;
        [titleText appendString:[NSString stringWithFormat:@"%@:%@;",model.sp_name,str1]];
    }
  
    str = [titleText mutableCopy];
    
    return str;
}
//去掉数组重复元素
- (NSMutableSet *)removeRepeat:(NSArray *)arr{
    NSMutableArray *dataArr =[NSMutableArray array];
    for (NSArray *arr1 in arr) {
        if (arr1.count != 0) {
            for (NSNumber *obj in arr1) {
                [dataArr addObject:obj.stringValue];
            }
        }
    }
    NSMutableSet *numSet = [[NSMutableSet alloc]initWithArray:dataArr];
    NSMutableArray *arr2 = [NSMutableArray array];
    for (Choose_spModel *titleModel in self.didDataArr) {
        NSString *str = titleModel.sp_value_name;
        [arr2 addObject:str];
    }
    NSMutableSet *oldSet = [[NSMutableSet alloc]initWithArray:arr2];
    [numSet minusSet:oldSet];
    
    return numSet;
}
// 判断是否相同

- (NSInteger )equalToArray:(NSArray *)arrA arrB:(NSArray *)arrB{
    int k = 0;
    if (arrA.count != arrB.count) {
        return  0;
    }else{
        for (int i = 0; i < arrA.count; i++) {
            Choose_spModel *titleModel = arrA[i];
            NSString * strA = titleModel.sp_value_id;
            NSNumber * strB = arrB[i];
            if ([strA isEqualToString:strB.stringValue]) {
                k++;
            }
            if (k == arrA.count) {
                return k;
            }
        }
    }
    return 0;
}

- (void)keyboredHiden{
    [self endEditing:YES];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
