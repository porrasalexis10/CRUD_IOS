//
//  UIColor+Colors.m
//  crud_axosnet
//
//  Created by Alexis Porras on 25/02/21.
//


#import "UIColor+Colors.h"

@implementation UIColor (Colors)
+ (UIColor*)primaryColor{
    return [UIColor colorNamed:@"PrimaryColor"];
}

+ (UIColor*)secondaryColor{
    return [UIColor colorNamed:@"SecondaryColor"];
}

+ (UIColor*)accentColor{
    return [UIColor colorNamed:@"AccentColor"];
}
@end
