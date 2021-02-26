//
//  UIImageViewRounded.m
//  crud_axosnet
//
//  Created by Alexis Porras on 25/02/21.
//

#import "UIImageViewRounded.h"

@implementation UIImageViewRounded

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = self.frame.size.width/2.0f;
}
@end
