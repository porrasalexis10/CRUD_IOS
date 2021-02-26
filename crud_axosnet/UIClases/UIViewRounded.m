//
//  UIViewRounded.m
//  crud_axosnet
//
//  Created by Alexis Porras on 25/02/21.
//

#import "UIViewRounded.h"

@implementation UIViewRounded

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10.0f;
}

@end
