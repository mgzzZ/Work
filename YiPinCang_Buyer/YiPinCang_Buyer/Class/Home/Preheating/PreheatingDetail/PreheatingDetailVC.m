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
#import "LiveDetailHHHVC.h"
#import "PreheatingDetailModel.h"
static NSString *Identifier = @"identifier";
@interface PreheatingDetailVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UILabel *likeCountLab;
@property (nonatomic, strong) UILabel *commentLab;
@property (nonatomic, strong) UIImageView *bottomImg;

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic) UIButton *movieCoverBtn;

@property (nonatomic, strong) PreheatingDetailModel *dataModel;
@property (strong, nonatomic) IBOutlet UITableView *CommentTableView;
@property (nonatomic, strong) UIView *tableHeaderV;
@property (nonatomic, strong) NSMutableArray *commentDataArr;
@property (nonatomic, strong) KeyboardTextView *keyboardView;

@property (nonatomic,strong)UIButton *messageBtn;
@property (nonatomic,assign)BOOL isSelected;

@property (nonatomic,copy)NSString *store_id;
@property (nonatomic,copy)NSString *likeCount;
@property (nonatomic,copy)NSString *isLike;

@end

@implementation PreheatingDetailVC
{
    NSInteger dataIndex;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    if (self.backBlock) {
        self.backBlock(self.likeCount,self.isLike,[NSString stringWithFormat:@"%zd",self.dataModel.comment_list.count]);
    }
    
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
                                                                                   @"strace_id" : weakSelf.tempStrace_ID,
                                                                                   @"message" : text
                                                                                   }]
                           success:^(id response) {
                               if ([YPC_Tools judgeRequestAvailable:response]) {
                                   [YPC_Tools showSvpWithNoneImgHud:@"评论成功"];
                                   
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
    self.title = @"详情";
    self.isSelected = NO;
    [self.CommentTableView registerClass:[DiscoverCommentCell class] forCellReuseIdentifier:Identifier];
    [self configNaviRightBtn];
  
    [self.view addSubview:self.keyboardView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addComment:) name:@"comment" object:nil];
    
    WS(weakSelf);
    self.CommentTableView.mj_header = [YPCRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf getDataForTableView];
    }];
    
//    self.CommentTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
//        [weakSelf addDataForTableViewFooter];
//    }];
//    self.CommentTableView.mj_footer.hidden = YES;
    
    [self getDataForTableView];
}

- (void)getDataForTableView
{
    WS(weakSelf);
    dataIndex = 1;
    [YPCNetworking postWithUrl:self.detailType == detailStylePerhearting ? @"shop/activity/prestracedetail" : @"shop/usercircle/storecircledetail"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"strace_id" : self.tempStrace_ID
//                                                                               @"pagination" : @{
//                                                                                       @"page" : [NSString stringWithFormat:@"%ld", dataIndex],
//                                                                                       @"count" : @"30"
//                                                                                       }
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.dataModel = [PreheatingDetailModel mj_objectWithKeyValues:response[@"data"]];
                               weakSelf.commentDataArr = [CommentListModel mj_objectArrayWithKeyValuesArray:weakSelf.dataModel.comment_list];
                               
                                weakSelf.commentLab.text = [NSString stringWithFormat:@"%zd",weakSelf.commentDataArr.count];
                               
                               [weakSelf setupTableViewHeader];
                               [weakSelf.CommentTableView reloadData];
                               
                               [weakSelf.CommentTableView.mj_header endRefreshing];
                               
//                               // 隐藏MJ加载尾部视图
//                               if ([response[@"paginated"][@"more"] integerValue] == 1) {
//                                   weakSelf.CommentTableView.mj_footer.hidden = NO;
//                               }else {
//                                   weakSelf.CommentTableView.mj_footer.hidden = YES;
//                               }
                           }
                       } fail:^(NSError *error) {
                           [YPC_Tools showSvpWithNoneImgHud:@"加载失败~"];
                       }];
}

//- (void)addDataForTableViewFooter
//{
//    dataIndex++;
//    WS(weakSelf);
//    [YPCNetworking postWithUrl:self.detailType == detailStylePerhearting ? @"shop/activity/prestracedetail" : @"shop/usercircle/storecircledetail"
//                  refreshCache:YES
//                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
//                                                                               @"strace_id" : self.tempStrace_ID,
//                                                                               @"pagination" : @{
//                                                                                       @"page" : [NSString stringWithFormat:@"%ld", dataIndex],
//                                                                                       @"count" : @"5"
//                                                                                       }
//                                                                               }]
//                       success:^(id response) {
//                           if ([YPC_Tools judgeRequestAvailable:response]) {
//                               weakSelf.dataModel = [PreheatingDetailModel mj_objectWithKeyValues:response[@"data"]];
//                               [weakSelf.commentDataArr addObjectsFromArray:[CommentListModel mj_objectArrayWithKeyValuesArray:weakSelf.dataModel.comment_list]];
//
//                               [weakSelf.CommentTableView reloadData];
//                               [weakSelf.CommentTableView.mj_footer endRefreshing];
//                               
//                               // 隐藏MJ加载尾部视图
//                               if ([response[@"paginated"][@"more"] integerValue] == 1) {
//                                   weakSelf.CommentTableView.mj_footer.hidden = NO;
//                               }else {
//                                   weakSelf.CommentTableView.mj_footer.hidden = YES;
//                               }
//                           }
//                       } fail:^(NSError *error) {
//                           [YPC_Tools showSvpWithNoneImgHud:@"加载失败~"];
//                       }];
//}

- (void)setupTableViewHeader
{
    UIView *tvHeaderV = [UIView new];
    tvHeaderV.backgroundColor = [UIColor whiteColor];
    tvHeaderV.sd_layout.widthIs(ScreenWidth);
    
    UIImageView *avatarImg = [UIImageView new];
    avatarImg.layer.cornerRadius = 23;
    avatarImg.layer.masksToBounds = YES;
    [avatarImg sd_setImageWithURL:[NSURL URLWithString:self.dataModel.strace_storelogo] placeholderImage:YPCImagePlaceHolder];
    
    UIButton *avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [avatarBtn addTarget:self action:@selector(pushDetail) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *nameLab = [UILabel new];
    nameLab.textAlignment = NSTextAlignmentLeft;
    nameLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
    nameLab.font = [UIFont boldSystemFontOfSize:18];
    nameLab.text = self.dataModel.strace_storename;
    
    UILabel *titleLab = [UILabel new];
    titleLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.text = self.dataModel.strace_title;
    
    UILabel *timeLab = [[UILabel alloc]init];
    timeLab.textAlignment = NSTextAlignmentLeft;
    timeLab.textColor = [Color colorWithHex:@"0xBFBFBF"];
    timeLab.font = [UIFont systemFontOfSize:13];
    timeLab.text = [YPC_Tools timeWithTimeIntervalString:self.dataModel.strace_time Format:@"YYYY-MM-dd"];
    
    self.commentLab = [[UILabel alloc]init];
    self.commentLab.textAlignment = NSTextAlignmentRight;
    self.commentLab.textColor = [Color colorWithHex:@"0xBFBFBF"];
    self.commentLab.font = [UIFont systemFontOfSize:13];
    self.commentLab.text = self.dataModel.strace_comment;

    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn setImage:IMAGE(@"find_pinglun_button") forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.likeCountLab = [[UILabel alloc]init];
    self.likeCountLab.textAlignment = NSTextAlignmentRight;
    self.likeCountLab.textColor = [Color colorWithHex:@"0xBFBFBF"];
    self.likeCountLab.font = [UIFont systemFontOfSize:13];
    self.likeCountLab.text = self.dataModel.strace_cool;
    self.likeCount = self.dataModel.strace_cool;
    self.isLike = self.dataModel.islike;
    
    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeBtn setImage:IMAGE(@"find_like_button") forState:UIControlStateNormal];
    [likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if ([self.dataModel.islike isEqualToString:@"0"]) {
        [likeBtn setImage:IMAGE(@"find_like_button") forState:UIControlStateNormal];
        likeBtn.enabled = YES;
    }else if ([self.dataModel.islike isEqualToString:@"1"]) {
        [likeBtn setImage:IMAGE(@"find_like_button_clicked") forState:UIControlStateNormal];
        likeBtn.enabled = NO;
    }
    
    self.bottomImg = [[UIImageView alloc]initWithImage:IMAGE(@"find_productdetails_icon_dialogbox")];
    if (self.commentDataArr.count == 0) {
        self.bottomImg.hidden = YES;
    }else {
        self.bottomImg.hidden = NO;
    }
    
    [tvHeaderV sd_addSubviews:@[avatarImg, avatarBtn, nameLab, titleLab, timeLab, self.commentLab, commentBtn, self.likeCountLab, likeBtn, self.bottomImg]];

    avatarImg.sd_layout.widthIs(46).heightIs(46).leftSpaceToView(tvHeaderV, 15).topSpaceToView(tvHeaderV, 15);
    avatarBtn.sd_layout.widthIs(46).heightIs(46).leftSpaceToView(tvHeaderV, 15).topSpaceToView(tvHeaderV, 15);
    nameLab.sd_layout.leftSpaceToView(avatarImg, 10).topEqualToView(avatarImg).heightIs(20).rightSpaceToView(tvHeaderV, 15);
    titleLab.sd_layout.leftEqualToView(nameLab).rightSpaceToView(tvHeaderV, 15).topSpaceToView(avatarImg, 0).autoHeightRatio(0);
    
    if ([self.dataModel.content_type integerValue] == 2) {
        UIImageView *videoImgV = [UIImageView new];
        videoImgV.contentMode = UIViewContentModeScaleAspectFill;
        videoImgV.clipsToBounds = YES;
        [videoImgV sd_setImageWithURL:[NSURL URLWithString:self.dataModel.video_img] placeholderImage:YPCImagePlaceMainHomeHolder];
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
        photosView.modeType = PhotoContainerModeTypeHave;
        if (self.dataModel.strace_content.count == 1) {
            photosView.WH = self.dataModel.aspect.floatValue;
        }
        photosView.thumbPicPathStringsArray = self.dataModel.strace_content_thumb;
        photosView.picPathStringsArray = self.dataModel.strace_content;
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
    
    self.tableHeaderV = tvHeaderV;
    [self.tableHeaderV setupAutoHeightWithBottomView:self.bottomImg bottomMargin:0];
    [self.tableHeaderV layoutSubviews];
    
    [self.CommentTableView setTableHeaderView:self.tableHeaderV];
    
    self.messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.messageBtn setImage:IMAGE(@"buypage_reminder_backgound") forState:UIControlStateNormal];
    [self.view addSubview:self.messageBtn];
    self.messageBtn.sd_layout
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,130 + 58)
    .widthIs(80)
    .heightIs(40);
    [self.messageBtn addTarget:self action:@selector(messageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.messageBtn.hidden = YES;
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
    if (indexPath.row == self.commentDataArr.count - 1 && self.isSelected) {
        self.messageBtn.hidden = YES;
    }
    cell.model = self.commentDataArr[indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark - Btn点击方法
- (void)commentBtnClick:(UIButton *)sender
{
    WS(weakSelf);
    [YPCRequestCenter isLoginAndPresentLoginVC:self success:^{
        [weakSelf.keyboardView becomeFirstResponder];
    }];
}

- (void)likeBtnClick:(UIButton *)sender
{
    WS(weakSelf);
    [YPCRequestCenter isLoginAndPresentLoginVC:self success:^{
        [YPCNetworking postWithUrl:weakSelf.detailType == detailStylePerhearting ? @"shop/explore/livegoodslike" : @"shop/usercircle/like"
                      refreshCache:YES
                            params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                                   @"strace_id" : weakSelf.tempStrace_ID
                                                                                   }]
                           success:^(id response) {
                               if ([YPC_Tools judgeRequestAvailable:response]) {
                                   [sender setImage:IMAGE(@"find_productdetails_icon_likes_cliked") forState:UIControlStateNormal];
                                   sender.enabled = NO;
                                   [weakSelf.dataModel setStrace_cool:[NSString stringWithFormat:@"%ld", weakSelf.dataModel.strace_cool.integerValue + 1]];
                                   [weakSelf.dataModel setIslike:@"1"];
                                   weakSelf.likeCountLab.text = weakSelf.dataModel.strace_cool;
                                   weakSelf.likeCount = weakSelf.dataModel.strace_cool;
                               }
                           }
                              fail:^(NSError *error) {
                                  
                              }];
    }];
}

- (void)playBrandVideoAction:(UIButton *)sender
{
    [self videoPlayActionWithURL:[NSURL URLWithString:self.dataModel.video]];
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
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setImage:IMAGE(@"mshare_button") forState:UIControlStateNormal];
//    [button sizeToFit];
//    [button addTarget:self
//               action:@selector(naviRightAction:)
//     forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = shareItem;
}
- (void)naviRightAction:(UIButton *)sender
{

}


- (void)addComment:(NSNotification *)notification{
    NSDictionary *dic = [notification object];
    
    PushModel *model = [PushModel mj_objectWithKeyValues:dic];
    if ([model.extras.strace_id isEqualToString:self.tempStrace_ID]) {
        self.isSelected = YES;
        self.messageBtn.hidden = NO;
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
        self.commentLab.text = [NSString stringWithFormat:@"%zd",self.commentDataArr.count];
    }
    
    
}

- (void)messageBtnClick{
    [self.CommentTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.commentDataArr.count - 1 inSection:0]
                                animated:YES
                          scrollPosition:UITableViewScrollPositionBottom];
}

- (void)pushDetail{
    if (self.dataModel.store_id.length != 0) {
        __block BOOL isPush = YES;
        WS(weakSelf);
        [self.rt_navigationController.rt_viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[obj class] isEqual:[LiveDetailHHHVC class]]) {
                [weakSelf.navigationController popToViewController:obj animated:YES];
                isPush = NO;
                *stop = YES;
            }
        }];
        if (isPush) {
            LiveDetailHHHVC *live = [[LiveDetailHHHVC alloc]init];
            live.store_id = self.dataModel.store_id;
            [self.navigationController pushViewController:live animated:YES];
        }
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
