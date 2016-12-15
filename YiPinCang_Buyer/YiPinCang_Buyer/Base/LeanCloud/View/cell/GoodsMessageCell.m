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

@interface GoodsMessageCell ()
@property (nonatomic, weak) GoodsMessageView *gmView;
@property (nonatomic, strong) OrderDetailModel *dataModel;
@end

static CGFloat LCCK_MSG_SPACE_TOP = 10;
static CGFloat LCCK_MSG_SPACE_BTM = 10;
static CGFloat LCCK_MSG_SPACE_LEFT = 20;
static CGFloat LCCK_MSG_SPACE_RIGHT = 20;

@implementation GoodsMessageCell

- (void)setup {
    self.fd_enforceFrameLayout = YES;
    [self.gmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(LCCK_MSG_SPACE_TOP, LCCK_MSG_SPACE_LEFT, LCCK_MSG_SPACE_BTM, LCCK_MSG_SPACE_RIGHT));
    }];
    [self updateConstraintsIfNeeded];
    [super setup];
}

- (CGSize)sizeThatFits:(CGSize)size {
    
    return CGSizeMake(size.width, 190.f);
}

- (void)configureCellWithData:(AVIMTypedMessage *)message {
    [super configureCellWithData:message];
    
    [YPCNetworking postWithUrl:@"shop/orders/detail"
                  refreshCache:YES
                        params:[YPCRequestCenter getUserInfoAppendDictionary:@{
                                                                               @"order_id" : [message.attributes valueForKey:@"orderID"]
                                                                               }]
                       success:^(id response) {
                           if ([YPC_Tools judgeRequestAvailable:response]) {
                               self.dataModel = [OrderDetailModel mj_objectWithKeyValues:response[@"data"]];
                               [self.gmView configureWithModel:self.dataModel];
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
    GoodsMessageView *gmV = [GoodsMessageView GoodsMessageView];
    [gmV setGoodsMesViewClickBlock:^(id object) {
        
        id ob = [self nextResponder];
        while (![ob isKindOfClass:[UIViewController class]] && ob != nil) {
            ob = [ob nextResponder];
        }
        UIViewController *currentVC = (LCCKBaseConversationViewController *)ob;
        OrderDetailVC *detailVC = [OrderDetailVC new];
        detailVC.order_id = self.dataModel.order_id;
        [currentVC.navigationController pushViewController:detailVC animated:YES];
        
    }];
    [self.contentView addSubview:(_gmView = gmV)];
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
