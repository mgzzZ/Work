#import <UIKit/UIKit.h>
#import "LiveSimpleInfo.h"
#import "LiveSimpleList.h"
@class LiveSimpleInfo;
@class LiveSimpleList;
@interface LiveSimpleModel : NSObject

@property (nonatomic, strong) LiveSimpleInfo * info;
@property (nonatomic, strong) LiveSimpleList * list;
@end
