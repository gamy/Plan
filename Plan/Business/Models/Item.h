//
//  Item.h
//  Plan
//
//  Created by gamyhuang on 14-6-25.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    ItemStatusNormal = 0,
    ItemStatusDone = 1,
    ItemStatusDelete = 2
} ItemStatus;


@interface Item : Model


@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSDate * modifyDate;
@property (nonatomic, assign) ItemStatus status;

@property (nonatomic, assign) CGFloat price;
@property (nonatomic, copy) NSString *planId;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, strong)NSMutableArray *images;

- (NSString *)priceDescription;

@end


@interface ItemManager : ModelManager
{

}

- (NSMutableArray *)itemsForPlanId:(NSString *)planId;

@end