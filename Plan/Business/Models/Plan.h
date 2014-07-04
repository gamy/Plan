//
//  Plan.h
//  Plan
//
//  Created by gamyhuang on 14-6-25.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    PlanStatusNormal = 0,
    PlanStatusDone = 1,
    PlanStatusDelete = 2
} PlanStatus;

@class Item;
@interface Plan : Model

@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSDate * modifyDate;
@property (nonatomic, assign) PlanStatus status;
- (NSMutableArray *)items;
- (NSInteger)totalPrice;

@end



@interface PlanManager:ModelManager

@end
