//
//  APKernel.m
//  crud_axosnet
//
//  Created by Alexis Porras on 25/02/21.
//

#import "APKernel.h"

#import "MainMenuViewController.h"

#define USER_DEFAULTS_WELCOME_DONE @"USER_DEFAULTS_WELCOME_DONE"

@implementation APKernel

static APKernel* instance;
+ (APKernel*)sharedInstance
{
    if (!instance){
        instance = [[self alloc] init];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        instance.welcomeDone = [[defaults valueForKey:USER_DEFAULTS_WELCOME_DONE] boolValue];
        
    }
    
    return instance;
}

static AppMode _appMode = AppModeUndefined;
+ (AppMode)getAppMode
{
    if (_appMode == AppModeUndefined){
        if(![APKernel sharedInstance].welcomeDone)
            _appMode = AppModeWelcome;
        else
            _appMode = AppModeUser;
    }
    
    return _appMode;
}

+ (void)reloadAppRoot
{
    id window = [[[UIApplication sharedApplication] windows] firstObject];
    if (window && [window isKindOfClass:[UIWindow class]]){
        id rootController = [window rootViewController];
        if (rootController && [rootController isKindOfClass:[MainMenuViewController class]])
            [rootController reloadRootViewController];
    }
}

static NSDateFormatter *_dateFormatter;
+ (NSDateFormatter*)dateFormatter
{
    if (_dateFormatter == nil)
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"dd/MM/yyyy - HH:mm";

    }
    
    return _dateFormatter;
}

+ (void)presentMessageAlert:(NSString *)message withTitle:(NSString*)title toController:(UIViewController *)controller
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:NULL];
    [alertController addAction:ok];
    
    [controller presentViewController:alertController animated:YES completion:nil];
}

+ (void)presentDecisionAlert:(NSString*)message withTitle:(NSString*)title withButton:(UIAlertAction*)decisionButton toController:(UIViewController *)controller
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Cancelar"
                               style:UIAlertActionStyleDefault
                               handler:NULL];
    
    [alert addAction:noButton];
    [alert addAction:decisionButton];
    
    [controller presentViewController:alert animated:YES completion:nil];
}

+ (void)presentViewController:(UIViewController*)presentedViewControler toMenuController:(UIViewController*)presentingViewControler
{
    if (presentingViewControler.splitViewController){
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:presentedViewControler];
        
        [presentingViewControler.splitViewController showDetailViewController:navigationController sender:nil];
    }
}

- (void)setDoneWelcome:(BOOL)welcomeDone
{
    if (_welcomeDone != welcomeDone){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:@(welcomeDone) forKey:USER_DEFAULTS_WELCOME_DONE];
        [defaults synchronize];
        
        _welcomeDone = welcomeDone;
        _appMode = AppModeUndefined;
        
        [APKernel reloadAppRoot];
    }
}
@end
