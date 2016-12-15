/*!
 @header WMPlayer.m
 
 @abstract  作者Github地址：https://github.com/zhengwenming
 作者CSDN博客地址:http://blog.csdn.net/wenmingzheng
 
 @author   Created by zhengwenming on  16/1/24
 
 @version 2.0.0 16/1/24 Creation(版本信息)
 
 Copyright © 2016年 郑文明. All rights reserved.
 */


#import "WMPlayer.h"
#define Window [UIApplication sharedApplication].keyWindow

#define WMPlayerSrcName(file) [@"WMPlayer.bundle" stringByAppendingPathComponent:file]
#define WMPlayerFrameworkSrcName(file) [@"Frameworks/WMPlayer.framework/WMPlayer.bundle" stringByAppendingPathComponent:file]

#define WMPlayerImage(file)      [UIImage imageNamed:WMPlayerSrcName(file)] ? :[UIImage imageNamed:WMPlayerFrameworkSrcName(file)]

#define kHalfWidth self.frame.size.width * 0.5
#define kHalfHeight self.frame.size.height * 0.5
//整个屏幕代表的时间
#define TotalScreenTime 90
#define LeastDistance 15

static void *PlayViewCMTimeValue = &PlayViewCMTimeValue;

static void *PlayViewStatusObservationContext = &PlayViewStatusObservationContext;

@interface WMPlayer () <UIGestureRecognizerDelegate>{
    //用来判断手势是否移动过
    BOOL _hasMoved;
    //记录触摸开始时的视频播放的时间
    float _touchBeginValue;
    //记录触摸开始亮度
    float _touchBeginLightValue;
    //记录触摸开始的音量
    float _touchBeginVoiceValue;
    //总时间
    CGFloat totalTime;
}

/** 是否初始化了播放器 */
@property (nonatomic, assign) BOOL isInitPlayer;
///记录touch开始的点
@property (nonatomic,assign)CGPoint touchBeginPoint;
///手势控制的类型
///判断当前手势是在控制进度?声音?亮度?
@property (nonatomic, assign) WMControlType controlType;
@property (nonatomic, strong)NSDateFormatter *dateFormatter;
//监听播放起状态的监听者
@property (nonatomic ,strong) id playbackTimeObserver;
//视频进度条的单击事件
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, assign) BOOL isDragingSlider;//是否点击了按钮的响应事件
//显示播放时间的UILabel
@property (nonatomic,strong) UILabel *timeLabel;
///进度滑块
@property (nonatomic, strong) UISlider *progressSlider;
///声音滑块
@property (nonatomic, strong) UISlider *volumeSlider;
//显示缓冲进度
@property (nonatomic, strong) UIProgressView *loadingProgress;
//商品按钮
@property (nonatomic, strong) UIButton *goodsBtn;
//直播组头部信息
@property (nonatomic, strong) UIImageView *avatorImgV;
@property (nonatomic, strong) UIButton *shareBtn;

@end

@implementation WMPlayer

/**
 *  storyboard、xib的初始化方法
 */
- (void)awakeFromNib
{
    [self initWMPlayer];
    [super awakeFromNib];
}
/**
 *  initWithFrame的初始化方法
 */
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initWMPlayer];
    }
    return self;
}

/**
 *  初始化WMPlayer的控件，添加手势，添加通知，添加kvo等
 */
-(void)initWMPlayer{
    
    [self setAutoresizesSubviews:NO];

    //wmplayer内部的一个view，用来管理子视图
    self.contentView = [[UIView alloc]init];
    self.contentView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
#if 0
    //创建fastForwardView
    [self creatFF_View];
    [[UIApplication sharedApplication].keyWindow addSubview:[WMLightView sharedLightView]];
    //设置默认值
    self.seekTime = 0.00;
    self.enableVolumeGesture = YES;
#endif
    
    //小菊花
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    UIActivityIndicatorViewStyleWhiteLarge 的尺寸是（37，37）
//    UIActivityIndicatorViewStyleWhite 的尺寸是（22，22）
    [self.contentView addSubview:self.loadingView];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
    [self.loadingView startAnimating];

    //topView
    self.topView = [[UIImageView alloc]init];
    self.topView.image = WMPlayerImage(@"top_shadow");
    self.topView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(0);
        make.height.mas_equalTo(70);
        make.top.equalTo(self.contentView).with.offset(0);
    }];
    
    //bottomView
    self.bottomView = [[UIImageView alloc]init];
    self.bottomView.image = WMPlayerImage(@"bottom_shadow");
    self.bottomView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(0);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.contentView).with.offset(0);
    }];
    
    //GoodsBtn
    self.goodsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goodsBtn.acceptEventInterval = .5f;
    self.goodsBtn.showsTouchWhenHighlighted = YES;
    [self.goodsBtn setImage:IMAGE(@"homepage_live_button_cart") forState:UIControlStateNormal];
    [self.goodsBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.goodsBtn];
    [self.goodsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).offset(-20);
        make.bottom.equalTo(self.bottomView).offset(-17);
        make.width.mas_equalTo(42);
        make.height.mas_equalTo(42);
    }];
    
    //_playOrPauseBtn
    self.playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playOrPauseBtn.acceptEventInterval = .5f;
    self.playOrPauseBtn.showsTouchWhenHighlighted = YES;
    [self.playOrPauseBtn addTarget:self action:@selector(PlayOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [self.playOrPauseBtn setImage:IMAGE(@"homepage_live_button_play") forState:UIControlStateNormal];
    [self.playOrPauseBtn setImage:IMAGE(@"homepage_live_button_pause") forState:UIControlStateSelected];
    [self.bottomView addSubview:self.playOrPauseBtn];
    self.playOrPauseBtn.selected = YES;//默认状态，即默认是不自动播放
    [self.playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).with.offset(15);
        make.centerY.equalTo(self.goodsBtn.mas_centerY);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(35);
    }];
    
    //slider
    self.progressSlider = [[UISlider alloc]init];
    self.progressSlider.minimumValue = 0.0;
    [self.progressSlider setThumbImage:WMPlayerImage(@"dot")  forState:UIControlStateNormal];
    self.progressSlider.minimumTrackTintColor = [Color colorWithHex:@"#E4393C"];
    self.progressSlider.maximumTrackTintColor = [UIColor clearColor];
    self.progressSlider.value = 0.0;//指定初始值
    //进度条的拖拽事件
    [self.progressSlider addTarget:self action:@selector(stratDragSlide:)  forControlEvents:UIControlEventValueChanged];
    //进度条的点击事件
    [self.progressSlider addTarget:self action:@selector(updateProgress:) forControlEvents:UIControlEventTouchUpInside];
    //给进度条添加单击手势
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGesture:)];
    self.tap.delegate = self;
    [self.progressSlider addGestureRecognizer:self.tap];
    [self.bottomView addSubview:self.progressSlider];
    self.progressSlider.backgroundColor = [UIColor clearColor];
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playOrPauseBtn.mas_right).offset(15);
        make.right.equalTo(self.goodsBtn.mas_left).offset(-20);
        make.centerY.equalTo(self.goodsBtn.mas_centerY);
        make.height.mas_equalTo(3);
    }];
    
    //缓存进度条
    self.loadingProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.loadingProgress.progressTintColor = [UIColor clearColor];
    self.loadingProgress.trackTintColor    = [Color colorWithHex:@"#FEFEFE"];
    [self.loadingProgress setProgress:0.0 animated:NO];
    [self.bottomView addSubview:self.loadingProgress];
    [self.loadingProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.progressSlider).insets(UIEdgeInsetsMake(1, 0, 0, 0));
    }];
    [self.bottomView sendSubviewToBack:self.loadingProgress];
    
    //时间
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.textColor = [Color colorWithHex:@"#FEFEFE"];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    self.timeLabel.text = @"0.0/0.0";
    [self.bottomView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressSlider.mas_bottom).offset(8);
        make.right.equalTo(self.progressSlider.mas_right);
    }];

    //关闭按钮
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeBtn.acceptEventInterval = .5f;
    self.closeBtn.showsTouchWhenHighlighted = YES;
    [self.closeBtn setImage:IMAGE(@"homepage_live_close") forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(colseTheVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(self).with.offset(20);
    }];
    
    //分享按钮
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareBtn.acceptEventInterval = .5f;
    self.shareBtn.showsTouchWhenHighlighted = YES;
//    [self.shareBtn setImage:IMAGE(@"productdetails_icon_share") forState:UIControlStateNormal];
    [self.shareBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.shareBtn];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.closeBtn.mas_centerY);
        make.right.equalTo(self.closeBtn.mas_left).offset(-20);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    
    //直播组信息背景图
    self.topGroupInfoImgV = [UIImageView new];
    self.topGroupInfoImgV.layer.cornerRadius = 17.f;
    self.topGroupInfoImgV.clipsToBounds = YES;
    self.topGroupInfoImgV.backgroundColor = [UIColor blackColor];
    self.topGroupInfoImgV.alpha = .5f;
    [self.topView addSubview:self.topGroupInfoImgV];
    [self.topGroupInfoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).offset(15);
        make.centerY.equalTo(self.closeBtn.mas_centerY);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(34);
    }];
    
    // 头像
    self.avatorImgV = [UIImageView new];
    self.avatorImgV.layer.cornerRadius = 15.5f;
    self.avatorImgV.clipsToBounds = YES;
    self.avatorImgV.userInteractionEnabled = YES;
    [self.topView addSubview:self.avatorImgV];
    UITapGestureRecognizer *avatorTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeAboutLivingStoreInfo:)];
    [self.avatorImgV addGestureRecognizer:avatorTap];
    [self.avatorImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topGroupInfoImgV.mas_centerY);
        make.left.equalTo(self.topGroupInfoImgV.mas_left).offset(2);
        make.width.mas_equalTo(31);
        make.height.mas_equalTo(31);
    }];
    
    //titleLabel
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [Color colorWithHex:@"#FEFEFE"];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [self.topView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topGroupInfoImgV.mas_centerY);
        make.left.equalTo(self.avatorImgV.mas_right).offset(6);
    }];
    
    self.followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.followBtn.acceptEventInterval = .5f;
    self.followBtn.showsTouchWhenHighlighted = YES;
    [self.followBtn setImage:IMAGE(@"homepage_live_button_follow") forState:UIControlStateNormal];
    [self.followBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.followBtn];
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topGroupInfoImgV.mas_centerY);
        make.left.equalTo(self.titleLabel.mas_right).offset(6);
    }];
    
    //VolumeView
    MPVolumeView *volumeView = [[MPVolumeView alloc]init];
    for (UIControl *view in volumeView.subviews) {
        if ([view.superclass isSubclassOfClass:[UISlider class]]) {
            self.volumeSlider = (UISlider *)view;
        }
    }
    
    // 单击的 Recognizer
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.numberOfTapsRequired = 1; // 单击
    singleTap.numberOfTouchesRequired = 1;
    [self.contentView addGestureRecognizer:singleTap];
    
    // 双击的 Recognizer
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTouchesRequired = 1; //手指数
    doubleTap.numberOfTapsRequired = 2; // 双击
    // 解决点击当前view时候响应其他控件事件
    [singleTap setDelaysTouchesBegan:YES];
    [doubleTap setDelaysTouchesBegan:YES];
    [singleTap requireGestureRecognizerToFail:doubleTap];//如果双击成立，则取消单击手势（双击的时候不回走单击事件）
    [self.contentView addGestureRecognizer:doubleTap];
    
    // 监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appwillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];    
}
#pragma mark
#pragma mark lazy 加载失败的label
-(UILabel *)loadFailedLabel{
    if (_loadFailedLabel==nil) {
        _loadFailedLabel = [[UILabel alloc]init];
        _loadFailedLabel.backgroundColor = [UIColor clearColor];
        _loadFailedLabel.textColor = [UIColor whiteColor];
        _loadFailedLabel.textAlignment = NSTextAlignmentCenter;
        _loadFailedLabel.text = @"视频加载失败";
        _loadFailedLabel.hidden = YES;
        [self.contentView addSubview:_loadFailedLabel];

        [_loadFailedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.width.equalTo(self.contentView);
            make.height.equalTo(@30);

        }];
    }
    return _loadFailedLabel;
}
#pragma mark
#pragma mark 进入后台
- (void)appDidEnterBackground:(NSNotification*)note
{
    if (self.playOrPauseBtn.isSelected==NO) {//如果是播放中，则继续播放
        NSArray *tracks = [self.currentItem tracks];
        for (AVPlayerItemTrack *playerItemTrack in tracks) {
            if ([playerItemTrack.assetTrack hasMediaCharacteristic:AVMediaCharacteristicVisual]) {
                playerItemTrack.enabled = YES;
            }
        }
        self.playerLayer.player = nil;
        [self.player play];
        NSLog(@"22222 %s WMPlayerStatePlaying",__FUNCTION__);

        self.state = WMPlayerStatePlaying;
    }else{
        NSLog(@"%s WMPlayerStateStopped",__FUNCTION__);
        self.state = WMPlayerStateStopped;
    }
}
#pragma mark 
#pragma mark 进入前台
- (void)appWillEnterForeground:(NSNotification*)note
{
    if (self.playOrPauseBtn.isSelected==NO) {//如果是播放中，则继续播放
        NSArray *tracks = [self.currentItem tracks];
        for (AVPlayerItemTrack *playerItemTrack in tracks) {
            if ([playerItemTrack.assetTrack hasMediaCharacteristic:AVMediaCharacteristicVisual]) {
                playerItemTrack.enabled = YES;
            }
        }
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.frame = self.contentView.bounds;
        self.playerLayer.videoGravity = AVLayerVideoGravityResize;
        [self.contentView.layer insertSublayer:_playerLayer atIndex:0];
        [self.player play];
        self.state = WMPlayerStatePlaying;
        NSLog(@"3333333%s WMPlayerStatePlaying",__FUNCTION__);

    }else{
        NSLog(@"%s WMPlayerStateStopped",__FUNCTION__);

        self.state = WMPlayerStateStopped;
    }
}
#pragma mark
#pragma mark appwillResignActive
- (void)appwillResignActive:(NSNotification *)note
{
    NSLog(@"appwillResignActive");
}
- (void)appBecomeActive:(NSNotification *)note
{
    NSLog(@"appBecomeActive");
}
//视频进度条的点击事件
- (void)actionTapGesture:(UITapGestureRecognizer *)sender {
    CGPoint touchLocation = [sender locationInView:self.progressSlider];
    CGFloat value = (self.progressSlider.maximumValue - self.progressSlider.minimumValue) * (touchLocation.x/self.progressSlider.frame.size.width);
    [self.progressSlider setValue:value animated:YES];

    [self.player seekToTime:CMTimeMakeWithSeconds(self.progressSlider.value, self.currentItem.currentTime.timescale)];
    if (self.player.rate != 1.f) {
        if ([self currentTime] == [self duration])
            [self setCurrentTime:0.f];
        self.playOrPauseBtn.selected = NO;
        [self.player play];
    }
}

#pragma mark
#pragma mark - layoutSubviews
-(void)layoutSubviews{
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}

#pragma mark
#pragma mark - 关闭按钮点击func
-(void)colseTheVideo:(UIButton *)sender{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(wmplayer:clickedCloseButton:)]) {
        [self.delegate wmplayer:self clickedCloseButton:sender];
    }
}
///获取视频长度
- (double)duration{
    AVPlayerItem *playerItem = self.player.currentItem;
    if (playerItem.status == AVPlayerItemStatusReadyToPlay){
        return CMTimeGetSeconds([[playerItem asset] duration]);
    }
    else{
        return 0.f;
    }
}
///获取视频当前播放的时间
- (double)currentTime{
    if (self.player) {
        return CMTimeGetSeconds([self.player currentTime]);
    }else{
        return 0.0;
    }
}

- (void)setCurrentTime:(double)time{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.player seekToTime:CMTimeMakeWithSeconds(time, self.currentItem.currentTime.timescale)];

    });
}
#pragma mark
#pragma mark - PlayOrPause
- (void)PlayOrPause:(UIButton *)sender{
    if (self.state ==WMPlayerStateStopped||self.state==WMPlayerStateFailed) {
        [self play];
    } else if(self.state ==WMPlayerStatePlaying){
        [self pause];
    }else if(self.state ==WMPlayerStateFinished){
        NSLog(@"ggggg");
        self.state = WMPlayerStatePlaying;
        [self.player play];
        self.playOrPauseBtn.selected = NO;
    }
    if ([self.delegate respondsToSelector:@selector(wmplayer:clickedPlayOrPauseButton:)]) {
        [self.delegate wmplayer:self clickedPlayOrPauseButton:sender];
    }
}
///播放
-(void)play{
    if (self.isInitPlayer == NO) {
        self.isInitPlayer = YES;
        [self creatWMPlayerAndReadyToPlay];
        [self.player play];
        self.playOrPauseBtn.selected = NO;
    }else{
        if (self.state==WMPlayerStateStopped||self.state ==WMPlayerStatePause) {
            self.state = WMPlayerStatePlaying;
            [self.player play];
            self.playOrPauseBtn.selected = NO;
        }else if(self.state ==WMPlayerStateFinished){
            NSLog(@"fffff");
        }
    }
}
///暂停
-(void)pause{
    if (self.state==WMPlayerStatePlaying) {
        self.state = WMPlayerStateStopped;
    }
    [self.player pause];
    self.playOrPauseBtn.selected = YES;
}

#pragma mark
#pragma mark - 单击手势方法
- (void)handleSingleTap:(UITapGestureRecognizer *)sender{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(wmplayer:singleTaped:)]) {
        [self.delegate wmplayer:self singleTaped:sender];
    }
}

#pragma mark
#pragma mark - 双击手势方法
- (void)handleDoubleTap:(UITapGestureRecognizer *)doubleTap{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(wmplayer:doubleTaped:)]) {
        [self.delegate wmplayer:self doubleTaped:doubleTap];
    }
    [self PlayOrPause:self.playOrPauseBtn];
}
/**
 *  重写playerItem的setter方法，处理自己的逻辑
 */
-(void)setCurrentItem:(AVPlayerItem *)playerItem{
    if (_currentItem==playerItem) {
        return;
    }
    if (_currentItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_currentItem];
        [_currentItem removeObserver:self forKeyPath:@"status"];
        [_currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [_currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
        _currentItem = nil;
    }
    _currentItem = playerItem;
    if (_currentItem) {
        [_currentItem addObserver:self
                           forKeyPath:@"status"
                              options:NSKeyValueObservingOptionNew
                              context:PlayViewStatusObservationContext];
        
        [_currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
        // 缓冲区空了，需要等待数据
        [_currentItem addObserver:self forKeyPath:@"playbackBufferEmpty" options: NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
        // 缓冲区有足够数据可以播放了
        [_currentItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options: NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
        
        [self.player replaceCurrentItemWithPlayerItem:_currentItem];
        // 添加视频播放结束通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_currentItem];
    }
}
/**
 *  重写placeholderImage的setter方法，处理自己的逻辑
 */
- (void)setPlaceholderImage:(UIImage *)placeholderImage
{
    _placeholderImage = placeholderImage;
    if (placeholderImage) {
        self.contentView.layer.contents = (id) self.placeholderImage.CGImage;
    } else {
        UIImage *image = WMPlayerImage(@"");
        self.contentView.layer.contents = (id) image.CGImage;
    }
}

-(void)creatWMPlayerAndReadyToPlay{
    //设置player的参数
    self.currentItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.URLString]];
    
    self.player = [AVPlayer playerWithPlayerItem:_currentItem];
    self.player.usesExternalPlaybackWhileExternalScreenIsActive=YES;
    //AVPlayerLayer
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.contentView.layer.bounds;
    //WMPlayer视频的默认填充模式，AVLayerVideoGravityResizeAspect
    self.playerLayer.videoGravity = AVLayerVideoGravityResize;
    [self.contentView.layer insertSublayer:_playerLayer atIndex:0];
    self.state = WMPlayerStateBuffering;
}
/**
 *  重写URLString的setter方法，处理自己的逻辑，
 */
- (void)setURLString:(NSString *)URLString{
    if (_URLString==URLString) {
        return;
    }
    _URLString = URLString;

    if (self.isInitPlayer) {
        self.state = WMPlayerStateBuffering;
    }else{
        self.state = WMPlayerStateStopped;
        //here
        [self.loadingView stopAnimating];
    }
    
    if (!self.placeholderImage) {//开发者可以在此处设置背景图片
        UIImage *image = WMPlayerImage(@"");
        self.contentView.layer.contents = (id) image.CGImage;
    }
}
/**
 *  设置播放的状态
 *  @param state WMPlayerState
 */
- (void)setState:(WMPlayerState)state
{
    _state = state;
    // 控制菊花显示、隐藏
    if (state == WMPlayerStateBuffering) {
        [self.loadingView startAnimating];
    }else if(state == WMPlayerStatePlaying){
        //here
        [self.loadingView stopAnimating];//
    }else if(state == WMPlayerStatePause){
        //here
        [self.loadingView stopAnimating];//
    }
    else{
        //here
        [self.loadingView stopAnimating];//
    }
}
/**
 *  数据setter方法
 */
- (void)setDataModel:(PlayerViewModel *)dataModel
{
    self.titleLabel.text = dataModel.name;
    [self.avatorImgV sd_setImageWithURL:[NSURL URLWithString:dataModel.avator] placeholderImage:YPCImagePlaceHolder];
    self.goodsBtn.badgeValue = dataModel.goodsCount;
    if ([dataModel.isfollowSeller isEqualToString:@"0"]) {
        self.followBtn.hidden = NO;
        [self.topGroupInfoImgV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100 + self.titleLabel.width);
        }];
    }else if ([dataModel.isfollowSeller isEqualToString:@"1"]) {
        self.followBtn.hidden = YES;
        [self.topGroupInfoImgV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(52 + self.titleLabel.width);
        }];
    }
}

/**
 *  通过颜色来生成一个纯色图片
 */
- (UIImage *)buttonImageFromColor:(UIColor *)color{
    
    CGRect rect = self.bounds;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); return img;
}

#pragma mark
#pragma mark--播放完成
- (void)moviePlayDidEnd:(NSNotification *)notification {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(wmplayerFinishedPlay:)]) {
        [self.delegate wmplayerFinishedPlay:self];
    }
    [self.player seekToTime:kCMTimeZero toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        if (finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.state = WMPlayerStateFinished;
                self.playOrPauseBtn.selected = YES;
            });
        }
    }];
}
#pragma mark
#pragma mark--开始拖曳sidle
- (void)stratDragSlide:(UISlider *)slider{
    self.isDragingSlider = YES;
}
#pragma mark
#pragma mark - 播放进度
- (void)updateProgress:(UISlider *)slider{
    self.isDragingSlider = NO;
    [self.player seekToTime:CMTimeMakeWithSeconds(slider.value, _currentItem.currentTime.timescale)];
}
#pragma mark
#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    /* AVPlayerItem "status" property value observer. */

    if (context == PlayViewStatusObservationContext)
    {
        if ([keyPath isEqualToString:@"status"]) {
            AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
            switch (status)
            {
                    /* Indicates that the status of the player is not yet known because
                     it has not tried to load new media resources for playback */
                case AVPlayerStatusUnknown:
                {
                    [self.loadingProgress setProgress:0.0 animated:NO];
                    NSLog(@"%s WMPlayerStateBuffering",__FUNCTION__);

                    self.state = WMPlayerStateBuffering;
                    [self.loadingView startAnimating];
                }
                    break;
                    
                case AVPlayerStatusReadyToPlay:
                {
                    self.state = WMPlayerStatePlaying;

                      /* Once the AVPlayerItem becomes ready to play, i.e.
                     [playerItem status] == AVPlayerItemStatusReadyToPlay,
                     its duration can be fetched from the item. */
                    if (CMTimeGetSeconds(_currentItem.duration)) {
                        
                        totalTime = CMTimeGetSeconds(_currentItem.duration);
                        if (!isnan(totalTime)) {
                            self.progressSlider.maximumValue = totalTime;
                            NSLog(@"totalTime = %f",totalTime);
                        }
                    }
                    //监听播放状态
                    [self initTimer];
                    
                    if (self.delegate&&[self.delegate respondsToSelector:@selector(wmplayerReadyToPlay:WMPlayerStatus:)]) {
                        [self.delegate wmplayerReadyToPlay:self WMPlayerStatus:WMPlayerStatePlaying];
                    }
                    //here

                    [self.loadingView stopAnimating];
                    // 跳到xx秒播放视频
                    if (self.seekTime) {
                        [self seekToTimeToPlay:self.seekTime];
                    }
                    
                }
                    break;
                    
                case AVPlayerStatusFailed:
                {
                    self.state = WMPlayerStateFailed;
                    NSLog(@"%s WMPlayerStateFailed",__FUNCTION__);

                    if (self.delegate&&[self.delegate respondsToSelector:@selector(wmplayerFailedPlay:WMPlayerStatus:)]) {
                        [self.delegate wmplayerFailedPlay:self WMPlayerStatus:WMPlayerStateFailed];
                    }
                    NSError *error = [self.player.currentItem error];
                    if (error) {
                        self.loadFailedLabel.hidden = NO;
                        [self bringSubviewToFront:self.loadFailedLabel];
                        //here
                        [self.loadingView stopAnimating];
                    }
                    NSLog(@"视频加载失败===%@",error.description);
                }
                    break;
            }

        }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            
            // 计算缓冲进度
            NSTimeInterval timeInterval = [self availableDuration];
            CMTime duration             = self.currentItem.duration;
            CGFloat totalDuration       = CMTimeGetSeconds(duration);
            //缓冲颜色
            self.loadingProgress.progressTintColor = [Color colorWithHex:@"#F6C3C3"];
            [self.loadingProgress setProgress:timeInterval / totalDuration animated:NO];
            
            
        } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            [self.loadingView startAnimating];
            // 当缓冲是空的时候
            if (self.currentItem.playbackBufferEmpty) {
                self.state = WMPlayerStateBuffering;
                NSLog(@"%s WMPlayerStateBuffering",__FUNCTION__);

                [self loadedTimeRanges];
            }
            
        } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            //here
            [self.loadingView stopAnimating];
            // 当缓冲好的时候
            if (self.currentItem.playbackLikelyToKeepUp && self.state == WMPlayerStateBuffering){
                NSLog(@"55555%s WMPlayerStatePlaying",__FUNCTION__);

                self.state = WMPlayerStatePlaying;
            }
            
        }
    }

}
/**
 *  缓冲回调
 */
- (void)loadedTimeRanges
{
    self.state = WMPlayerStateBuffering;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self play];
        //here
        [self.loadingView stopAnimating];
    });
}

#pragma  mark - 定时器
-(void)initTimer{
    double interval = .1f;
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration))
    {
        return;
    }
    long long nowTime = _currentItem.currentTime.value/_currentItem.currentTime.timescale;
        CGFloat width = CGRectGetWidth([self.progressSlider bounds]);
        interval = 0.5f * nowTime / width;
    __weak typeof(self) weakSelf = self;
    self.playbackTimeObserver =  [weakSelf.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0, NSEC_PER_SEC)  queue:dispatch_get_main_queue() /* If you pass NULL, the main queue is used. */
        usingBlock:^(CMTime time){
        [weakSelf syncScrubber];
    }];
    
}
- (void)syncScrubber{
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration)){
        self.progressSlider.minimumValue = 0.0;
        return;
    }
        float minValue = [self.progressSlider minimumValue];
        float maxValue = [self.progressSlider maximumValue];
        long long nowTime = _currentItem.currentTime.value/_currentItem.currentTime.timescale;
        self.timeLabel.text = [NSString stringWithFormat:@"%@/%@", [self convertTime:nowTime], [self convertTime:totalTime]];
        if (self.isDragingSlider==YES) {//拖拽slider中，不更新slider的值
            
        }else if(self.isDragingSlider==NO){
            [self.progressSlider setValue:(maxValue - minValue) * nowTime / totalTime + minValue];
        }
}
/**
 *  跳到time处播放
 *  @ param seek_Time这个时刻，这个时间点
 */
- (void)seekToTimeToPlay:(double)time{
    if (self.player&&self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        if (time>=totalTime) {
            time = 0.0;
        }
        if (time<0) {
            time=0.0;
        }
//        int32_t timeScale = self.player.currentItem.asset.duration.timescale;
        //currentItem.asset.duration.timescale计算的时候严重堵塞主线程，慎用
        /* A timescale of 1 means you can only specify whole seconds to seek to. The timescale is the number of parts per second. Use 600 for video, as Apple recommends, since it is a product of the common video frame rates like 50, 60, 25 and 24 frames per second*/

        [self.player seekToTime:CMTimeMakeWithSeconds(time, _currentItem.currentTime.timescale) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            
        }];
        
        
    }
}
- (CMTime)playerItemDuration{
    AVPlayerItem *playerItem = _currentItem;
    if (playerItem.status == AVPlayerItemStatusReadyToPlay){
        return([playerItem duration]);
    }
    return(kCMTimeInvalid);
}
- (NSString *)convertTime:(float)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [[self dateFormatter] setDateFormat:@"HH:mm:ss"];
    } else {
        [[self dateFormatter] setDateFormat:@"mm:ss"];
    }
    return [[self dateFormatter] stringFromDate:d];
}
/**
 *  计算缓冲进度
 *
 *  @return 缓冲进度
 */
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [_currentItem loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    }
    return _dateFormatter;
}

#pragma mark - touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.playerIsOnWindow) {
        [super touchesBegan:touches withEvent:event];
        _hasMoved = NO;
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:Window];
        if (CGRectContainsPoint(self.frame, point)) {
            _hasMoved = YES;
        }
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.playerIsOnWindow) {
        if (!_hasMoved) {
            return;
        }
        UITouch * touch = (UITouch *)touches.anyObject;
        CGPoint point = [touch locationInView:Window];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(Window.mas_right).offset(point.x - ScreenWidth);
            make.bottom.equalTo(Window.mas_bottom).offset(point.y - ScreenHeight + 69 < 0 ? point.y - ScreenHeight + 69 : 0);
        }];
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.playerIsOnWindow) {
        if (!_hasMoved) {
            return;
        }
        UITouch * touch = (UITouch *)touches.anyObject;
        CGPoint point = [touch locationInView:Window];
        if (point.x > ScreenWidth / 2 + self.width / 2) {
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(Window.mas_right).offset(0);
            }];
        }else {
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(Window.mas_right).offset(-ScreenWidth + self.width);
            }];
        }
    }
}

//重置播放器
-(void )resetWMPlayer{
    self.currentItem = nil;
    self.seekTime = 0;
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 暂停
    [self.player pause];
    // 移除原来的layer
    [self.playerLayer removeFromSuperlayer];
    // 替换PlayerItem为nil
    [self.player replaceCurrentItemWithPlayerItem:nil];
    // 把player置为nil
    self.player = nil;
}
-(void)dealloc{
    for (UIView *aLightView in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([aLightView isKindOfClass:[WMLightView class]]) {
            [aLightView removeFromSuperview];
        }
    }
    NSLog(@"WMPlayer dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    [self.player pause];
    [self.player removeTimeObserver:self.playbackTimeObserver];
    
    //移除观察者
    [_currentItem removeObserver:self forKeyPath:@"status"];
    [_currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [_currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [_currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];

    [self.effectView removeFromSuperview];
    self.effectView = nil;
    [self.playerLayer removeFromSuperlayer];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.player = nil;
    self.currentItem = nil;
    self.playOrPauseBtn = nil;
    self.playerLayer = nil;
}

//获取当前的旋转状态
+(CGAffineTransform)getCurrentDeviceOrientation{
    //状态条的方向已经设置过,所以这个就是你想要旋转的方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    //根据要进行旋转的方向来计算旋转的角度
    if (orientation ==UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    }else if (orientation ==UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    }else if(orientation ==UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}

- (void)buttonClickAction:(UIButton *)sender
{
    if (sender == self.shareBtn) {
        self.ButtonClickedBlock(@"share");
    }else if (sender == self.goodsBtn) {
        self.ButtonClickedBlock(@"seeGoods");
    }else if (sender == self.followBtn) {
        self.ButtonClickedBlock(@"follow");
    }
}

- (void)seeAboutLivingStoreInfo:(UITapGestureRecognizer *)tap
{
    self.ButtonClickedBlock(@"seeAbout");
}



@end
