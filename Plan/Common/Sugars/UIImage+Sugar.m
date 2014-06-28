//
//  UIImage+Sugar.m
//  Plan
//
//  Created by gamyhuang on 14-6-28.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import "UIImage+Sugar.h"

@implementation UIImage (Sugar)

- (NSData *)data
{
    return UIImageJPEGRepresentation(self, 1.0f);
}



@end
