//
//  Plan.m
//  Plan
//
//  Created by gamyhuang on 14-6-25.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import "Plan.h"
#import "item.h"

@implementation Plan

- (instancetype)init
{    
    self = [super init];
    if (self) {
        self.createDate = [NSDate date];
        self.modifyDate = self.createDate;
        self.status = PlanStatusNormal;
    }
    return self;
}

-(NSString *)title
{
    if ([_title length] == 0) {
        _title = @"未命名";
    }
    return _title;
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

- (NSMutableArray *)items
{
    return [[ItemManager sharedManager] itemsForPlanId:self.cid];
}

@end


@implementation PlanManager


- (Class)modeClass
{
    return [Plan class];
}

- (void)deleteModel:(Model *)model
{
    Plan *plan = (Plan *)model;
    NSArray *temp = [plan.items copy];
    for (Item *item in temp) {
        [[ItemManager sharedManager] deleteModel:item];
    }
    [super deleteModel:model];
}



@end