//
//  CommonManager.h
//  Plan
//
//  Created by gamyhuang on 14-7-1.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonManager : NSObject

@property(nonatomic, readonly) LevelDB *db;

+ (instancetype)sharedManager;
- (BOOL)needLevelDB;
- (Class)modeClass;

@end



#define CM_INTERFACE(name, clazz)\
- (void)set##name:(clazz *)object forKey:(NSString *)key;\
- (clazz *)name##ForKey:(NSString *)key;\
- (NSString *)save##name:(clazz *)name;\
- (void)remove##name##ForKey:(NSString *)key;\

#define CM_IMPLEMENT(name, clazz)\
- (void)set##name:(clazz *)object forKey:(NSString *)key{\
    [self setObject:object forKey:key];\
}\
- (clazz *)name##ForKey:(NSString *)key{\
    return [self objectForKey:key];\
}\
- (void)remove##name##ForKey:(NSString *)key{\
    [self removeObjectForKey:key];\
}\
- (NSString *)save##name:(clazz *)name{\
    return [self saveObject:name];\
}\




@interface DataManager: CommonManager

- (NSString *)saveObject:(id)object;
- (void)removeObjectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;

@end;