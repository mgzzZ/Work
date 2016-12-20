//
//  HomeCell.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/8.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "HomeCell.h"
#import "endActivityGoodsCVCell.h"
#import "HomeTimeCutdownView.h"
#import "CommendModel.h"
#import "DiscoverDetailVC.h"

static NSString *Identifier = @"endActivityGoodsCVCell";
@interface HomeCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UIImageView *logoImgV;
@property (strong, nonatomic) IBOutlet UILabel *brandNameL;
@property (strong, nonatomic) IBOutlet UILabel *audienceNumL;
@property (strong, nonatomic) IBOutlet UIButton *statusBtn;
@property (strong, nonatomic) IBOutlet UILabel *desL;

@property (strong, nonatomic) IBOutlet UIImageView *bgImgV;

@property (strong, nonatomic) IBOutlet UILabel *timeL;
@property (strong, nonatomic) IBOutlet UILabel *adressL;

@property (weak, nonatomic) IBOutlet UICollectionView *endCollectionView;
@property (nonatomic, strong) NSMutableArray *cvDataArr;

@property (strong, nonatomic) IBOutlet HomeTimeCutdownView *timeCutdownV;

@end

@implementation HomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (NSMutableArray *)cvDataArr
{
    if (_cvDataArr) {
        return _cvDataArr;
    }
    _cvDataArr = [NSMutableArray array];
    return _cvDataArr;
}

- (IBAction)playVideoAction:(UIButton *)sender {
    self.ButtonClickedBlock(@"play");
}
- (IBAction)NoticeActicityAction:(UIButton *)sender {
    WS(weakSelf);
    if (self.tempModel.store_info.isRss.integerValue == 0) {
        
        if ([YPCRequestCenter isLoginAndPresentLoginVC:[YPC_Tools getControllerWithView:self]]) {
            [YPCNetworking postWithUrl:@"shop/activity/rssactivity"
                          refreshCache:YES
                                params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                       @"live_id"   : weakSelf.tempModel.live_id
                                                                                       }]
                               success:^(id response) {
                                   if ([YPC_Tools judgeRequestAvailable:response]) {
                                       [YPC_Tools showSvpWithNoneImgHud:@"设置提醒成功"];
                                       [self.statusBtn setImage:IMAGE(@"homepage_icon_playdown") forState:UIControlStateNormal];
                                       [weakSelf.tempModel.store_info setIsRss:@"1"];
                                       weakSelf.ButtonClickedBlock(@"successRss");
                                   }
                               }
                                  fail:nil];
        }
    }else {
        
        if ([YPCRequestCenter isLoginAndPresentLoginVC:[YPC_Tools getControllerWithView:self]]) {
            [YPCNetworking postWithUrl:@"shop/activity/rssactivitycancel"
                          refreshCache:YES
                                params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                       @"live_id"   : weakSelf.tempModel.live_id
                                                                                       }]
                               success:^(id response) {
                                   if ([YPC_Tools judgeRequestAvailable:response]) {
                                       [YPC_Tools showSvpWithNoneImgHud:@"取消订阅"];
                                       [self.statusBtn setImage:IMAGE(@"homepage_icon_playtips") forState:UIControlStateNormal];
                                       [weakSelf.tempModel.store_info setIsRss:@"0"];
                                       weakSelf.ButtonClickedBlock(@"cancelRss");
                                   }
                               }
                                  fail:nil];
        }
    }
}

- (void)setIsImgPHViewHidden:(BOOL)isImgPHViewHidden
{
    _isImgPHViewHidden = isImgPHViewHidden;
    if (_isImgPHViewHidden) {
        self.nowifiImgPHView.hidden = YES;
    }else {
        self.nowifiImgPHView.hidden = NO;
    }
}

- (void)setTempModel:(HomeTVDetailModel *)tempModel
{
    _tempModel = tempModel;
    [self.logoImgV sd_setImageWithURL:[NSURL URLWithString:_tempModel.brand.brand_pic] placeholderImage:IMAGE(@"find_logo_placeholder")];
    self.brandNameL.text = _tempModel.brand.brand_name;
    self.audienceNumL.text = _tempModel.brand.attentions;
    self.desL.text = _tempModel.name;
    [self.bgImgV sd_setImageWithURL:[NSURL URLWithString:_tempModel.activity_pic] placeholderImage:IMAGE(@"homepage_banner_zhanweitu")];
    self.timeL.text = [NSString stringWithFormat:@"%@-%@", [YPC_Tools timeWithTimeIntervalString:_tempModel.start Format:@"MM月dd日"], [YPC_Tools timeWithTimeIntervalString:_tempModel.end Format:@"MM月dd日"]];
    self.adressL.text = _tempModel.address;
    
    if ([_tempModel.state isEqualToString:@"0"]) {// 预热
        
        self.timeCutdownV.colorStyle = SecondColorStyleGreen;
        [self.timeCutdownV startTime:_tempModel.starttime endTime:_tempModel.endtime];
        self.statusBtn.enabled = YES;
        self.statusBtn.acceptEventInterval = 1.f;
        if (_tempModel.store_info.isRss.integerValue == 0) {
            [self.statusBtn setImage:IMAGE(@"homepage_icon_playtips") forState:UIControlStateNormal];
        }else {
            [self.statusBtn setImage:IMAGE(@"homepage_icon_playdown") forState:UIControlStateNormal];
        }
        
    }else if ([_tempModel.state isEqualToString:@"1"] || [_tempModel.state isEqualToString:@"4"]) { // 直播中
        
        self.timeCutdownV.colorStyle = SecondColorStyleRed;
        [self.timeCutdownV startTime:_tempModel.starttime endTime:_tempModel.endtime];
        self.statusBtn.enabled = NO;
        
    }else{ // 已结束
        self.statusBtn.enabled = NO;
        if (_tempModel.goods_data.count > 0) {
            self.endCollectionView.hidden = NO;
            self.cvDataArr = [CommendModel mj_objectArrayWithKeyValuesArray:_tempModel.goods_data];
            [self registCollectionView];
        }else {
            self.endCollectionView.hidden = YES;
        }
    }
}

- (void)registCollectionView
{
    self.endCollectionView.delegate = self;
    self.endCollectionView.dataSource = self;
    [self.endCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([endActivityGoodsCVCell class]) bundle:nil] forCellWithReuseIdentifier:Identifier];
    [self.endCollectionView reloadData];
}

#pragma mark - CollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cvDataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    endActivityGoodsCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    cell.tempModel = self.cvDataArr[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100.f, 150.f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DiscoverDetailVC *detailVC = [DiscoverDetailVC new];
    detailVC.live_id = self.tempModel.live_id;
    detailVC.strace_id = [self.cvDataArr[indexPath.row] strace_id];
    detailVC.hidesBottomBarWhenPushed = YES;
    [[YPC_Tools getControllerWithView:self].navigationController pushViewController:detailVC animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
