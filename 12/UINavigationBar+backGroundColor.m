//
//  UINavigationBar+backGroundColor.m
//  12
//
//  Created by 王吉吉 on 2016/11/17.
//  Copyright © 2016年 王喆. All rights reserved.
//

#import "UINavigationBar+backGroundColor.h"

@implementation UINavigationBar (backGroundColor)
static char overlayKey;

- (UIView *)overlay
{    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)lt_setBackgroundColor:(UIColor *)backgroundColor
{    if (!self.overlay) {
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:[UIImage new]];        // insert an overlay into the view hierarchy
    self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 64)];
    self.overlay.userInteractionEnabled = NO;
    [self insertSubview:self.overlay atIndex:0];
    
}    self.overlay.backgroundColor = backgroundColor;
}
@end
