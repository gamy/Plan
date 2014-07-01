//
//  ImageManager.m
//  Plan
//
//  Created by gamyhuang on 14-7-1.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import "ImageManager.h"
#import "LevelDB.h"

@implementation ImageManager

- (id)init
{
    self = [super init];
    if (self) {
        self.db.encoder = ^(LevelDBKey * key, UIImage* object){
            return [object data];
        };
        self.db.decoder = ^(LevelDBKey * key, NSData *data){
            return [UIImage imageWithData:data];
        };
    }
    return self;
}


CM_IMPLEMENT(Image,UIImage)


@end
