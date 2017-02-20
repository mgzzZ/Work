//
//  PhotoContainerView.m
//  TaoFactory_Seller
//
//  Created by 孟镇 on 16/9/27.
//  Copyright © 2016年 YPC_mz. All rights reserved.
//

#import "PhotoContainerView.h"
#import "UIView+SDAutoLayout.h"
#import "ZLPhoto.h"

@interface PhotoContainerView () <ZLPhotoPickerBrowserViewControllerDelegate,ZLPhotoPickerBrowserViewControllerDataSource>

@property (nonatomic, strong) NSArray *imageViewsArray;

@end

@implementation PhotoContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    NSMutableArray *temp = [NSMutableArray new];
    
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        [temp addObject:imageView];
    }
    
    self.imageViewsArray = [temp copy];
}


- (void)setThumbPicPathStringsArray:(NSArray *)thumbPicPathStringsArray{
    _thumbPicPathStringsArray = thumbPicPathStringsArray;
    if (self.modeType == PhotoContainerModeTypeNormal) {
        return;
    }
    for (long i = _thumbPicPathStringsArray.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    if (_thumbPicPathStringsArray.count == 0) {
        self.height = 0;
        self.fixedHeight = @(0);
        return;
    }
    
    CGFloat itemW = [self itemWidthForPicPathArray:_thumbPicPathStringsArray];
    CGFloat itemH = 0;
    if (self.containerType == PhotoContainerTypeGeneral) {
        
        itemH = itemW;
    }else{
        if (_thumbPicPathStringsArray.count == 1) {
            if (self.WH != 0) {
                itemH = itemW / self.WH ;
            }else{
                itemH = itemW;
            }
        } else {
            itemH = itemW;
        }
    }
    
    long perRowItemCount = [self perRowItemCountForPicPathArray:_thumbPicPathStringsArray];
    CGFloat margin = 5;
    
    [_thumbPicPathStringsArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 8) {
            return ;
        }
        long columnIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        UIImageView *imageView = [_imageViewsArray objectAtIndex:idx];
        imageView.hidden = NO;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",obj]] placeholderImage:YPCImagePlaceHolder];
        
        imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
    }];
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(_thumbPicPathStringsArray.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
    self.width = w;
    self.height = h;
    
    self.fixedHeight = @(h);
    self.fixedWidth = @(w);

}



- (void)setPicPathStringsArray:(NSArray *)picPathStringsArray{
    _picPathStringsArray = picPathStringsArray;
    
    if (self.modeType == PhotoContainerModeTypeHave) {
        return;
    }
    for (long i = _picPathStringsArray.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    if (_picPathStringsArray.count == 0) {
        self.height = 0;
        self.fixedHeight = @(0);
        return;
    }
    
    CGFloat itemW = [self itemWidthForPicPathArray:_picPathStringsArray];
    CGFloat itemH = 0;
    if (self.containerType == PhotoContainerTypeGeneral) {
        
        itemH = itemW;
    }else{
        if (_picPathStringsArray.count == 1) {
            if (self.WH != 0) {
                itemH = itemW / self.WH ;
            }else{
                itemH = itemW;
            }
        } else {
            itemH = itemW;
        }
    }
    
    long perRowItemCount = [self perRowItemCountForPicPathArray:_picPathStringsArray];
    CGFloat margin = 5;
    
    [_picPathStringsArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 8) {
            return ;
        }
        long columnIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        UIImageView *imageView = [_imageViewsArray objectAtIndex:idx];
        imageView.hidden = NO;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",obj]] placeholderImage:YPCImagePlaceHolder];
        
        imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
    }];
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(_picPathStringsArray.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
    self.width = w;
    self.height = h;
    
    self.fixedHeight = @(h);
    self.fixedWidth = @(w);
}

#pragma mark - private actions

- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    UIView *imageView = tap.view;
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    pickerBrowser.editing = NO;
    pickerBrowser.delegate = self;
    pickerBrowser.dataSource = self;
    pickerBrowser.status = UIViewAnimationAnimationStatusFade;
    pickerBrowser.currentIndexPath = [NSIndexPath indexPathForRow:imageView.tag inSection:0];
    [pickerBrowser showPickerVc:[YPC_Tools getControllerWithView:self]];
}

- (CGFloat)itemWidthForPicPathArray:(NSArray *)array
{
    if (self.containerType == PhotoContainerTypeGeneral) {
        CGFloat width = (ScreenWidth - 36) / 3;
        return width;
    }else{
        if (array.count == 1) {
            return 130;
        } else {
            if (self.containerType == PhotoContainerTypeNormal) {
                return ScreenWidth > 320 ? 80 : 70;
            }else if (self.containerType == PhotoContainerTypeFullScreenWidth) {
                return (ScreenWidth - 42) / 3;
            }else if (self.containerType == PhotoContainerTypeFindScreenWidth) {
                return (ScreenWidth - 55 - 15 - 42) / 3;
            }else {
                return 0;
            }
        }
    }
    
}

- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array
{
    if (self.containerType == PhotoContainerTypeGeneral) {
        
        return 3;
    }else{
        if (array.count < 3) {
            return array.count;
        } else if (array.count <= 4) {
            return 2;
        } else {
            return 3;
        }
    }
    
}

#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser{
    return 1;
}

- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    
    return self.picPathStringsArray.count;
    
}
#pragma mark - 每个组展示什么图片,需要包装下ZLPhotoPickerBrowserPhoto
- (ZLPhotoPickerBrowserPhoto *) photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    ZLPhotoAssets *imageObj = [self.picPathStringsArray objectAtIndex:indexPath.row];
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
    photo.toView = self.imageViewsArray[indexPath.row];
    photo.thumbImage = [(UIImageView *)self.imageViewsArray[indexPath.row] image];
    return photo;
}

@end
