//
//  GoodsMessageCell.m
//  TaoFactory_Seller
//
//  Created by 孟镇 on 16/10/7.
//  Copyright © 2016年 YPC_mz. All rights reserved.
//

#import "GoodsMessageCell.h"
#import "GoodsMessage.h"
#import "GoodsMessageView.h"
#import "OrderDetailModel.h"
#import "OrderDetailVC.h"
#import "OrderGoodsInfoModel.h"

@interface GoodsMessageCell ()
@property (nonatomic, weak) GoodsMessageView *gmView;
@property (nonatomic, strong) OrderDetailModel *dataModel;
@property (nonatomic, copy) NSString *index;
@end

static CGFloat LCCK_MSG_SPACE_TOP = 10;
static CGFloat LCCK_MSG_SPACE_BTM = 10;
static CGFloat LCCK_MSG_SPACE_LEFT = 0;
static CGFloat LCCK_MSG_SPACE_RIGHT = 0;

@implementation GoodsMessageCell

- (void)setup {
    WS(weakSelf);
    self.fd_enforceFrameLayout = YES;
    self.contentView.layer.cornerRadius = 10.f;
    self.contentView.clipsToBounds = YES;
    [self.gmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).with.insets(UIEdgeInsetsMake(LCCK_MSG_SPACE_TOP, LCCK_MSG_SPACE_LEFT, LCCK_MSG_SPACE_BTM, LCCK_MSG_SPACE_RIGHT));
    }];
    [self updateConstraintsIfNeeded];
    [super setup];
}

- (CGSize)sizeThatFits:(CGSize)size {
    
    return CGSizeMake(size.width, 180.f);
}

- (void)configureCellWithData:(AVIMTypedMessage *)message{
    [super configureCellWithData:message];
    
    WS(weakSelf);
    [YPCNetworking postWithUrl:@"shop/orders/detail"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"order_id" : [message.attributes valueForKey:@"orderID"]
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               weakSelf.dataModel = [OrderDetailModel mj_objectWithKeyValues:response[@"data"]];
                               weakSelf.index = [message.attributes valueForKey:@"index"];
                               [weakSelf.gmView configureWithModel:weakSelf.dataModel andDataIndex:weakSelf.index];
                           }
                       }
                          fail:^(NSError *error) {
                              [YPC_Tools showSvpHudError:@"订单信息发送失败"];
                          }];
}

+ (void)load {
    [self registerCustomMessageCell];
}

+ (AVIMMessageMediaType)classMediaType {
    return LeanCloudCustomMessageGoods;
}

- (GoodsMessageView *)gmView
{
    if (_gmView) {
        return _gmView;
    }
    WS(weakSelf);
    GoodsMessageView *gmV = [GoodsMessageView GoodsMessageViewWithGoodsCount:[self.dataModel.goodsinfo.firstObject goods].count];
    [gmV setGoodsMesViewClickBlock:^(id object) {
        
        id ob = [weakSelf nextResponder];
        while (![ob isKindOfClass:[UIViewController class]] && ob != nil) {
            ob = [ob nextResponder];
        }
        UIViewController *currentVC = (LCCKBaseConversationViewController *)ob;
        OrderDetailVC *detailVC = [OrderDetailVC new];
        detailVC.order_id = [(OrderGoodsInfoModel *)weakSelf.dataModel.goodsinfo[weakSelf.index.integerValue] store].order_id;
        [currentVC.navigationController pushViewController:detailVC animated:YES];
        
    }];
    [weakSelf.contentView addSubview:(_gmView = gmV)];
    return _gmView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
