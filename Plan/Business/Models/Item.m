//
//  Item.m
//  Plan
//
//  Created by gamyhuang on 14-6-25.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import "Item.h"
#import "Plan.h"


@implementation Item

- (instancetype)init
{    
    self = [super init];
    if (self) {
        self.title = @"未命名";
        self.createDate = [NSDate date];
        self.modifyDate = self.createDate;
        self.status = PlanStatusNormal;
        self.price = 0;
    }
    return self;
}


- (NSString *)savedKey
{
    return self.cid;
}

+ (NSComparator)comparator
{
    return  ^(id obj1, id obj2){
        Plan *p1 = obj1;
        Plan *p2 = obj2;
        if ([p1.modifyDate isEqualToDate:p2.modifyDate]) {
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending;
        }
    };
}

@end


@implementation ItemManager


- (Class)modeClass
{
    return [Item class];
}

@end