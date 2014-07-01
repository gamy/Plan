//
//  Model.h
//  Plan
//
//  Created by gamyhuang on 14-6-28.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+NSCoding.h"
#import "NSObject+AutoDescription.h"
#import "CommonManager.h"

@interface Model : NSObject<NSCoding>

@property (nonatomic, readonly) NSString * cid;


- (NSString *)savedKey;

+ (NSComparator)comparator;

@end


@interface ModelManager : CommonManager


@end


@interface ModelManager (Access)

- (id)createModel;
- (void)addModel:(Model *)model;
- (void)saveModel:(Model *)model;
- (id)modelForKey:(NSString *)key;
- (void)deleteModel:(Model *)model;
- (void)deleteModelForKey:(NSString *)key;

- (NSMutableArray *)allModels;

- (NSMutableArray *)reloadModels;

- (NSMutableArray *)sortModels;

- (void)clearModels;

@end