//
//  APKernel.h
//  crud_axosnet
//
//  Created by Alexis Porras on 25/02/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    AppModeUndefined,
    AppModeWelcome,
    AppModeUser
} AppMode;

@interface APKernel : NSObject
@property (readwrite, nonatomic) BOOL welcomeDone;

+ (APKernel*)sharedInstance;
+ (AppMode)getAppMode;

+ (void)presentMessageAlert:(NSString *)message withTitle:(NSString*)title toController:(UIViewController *)controller;
+ (void)presentDecisionAlert:(NSString*)message withTitle:(NSString*)title withButton:(UIAlertAction*)decisionButton toController:(UIViewController *)controller;
+ (void)presentViewController:(UIViewController*)presentedViewControler toMenuController:(UIViewController*)presentingViewControler;

- (void)setDoneWelcome:(BOOL)welcomeDone;

+ (NSDateFormatter *)dateFormatter;
@end
