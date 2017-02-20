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
{
    long _totalTimes;
    
}
@property (strong, nonatomic) IBOutlet UIImageView *bgImgV;

@property (nonatomic, strong) IBOutlet UILabel *titleL;
@property (strong, nonatomic) IBOutlet UILabel *timeCountDownL;
@property (strong, nonatomic) IBOutlet UILabel *adressL;
@property (strong, nonatomic) IBOutlet UIImageView *startLivingAnimationImg;

@property (weak, nonatomic) IBOutlet UICollectionView *endCollectionView;
@property (nonatomic, strong) NSMutableArray *cvDataArr;

@property (strong, nonatomic) IBOutlet HomeTimeCutdownView *timeCutdownV;

@property (nonatomic,strong) dispatch_source_t timer;
@property (nonatomic, copy) NSString *timeCountDownTitle;
@property (nonatomic, copy) NSString *dayL1;
@property (nonatomic, copy) NSString *dayL2;
@property (nonatomic, copy) NSString *hourL1;
@property (nonatomic, copy) NSString *hourL2;
@property (nonatomic, copy) NSString *minuteL1;
@property (nonatomic, copy) NSString *minuteL2;
@property (nonatomic, copy) NSString *secondL1;
@property (nonatomic, copy) NSString *secondL2;

@end

@implementation HomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)drawRect:(CGRect)rect
{
    if ([_tempModel.ac_state isEqualToString:@"0"]) { // 预热
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgImgV.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(2, 2)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bgImgV.bounds;
        maskLayer.path = maskPath.CGPath;
        self.bgImgV.layer.mask = maskLayer;
    }else if([_tempModel.ac_state isEqualToString:@"1"] || [_tempModel.ac_state isEqualToString:@"4"]) { // 直播中
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgImgV.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(6, 6)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bgImgV.bounds;
        maskLayer.path = maskPath.CGPath;
        self.bgImgV.layer.mask = maskLayer;
    }
}

- (NSMutableArray *)cvDataArr
{
    if (_cvDataArr) {
        return _cvDataArr;
    }
    _cvDataArr = [NSMutableArray array];
    return _cvDataArr;
}

- (void)setTempModel:(HomeTVDetailModel *)tempModel
{
    _tempModel = tempModel;
    
    if ([_tempModel.ac_state isEqualToString:@"0"]) {// 预热
        
        [self.bgImgV sd_setImageWithURL:[NSURL URLWithString:_tempModel.activity_pic] placeholderImage:YPCImagePlaceHolderBigSquare];
        self.titleL.text = _tempModel.name;
        [self coutDownTimeAction:_tempModel.starttime endTime:_tempModel.endtime];
        
    }else if ([_tempModel.ac_state isEqualToString:@"1"] || [_tempModel.ac_state isEqualToString:@"4"]) { // 直播中
        
        [self startAnimation];
        [self.bgImgV sd_setImageWithURL:[NSURL URLWithString:_tempModel.activity_pic] placeholderImage:IMAGE(@"homepage_banner_zhanweitu")];
        self.adressL.text = _tempModel.address;
        self.timeCutdownV.colorStyle = SecondColorStyleRed;
        [self.timeCutdownV startTime:_tempModel.starttime endTime:_tempModel.endtime];
        
    }else{ // 已结束
        [self.bgImgV sd_setImageWithURL:[NSURL URLWithString:_tempModel.activity_pic] placeholderImage:IMAGE(@"homepage_banner_zhanweitu")];
        self.adressL.text = _tempModel.address;
        if (_tempModel.goods_data.count > 0) {
            self.endCollectionView.hidden = NO;
            self.cvDataArr = [CommendModel mj_objectArrayWithKeyValuesArray:_tempModel.goods_data];
            [self registCollectionView];
        }else {
            self.endCollectionView.hidden = YES;
        }
    }
}

- (void)startAnimation
{
    NSArray *images = [[NSArray alloc] init];
    
    images = [NSArray arrayWithObjects:
              IMAGE(@"homepage_living_icon1"),
              IMAGE(@"homepage_living_icon2"),
              IMAGE(@"homepage_living_icon3"),
              nil];
    
    self.startLivingAnimationImg.animationImages = images;
    self.startLivingAnimationImg.animationDuration = .5f;
    self.startLivingAnimationImg.animationRepeatCount = 0;
    [self.startLivingAnimationImg startAnimating];
}

- (void)coutDownTimeAction:(NSString *)startTime endTime:(NSString *)endTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateA = [dateFormatter dateFromString:endTime];
    NSDate *dateB = [dateFormatter dateFromString:[self getCurrentTime]];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        // 时间处理
        NSString *distanceEndTime = [self intervalFromLastDate:[self getCurrentTime] toTheDate:endTime];
        int end_hour   = [[distanceEndTime componentsSeparatedByString:@":"][0] intValue];
        int end_min    = [[distanceEndTime componentsSeparatedByString:@":"][1] intValue];
        int end_second = [[distanceEndTime componentsSeparatedByString:@":"][2] intValue];
        _totalTimes = end_hour * 60 * 60 + end_min * 60 + end_second;
        
        if (self.timer) {
            dispatch_cancel(self.timer);
        }
        
        NSString *distanceStartTime = [self intervalFromLastDate:startTime toTheDate:[self getCurrentTime]];
        int start_hour   = [[distanceStartTime componentsSeparatedByString:@":"][0] intValue];
        int start_min    = [[distanceStartTime componentsSeparatedByString:@":"][1] intValue];
        int start_second = [[distanceStartTime componentsSeparatedByString:@":"][2] intValue];
        long totalTimes = start_hour*60*60 + start_min*60 + start_second;
        
        // 已经开始(当前时间 大于 开始时间)
        if (totalTimes >= 0)
        {
            self.timeCountDownTitle     = @"倒计时 ";
            
            [self day:end_hour/24 hour:end_hour%24 minute:end_min second:end_second];
        }
        // 还未开始(当前时间 小于 开始时间)
        else
        {
            self.timeCountDownTitle     = @"倒计时 ";
            _totalTimes    = -totalTimes;
            [self day:-start_hour/24 hour:-start_hour%24 minute:-start_min second:-start_second];
        }
        
        [self cutDown];
        
    }
    else if (result == NSOrderedAscending){
        self.timeCountDownL.text     = @"已结束";
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
    return CGSizeMake(70.f, 112.f);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DiscoverDetailVC *detailVC = [DiscoverDetailVC new];
    detailVC.strace_id = [self.cvDataArr[indexPath.row] strace_id];
    detailVC.hidesBottomBarWhenPushed = YES;
    [[YPC_Tools getControllerWithView:self].navigationController pushViewController:detailVC animated:YES];
}

- (NSString *)intervalFromLastDate:(NSString *)dateString1  toTheDate:(NSString *)dateString2
{
    NSArray *timeArray1   = [dateString1 componentsSeparatedByString:@"."];
    dateString1           = [timeArray1 objectAtIndex:0];
    
    NSArray *timeArray2   = [dateString2 componentsSeparatedByString:@"."];
    dateString2           = [timeArray2 objectAtIndex:0];
    
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *d1            = [date dateFromString:dateString1];
    NSTimeInterval late1  = [d1 timeIntervalSince1970]*1;
    
    NSDate *d2            = [date dateFromString:dateString2];
    NSTimeInterval late2  = [d2 timeIntervalSince1970]*1;
    
    NSTimeInterval cha    = late2 - late1;
    NSString *timeString  = @"";
    NSString *house       = @"";
    NSString *min         = @"";
    NSString *sen         = @"";
    
    // 秒
    sen        = [NSString stringWithFormat:@"%d", (int)cha%60];
    sen        = [NSString stringWithFormat:@"%@", sen];
    
    // 分
    min        = [NSString stringWithFormat:@"%d", (int)cha/60%60];
    min        = [NSString stringWithFormat:@"%@", min];
    
    // 小时
    house      = [NSString stringWithFormat:@"%d", (int)cha/3600];
    house      = [NSString stringWithFormat:@"%@", house];
    
    timeString = [NSString stringWithFormat:@"%@:%@:%@",house,min,sen];
    
    return timeString;
}

- (NSString *)getCurrentTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    
    return dateTime;
}

- (void)day:(int)d hour:(int)h minute:(int)m second:(int)s
{
    NSString *day = [NSString stringWithFormat:@"%02d", d];
    self.dayL1 = [day substringWithRange:NSMakeRange(0, 1)];
    self.dayL2 = [day substringWithRange:NSMakeRange(1, 1)];
    
    NSString *hour = [NSString stringWithFormat:@"%02d", h];
    self.hourL1 = [hour substringWithRange:NSMakeRange(0, 1)];
    self.hourL2 = [hour substringWithRange:NSMakeRange(1, 1)];
    
    NSString *minute = [NSString stringWithFormat:@"%02d", m];
    self.minuteL1 = [minute substringWithRange:NSMakeRange(0, 1)];
    self.minuteL2 = [minute substringWithRange:NSMakeRange(1, 1)];
    
    NSString *second = [NSString stringWithFormat:@"%02d", s];
    self.secondL1 = [second substringWithRange:NSMakeRange(0, 1)];
    self.secondL2 = [second substringWithRange:NSMakeRange(1, 1)];
}

- (void)cutDown
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    uint64_t intival      = 1.0 * NSEC_PER_SEC;
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW,(int64_t)2.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(_timer, start, intival, 0);
    WS(weakSelf);
    dispatch_source_set_event_handler(_timer, ^
                                      {
                                          __block long time = -- _totalTimes;
                                          dispatch_async(dispatch_get_main_queue(), ^
                                                         {
                                                             // 秒
                                                             NSString *second = [NSString stringWithFormat:@"%02ld",time%60];
                                                             weakSelf.secondL1 = [second substringWithRange:NSMakeRange(0, 1)];
                                                             weakSelf.secondL2 = [second substringWithRange:NSMakeRange(1, 1)];
                                                             // 分
                                                             time /= 60;
                                                             if (time > 0)
                                                             {
                                                                 NSString *minute = [NSString stringWithFormat:@"%02ld",time%60];
                                                                 weakSelf.minuteL1 = [minute substringWithRange:NSMakeRange(0, 1)];
                                                                 weakSelf.minuteL2 = [minute substringWithRange:NSMakeRange(1, 1)];
                                                             } else {
                                                                 weakSelf.minuteL1 = @"0";
                                                                 weakSelf.minuteL2 = @"0";
                                                             }
                                                             
                                                             // 时
                                                             time /= 60;
                                                             if (time > 0)
                                                             {
                                                                 NSString *hour = [NSString stringWithFormat:@"%02ld",time%24];
                                                                 weakSelf.hourL1 = [hour substringWithRange:NSMakeRange(0, 1)];
                                                                 weakSelf.hourL2 = [hour substringWithRange:NSMakeRange(1, 1)];
                                                                 
                                                             } else {
                                                                 weakSelf.hourL1 = @"0";
                                                                 weakSelf.hourL2 = @"0";
                                                             }
                                                             // 天
                                                             if (time/24 > 0)
                                                             {
                                                                 NSString *day = [NSString stringWithFormat:@"%02ld",time/24];
                                                                 weakSelf.dayL1 = [day substringWithRange:NSMakeRange(0, 1)];
                                                                 weakSelf.dayL2 = [day substringWithRange:NSMakeRange(1, 1)];
                                                             }else
                                                             {
                                                                 weakSelf.dayL1 = @"0";
                                                                 weakSelf.dayL2 = @"0";
                                                             }
                                                             if (![weakSelf.hourL1 isEqualToString:@"0"] && ![weakSelf.hourL2 isEqualToString:@"0"]) {
                                                                 weakSelf.timeCountDownL.text = [NSString stringWithFormat:@"%@%@%@天%@%@时%@%@分%@%@秒", weakSelf.timeCountDownTitle, weakSelf.dayL1, weakSelf.dayL2, weakSelf.hourL1, weakSelf.hourL2, weakSelf.minuteL1, weakSelf.minuteL2, weakSelf.secondL1, weakSelf.secondL2];
                                                             }else {
                                                                 weakSelf.timeCountDownL.text = [NSString stringWithFormat:@"%@%@%@时%@%@分%@%@秒", weakSelf.timeCountDownTitle, weakSelf.hourL1, weakSelf.hourL2, weakSelf.minuteL1, weakSelf.minuteL2, weakSelf.secondL1, weakSelf.secondL2];
                                                             }
                                                         });
                                          
                                          if (_totalTimes == 0)
                                          {
                                              dispatch_cancel(self.timer);
                                          }
                                      });
    dispatch_resume(_timer);
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
