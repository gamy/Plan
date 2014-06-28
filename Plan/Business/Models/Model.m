//
//  Model.m
//  Plan
//
//  Created by gamyhuang on 14-6-28.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import "Model.h"

@implementation Model

- (id)init
{
    self = [super init];
    if (self) {
        _cid = [NSString UUID];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self autoEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    [self autoDecode:aDecoder];
    return self;
}

- (NSString *)description
{
    return [self autoDescription];
}

+ (NSComparator)comparator
{
    return  ^(id obj1, id obj2){
        return NSOrderedSame;
    };
}

- (NSString *)savedKey{
    return self.cid;
}

- (BOOL)isEqual:(id)object
{
    return [self.cid isEqual:[object cid]];
}

- (NSUInteger)hash{
    return [self.cid hash];
}

@end


@implementation ModelManager
{
    NSMutableArray *_models;
}

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

@implementation ModelManager(Access)


- (id)createModel
{
    Model *model = [[self modeClass] new];
    [self addModel:model];
    return model;
}

- (void)addModel:(Model *)model
{
    if (model == nil) {
        return;
    }
    if (![_db objectExistsForKey:model.savedKey]) {
        if (!_models) {
            //load models
            [self allModels];
        }
        [_models insertObject:model atIndex:0];
    }
    [self saveModel:model];
}

- (void)saveModel:(Model *)model
{
    [_db setObject:model forKey:model.savedKey];
}
- (id)modelForKey:(NSString *)key
{
    return [_db objectForKey:key];
}

- (void)deleteModel:(Model *)model
{
    if (model) {
        [_models removeObject:model];
        [_db removeObjectForKey:model.savedKey];
    }
}

- (void)deleteModelForKey:(NSString *)key
{
    [_db removeObjectForKey:key];
}

- (NSMutableArray *)allModels
{
    
    if (_models == nil) {
        NSLog(@"models is nil, load from db");
        _models = [NSMutableArray array];
        //Load from db
        [_db enumerateKeysAndObjectsUsingBlock:^(LevelDBKey *key, id value, BOOL *stop) {
            if (value) {
                [_models addObject:value];
            }
        }];
        [_models sortUsingComparator:[[self modeClass] comparator]];
    }
    return _models;
}

- (void)clearModels
{
    [_models removeAllObjects];
    [_db removeAllObjects];
}


- (NSMutableArray *)reloadModels
{
    _models = nil;
    return [self allModels];
}

- (NSMutableArray *)sortModels
{
    [_models sortUsingComparator:[[self modeClass] comparator]];
    return _models;
}


@end
