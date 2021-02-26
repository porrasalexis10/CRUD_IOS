//
//  FinishWelcomeViewController.m
//  crud_axosnet
//
//  Created by Alexis Porras on 25/02/21.
//

#import "FinishWelcomeViewController.h"
#import "APKernel.h"

@interface FinishWelcomeViewController ()

@end

@implementation FinishWelcomeViewController


- (IBAction)dismisController:(id)sender {
    [[APKernel sharedInstance] setDoneWelcome:YES];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CRUD" bundle:nil];
    UIViewController *viewController = [storyboard instantiateInitialViewController];
    [self.view.window setRootViewController: viewController];
}
@end

