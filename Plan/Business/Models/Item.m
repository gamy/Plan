//
//  Item.m
//  Plan
//
//  Created by gamyhuang on 14-6-25.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import "Item.h"
#import "Plan.h"
#import "ImageManager.h"

@implementation Item
{
    NSMutableDictionary *imageDict;
}
- (instancetype)init
{    
    self = [super init];
    if (self) {
        self.createDate = [NSDate date];
        self.modifyDate = self.createDate;
        self.status = PlanStatusNormal;
        self.price = 0;
    }
    return self;
}

- (NSString *)title
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

- (UIImage *)imageForKey:(NSString *)key
{
    if (!key) {
        return nil;
    }
    if (!imageDict) {
        imageDict = [NSMutableDictionary dictionary];
    }
    UIImage *image = imageDict[key];
    if (image == nil) {
        image = [[ImageManager sharedManager] ImageForKey:key];
        if (image) {
            imageDict[key] = image;
        }
    }
    return image;
}

- (void)clearImageCache
{
    [imageDict removeAllObjects];
}

- (void)setImage:(UIImage *)image ForKey:(NSString *)key
{
    if (key) {
        imageDict[key] = image;
        [[ImageManager sharedManager] setImage:image forKey:key];
    }
}
- (void)addImage:(UIImage *)image
{
    if (image) {
        NSString *key = [[ImageManager sharedManager] saveImage:image];
        [self.imageKeys addObject:key];
        [imageDict setObject:image forKey:key];
    }
}
- (void)removeImageWithKey:(NSString *)key
{
    if (key) {
        [[ImageManager sharedManager] removeImageForKey:key];
        [self.imageKeys removeObject:key];
        [imageDict removeObjectForKey:key];
    }
}

- (void)removeAllImages
{
    NSArray *temp = [self.imageKeys copy];
    for (NSString *key in temp) {
        [self removeImageWithKey:key];
    }
}

- (NSMutableArray *)imageKeys
{
    if (_imageKeys == nil) {
        _imageKeys = [NSMutableArray array];
    }
    return _imageKeys;
}

- (UIImage *)firstImage
{
    if ([self.imageKeys count] > 0) {
        UIImage *image = [self imageForKey:self.imageKeys[0]];
        return image;
    }
    return nil;
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

- (void)deleteModel:(Model *)model
{
    [(Item *)model removeAllImages];
    [super deleteModel:model];
}


@end