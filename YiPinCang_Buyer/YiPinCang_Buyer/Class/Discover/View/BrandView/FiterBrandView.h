//
//  FiterBrandView.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/11/11.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BackIdBlock)(NSString *brand,NSString *bind);

@interface FiterBrandView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableDictionary *dataDic;
@property (nonatomic,strong)NSArray *keysArr;
@property (nonatomic,assign)NSInteger oldSection;
@property (nonatomic,assign)NSInteger oldRow;
@property (nonatomic,copy)NSString *brand;
@property (nonatomic,copy)NSString *bind;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UIButton *resetBtn;
@property (nonatomic,strong)UIButton *finishBtn;
@property (nonatomic,copy)BackIdBlock backId;
@end
