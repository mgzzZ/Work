//
//  JPVideoPlayer.m
//  JPVideoPlayer
//
//  Created by lava on 16/9/13.
//  Hello! I am NewPan from Guangzhou of China, Glad you could use my framework, If you have any question or wanna to contact me, please open https://github.com/Chris-Pan or http://www.jianshu.com/users/e2f2d779c022/latest_articles

#import "JPVideoPlayer.h"
#import "JPVideoURLAssetResourceLoader.h"
#import "JPDownloadManager.h"
#import "JPVideoCachePathTool.h"
#import "UIView+JPObserveDealloc.h"

@interface JPVideoPlayer()<JPVideoURLAssetResourceLoaderDelegate>

/**
 * Video data provider
 * 数据源
 */
@property(nonatomic, strong)JPVideoURLAssetResourceLoader *resourceLoader;

/** asset */
@property(nonatomic, strong)AVURLAsset *videoURLAsset;

/**
 * The Item of playing video
 * 当前正在播放视频的Item
 */
@property (nonatomic, strong)AVPlayerItem *currentPlayerItem;

/**
 * The current picture player
 * 当前图像层
 */
@property (nonatomic, strong)AVPlayerLayer *currentPlayerLayer;

/**
 * The view of video will play on
 * 视频图像载体View
 */
@property (nonatomic, weak)UIView *showView;

/** 
 * The hash value of showView
 * showView的hash值
 */
@property(nonatomic, assign)NSUInteger showViewHash;

/**
 * video url
 * 播放视频url
 */
@property(nonatomic, strong)NSURL *playPathURL;

/**
 * player
 */
@property(nonatomic, strong)AVPlayer *player;

/**
 * Is self observer the notification
 * 是否添加了监听
 */
@property(nonatomic, assign)BOOL isAddObserver;

@property (nonatomic, strong) UIImageView *videoPHView;

@end


@implementation JPVideoPlayer

#pragma mark --------------------------------------------------
#pragma mark INITIALIZER

+(instancetype)sharedInstance{
    return [[self alloc]init];
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static id _shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [super allocWithZone:zone];
    });
    return _shareInstance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _stopWhenAppDidEnterBackground = YES;
        
        // Avoid notification center add self as observer again and again that lead to block.
        // 避免重复添加监听导致监听方法被重复调起, 导致的卡顿. 感谢简书@菜先生 http://www.jianshu.com/users/475fdcde8924/latest_articles提醒
        [self addObserverOnce];
        
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (UIImageView *)videoPHView
{
    if (_videoPHView) {
        return _videoPHView;
    }
    _videoPHView = [UIImageView new];
    _videoPHView.animationImages = [NSArray arrayWithObjects:
                                    IMAGE(@"s10"),
                                    IMAGE(@"s9"),
                                    IMAGE(@"s8"),
                                    IMAGE(@"s7"),
                                    IMAGE(@"s6"),
                                    IMAGE(@"s5"),
                                    IMAGE(@"s4"),
                                    IMAGE(@"s3"),
                                    IMAGE(@"s2"),
                                    IMAGE(@"s1")
                                    , nil];
    _videoPHView.frame = CGRectMake(ScreenWidth / 2 - 40, self.showView.center.y - 40 - 82, 80, 80);
    _videoPHView.animationDuration = 1.f;
    _videoPHView.animationRepeatCount = 0;
    return _videoPHView;
}


#pragma mark --------------------------------------------------
#pragma mark Public

- (void)playWithUrl:(NSURL *)url showView:(UIView *)showView{
    
    self.playPathURL = url;
    _showView = showView;
    _showViewHash = [showView hash];
    _showView.isShowView = YES;
    
    // Release all configuration before.
    // 释放之前的配置
    [self stop];
    
    // Check is already exist cache of this file(url) or not.
    // If existed, we play video from disk.
    // If not exist, we request data from network.
    // 检查有没有缓存, 如果有缓存, 直接读取缓存文件, 如果没有缓存, 就去请求下载
    // 这里感谢简书作者 @老孟(http://www.jianshu.com/users/9f6960a40be6/timeline), 他帮我测试了多数的真机设备, 包括iPhone 5s 国行 系统9.3.5  iPhone 6plus 港行 系统10.0.2 iPhone 6s 国行 系统9.3.2  iPhone 6s plus 港行 系统10.0.0 iPhone 7plus 国行 系统10.1.1, 我之前由于手上设备有限, 只测试了 iPhone 6s 和 iPhone 6s plus, 但是 @老孟发 现在较旧设备上有卡顿的现象, 具体表现为播放本地已经缓存的视频的时候会出现2-3秒的假死, 其实是阻塞了主线程. 现在经过修改过后的版本修复了这个问题, 并且以上设备都测试通过, 没有出现卡顿情况.
    
    NSString *suggestFileName = [url.absoluteString lastPathComponent];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [JPVideoCachePathTool fileSavePath];
    path = [path stringByAppendingPathComponent:suggestFileName];
    if ([manager fileExistsAtPath:path]) {
        
        // Play video from disk.
        // 直接从本地读取数据进行播放
        
//        NSLog(@"File already existed, we play video from disk, 文件已存在, 从本地读取播放");
        
        NSURL *playPathURL = [NSURL fileURLWithPath:path];
        AVURLAsset *videoURLAsset = [AVURLAsset URLAssetWithURL:playPathURL options:nil];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:videoURLAsset];
        self.currentPlayerItem = playerItem;
        self.player = [AVPlayer playerWithPlayerItem:playerItem];
        self.currentPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.currentPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.currentPlayerLayer.frame = CGRectMake(0, 0, _showView.bounds.size.width, _showView.bounds.size.height);
        
        [self endLoading];
    }
    else{
      
        // Re-create all all configuration agian.
        // Make the "resourceLoader" become the delegate of "videoURLAsset", and provide data to the player.
        // 将播放器请求数据的代理设为缓存中间区
        
        JPVideoURLAssetResourceLoader *resourceLoader = [JPVideoURLAssetResourceLoader new];
        self.resourceLoader = resourceLoader;
        resourceLoader.delegate = self;
        NSURL *playUrl = [resourceLoader getSchemeVideoURL:url];
        AVURLAsset *videoURLAsset = [AVURLAsset URLAssetWithURL:playUrl options:nil];
        self.videoURLAsset = videoURLAsset;
        [self.videoURLAsset.resourceLoader setDelegate:resourceLoader queue:dispatch_get_main_queue()];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:videoURLAsset];
        self.currentPlayerItem = playerItem;
        
        self.player = [AVPlayer playerWithPlayerItem:playerItem];
        self.currentPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.currentPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.currentPlayerLayer.frame = CGRectMake(0, 0, showView.bounds.size.width, showView.bounds.size.height);
    }
}

- (void)resume{
    if (!self.currentPlayerItem) return;
    [self.player play];
}

- (void)pause{
    if (!self.currentPlayerItem) return;
    [self.player pause];
}

- (void)stop{
    if (!self.player) return;
    [self.player pause];
    [self.player cancelPendingPrerolls];
    if (self.currentPlayerLayer) {
        [self.currentPlayerLayer removeFromSuperlayer];
        self.currentPlayerLayer = nil;
    }
    [self.videoURLAsset.resourceLoader setDelegate:nil queue:dispatch_get_main_queue()];
    self.videoURLAsset = nil;
    self.currentPlayerItem = nil;
    self.player = nil;
    self.playPathURL = nil;
    [self.resourceLoader invalidDownload];
    self.resourceLoader = nil;
}

-(void)setMute:(BOOL)mute{
    _mute = mute;
    self.player.muted = mute;
}


#pragma mark -----------------------------------------
#pragma mark Observer

-(void)receiveMemoryWarning{
    NSLog(@"receiveMemoryWarning, 内存警告");
    [self stop];
}

- (void)appDidEnterBackground{
    if (self.stopWhenAppDidEnterBackground) {
        [self pause];
    }
}

- (void)appDidEnterPlayGround{
    [self resume];
}

- (void)playerItemDidPlayToEnd:(NSNotification *)notification{
    
    // Seek the start point of file data and repeat play, this handle have no Memory surge
    // 重复播放, 从起点开始重播, 没有内存暴涨
    
    __weak typeof(self) weak_self = self;
    [self.player seekToTime:CMTimeMake(0, 1) completionHandler:^(BOOL finished) {
        __strong typeof(weak_self) strong_self = weak_self;
        if (!strong_self) return;
        [strong_self.player play];
    }];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        AVPlayerItemStatus status = playerItem.status;
        switch (status) {
            case AVPlayerItemStatusUnknown:{
                [self startLoading];
            }
                break;
                
            case AVPlayerItemStatusReadyToPlay:{
                
                // 显示图像逻辑
                [self.player play];
                self.player.muted = self.mute;
                [self handleShowViewSublayers];
                [self endLoading];
            }
                break;
                
            case AVPlayerItemStatusFailed:{
                [self endLoading];
            }
                break;
            default:
                break;
        }
    }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) { // 监听播放器在缓冲数据的状态
        [self startLoading];
    }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        [self endLoading];
    }
}

- (void)startLoading
{
    [self.showView addSubview:self.videoPHView];
    self.videoPHView.hidden = NO;
    [self.videoPHView startAnimating];
}
- (void)endLoading
{
    self.videoPHView.hidden = YES;
    [self.videoPHView stopAnimating];
}


#pragma mark -----------------------------------------
#pragma mark Private

-(void)viewDealloc:(NSNotification *)note{
    
    UIView *deallocView = note.object;
    NSUInteger hash = [deallocView hash];
    if (hash == _showViewHash) {
        
        // The showView was dealloc, should stop play video right now.
        // 播放视频的view已经释放, 所以应该关闭视频播放
        
        self.showView = nil;
        [self stop];
    }
}

-(void)addObserverOnce{
    if (!_isAddObserver) {
      
        // Add observer.
        // 添加监听
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDealloc:) name:@"kViewDeallocNote" object:nil];
    }
    _isAddObserver = YES;
}

-(void)handleShowViewSublayers{
    
    // Here have a fade in animation
//    [UIView animateWithDuration:0.2 animations:^{
//        _showView.alpha = 0;
//    } completion:^(BOOL finished) {
        //        for (CALayer *layer in _showView.subviews) {
        //            if (![_showView.subviews isEqual:self.videoPHView]) {
        //                [layer removeFromSuperlayer];
        //            }else {
        //
        //            }
        //        }
//    [_showView.layer addSublayer:self.currentPlayerLayer];
    [_showView.layer insertSublayer:self.currentPlayerLayer atIndex:0];
//        [UIView animateWithDuration:0.2 animations:^{
//            _showView.alpha = 1;
//        } completion:nil];
//    }];
}

-(void)setCurrentPlayerItem:(AVPlayerItem *)currentPlayerItem{
    
    if (_currentPlayerItem) {
        [_currentPlayerItem removeObserver:self forKeyPath:@"status"];
        [_currentPlayerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_currentPlayerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [_currentPlayerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    }
    _currentPlayerItem = currentPlayerItem;
    
    [_currentPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [_currentPlayerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [_currentPlayerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [_currentPlayerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)setCurrentPlayerLayer:(AVPlayerLayer *)currentPlayerLayer{
    if (_currentPlayerLayer) {
        [_currentPlayerLayer removeFromSuperlayer];
    }
    _currentPlayerLayer = currentPlayerLayer;
}


#pragma mark -----------------------------------------
#pragma mark JPLoaderURLConnectionDelegate

-(void)didFailLoadingWithManager:(JPDownloadManager *)manager WithError:(NSError *)errorCode{
    
}

-(void)didFinishLoadingWithManager:(JPDownloadManager *)manager fileSavePath:(NSString *)filePath{
    NSLog(@"Download finished, 下载完成");
}


@end
