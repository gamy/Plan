//
//  Plan.m
//  Plan
//
//  Created by gamyhuang on 14-6-25.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import "Plan.h"


@implementation Plan

- (instancetype)init
{    
    self = [super init];
    if (self) {
        self.title = @"未命名";
        self.createDate = [NSDate date];
        self.modifyDate = self.createDate;
        self.status = PlanStatusNormal;
    }
    return self;
}

+ (NSComparator)comparator
{
    return  ^(id obj1, id obj2){
        Plan *p1 = obj1;
        Plan *p2 = obj2;
        if ([p1.modifyDate timeIntervalSinceDate:p2.modifyDate] < 0){
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending;
        }
    };
}


@end


@implementation PlanManager


- (Class)modeClass
{
    return [Plan class];
}

@end