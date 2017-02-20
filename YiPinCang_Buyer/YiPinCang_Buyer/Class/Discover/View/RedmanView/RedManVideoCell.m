//
//  RedManVideoCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/27.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "RedManVideoCell.h"

@implementation RedManVideoCell
{
    AVPlayer *_player;
    AVPlayerLayer *_playerLayer;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.txImg.sd_layout
        .leftSpaceToView(self.contentView,13)
        .topSpaceToView(self.contentView,18)
        .widthIs(46)
        .heightIs(46);
        [self.txImg setSd_cornerRadiusFromWidthRatio:@0.5];
        
        self.txBtn.sd_layout
        .leftSpaceToView(self.contentView,13)
        .topSpaceToView(self.contentView,18)
        .widthIs(46)
        .heightIs(46);
        
        self.btn.sd_layout
        .rightSpaceToView(self.contentView,0)
        .topSpaceToView(self.contentView,15)
        .widthIs(75)
        .heightIs(55);
        
        self.nameLab.sd_layout
        .leftSpaceToView(self.txImg,5)
        .topEqualToView(self.txImg)
        .heightIs(15)
        .rightSpaceToView(self.btn,15);
        self.countLab.sd_layout
        .leftEqualToView(self.nameLab)
        .topSpaceToView(self.nameLab,10)
        .rightSpaceToView(self.btn,15)
        .heightIs(15);
        
        self.titleLab.sd_layout
        .leftSpaceToView(self.contentView,13)
        .rightSpaceToView(self.contentView,13)
        .topSpaceToView(self.txImg,13)
        .autoHeightRatio(0);
        
        self.bgImg.sd_layout
        .leftSpaceToView(self.contentView,13)
        .topSpaceToView(self.titleLab,10)
        .widthIs(232)
        .heightIs(232);
        
        self.playBtn.sd_layout
        .leftEqualToView(self.bgImg)
        .rightEqualToView(self.bgImg)
        .topEqualToView(self.bgImg)
        .bottomEqualToView(self.bgImg);
        
        [self.playBtn addTarget:self action:@selector(palyClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.likeCountLab.sd_layout
        .rightSpaceToView(self.contentView,13)
        .topSpaceToView(self.bgImg,16)
        .heightIs(15);
        
        self.likeBtn.sd_layout
        .widthIs(19)
        .heightIs(44)
        .rightSpaceToView(self.likeCountLab,5)
        .centerYEqualToView(self.likeCountLab);
        
        self.commentLab.sd_layout
        .rightSpaceToView(self.likeBtn,22)
        .topSpaceToView(self.bgImg,16)
        .heightIs(15);
        
        self.commentImg.sd_layout
        .rightSpaceToView(self.commentLab,5)
        .centerYEqualToView(self.likeCountLab)
        .widthIs(19)
        .heightIs(19);
        
        self.timeLab.sd_layout
        .leftSpaceToView(self.contentView,13)
        .centerYEqualToView(self.likeCountLab)
        .heightIs(15);
        
        self.lineView.sd_layout
        .leftSpaceToView(self.contentView,0)
        .rightSpaceToView(self.contentView,0)
        .heightIs(1)
        .topSpaceToView(self.likeCountLab,16);
        [self setupAutoHeightWithBottomView:self.lineView bottomMargin:0];
    }
    return self;
}


- (void)setModel:(RedListModel *)model{
    if (_model != model) {
        _model = model;
    }
    if ([model.is_follow isEqualToString:@"1"]) {
        self.btn.selected = YES;
    }else{
        self.btn.selected = NO;
    }
    if ([model.islike isEqualToString:@"1"]) {
        self.likeBtn.selected = YES;
    }else{
        self.likeBtn.selected = NO;
    }
    self.nameLab.text = model.store_name;
    [self.txImg sd_setImageWithURL:[NSURL URLWithString:model.store_avatar] placeholderImage:YPCImagePlaceHolder];
    self.countLab.text = [NSString stringWithFormat:@"动态%@",model.strace_count];
    self.titleLab.text = model.strace_title;
    self.timeLab.text = model.strace_time;
    [self.timeLab sizeToFit];
    self.timeLab.sd_layout
    .widthIs(self.timeLab.frame.size.width);
    self.likeCountLab.text = model.strace_cool;
    [self.likeCountLab sizeToFit];
    self.likeCountLab.sd_layout
    .widthIs(self.likeCountLab.frame.size.width);
    self.commentLab.text = model.strace_comment;
    [self.commentLab sizeToFit];
    self.commentLab.sd_layout
    .widthIs(self.commentLab.frame.size.width);
    [self.bgImg sd_setImageWithURL:[NSURL URLWithString:model.video_img] placeholderImage:YPCImagePlaceHolder];
}

- (void)palyClick{
    UIView *blackView = [[UIView alloc] init];
    blackView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    blackView.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication].keyWindow addSubview:blackView];
    [blackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blackViewTap:)]];
    UIView *videoV = [[UIView alloc] init];
    videoV.frame = CGRectMake(0.f, ScreenHeight * 3 / 10, ScreenWidth, ScreenHeight * 2 / 5);
    [blackView addSubview:videoV];
    // 1、获取媒体资源地址
    NSString *url = @"";
    
    url = _model.video;
    
    
    NSURL *sourceMovieURL = [NSURL URLWithString:url];
    // 2、创建AVPlayerItem
    AVAsset *asset = [AVAsset assetWithURL:sourceMovieURL];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    // 3、根据AVPlayerItem创建媒体播放器
    _player = [AVPlayer playerWithPlayerItem:playerItem];
    // 4、创建AVPlayerLayer，用于呈现视频
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    // 5、设置显示大小和位置
    playerLayer.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight * 2 / 5);
    // 6、设置拉伸模式
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [videoV.layer addSublayer:playerLayer];
    [_player play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runloopPlayVideo:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
}
- (void)runloopPlayVideo:(NSNotification *)notification {
    AVPlayerItem *playerItem = [notification object];
    [playerItem seekToTime:kCMTimeZero];
    [_player play];
}
- (void)blackViewTap:(UITapGestureRecognizer *)tap {
    UIView *view = tap.view;
    [view removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    _player = nil;
    [_playerLayer removeFromSuperlayer];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (UIImageView *)txImg{
    if (_txImg == nil) {
        _txImg = [[UIImageView alloc]init];
        [self.contentView addSubview:_txImg];
    }
    return _txImg;
}

- (UILabel *)nameLab{
    if (_nameLab == nil) {
        _nameLab = [[UILabel alloc]init];
        [self.contentView addSubview:_nameLab];
        _nameLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _nameLab.textAlignment = NSTextAlignmentLeft;
        _nameLab.textColor = [Color colorWithHex:@"#333333"];
    }
    return _nameLab;
}

- (UILabel *)countLab{
    if (_countLab == nil) {
        _countLab = [[UILabel alloc]init];
        _countLab.textColor = [Color colorWithHex:@"#999999"];
        _countLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _countLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_countLab];
    }
    return _countLab;
}

- (UIButton *)btn{
    if (_btn == nil) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setImage:IMAGE(@"find_livestreaming_buttons") forState:UIControlStateNormal];
        [_btn setImage:IMAGE(@"find_livestreaming_buttons2") forState:UIControlStateSelected];
        _btn.acceptEventInterval = 0.5;
        [self.contentView addSubview:_btn];
    }
    return _btn;
}

- (UILabel *)titleLab{
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.font = YPCPFFont(14);
        [_titleLab setNumberOfLines:0];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.textColor = [Color colorWithHex:@"#191919"];
        [self.contentView addSubview:_titleLab];
    }
    return _titleLab;
}

- (UILabel *)timeLab{
    if (_timeLab == nil) {
        _timeLab = [[UILabel alloc]init];
        [self.contentView addSubview:_timeLab];
        _timeLab.textAlignment = NSTextAlignmentLeft;
        _timeLab.font = YPCPFFont(12);
        _timeLab.textColor = [Color colorWithHex:@"0x999999"];
    }
    return _timeLab;
}

- (UIImageView *)commentImg{
    if (_commentImg == nil) {
        _commentImg = [[UIImageView alloc]initWithImage:IMAGE(@"find_review_icon")];
        [self.contentView addSubview:_commentImg];
    }
    return _commentImg;
}

- (UIButton *)likeBtn{
    if (_likeBtn == nil) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn setImage:IMAGE(@"find_like_icon1") forState:UIControlStateNormal];
        [_likeBtn setImage:IMAGE(@"find_likedown_icon") forState:UIControlStateSelected];
        [self.contentView addSubview:_likeBtn];
    }
    return _likeBtn;
}

- (UIView *)lineView{
    if (_lineView == nil) {
        
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [Color colorWithHex:@"#f2f2f2"];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}

- (UIButton *)playBtn{
    if (_playBtn == nil) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:IMAGE(@"find_live_icon111") forState:UIControlStateNormal];
        [self.contentView addSubview:_playBtn];
    }
    return _playBtn;
}

- (UIImageView *)bgImg{
    if (_bgImg == nil) {
        _bgImg = [[UIImageView alloc]init];
        [self.contentView addSubview:_bgImg];
    }
    return _bgImg;
}
- (UILabel *)likeCountLab{
    if (_likeCountLab == nil) {
        _likeCountLab = [[UILabel alloc]init];
        _likeCountLab.textAlignment = NSTextAlignmentRight;
        _likeCountLab.font = YPCPFFont(12);
        _likeCountLab.textColor = [Color colorWithHex:@"#999999"];
        [self.contentView addSubview:_likeCountLab];
    }
    return _likeCountLab;
}

- (UILabel *)commentLab{
    if (_commentLab == nil) {
        _commentLab = [[UILabel alloc]init];
        _commentLab.textAlignment = NSTextAlignmentRight;
        _commentLab.font = YPCPFFont(12);
        _commentLab.textColor = [Color colorWithHex:@"#999999"];
        [self.contentView addSubview:_commentLab];
    }
    return _commentLab;
}

- (UIButton *)txBtn{
    if (_txBtn == nil) {
        _txBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_txBtn];
    }
    return _txBtn;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
