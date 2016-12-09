//
//  BrandnewView.m
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/8.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import "BrandnewView.h"
#import "LiveDetailListCell.h"
#import "LiveDetailSectionModel.h"
#import "GuessLikeView.h"

#import "MHFacebookImageViewer.h"
#import "UIImageView+MHFacebookImageViewer.h"
#import <ImagePlayerView.h>
#import "BrandBannerModel.h"
@interface BrandnewView ()<UITableViewDelegate,UITableViewDataSource,ImagePlayerViewDelegate,MHFacebookImageViewerDatasource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *guessLikeArr;//推荐商品
@property (nonatomic,strong)ImagePlayerView *titleImg;
@property (nonatomic,strong)BrandBannerModel *bannerModel;
@end


@implementation BrandnewView
- (void)dealloc
{
    // clear
    [self.titleImg stopTimer];
    self.titleImg.imagePlayerViewDelegate = nil;
    self.titleImg = nil;
}
- (instancetype)initWithFrame:(CGRect)frame{
   self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.dataArr = [NSMutableArray array];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.titleImg = [[ImagePlayerView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 250)];
    self.titleImg.imagePlayerViewDelegate = self;
    self.titleImg.scrollInterval = 3.0f;
    self.titleImg.backgroundColor = [UIColor whiteColor];
    self.titleImg.pageControlPosition = ICPageControlPosition_BottomCenter;
    self.titleImg.hidePageControl = NO;
    self.tableView.tableHeaderView = self.titleImg;
    [self  getData];
    [self getDataGuessUlike];
    [self getBrandbanner];
}
- (void)reload{
    [self  getData];
    [self getDataGuessUlike];
    [self getBrandbanner];
}

//发现品牌首页
- (void)getData{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/showstore/brandnew"
                  refreshCache:YES
                        params:@{@"pagination":@{
                                         @"page":@"1",
                                         @"count" : @"10"
                                         }
                                 }
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.dataArr = [LiveDetailSectionModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                               [weakSelf.tableView reloadData];
                           }
                           
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}

- (void)getDataGuessUlike{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/goods/guesslist"
                  refreshCache:YES
                        params:@{
                                                                               @"pagination":@{
                                                                                       @"count":@"24",
                                                                                       @"page":@"1"
                                                                                       }
                                                                               }
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.guessLikeArr = [GuessModel mj_objectArrayWithKeyValuesArray:response[@"data"]];                              
                               GuessLikeView *guessLikeView = [[GuessLikeView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ((ScreenWidth - 46) / 2 * 182 / 137 +60 + 20) * weakSelf.guessLikeArr.count / 2 + 50)];
                               guessLikeView.dataArr = weakSelf.guessLikeArr;
                               guessLikeView.didSelect = ^(NSIndexPath *index){
                                   GuessModel *model = weakSelf.guessLikeArr[index.row];
                                   if (weakSelf.didlike) {
                                       weakSelf.didlike(index,model);
                                   }
                                   
                               };
                               weakSelf.tableView.tableFooterView = guessLikeView;
                               
                           }
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}

- (void)getBrandbanner{
    WS(weakSelf);
    
    [YPCNetworking postWithUrl:@"shop/showstore/brandbanner"
                  refreshCache:YES
                        params:@{
                                 
                                 }
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.bannerModel = [BrandBannerModel mj_objectWithKeyValues:response[@"data"]];
                               [weakSelf.titleImg reloadData];
                               
                           }
                           
                       }
                          fail:^(NSError *error) {
                              
                          }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    LiveDetailSectionModel *model = self.dataArr[section];
    return model.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 42;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 81;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 42)];
    view.layer.borderWidth = 1;
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderColor = [Color colorWithHex:@"0xefefef"].CGColor;
    LiveDetailSectionModel *model = self.dataArr[section];
    UILabel *nameLab = [[UILabel alloc]init];
    [view addSubview:nameLab];
    
    nameLab.font = [UIFont systemFontOfSize:16];
    nameLab.textAlignment = NSTextAlignmentCenter;
    UIView *leftView = [[UIView alloc]init];
    leftView.backgroundColor = [Color colorWithHex:@"0x2c2c2c"];
    [view addSubview:leftView];
    UIView *rightView = [[UIView alloc]init];
    rightView.backgroundColor = [Color colorWithHex:@"0x2c2c2c"];
    [view addSubview:rightView];
    if ([model.type isEqualToString:@"start_activity"]) {
        //直播中
        
        nameLab.text = @"直播中";
        [nameLab sizeToFit];
        nameLab.sd_layout
        .centerXEqualToView(view)
        .centerYEqualToView(view)
        .widthIs(nameLab.size.width)
        .heightIs(42);
    }else if ([model.type isEqualToString:@"will_activity"]){
        //预告
        nameLab.text = @"直播预告";
        [nameLab sizeToFit];
        nameLab.sd_layout
        .centerXEqualToView(view)
        .centerYEqualToView(view)
        .widthIs(nameLab.size.width)
        .heightIs(42);
    }else if ([model.type isEqualToString:@"end_activity"]){
        //回放
        nameLab.text = @"往期直播";
        [nameLab sizeToFit];
        
        nameLab.sd_layout
        .centerXEqualToView(view)
        .centerYEqualToView(view)
        .widthIs(nameLab.size.width)
        .heightIs(42);
        
    }else{
        
    }
    leftView.sd_layout
    .rightSpaceToView(nameLab,5)
    .widthIs(18)
    .heightIs(2)
    .centerYEqualToView(view);
    rightView.sd_layout
    .leftSpaceToView(nameLab,5)
    .widthIs(18)
    .heightIs(2)
    .centerYEqualToView(view);
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"liveLisrt";
    LiveDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"LiveDetailListCell" owner:self options:nil][0];
    }
    LiveDetailSectionModel *model = self.dataArr[indexPath.section];
    LiveDetailListDataModel *listModel = model.data[indexPath.row];
    cell.model = listModel;
    if ([model.type isEqualToString:@"start_activity"]) {
        //直播中
        [cell.typeImg setImage:IMAGE(@"livemembers_details_icon_live")];
        [cell.leftImg setImage:IMAGE(@"homepage_yure_live_icon")];
        [cell.rightImg setImage:IMAGE(@"find_productdetails_icon_likes")];
        cell.leftLab.text = [NSString stringWithFormat:@"%@人观看中",listModel.live_users];
        cell.rightLab.text = listModel.live_like;
        cell.titleLab.text = listModel.name;
        cell.rightImg.hidden = NO;
        cell.rightLab.hidden = NO;
    }else if ([model.type isEqualToString:@"will_activity"]){
        //预告
        [cell.typeImg setImage:IMAGE(@"livemembers_details_icon_trailer")];
        [cell.leftImg setImage:IMAGE(@"homepage_yure_hot_icon")];
        [cell.rightImg setImage:IMAGE(@"homepage_follow_icon")];
        cell.leftLab.text = [NSString stringWithFormat:@"%@热度",listModel.live_users];
        cell.rightLab.text = [NSString stringWithFormat:@"%@人关注",listModel.live_like];
        cell.titleLab.text = [NSString stringWithFormat:@" %@",listModel.name];
        cell.rightImg.hidden = NO;
        cell.rightLab.hidden = NO;
    }else if ([model.type isEqualToString:@"end_activity"]){
        //回放
        [cell.typeImg setImage:IMAGE(@"livemembers_details_icon_playback")];
        [cell.leftImg setImage:IMAGE(@"homepage_wathchnumber_icon")];
        cell.rightImg.hidden = YES;
        cell.leftLab.text = [NSString stringWithFormat:@"%@人观看",listModel.live_users];
        cell.rightLab.hidden = YES;
        cell.titleLab.text = [NSString stringWithFormat:@" %@",listModel.name];
    }else{
        
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LiveDetailSectionModel *model = self.dataArr[indexPath.section];
    LiveDetailListDataModel *listModel = model.data[indexPath.row];
    NSString *typeStr = @"";
    if ([model.type isEqualToString:@"start_activity"]) {
        //直播中
        typeStr = @"直播中";
        
    }else if ([model.type isEqualToString:@"will_activity"]){
        //预告
        typeStr = @"预告";
    }else if ([model.type isEqualToString:@"end_activity"]){
        //回放
        typeStr = @"回放";
    }else{
        typeStr = @"其他";
    }
    if (self.didcell) {
        self.didcell(indexPath,listModel,typeStr);
    }
}

-(void)viewDidLayoutSubviews
{
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - ImagePlayerViewDelegate
- (NSInteger)numberOfItems
{
    return self.bannerModel.image.count;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    // recommend to use SDWebImage lib to load web image
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    if (self.bannerModel.image.count == 0) {
        
    }else{
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.bannerModel.image[index]] placeholderImage:YPCImagePlaceHolder];
    }
    [imageView setupImageViewerWithDatasource:self initialIndex:index onOpen:^{
        NSLog(@"OPEN!");
    } onClose:^{
        NSLog(@"CLOSE!");
    }];
    imageView.clipsToBounds = YES;
    
}
- (NSInteger) numberImagesForImageViewer:(MHFacebookImageViewer *)imageViewer {
    return self.bannerModel.image.count;
}
-  (NSURL*) imageURLAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer {
   // ShoppingImgsModel *model = self.model.image[index];
    return [NSURL URLWithString:self.bannerModel.image[index]];
}

- (UIImage*) imageDefaultAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer{
    return YPCImagePlaceHolder;
}

@end
