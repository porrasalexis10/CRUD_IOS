//
//  TableViewCell.h
//  crud_axosnet
//
//  Created by Alexis Porras on 25/02/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *cellIdentifier = @"exampleCell";
@interface TableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

@property (readwrite, nonatomic) id parentController;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
