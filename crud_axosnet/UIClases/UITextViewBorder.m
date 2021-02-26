//
//  UITextViewBorder.m
//  crud_axosnet
//
//  Created by Alexis Porras on 25/02/21.
//

#import "UITextViewBorder.h"

@implementation UITextViewBorder
{
    CALayer *_underlineBorder;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    if (_underlineBorder == nil && self.borderlineColor && self.justUnderline)
    {
        _underlineBorder = [CALayer layer];
        CGFloat borderWidth = 1.0;
        _underlineBorder.borderColor = self.borderlineColor.CGColor;
        _underlineBorder.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, self.frame.size.height);
        _underlineBorder.borderWidth = borderWidth;
        [self.layer addSublayer:_underlineBorder];
        
        self.layer.masksToBounds = YES;
        
        self.backgroundColor = [UIColor systemGray6Color];
    }
    else if (self.borderlineColor)
    {
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = 3.0f;
        self.layer.borderColor = self.borderlineColor.CGColor;
    }
    
    self.layer.cornerRadius = 10.0f;
}

@end
