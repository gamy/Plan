//
//  UIView+Sugar.m
//  Plan
//
//  Created by gamyhuang on 14-6-29.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import "UIView+Sugar.h"

@implementation UIView (Sugar)

- (UIView*)firstResponder
{
    for ( UIView *childView in self.subviews ) {
        if ([childView isFirstResponder]) return childView;
        UIView *result = [childView firstResponder];
        if (result) return result;
    }
    return nil;
}

@end
