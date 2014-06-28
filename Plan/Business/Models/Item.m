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

- (NSString *)priceDescription
{
    NSString *priceString = 0;
    if (self.price == 0) {
        priceString = @"";
    }else if(self.price - (int)(self.price) < 0.01){
        priceString = [NSString stringWithFormat:@"%d", (int)self.price];
    }else{
        priceString = [NSString stringWithFormat:@"%.1f",self.price];
    }
    return priceString;
}

- (NSString *)savedKey
{
    return self.cid;
}

@end


@implementation ItemManager


- (Class)modeClass
{
    return [Item class];
}

- (NSMutableArray *)itemsForPlanId:(NSString *)planId
{
    
    NSMutableArray *list = [NSMutableArray array];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.planId = %@",planId];
    [self.db enumerateKeysAndObjectsBackward:YES lazily:NO startingAtKey:nil filteredByPredicate:predicate andPrefix:nil usingBlock:^(LevelDBKey * key, id value, BOOL *stop)
    {
        [list addObject:value];
    }];
    return list;
}

@end