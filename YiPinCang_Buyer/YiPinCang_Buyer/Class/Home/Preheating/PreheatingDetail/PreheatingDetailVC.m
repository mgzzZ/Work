//
//  PreheatingDetailVC.m
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/19.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "PreheatingDetailVC.h"
#import "PhotoContainerView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CommentListModel.h"
#import "DiscoverCommentCell.h"
#import "LoginVC.h"
#import "KeyboardTextView.h"
#import "PushModel.h"
static NSString *Identifier = @"identifier";
@interface PreheatingDetailVC ()
@property (nonatomic, strong) UILabel *likeCountLab;
@property (nonatomic, strong) UILabel *commentLab;
@property (nonatomic, strong) UIImageView *bottomImg;

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic) UIButton *movieCoverBtn;

@property (strong, nonatomic) IBOutlet UITableView *CommentTableView;
@property (nonatomic, strong) NSMutableArray *commentDataArr;
@property (nonatomic, strong) KeyboardTextView *keyboardView;

@end

@implementation PreheatingDetailVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

- (NSMutableArray *)commentDataArr
{
    if (_commentDataArr) {
        return _commentDataArr;
    }
    _commentDataArr = [NSMutableArray array];
    return _commentDataArr;
}

- (KeyboardTextView *)keyboardView
{
    if (_keyboardView) {
        return _keyboardView;
    }
    _keyboardView = [[KeyboardTextView alloc] initWithTextViewFrame:CGRectMake(0, ScreenHeight - 49, ScreenWidth, 49)];
    WS(weakSelf);
    [_keyboardView setButtonClickedBlock:^(NSString *text) {
        [YPCNetworking postWithUrl:weakSelf.detailType == detailStylePerhearting ? @"shop/activity/sendcomment" : @"shop/usercircle/storecirclecomment"
                      refreshCache:YES
                            params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                   @"strace_id" : weakSelf.tempModel.strace_id,
                                                                                   @"message" : text
                                                                                   }]
                           success:^(id response) {
                               if ([YPC_Tools judgeRequestAvailable:response]) {
                                   [YPC_Tools showSvpWithNoneImgHud:@"回复成功"];
                                   
                                   [weakSelf getDataForTableView];
                               }
                           }
                              fail:^(NSError *error) {
                                  
                              }];
    }];
    return _keyboardView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"直播现场预告详情";
    
    [self.CommentTableView registerClass:[DiscoverCommentCell class] forCellReuseIdentifier:Identifier];
    
    [self configNaviRightBtn];
    [self setupTableViewHeader];
    [self getDataForTableView];
    [self.view addSubview:self.keyboardView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addComment:) name:@"comment" object:nil];
}

- (void)getDataForTableView
{
    WS(weakSelf);
    [YPCNetworking postWithUrl:weakSelf.detailType == detailStylePerhearting ? @"shop/activity/prestracedetail" : @"shop/usercircle/storecircledetail"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"strace_id" : self.tempModel.strace_id
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.commentDataArr = [CommentListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                               if (weakSelf.commentDataArr.count == 0) {
                                   weakSelf.bottomImg.hidden = YES;
                               }else {
                                   weakSelf.bottomImg.hidden = NO;
                               }
                               [weakSelf.CommentTableView reloadData];
                           }
                       } fail:^(NSError *error) {
                           
                       }];
}

- (void)setupTableViewHeader
{
    UIView *tvHeaderV = [UIView new];
    tvHeaderV.backgroundColor = [UIColor whiteColor];
    tvHeaderV.sd_layout.widthIs(ScreenWidth);
    
    UIImageView *avatarImg = [UIImageView new];
    avatarImg.layer.cornerRadius = 23;
    avatarImg.layer.masksToBounds = YES;
    [avatarImg sd_setImageWithURL:[NSURL URLWithString:self.tempModel.strace_storelogo] placeholderImage:YPCImagePlaceHolder];
    
    UILabel *nameLab = [UILabel new];
    nameLab.textAlignment = NSTextAlignmentLeft;
    nameLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
    nameLab.font = [UIFont boldSystemFontOfSize:18];
    nameLab.text = self.tempModel.strace_storename;
    
    UILabel *titleLab = [UILabel new];
    titleLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.text = self.tempModel.strace_title;
    
    UILabel *timeLab = [[UILabel alloc]init];
    timeLab.textAlignment = NSTextAlignmentLeft;
    timeLab.textColor = [Color colorWithHex:@"0xBFBFBF"];
    timeLab.font = [UIFont systemFontOfSize:13];
    timeLab.text = [YPC_Tools timeWithTimeIntervalString:self.tempModel.strace_time Format:@"YYYY-MM-dd"];
    
    self.commentLab = [[UILabel alloc]init];
    self.commentLab.textAlignment = NSTextAlignmentRight;
    self.commentLab.textColor = [Color colorWithHex:@"0xBFBFBF"];
    self.commentLab.font = [UIFont systemFontOfSize:13];
    self.commentLab.text = self.tempModel.strace_comment;
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn setImage:IMAGE(@"find_productdetails_icon_commentnumber") forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.likeCountLab = [[UILabel alloc]init];
    self.likeCountLab.textAlignment = NSTextAlignmentRight;
    self.likeCountLab.textColor = [Color colorWithHex:@"0xBFBFBF"];
    self.likeCountLab.font = [UIFont systemFontOfSize:13];
    self.likeCountLab.text = self.tempModel.strace_cool;
    
    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeBtn setImage:IMAGE(@"find_productdetails_icon_likes") forState:UIControlStateNormal];
    [likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if ([self.tempModel.islike isEqualToString:@"0"]) {
        [likeBtn setImage:IMAGE(@"find_productdetails_icon_likes") forState:UIControlStateNormal];
        likeBtn.enabled = YES;
    }else if ([self.tempModel.islike isEqualToString:@"1"]) {
        [likeBtn setImage:IMAGE(@"find_productdetails_icon_likes_cliked") forState:UIControlStateNormal];
        likeBtn.enabled = NO;
    }
    
    self.bottomImg = [[UIImageView alloc]initWithImage:IMAGE(@"find_productdetails_icon_dialogbox")];
    self.bottomImg.hidden = YES;
    
    [tvHeaderV sd_addSubviews:@[avatarImg, nameLab, titleLab, timeLab, self.commentLab, commentBtn, self.likeCountLab, likeBtn, self.bottomImg]];

    avatarImg.sd_layout.widthIs(46).heightIs(46).leftSpaceToView(tvHeaderV, 15).topSpaceToView(tvHeaderV, 15);
    nameLab.sd_layout.leftSpaceToView(avatarImg, 10).topEqualToView(avatarImg).heightIs(20).rightSpaceToView(tvHeaderV, 15);
    titleLab.sd_layout.leftEqualToView(nameLab).rightSpaceToView(tvHeaderV, 15).topSpaceToView(avatarImg, 0).autoHeightRatio(0);
    
    if ([self.tempModel.content_type integerValue] == 2) {
        UIImageView *videoImgV = [UIImageView new];
        videoImgV.contentMode = UIViewContentModeScaleAspectFill;
        videoImgV.clipsToBounds = YES;
        [videoImgV sd_setImageWithURL:[NSURL URLWithString:self.tempModel.video_img] placeholderImage:YPCImagePlaceMainHomeHolder];
        [tvHeaderV addSubview:videoImgV];
        
        UIButton *playVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [playVideoBtn setImage:IMAGE(@"homepage_yure_videoplay") forState:UIControlStateNormal];
        [playVideoBtn addTarget:self action:@selector(playBrandVideoAction:) forControlEvents:UIControlEventTouchUpInside];
        [tvHeaderV addSubview:playVideoBtn];
        
        videoImgV.sd_layout.topSpaceToView(titleLab, 11).leftEqualToView(titleLab).widthIs(ScreenWidth / 25 * 16).heightIs(ScreenWidth > 320 ? 170 : 150);
        playVideoBtn.sd_layout.centerXEqualToView(videoImgV).centerYEqualToView(videoImgV).widthIs(60).heightIs(60);
        timeLab.sd_layout.topSpaceToView(videoImgV, 12).leftEqualToView(videoImgV).heightIs(15);
        [timeLab setSingleLineAutoResizeWithMaxWidth:100.f];
        self.commentLab.sd_layout.rightSpaceToView(tvHeaderV, 14).topSpaceToView(videoImgV, 17).heightIs(10);
        [self.commentLab setSingleLineAutoResizeWithMaxWidth:100.f];
        commentBtn.sd_layout.rightSpaceToView(self.commentLab, 5).topSpaceToView(videoImgV, 10.5).widthIs(25).heightIs(25);
        self.likeCountLab.sd_layout.rightSpaceToView(commentBtn, 29).topSpaceToView(videoImgV, 17).heightIs(10);
        [self.likeCountLab setSingleLineAutoResizeWithMaxWidth:100.f];
        likeBtn.sd_layout.rightSpaceToView(self.likeCountLab, 5).topSpaceToView(videoImgV, 10.5).widthIs(25).heightIs(25);
        
    }else {
        
        PhotoContainerView *photosView = [PhotoContainerView new];
        photosView.containerType = PhotoContainerTypeNormal;
        photosView.picPathStringsArray = self.tempModel.strace_content;
        if (self.tempModel.strace_content.count == 1) {
            photosView.WH = self.tempModel.aspect.floatValue;
        }
        [tvHeaderV addSubview:photosView];
        
        photosView.sd_layout.topSpaceToView(titleLab, 11).leftEqualToView(titleLab);
        timeLab.sd_layout.topSpaceToView(photosView, 12).leftEqualToView(photosView).heightIs(15);
        [timeLab setSingleLineAutoResizeWithMaxWidth:100.f];
        self.commentLab.sd_layout.rightSpaceToView(tvHeaderV, 14).topSpaceToView(photosView, 17).heightIs(10);
        [self.commentLab setSingleLineAutoResizeWithMaxWidth:100.f];
        commentBtn.sd_layout.rightSpaceToView(self.commentLab, 5).topSpaceToView(photosView, 10.5).widthIs(25).heightIs(25);
        self.likeCountLab.sd_layout.rightSpaceToView(commentBtn, 29).topSpaceToView(photosView, 17).heightIs(10);
        [self.likeCountLab setSingleLineAutoResizeWithMaxWidth:100.f];
        likeBtn.sd_layout.rightSpaceToView(self.likeCountLab, 5).topSpaceToView(photosView, 10.5).widthIs(25).heightIs(25);
    }
    
    self.bottomImg.backgroundColor = [UIColor whiteColor];
    self.bottomImg.sd_layout
    .leftSpaceToView(tvHeaderV,30)
    .widthIs(15)
    .heightIs(8)
    .topSpaceToView(timeLab,12);
    [tvHeaderV setupAutoHeightWithBottomView:self.bottomImg bottomMargin:0];
    
    [self.CommentTableView setTableHeaderView:tvHeaderV];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentDataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentListModel *model = self.commentDataArr[indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[DiscoverCommentCell class]  contentViewWidth:ScreenWidth];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscoverCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    cell.model = self.commentDataArr[indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark - Btn点击方法
- (void)commentBtnClick:(UIButton *)sender
{
    if ([YPCRequestCenter isLoginAndPresentLoginVC:self]) {
        [self.keyboardView becomeFirstResponder];
    }
}

- (void)likeBtnClick:(UIButton *)sender
{
    WS(weakSelf);
    if ([YPCRequestCenter isLoginAndPresentLoginVC:self]) {
        [YPCNetworking postWithUrl:weakSelf.detailType == detailStylePerhearting ? @"shop/explore/livegoodslike" : @"shop/usercircle/like"
                      refreshCache:YES
                            params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                   @"strace_id" : self.tempModel.strace_id
                                                                                   }]
                           success:^(id response) {
                               if ([YPC_Tools judgeRequestAvailable:response]) {
                                   [sender setImage:IMAGE(@"find_productdetails_icon_likes_cliked") forState:UIControlStateNormal];
                                   sender.enabled = NO;
                                   [weakSelf.tempModel setStrace_cool:[NSString stringWithFormat:@"%ld", _tempModel.strace_cool.integerValue + 1]];
                                   [weakSelf.tempModel setIslike:@"1"];
                                   weakSelf.likeCountLab.text = _tempModel.strace_cool;
                               }
                           }
                              fail:^(NSError *error) {
                                  
                              }];
    }
}

- (void)playBrandVideoAction:(UIButton *)sender
{
    [self videoPlayActionWithURL:[NSURL URLWithString:self.tempModel.video]];
}

#pragma mark - 播放视频
- (void)videoPlayActionWithURL:(NSURL *)url
{
    // 设置视频播放器
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    self.moviePlayer.allowsAirPlay = YES;
    [self.moviePlayer setControlStyle:MPMovieControlStyleNone];
    [self.moviePlayer.view setFrame:self.view.bounds];
    self.moviePlayer.repeatMode = MPMovieRepeatModeOne;
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        if(windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            [window addSubview:self.moviePlayer.view];
            break;
        }
    }
    [self.moviePlayer play];
    self.movieCoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.movieCoverBtn.frame = self.view.bounds;
    self.movieCoverBtn.backgroundColor = [UIColor clearColor];
    [self.moviePlayer.view addSubview:self.movieCoverBtn];
    [self.movieCoverBtn addTarget:self action:@selector(dismissMoviePlayer) forControlEvents:UIControlEventTouchUpInside];
    [YPC_Tools setStatusBarIsHidden:YES];
}

- (void)dismissMoviePlayer
{
    if (self.moviePlayer) {
        [YPC_Tools setStatusBarIsHidden:NO];
        [self.moviePlayer stop];
        [self.moviePlayer.view removeFromSuperview];
        [self.movieCoverBtn removeFromSuperview];
        self.moviePlayer = nil;
        self.movieCoverBtn = nil;
    }
}

#pragma mark - Navi右按钮
- (void)configNaviRightBtn
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:IMAGE(@"mine_productdetails_icon_share") forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self
               action:@selector(naviRightAction:)
     forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = shareItem;
}
- (void)naviRightAction:(UIButton *)sender
{
    
}


- (void)addComment:(NSNotification *)notification{
    NSDictionary *dic = [notification object];
    
    PushModel *model = [PushModel mj_objectWithKeyValues:dic];
    if ([model.extras.strace_id isEqualToString:self.tempModel.strace_id]) {
        CommentListModel *commentlistModel = [[CommentListModel alloc]init];
        commentlistModel.scomm_memberavatar = model.extras.avatar;
        commentlistModel.scomm_content = model.title;
        commentlistModel.comment_type = model.extras.comment_type;
        commentlistModel.scommto_memberid = model.extras.replyto;
        commentlistModel.scomm_membername = model.extras.scomm_membername;
        commentlistModel.scomm_time = model.extras.scomm_time;
        commentlistModel.scommto_membername = model.extras.scommto_membername;
        [self.commentDataArr addObject:commentlistModel];
        NSIndexPath *index = [NSIndexPath indexPathForRow:self.commentDataArr.count - 1 inSection:0];
        [self.CommentTableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
