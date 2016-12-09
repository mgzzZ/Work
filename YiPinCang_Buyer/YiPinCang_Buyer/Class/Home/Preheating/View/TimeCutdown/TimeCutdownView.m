//
//  TimeCutdownView.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/16.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "TimeCutdownView.h"

@interface TimeCutdownView ()
{
    long _totalTimes;
}

@property (strong, nonatomic) IBOutlet UILabel *titleL;
@property (strong, nonatomic) IBOutlet UILabel *dayL1;
@property (strong, nonatomic) IBOutlet UILabel *dayL2;
@property (strong, nonatomic) IBOutlet UILabel *hourL1;
@property (strong, nonatomic) IBOutlet UILabel *hourL2;
@property (strong, nonatomic) IBOutlet UILabel *minuteL1;
@property (strong, nonatomic) IBOutlet UILabel *minuteL2;
@property (strong, nonatomic) IBOutlet UILabel *secondL1;
@property (strong, nonatomic) IBOutlet UILabel *secondL2;

@end

@implementation TimeCutdownView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"TimeCutdownView" owner:self options:nil];
    [self addSubview:self.contentView];
}

- (void)layoutSubviews
{
    CGRect frame = self.frame;
    frame.size.width = ScreenWidth;
    [self setFrame:frame];
}

- (void)startTime:(NSString *)startTime endTime:(NSString *)endTime
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
        self.timeEnd = NO;
        
        NSString *distanceStartTime = [self intervalFromLastDate:startTime toTheDate:[self getCurrentTime]];
        int start_hour   = [[distanceStartTime componentsSeparatedByString:@":"][0] intValue];
        int start_min    = [[distanceStartTime componentsSeparatedByString:@":"][1] intValue];
        int start_second = [[distanceStartTime componentsSeparatedByString:@":"][2] intValue];
        long totalTimes = start_hour*60*60 + start_min*60 + start_second;
        
        // 已经开始(当前时间 大于 开始时间)
        if (totalTimes >= 0)
        {
            self.timeStart = YES;
            self.titleL.text     = @"—— 距离直播结束还剩 ——";
            
            [self day:end_hour/24 hour:end_hour%24 minute:end_min second:end_second];
        }
        // 还未开始(当前时间 小于 开始时间)
        else
        {
            self.timeStart = NO;
            self.titleL.text     = @"—— 距离直播开始还剩 ——";
            _totalTimes    = -totalTimes;
            [self day:-start_hour/24 hour:-start_hour%24 minute:-start_min second:-start_second];
        }
        
        [self cutDown];

    }
    else if (result == NSOrderedAscending){
        self.titleL.text     = @"—— 活动已结束 ——";
        self.dayL1.text = @"0";
        self.dayL2.text = @"0";
        self.hourL1.text = @"0";
        self.hourL2.text = @"0";
        self.minuteL1.text = @"0";
        self.minuteL2.text = @"0";
        self.secondL1.text = @"0";
        self.secondL2.text = @"0";
    }
}

- (void)day:(int)d hour:(int)h minute:(int)m second:(int)s
{
    NSString *day = [NSString stringWithFormat:@"%02d", d];
    self.dayL1.text = [day substringWithRange:NSMakeRange(0, 1)];
    self.dayL2.text = [day substringWithRange:NSMakeRange(1, 1)];
    
    NSString *hour = [NSString stringWithFormat:@"%02d", h];
    self.hourL1.text = [hour substringWithRange:NSMakeRange(0, 1)];
    self.hourL2.text = [hour substringWithRange:NSMakeRange(1, 1)];
    
    NSString *minute = [NSString stringWithFormat:@"%02d", m];
    self.minuteL1.text = [minute substringWithRange:NSMakeRange(0, 1)];
    self.minuteL2.text = [minute substringWithRange:NSMakeRange(1, 1)];
    
    NSString *second = [NSString stringWithFormat:@"%02d", s];
    self.secondL1.text = [second substringWithRange:NSMakeRange(0, 1)];
    self.secondL2.text = [second substringWithRange:NSMakeRange(1, 1)];
}

- (void)cutDown
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    uint64_t intival      = 1.0 * NSEC_PER_SEC;
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW,(int64_t)2.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(_timer, start, intival, 0);
    
    dispatch_source_set_event_handler(_timer, ^
                                      {
                                          __block long time = -- _totalTimes;
                                          dispatch_async(dispatch_get_main_queue(), ^
                                                         {
                                                             // 秒
                                                             NSString *second = [NSString stringWithFormat:@"%02ld",time%60];
                                                             self.secondL1.text = [second substringWithRange:NSMakeRange(0, 1)];
                                                             self.secondL2.text = [second substringWithRange:NSMakeRange(1, 1)];
                                                             // 分
                                                             time /= 60;
                                                             if (time > 0)
                                                             {
                                                                 NSString *minute = [NSString stringWithFormat:@"%02ld",time%60];
                                                                 self.minuteL1.text = [minute substringWithRange:NSMakeRange(0, 1)];
                                                                 self.minuteL2.text = [minute substringWithRange:NSMakeRange(1, 1)];
                                                             } else {
                                                                 self.minuteL1.text = @"0";
                                                                 self.minuteL2.text = @"0";
                                                             }
                                                             
                                                             // 时
                                                             time /= 60;
                                                             if (time > 0)
                                                             {
                                                                 NSString *hour = [NSString stringWithFormat:@"%02ld",time%24];
                                                                 self.hourL1.text = [hour substringWithRange:NSMakeRange(0, 1)];
                                                                 self.hourL2.text = [hour substringWithRange:NSMakeRange(1, 1)];
                                                                 
                                                             } else {
                                                                 self.hourL1.text = @"0";
                                                                 self.hourL2.text = @"0";
                                                             }
                                                             // 天
                                                             if (time/24 > 0)
                                                             {
                                                                 NSString *day = [NSString stringWithFormat:@"%02ld",time/24];
                                                                 self.dayL1.text = [day substringWithRange:NSMakeRange(0, 1)];
                                                                 self.dayL2.text = [day substringWithRange:NSMakeRange(1, 1)];
                                                             }else
                                                             {
                                                                 self.dayL1.text = @"0";
                                                                 self.dayL2.text = @"0";
                                                             }
                                                         });
                                          
                                          if (_totalTimes == 0)
                                          {
                                              dispatch_cancel(self.timer);
                                              
                                              if (self.TimeEndBlock) {
                                                  self.TimeEndBlock();
                                              }
                                              
                                              // 未开始 ---> 开始,刷新计时器,进入结束倒计时
                                              if (!self.timeStart)
                                              {
                                                  if (self.TimeStartBlock) {
                                                      self.TimeStartBlock();
                                                  }
                                                  
                                              }
                                          }
                                      });
    dispatch_resume(_timer);

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

@end
