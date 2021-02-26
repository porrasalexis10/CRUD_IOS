//
//  MainMenuViewController.h
//  crud_axosnet
//
//  Created by Alexis Porras on 25/02/21.
//

#import <UIKit/UIKit.h>

@interface MainMenuViewController : UIViewController

- (void)reloadRootViewController;
- (void)showNotificationWithAction:(NSInteger)actionKind andID:(id)actionID andBody:(id)actionBody;
@end
