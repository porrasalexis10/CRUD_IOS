//
//  MainMenuViewController.m
//  crud_axosnet
//
//  Created by Alexis Porras on 25/02/21.
//

#import "MainMenuViewController.h"
#import "APKernel.h"


@interface MainMenuViewController ()
{
    AppMode _appMode;
    
}
@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
            
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadRootViewController];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    UIStoryboard *storyboard;
    
    if (_appMode == AppModeWelcome){
        storyboard = [UIStoryboard storyboardWithName:@"Welcome" bundle:nil];
        [self presentViewController:[storyboard instantiateInitialViewController] animated:YES completion:NULL];
    }else{
        storyboard = [UIStoryboard storyboardWithName:@"CRUD" bundle:nil];
        [self presentViewController:[storyboard instantiateInitialViewController] animated:YES completion:NULL];
    }
    

    UIViewController *viewController = [storyboard instantiateInitialViewController];
    [self.view.window setRootViewController: viewController];
}
- (void)reloadRootViewController
{
    AppMode appMode = [APKernel getAppMode];
    if (_appMode != appMode)
    {
        _appMode = appMode;
        
        UIStoryboard *storyboard;
        BOOL menuNavigationViewController = NO;
        switch ([APKernel getAppMode]) {
            case AppModeUser:
                storyboard = [UIStoryboard storyboardWithName:@"CRUD" bundle:nil];
                menuNavigationViewController = YES;
                break;
            case AppModeWelcome:
                storyboard = [UIStoryboard storyboardWithName:@"Welcome" bundle:nil];
                break;
            default:
                break;
        }

        UIViewController *navigationController = [storyboard instantiateInitialViewController];
        [self presentViewController:navigationController animated:YES completion:nil];        
    }
}
@end

