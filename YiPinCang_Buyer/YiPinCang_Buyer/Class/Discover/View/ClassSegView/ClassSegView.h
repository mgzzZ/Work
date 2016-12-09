//
//  ClassSegView.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/9.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClassBackIdBlock)(NSString *class_id);
@interface ClassSegView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableDictionary *dataDic;
@property (nonatomic,strong)NSArray *keysArr;
@property (nonatomic,assign)NSInteger oldSection;
@property (nonatomic,assign)NSInteger oldRow;
@property (nonatomic,copy)NSString *brand;
@property (nonatomic,copy)NSString *bind;
@property (nonatomic,copy)ClassBackIdBlock classBackId;
@end
