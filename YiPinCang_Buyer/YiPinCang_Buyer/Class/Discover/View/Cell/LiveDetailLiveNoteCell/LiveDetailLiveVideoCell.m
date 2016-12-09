//
//  LiveDetailLiveVideoCell.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/2.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "LiveDetailLiveVideoCell.h"

@implementation LiveDetailLiveVideoCell
{
    AVPlayer *_player;
    AVPlayerLayer *_playerLayer;

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        [self setup];
    }
    return self;
}
- (void)setup{
    self.titleLab = [[UILabel alloc]init];
    self.titleLab.textColor = [Color colorWithHex:@"#2C2C2C"];
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    self.titleLab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.titleLab];
    self.titleLab.sd_layout
    .leftSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView,15)
    .rightSpaceToView(self.contentView,15)
    .autoHeightRatio(0);
    self.bgImg = [[UIImageView alloc]init];
    self.bgImg.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.bgImg];
    self.bgImg.sd_layout
    .leftEqualToView(self.titleLab)
    .topSpaceToView(self.titleLab,10)
    .rightEqualToView(self.titleLab)
    .heightIs(175);
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:IMAGE(@"homepage_yure_videoplay1") forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(palyClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.playBtn];
    self.playBtn.sd_layout
    .leftEqualToView(self.bgImg)
    .rightEqualToView(self.bgImg)
    .topEqualToView(self.bgImg)
    .bottomEqualToView(self.bgImg);
    self.timeLab = [[UILabel alloc]init];
    self.timeLab.textColor = [Color colorWithHex:@"#BFBFBF"];
    self.timeLab.font = [UIFont systemFontOfSize:13];
    self.timeLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.timeLab];
    self.timeLab.sd_layout
    .leftEqualToView(self.titleLab)
    .topSpaceToView(self.bgImg,10)
    .heightIs(15);
    self.commentLab = [[UILabel alloc]init];
    [self.contentView addSubview:self.commentLab];
    self.commentLab.textAlignment = NSTextAlignmentRight;
    self.commentLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
    self.commentLab.font = [UIFont systemFontOfSize:13];
    self.commentLab.sd_layout
    .rightEqualToView(self.titleLab)
    .topSpaceToView(self.timeLab,5)
    .heightIs(15);
    self.commentImg = [[UIImageView alloc]initWithImage:IMAGE(@"find_productdetails_icon_commentnumber")];
    [self.contentView addSubview:self.commentImg];
    self.commentImg.sd_layout
    .widthIs(25)
    .heightIs(25)
    .rightSpaceToView(self.commentLab,5)
    .centerYEqualToView(self.commentLab);
    
    self.likeLab = [[UILabel alloc]init];
    self.likeLab.textAlignment = NSTextAlignmentRight;
    self.likeLab.textColor = [Color colorWithHex:@"0x2c2c2c"];
    self.likeLab.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.likeLab];
    self.likeLab.sd_layout
    .rightSpaceToView(self.commentImg,30)
    .centerYEqualToView(self.commentLab)
    .heightIs(15);
    self.likeImg = [[UIImageView alloc]initWithImage:IMAGE(@"find_productdetails_icon_likes")];
    [self.contentView addSubview:self.likeImg];
    self.likeImg.sd_layout
    .rightSpaceToView(self.likeLab,5)
    .centerYEqualToView(self.commentLab)
    .widthIs(25)
    .heightIs(25);
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [Color colorWithHex:@"0xefefef"];
    [self.contentView addSubview:view];
    view.sd_layout
    .leftEqualToView(self.contentView)
    .rightSpaceToView(self.contentView,0)
    .heightIs(7)
    .topSpaceToView(self.likeImg,15);
    [self setupAutoHeightWithBottomView:view bottomMargin:0];
}
- (void)setModel:(LiveNoteModel *)model{
    if (_model != model) {
        _model = model;
    }
    self.titleLab.text = model.strace_title;
   
    NSString *time = [YPC_Tools timeWithTimeIntervalString:model.strace_time Format:@"YYYY-MM-dd"];
    self.timeLab.text = time;
    [self.timeLab sizeToFit];
    self.timeLab.sd_layout.widthIs(self.timeLab.frame.size.width);
    self.likeLab.text = model.strace_cool;
    self.commentLab.text = model.strace_comment;
   [self.bgImg sd_setImageWithURL:[NSURL URLWithString:model.video_img] placeholderImage:YPCImagePlaceHolder];
    [self.commentLab sizeToFit];
    
    self.commentLab.sd_layout.widthIs(self.commentLab.size.width);
     [self.likeLab sizeToFit];
    self.likeLab.sd_layout.widthIs(self.likeLab.size.width);
   
    self.bgImg.backgroundColor = [UIColor blueColor];
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
    
    url = _model.strace_contentstr;
    
    
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
