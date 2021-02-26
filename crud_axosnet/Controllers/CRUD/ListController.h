//
//  ViewController.h
//  crud_axosnet
//
//  Created by Alexis Porras on 25/02/21.
//

#import <UIKit/UIKit.h>

@interface ListController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *emptyLabel;
@end

