//
//  CommonManager.m
//  Plan
//
//  Created by gamyhuang on 14-7-1.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import "CommonManager.h"

@implementation CommonManager

- (Class)modeClass
{
    return [Model class];
}


- (BOOL)needLevelDB
{
    return YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([self needLevelDB]) {
            NSLog(@"init data base = %@", NSStringFromClass([self class]));
            _db = [LevelDB databaseInLibraryWithName:NSStringFromClass([self class])];
        }
    }
    return self;
}

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static NSMutableDictionary *managerDict = nil;
    dispatch_once(&onceToken, ^{
        managerDict = [NSMutableDictionary dictionary];
    });
    NSString *key = NSStringFromClass(self);
    id manager = managerDict[key];
    if (manager == nil) {
        manager = [[self alloc] init];
        managerDict[key] = manager;
    }
    return manager;
}

@end


@implementation DataManager

- (NSString *)saveObject:(id)object
{
    if (object) {
        NSString *key = [NSString UUID];
        [self.db setObject:object forKey:key];
        return key;
    }
    return nil;
}
- (void)removeObjectForKey:(NSString *)key
{
    NSLog(@"<removeObjectForKey>, key = %@", key);
    if (key) {
        [self.db removeObjectForKey:key];
    }
}
- (void)setObject:(id)object forKey:(NSString *)key
{
    if (key) {
        [self.db setObject:object forKey:key];
    }
}
- (id)objectForKey:(NSString *)key
{
    if (key) {
        return [self.db objectForKey:key];
    }
    return nil;
}


@end