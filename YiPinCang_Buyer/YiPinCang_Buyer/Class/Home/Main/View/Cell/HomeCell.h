//
//  HomeCell.h
//  YiPinCang_Buyer
//
//  Created by Laomeng on 16/11/8.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeTVDetailModel.h"

/**
 * The style of cell cannot stop in screen center.
 * 播放滑动不可及cell的类型
 */
typedef NS_ENUM(NSUInteger, PlayUnreachCellStyle) {
    PlayUnreachCellStyleUp = 1, // top 顶部不可及
    PlayUnreachCellStyleDown = 2, // bottom 底部不可及
    PlayUnreachCellStyleNone = 3 // normal 播放滑动可及cell
};
typedef NS_ENUM(NSUInteger, AutoPlayCellStyle) {
    CanAutoPlayCellStyle = 1,
    NotAutoPlayCellStyle = 2
};

@interface HomeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView;

/** videoPath */
@property(nonatomic, strong)NSString *videoPath;

/** indexPath */
@property(nonatomic, strong)NSIndexPath *indexPath;

/** cell类型 */
@property(nonatomic, assign)PlayUnreachCellStyle cellStyle;

/** 流量进入首页显示图片, 不自动播放视频 */
@property (strong, nonatomic) IBOutlet UIView *nowifiImgPHView;

/** 是否隐藏图片 */
@property (nonatomic, assign) BOOL isImgPHViewHidden;
@property (strong, nonatomic) IBOutlet UIButton *playBtn;

/** 数据 */
@property (nonatomic, strong) HomeTVDetailModel *tempModel;

@property (nonatomic, copy) void (^ButtonClickedBlock)(id object);

@property (nonatomic, assign) AutoPlayCellStyle autoPlayStyle;

@end
