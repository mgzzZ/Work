//
//  LiveNoteView.h
//  YiPinCang_Buyer
//
//  Created by YPC on 16/12/6.
//  Copyright © 2016年 Laomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveNoteModel.h"
typedef void(^NoteDidcellBlock)(NSIndexPath *index,LiveNoteModel *model);
@interface LiveNoteView : UITableView
+ (LiveNoteView *)contentTableView;
@property (nonatomic,strong)NSString *store_id;
@property (nonatomic,copy)NoteDidcellBlock notedidcell;
@end
