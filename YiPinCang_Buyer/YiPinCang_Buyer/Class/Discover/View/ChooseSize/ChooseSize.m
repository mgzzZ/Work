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

typedef enum : NSUInteger {
    SEGCOUNTOFONE = 1,
    SEGCOUNTMORE,

} SEGCOUNT;

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
@property (nonatomic,assign)SEGCOUNT segcountType;

@property (nonatomic, strong) NSMutableArray *selectIndexPathArr; // 记录当前选中indexPath

@end

@implementation ChooseSize

- (NSMutableArray *)selectIndexPathArr
{
    if (_selectIndexPathArr) {
        return _selectIndexPathArr;
    }
    _selectIndexPathArr = [NSMutableArray new];
    return _selectIndexPathArr;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
         [self setup];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboredHiden)];
        [self addGestureRecognizer:tap];
       
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
    self.oldRow = -1;
    self.oldSection = -1;
    self.isDelete = NO;
    
    self.count = count;
    self.maxCount = maxCount;
    self.payNumberBtn.currentNumber = [NSString stringWithFormat:@"%zd",count];
    self.payNumberBtn.maxValue = maxCount;
    self.countLab.text = [NSString stringWithFormat:@"库存:%zd",maxCount];
    if (_model != model) {
        _model = model;
    }
    if (model.group.count == 1) {
        self.segcountType = SEGCOUNTOFONE;
    }else{
        self.segcountType = SEGCOUNTMORE;
    }
    [self.img sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:YPCImagePlaceHolder];
    self.priceLab.text =  [NSString stringWithFormat:@"¥%@",price];
    if (self.model.info.count == 1) {
        NSString *str = @"";
        NSMutableString *titleText = [[NSMutableString alloc]initWithString:str];
        for (int i = 0; i < self.model.group.count; i++) {
            ChooseSize_groupModel *model = self.model.group[i];
            Choose_spModel *titleModel = model.data[0];
            
            [titleText appendString:[NSString stringWithFormat:@"%@ ",titleModel.sp_value_name]];
        }
        self.titleLab.text = titleText;
    }else{
        self.titleLab.text =  chooseMessage;
    }
    if (model.group.count == 0) {
        self.collection.userInteractionEnabled = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboredHiden)];
        [self addGestureRecognizer:tap];
        self.collection.allowsMultipleSelection = YES;
    }else{
        self.collection.userInteractionEnabled = YES;
        self.collection.allowsMultipleSelection = YES;
    }
    
    [self.collection reloadData];
}
- (void)setup{
    self.goods_id = @"A";
    self.didDataArr = [[NSMutableArray alloc]init];
    self.chooseDataArr = [[NSMutableArray alloc]init];
    self.selectIndexPathArr = [[NSMutableArray alloc]init];
    self.oldRow = -1;
    self.oldSection = 0;
    self.isDelete = NO;
    self.img = [[UIImageView alloc]init];
    self.img.contentMode = UIViewContentModeScaleAspectFill;
    self.img.backgroundColor = [UIColor whiteColor];
    self.img.clipsToBounds = YES;
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
    if (self.model.info.count == 1) {
        [self cellDidType:cell];
         cell.titleLab.text = [NSString stringWithFormat:@"%@",titleModel.sp_value_name];
    }else{
        switch (self.segcountType) {
            case SEGCOUNTOFONE:
            {
                cell.segcount = SEGCOUNTOFONECELL;
                cell.titleLab.text = [NSString stringWithFormat:@"%@",titleModel.sp_value_name];
                cell.bgView.layer.borderColor = [Color colorWithHex:@"0xefefef"].CGColor;
                cell.bgView.layer.borderWidth = 2;
                cell.success = ^(NSIndexPath *index){
                    
                    [weakSelf.selectIndexPathArr addObject:index];
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
                    [weakSelf.selectIndexPathArr removeObject:index];
                };
                if (titleModel.isSelete == YES) {
                    cell.titleLab.textColor = [UIColor grayColor];
                }
                
            }
                break;
            case SEGCOUNTMORE:
            {
                
                cell.segcount = SEGCOUNTMORECELL;
                cell.model = titleModel;
                
            }
                break;
            default:
                break;
        }
    }
    
        return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self keyboredHiden];
    
    ChooseSizeCell *cell = (ChooseSizeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    ChooseSize_groupModel *model = self.model.group[indexPath.section];
    Choose_spModel *titleModel = model.data[indexPath.row];
    if (self.model.info.count == 1) {
        return;
    }else{
        switch (self.segcountType) {
            case SEGCOUNTOFONE:
            {
                cell.index = indexPath;
                
                if (titleModel.isSelete == NO ) {
                    if (self.oldRow != indexPath.row && self.oldRow != -1) {
                        Choose_spModel *titleModel1 = model.data[self.oldRow];
                        titleModel1.isSelete = NO;
                    }
                    self.oldRow = indexPath.row;
                    titleModel.isSelete = YES;
                    [self.didDataArr removeAllObjects];
                    [self.didDataArr addObject:titleModel];
                    NSString *str = [self returnPaystring:self.didDataArr];
                    if (str.length == 0) {
                        self.titleLab.text = @"请选择规格";
                    }else{
                        self.titleLab.text = str;
                    }
                }else{
                    titleModel.isSelete = NO;
                    [self.didDataArr removeAllObjects];
                    self.titleLab.text = @"请选择规格";
                }
            }
                break;
            case SEGCOUNTMORE:
            {
                
                
                if (titleModel.isSelete == NO) {
                    [self selectItemAtCollectionView:collectionView andIndexPath:indexPath];
                }
                
                
                //            ChooseSize_groupModel *model = self.model.group[indexPath.section];
                //            Choose_spModel *titleModelold = model.data[indexPath.row];
                //            if (titleModelold.isSelete == NO) {
                //                 [self selectItemAtCollectionView:collectionView andIndexPath:indexPath];
                //                for (int i = 0; i < self.model.group.count; i++) {
                //                    ChooseSize_groupModel *model1 = self.model.group[i];
                //                    for (int j = 0; j < model1.data.count; j++) {
                //                        NSIndexPath *index = [NSIndexPath indexPathForRow:j inSection:i];
                //                        Choose_spModel *titleModel1 = model1.data[j];
                //                        YPCAppLog(@"%@---%zd---%zd",titleModel1.spType,i,j);
                //                        [self.collection reloadItemsAtIndexPaths:@[index]];
                //                    }
                //                }
                //            }
                
                
                
                YPCAppLog(@"------end---");
            }
                break;
                
            default:
                break;
        }
    }
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.model.info.count == 1) {
        return;
    }else{
        switch (self.segcountType) {
            case SEGCOUNTOFONE:
            {
                if (self.oldRow == indexPath.row) {
                    ChooseSize_groupModel *model = self.model.group[indexPath.section];
                    Choose_spModel *titleModel = model.data[indexPath.row];
                    ChooseSizeCell *cell = (ChooseSizeCell *)[collectionView cellForItemAtIndexPath:indexPath];
                    if (titleModel.isSelete) {
                        titleModel.isSelete = NO;
                        cell.index = indexPath;
                    }
                    cell.bgView.backgroundColor = [UIColor whiteColor];
                    cell.titleLab.textColor = [UIColor blackColor];
                    cell.bgView.layer.borderColor = [Color colorWithHex:@"0xefefef"].CGColor;
                    
                }
            }
                break;
            case SEGCOUNTMORE:
            {
                if ([self.selectIndexPathArr containsObject:indexPath]) {
                    [self deleteData:indexPath];
                    [self.selectIndexPathArr removeObject:indexPath];
                    [self segData:indexPath];
                    
                }
            }
                break;
            default:
                break;
        }
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
        [self.selectIndexPathArr removeAllObjects];
        self.isDelete = NO;
        
        self.cancel();
    }
    [self keyboredHiden];
}
- (void)nextBtnClick{
    
    if (self.model.info.count == 1) {
        ChooseSize_dataModel *dataModel = self.model.info[0];
        self.did(dataModel.goods_id,[NSString stringWithFormat:@"%zd",_count],@"");
        self.maxCount = self.maxCount - _count;
        if (self.maxCount < 1) {
            self.maxCount = 0;
        }
        self.payNumberBtn.maxValue = self.maxCount;
        self.countLab.text = [NSString stringWithFormat:@"库存:%zd",self.maxCount];
        return;
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

    
    if (self.model.group.count == 0) {
        [self.chooseDataArr removeAllObjects];;
        [self.selectIndexPathArr removeAllObjects];
        self.isDelete = NO;
        ChooseSize_dataModel *dataModel = self.model.info[0];
        self.did(dataModel.goods_id,[NSString stringWithFormat:@"%zd",_count],@"");
        self.maxCount = self.maxCount - _count;
        if (self.maxCount < 1) {
            self.maxCount = 0;
        }
        self.payNumberBtn.maxValue = self.maxCount;
        self.countLab.text = [NSString stringWithFormat:@"库存:%zd",self.maxCount];
    }else if (self.didDataArr.count == self.model.group.count) {
        if (self.did && ![_goods_id isEqualToString:@"A"]) {
            NSString *str = [self returnPaystring:self.didDataArr];
            [self.chooseDataArr removeAllObjects];;
            [self.selectIndexPathArr removeAllObjects];
            self.isDelete = NO;
            self.did(_goods_id,[NSString stringWithFormat:@"%zd",_count],str);
            self.maxCount = self.maxCount - _count;
            if (self.maxCount < 1) {
                self.maxCount = 0;
            }
            self.payNumberBtn.maxValue = self.maxCount;
            self.countLab.text = [NSString stringWithFormat:@"库存:%zd",self.maxCount];
        }else{
            [YPC_Tools showSvpWithNoneImgHud:@"请选择合适的规格型号"];
        }
    }else{
        [YPC_Tools showSvpWithNoneImgHud:@"请选择合适的规格型号"];
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
    if (dataArr.count == 0) {
        return @"";
    }
    int k = 0;
    NSString *str = @"";
    NSMutableString *titleText = [[NSMutableString alloc]initWithString:str];

    //for (int j = 0; j < dataArr.count; j++) {
        for (int i = 0; i < self.model.group.count; i++) {
            ChooseSize_groupModel *model = self.model.group[i];
            Choose_spModel *titleModel = dataArr[i];
            NSString * str1 = titleModel.sp_value_name;
            [titleText appendString:[NSString stringWithFormat:@"%@:%@;",model.sp_name,str1]];
            k++;
            if (k == dataArr.count) {
                return [titleText mutableCopy];
            }
        }
   // }
    
  
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
            for (int j = 0;  j <arrB.count; j++) {
                Choose_spModel *titleModel = arrA[i];
                NSString * strA = titleModel.sp_value_id;
                NSNumber * strB = arrB[j];
                if ([strA isEqualToString:strB.stringValue]) {
                    k++;
                }
                if (k == arrA.count) {
                    return k;
                }
            }
        }
    }
    return 0;
}


// cell 选中状态
- (void)cellDidType:(ChooseSizeCell *)cell{
    cell.bgView.backgroundColor = [UIColor redColor];
    cell.titleLab.textColor = [UIColor whiteColor];
    cell.bgView.layer.borderColor = [UIColor redColor].CGColor;

}
// cell 可选状态
- (void)cellMayDidType:(ChooseSizeCell *)cell{
    cell.bgView.backgroundColor = [UIColor whiteColor];
    cell.titleLab.textColor = [UIColor blackColor];
    cell.bgView.layer.borderColor = [Color colorWithHex:@"0xefefef"].CGColor;
}
// cell 不可选状态
- (void)cellNoDidType:(ChooseSizeCell *)cell{
    cell.titleLab.textColor = [Color colorWithHex:@"0xdbdbdb"];
    cell.bgView.backgroundColor = [UIColor whiteColor];
    cell.bgView.layer.borderColor = [Color colorWithHex:@"0xefefef"].CGColor;
}

- (void)selectItemAtCollectionView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectIndexPathArr.count == 0) {
        
        [self.selectIndexPathArr addObject:indexPath];
        
        [self addData:indexPath];
        [self segData:indexPath];
    }else{
        
        WS(weakSelf);
        __block BOOL isSameSection;
        [self.selectIndexPathArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSIndexPath *tempIndex = obj;
            if (tempIndex.section == indexPath.section) {
                // 这里删除之前这个section的选中状态 记录也对应上传idx下的数据
                [collectionView deselectItemAtIndexPath:weakSelf.selectIndexPathArr[idx] animated:NO];
                
                [weakSelf deleteData:weakSelf.selectIndexPathArr[idx]];
                
                [weakSelf.selectIndexPathArr removeObjectAtIndex:idx];
                
                [weakSelf.selectIndexPathArr addObject:indexPath];
                [self addData:indexPath];
                [self segData:indexPath];
                
                isSameSection = YES;
                
                *stop = YES;
                
            }else {
                isSameSection = NO;
            }
        }];
        
        if (!isSameSection) {
            [weakSelf.selectIndexPathArr addObject:indexPath];
            [self addData:indexPath];
            [self segData:indexPath];
        }
    }
    


}

- (void)deleteData:(NSIndexPath *)indexPath{
    
    ChooseSize_groupModel *model = self.model.group[indexPath.section];
    Choose_spModel *titleModel = model.data[indexPath.row];
    //titleModel.didType = @"2";
    
    titleModel.spType = @"0";
    
    [self.didDataArr removeObject:titleModel];
    
    NSString *str = [self returnPaystring:self.didDataArr];
    if (str.length == 0) {
        self.titleLab.text = @"请选择规格";
    }else{
        self.titleLab.text = str;
    }
}


- (void)addData:(NSIndexPath *)indexPath{
    ChooseSize_groupModel *model = self.model.group[indexPath.section];
    Choose_spModel *titleModel = model.data[indexPath.row];
    [self.didDataArr addObject:titleModel];
    NSString *str = [self returnPaystring:self.didDataArr];
    if (str.length == 0) {
        self.titleLab.text = @"请选择规格";
    }else{
        self.titleLab.text = str;
    }
}



- (void)segData:(NSIndexPath *)indexPath{
   
        [self.chooseDataArr removeAllObjects];
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
                // 先遍历可以选择的情况.

                // 分3种状态 1种是当前点击的 变红色 2 第一次点击的同级 可以都可以选 3 didset符合的都可以点  其他都不能点击
                NSIndexPath *indexxxx = [NSIndexPath indexPathForRow:j inSection:i];
                ChooseSizeCell *cell = (ChooseSizeCell *)[self.collection cellForItemAtIndexPath:indexxxx];
                if (self.didDataArr.count == 0) {
                    [self cellMayDidType:cell];
                }else{
                    for (NSObject *obj in self.didSet) {
                        if ([titleModel1.sp_value_id isEqual:obj] ) {
                            titleModel1.isSelete = NO;
                            NSIndexPath *index = [NSIndexPath indexPathForRow:j inSection:i];
                            if ([index isEqual:indexPath]) {
                                for (NSIndexPath *indexold in self.selectIndexPathArr) {
                                    if ([index isEqual:indexold]) {
                                        titleModel1.spType = @"1";
                                        titleModel1.isDid = YES;
                                        YPCAppLog(@"%zd,%zd,111已点",i , j);
                                        titleModel1.isSelete = NO;
                                        [self cellDidType:cell];
                                    }else{
                                        titleModel1.spType = @"0";
                                        titleModel1.isDid = YES;
                                        YPCAppLog(@"%zd,%zd,000可点",i , j);
                                        titleModel1.isSelete = NO;
                                        [self cellMayDidType:cell];
                                    }
                                }
                                
                            }else{
                                
                                for (NSIndexPath *indexold in self.selectIndexPathArr) {
                                    if ([indexold isEqual:index]) {
                                        
                                        titleModel1.spType = @"1";
                                        titleModel1.isDid = YES;
                                        YPCAppLog(@"%zd,%zd,222已点",i , j);
                                        [self cellDidType:cell];
                                        titleModel1.isSelete = NO;
                                    }else{
                                        if (![titleModel1.spType isEqualToString:@"1"]) {
                                            titleModel1.spType = @"0";
                                            titleModel1.isDid = NO;
                                            [self cellMayDidType:cell];
                                            titleModel1.isSelete = NO;
                                            YPCAppLog(@"%zd,%zd,可点",i , j);
                                        }
                                       
                                    }
                                }
                            }
                            break;
                        }else{
                            
                            if (self.didDataArr.count == 1 && i == indexPath.section) {
                                titleModel1.spType = @"0";
                                YPCAppLog(@"%zd,%zd,可点",i , j);
                                titleModel1.isSelete = NO;
                                titleModel1.isDid = NO;
                                [self cellMayDidType:cell];
                            }else{
                                titleModel1.spType = @"2";
                                YPCAppLog(@"%zd,%zd,不能点",i , j);
                                titleModel1.isSelete = YES;
                                titleModel1.isDid = NO;
                                [self cellNoDidType:cell];
                            }
                        }
                    }
                }

            }
        }
        
    

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
