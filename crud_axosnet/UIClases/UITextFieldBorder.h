//
//  UITextFieldBorder.h
//  crud_axosnet
//
//  Created by Alexis Porras on 25/02/21.
//

#import <UIKit/UIKit.h>

@interface UITextFieldBorder : UITextField

@property (nonatomic) IBInspectable UIColor *borderlineColor;
@property (nonatomic) IBInspectable BOOL justUnderline;

- (void)changeOverlineColor:(UIColor *)color;

@end
