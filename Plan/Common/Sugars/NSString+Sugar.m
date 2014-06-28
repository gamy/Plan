//
//  NSString+Sugar.m
//  Plan
//
//  Created by gamyhuang on 14-6-28.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import "NSString+Sugar.h"

@implementation NSString (Sugar)


 + (NSString *)UUID
{
    CFUUIDRef uuidRef =CFUUIDCreate(NULL);
    
    CFStringRef uuidStringRef =CFUUIDCreateString(NULL, uuidRef);
    
    CFRelease(uuidRef);
    
    NSString *uniqueId = (__bridge NSString *)(uuidStringRef);
    
    CFRelease(uuidStringRef);
    
    return uniqueId;
}

@end
