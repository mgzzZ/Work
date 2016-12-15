/*
 ***************************************************************************
 * 建立日期	： 2016-07-26
 * 版权声明	： 本代码版权归圣笛科技所有，禁止任何未授权的传播和使用
 * 作者		： yanjiaming@sainti.com
 * 模块		：
 * 描述		： 引导页面的VC控制器，采用单例创建
 * -------------------------------------------------------------------------
 * 修改历史
 * 序号			日期					修改人				修改原因
 * <#序号#>        <#日期#>                <#修改人#>              <#修改原因#>
 *
 ***************************************************************************
 */

#import "YJMGuideViewManager.h"
#import "YJMGuideView.h"

@interface YJMGuideViewManager()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UICollectionView *view;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) UIColor *buttonBgColor;
@property (nonatomic, assign) UIColor *buttonBorderColor;
@property (nonatomic, assign) UIColor *titleColor;
@property (nonatomic, copy  ) NSString *buttonTitle;

@end

@implementation YJMGuideViewManager

+ (instancetype)sharedInstance {
    static YJMGuideViewManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YJMGuideViewManager alloc]init];
    });
    return instance;
}

/*
 方法描述:
 引导页界面
 
 参数说明:
 <#参数说明#>
 
 返回结果:
 <#返回结果#>
 
 */
- (UICollectionView *)view {
    if (!_view) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = kScreen.size;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _view = [[UICollectionView alloc] initWithFrame:kScreen collectionViewLayout:layout];
        _view.bounces = NO;
        _view.backgroundColor = [UIColor whiteColor];
        _view.showsHorizontalScrollIndicator = NO;
        _view.showsVerticalScrollIndicator = NO;
        _view.pagingEnabled = YES;
        _view.dataSource = self;
        _view.delegate = self;
        
        [_view registerClass:[YJMGuideViewCell class] forCellWithReuseIdentifier:kCellIdentifier_HcdGuideViewCell];
    }
    return _view;
}

/*
 方法描述:
 初始化pageControl
 
 参数说明:
 <#参数说明#>
 
 返回结果:
 <#返回结果#>
 
 */
- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectMake(0, 0, kScreen.size.width, 44.0f);
        _pageControl.center = CGPointMake(ScreenWidth / 2, ScreenHeight - 60);
    }
    return _pageControl;
}

- (void)showGuideViewWithImages:(NSArray *)images
                 andButtonTitle:(NSString *)title
            andButtonTitleColor:(UIColor *)titleColor
               andButtonBGColor:(UIColor *)bgColor
           andButtonBorderColor:(UIColor *)borderColor {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *version = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    //根据版本号来判断是否需要显示引导页，一般来说每更新一个版本引导页都会有相应的修改
    BOOL show = [userDefaults boolForKey:[NSString stringWithFormat:@"version_%@", version]];
    
    if (!show && nil == self.window) {
        self.images = images;
        self.buttonBorderColor = borderColor;
        self.buttonBgColor = bgColor;
        self.buttonTitle = title;
        self.titleColor = titleColor;
        self.pageControl.numberOfPages = 0;
        self.window = [UIApplication sharedApplication].keyWindow;
        [self.window addSubview:self.view];
//        [self.window addSubview:self.pageControl];
        
        [userDefaults setBool:YES forKey:[NSString stringWithFormat:@"version_%@", version]];
        [userDefaults synchronize];
    }
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YJMGuideViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_HcdGuideViewCell forIndexPath:indexPath];
    
    UIImage *img = [self.images objectAtIndex:indexPath.row];
    CGSize size = [self adapterSizeImageSize:img.size compareSize:kScreen.size];
    
    //自适应图片位置,图片可以是任意尺寸,会自动缩放.
    cell.imageView.frame = CGRectMake(0, 0, size.width, size.height);
    cell.imageView.image = img;
    cell.imageView.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
    
    if (indexPath.row == self.images.count - 1) {
        [cell.button setHidden:NO];
        [cell.button addTarget:self action:@selector(nextButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button setBackgroundColor:self.buttonBgColor];
        [cell.button setTitle:self.buttonTitle forState:UIControlStateNormal];
        [cell.button.titleLabel setTextColor:self.titleColor];
        cell.button.layer.borderColor = [self.buttonBorderColor CGColor];
    } else {
        [cell.button setHidden:YES];
    }
    
    return cell;
}

/**
 *  计算自适应的图片
 *
 *  @param is 需要适应的尺寸
 *  @param cs 适应到的尺寸
 *
 *  @return 适应后的尺寸
 */
- (CGSize)adapterSizeImageSize:(CGSize)is compareSize:(CGSize)cs
{
    CGFloat w = cs.width;
    CGFloat h = cs.width / is.width * is.height;
    
    if (h < cs.height) {
        w = cs.height / h * w;
        h = cs.height;
    }
    return CGSizeMake(w, h);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.pageControl.currentPage = (scrollView.contentOffset.x / ScreenWidth);
}

/*
 方法描述:
 点击立即体验按钮响应事件
 
 参数说明:
 <#参数说明#>
 
 返回结果:
 <#返回结果#>
 
 */
- (void)nextButtonHandler:(id)sender {
    
    [self.view removeFromSuperview];
    [self setWindow:nil];
    [self setView:nil];
    [self setPageControl:nil];
}

@end
