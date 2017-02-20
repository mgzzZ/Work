//
//  CCWebViewController.m
//  WebViewDemo
//
//  Created by XZC on 15/11/27.
//  Copyright (c) 2015年 MMC. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "WebViewController.h"

@interface WebViewController ()<UIActionSheetDelegate,WKNavigationDelegate, UINavigationControllerDelegate>
@property (assign, nonatomic) NSUInteger loadCount;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) WKWebView *wkWebView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = self.navTitle;
    
    [self configUI];
    [self configMenuItem];
}

- (void)configUI {
    
    // 进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    progressView.tintColor = [Color colorWithHex:@"#e4393c"];
    progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    wkWebView.backgroundColor = [UIColor whiteColor];
    wkWebView.navigationDelegate = self;
    [self.view insertSubview:wkWebView belowSubview:progressView];
    
    [wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_homeUrl]];
    [wkWebView loadRequest:request];
    self.wkWebView = wkWebView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:IMAGE(@"back_icon") forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self
               action:@selector(backBtnPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = editItem;
}

- (void)configMenuItem {
    
    // 导航栏的菜单按钮
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuBtn sizeToFit];
    [menuBtn setImage:IMAGE(@"homepage_img_germany") forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(menuBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    self.navigationItem.rightBarButtonItem = menuItem;
}

- (void)configColseItem {
    
    // 导航栏的关闭按钮
    UIButton *colseBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [colseBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [colseBtn setTitleColor:[Color colorWithHex:@"#fefefe"] forState:UIControlStateNormal];
    [colseBtn addTarget:self action:@selector(colseBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [colseBtn sizeToFit];
    
    UIBarButtonItem *colseItem = [[UIBarButtonItem alloc] initWithCustomView:colseBtn];
    NSMutableArray *newArr = [NSMutableArray arrayWithObjects:self.navigationItem.leftBarButtonItem,colseItem, nil];
    self.navigationItem.leftBarButtonItems = newArr;
}

#pragma mark - 普通按钮事件

// 返回按钮点击
- (void)backBtnPressed:(id)sender {
    if (self.wkWebView.canGoBack) {
        [self.wkWebView goBack];
        if (self.navigationItem.leftBarButtonItems.count == 1) {
            [self configColseItem];
        }
    }else {
        self.navigationItem.hidesBackButton = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 菜单按钮点击
- (void)menuBtnPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"safari打开",@"复制链接",@"分享",@"刷新", nil];
    [actionSheet showInView:self.view];
}

// 关闭按钮点击
- (void)colseBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 菜单按钮事件

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    NSString *urlStr = _homeUrl;
    urlStr = self.wkWebView.URL.absoluteString;
    if (buttonIndex == 0) {
        // safari打开
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }else if (buttonIndex == 1) {
        
        // 复制链接
        if (urlStr.length > 0) {
            [[UIPasteboard generalPasteboard] setString:urlStr];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"已复制链接到黏贴板" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
            [alertView show];
        }
    }else if (buttonIndex == 2) {
        // 分享
        //[self.wkWebView evaluateJavaScript:@"这里写js代码" completionHandler:^(id reponse, NSError * error) {
            //NSLog(@"返回的结果%@",reponse);
        //}];
        NSLog(@"这里自己写，分享url：%@",urlStr);
    }else if (buttonIndex == 3) {
        // 刷新
        [self.wkWebView reload];
    }
}

#pragma mark - wkWebView代理

// 如果不添加这个，那么wkwebview跳转不了AppStore
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.wkWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

// 记得取消监听
- (void)dealloc {
    YPCAppLog(@"Dealloc");
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - webView代理
// 计算webView进度条
- (void)setLoadCount:(NSUInteger)loadCount {
    _loadCount = loadCount;
    if (loadCount == 0) {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    }else {
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
        if (newP > 0.95) {
            newP = 0.95;
        }
        [self.progressView setProgress:newP animated:YES];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.loadCount ++;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.loadCount --;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    self.loadCount --;
}

@end
