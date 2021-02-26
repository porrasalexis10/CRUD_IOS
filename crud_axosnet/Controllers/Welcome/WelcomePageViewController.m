//
//  WelcomePageViewController.m
//  crud_axosnet
//
//  Created by Alexis Porras on 25/02/21.
//

#import "WelcomePageViewController.h"

@interface WelcomePageViewController ()
{
    NSArray *viewControllers;
}
@end

@implementation WelcomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.dataSource = self;
    

    UIViewController *first = [self.storyboard instantiateViewControllerWithIdentifier:@"firstPage"];
    UIViewController *second = [self.storyboard instantiateViewControllerWithIdentifier:@"secondPage"];
    UIViewController *third = [self.storyboard instantiateViewControllerWithIdentifier:@"thirdPage"];
    UIViewController *fourth = [self.storyboard instantiateViewControllerWithIdentifier:@"fourthPage"];
    
    viewControllers = @[first, second, third, fourth];
    [self setViewControllers:@[first]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return [viewControllers count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {

    NSInteger nextIndex = [viewControllers indexOfObject:viewController] +1;
    if (nextIndex < viewControllers.count)
        return viewControllers[nextIndex];
    
     return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger previousIndex = [viewControllers indexOfObject:viewController] -1;
    if (previousIndex >= 0)
        return viewControllers[previousIndex];
    
    return nil;
}

//
//- (void)nextPage{
////    [self setPageIndex:2];
//    [self setViewControllers:@[fifth]
//     direction:UIPageViewControllerNavigationDirectionForward
//      animated:YES
//    completion:nil];
//}
@end
