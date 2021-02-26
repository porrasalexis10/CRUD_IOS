//
//  UITextFieldBorder.m
//  crud_axosnet
//
//  Created by Alexis Porras on 25/02/21.
//

#import "UITextFieldBorder.h"

@implementation UITextFieldBorder
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
        
        self.backgroundColor = [UIColor clearColor];
    }
    else if (self.borderlineColor && !self.justUnderline)
    {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 7.5f;
        self.layer.borderColor = self.borderlineColor.CGColor;
    }
}


// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 0);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 0);
}

- (void)changeOverlineColor:(UIColor *)color
{
    if (self.justUnderline){
        if (color)
            _underlineBorder.borderColor = color.CGColor;
        else if (self.borderlineColor)
            _underlineBorder.borderColor = self.borderlineColor.CGColor;
        
        [_underlineBorder setNeedsDisplay];
    } else {
        if (color)
            self.layer.borderColor = color.CGColor;
        else if (self.borderlineColor)
            self.layer.borderColor = self.borderlineColor.CGColor;
        
        [self.layer setNeedsDisplay];
    }
}

@end
