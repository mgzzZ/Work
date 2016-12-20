//
//  FloatingViewController.h
//  Unity-iPhone
//
//  Created by Xinhou Jiang on 6/13/16.
//
//

//http://www.myexception.cn/operating-system/1924022.html

#import <UIKit/UIKit.h>

@interface FloatingViewController : UIViewController

@property (nonatomic, assign) BOOL isHiddenOnWindow;
@property (nonatomic, strong) LCCKConversationViewController *conversationVC;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *index;


- (void)removeFromWindow;

@end
