//
//  FormViewController.h
//  crud_axosnet
//
//  Created by Alexis Porras on 25/02/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FormViewController : UIViewController <UITextViewDelegate>
@property (readwrite, nonatomic) id parentController;
@property (readwrite, nonatomic) NSDictionary *parentRow;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UITextField *providerTextField;
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) IBOutlet UITextField *codeTextField;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;

@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

NS_ASSUME_NONNULL_END
