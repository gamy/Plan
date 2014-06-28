//
//  GMDevice.h
//  Plan
//
//  Created by gamyhuang on 14-6-28.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMDevice : NSObject

+ (BOOL)is4InchScreen;
+ (BOOL)iOS7;
+ (BOOL)iOS6;
+ (BOOL)retinaDisplay;

+ (CGFloat)systemVersion;
+ (NSString *)systemVersionString;

+ (BOOL)canAccessCamera;
+ (BOOL)canAccessAlbum;
+ (BOOL)needRequestAccessForCamera;
+ (BOOL)needRequestAccessForAlbum;
+ (void)requestAccessForCameraWithCompletion:(void (^)(BOOL granted))handler;
+ (void)requestAccessForAlbumWithCompletion:(void (^)(BOOL granted))handler;


@end
