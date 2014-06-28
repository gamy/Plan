//
//  GMDevice.m
//  Plan
//
//  Created by gamyhuang on 14-6-28.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

@import AVFoundation;
@import AssetsLibrary;

#import "GMDevice.h"


@implementation GMDevice


+ (BOOL)is4InchScreen
{
    static BOOL is4InchScreen = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        is4InchScreen = [UIScreen mainScreen].bounds.size.height == 568.0f;
    });
    return is4InchScreen;
}

+ (BOOL)iOS7
{
    return floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1;
}

+ (BOOL)iOS6
{
    return floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_5_1;
}

+ (BOOL)retinaDisplay
{
    static BOOL retinaDisplay = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        retinaDisplay = [UIScreen mainScreen].scale == 2.0f;
    });
    return retinaDisplay;
}

+ (CGFloat)systemVersion
{
    static CGFloat systemVersion = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemVersion = [[UIDevice currentDevice] systemVersion].floatValue;
    });
    return systemVersion;
}

+ (NSString *)systemVersionString
{
    static NSString *systemVersionString;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemVersionString = [[UIDevice currentDevice] systemVersion];
    });
    return systemVersionString;
}


+ (BOOL)cameraPermission
{
    NSString *mediaType = AVMediaTypeVideo; // Or AVMediaTypeAudio
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    // This status is normally not visible—the AVCaptureDevice class methods for discovering devices do not return devices the user is restricted from accessing.
    if(authStatus == AVAuthorizationStatusRestricted){
        NSLog(@"Restricted");
    }
    
    // The user has explicitly denied permission for media capture.
    else if(authStatus == AVAuthorizationStatusDenied){
        NSLog(@"Denied");
    }
    
    // The user has explicitly granted permission for media capture, or explicit user permission is not necessary for the media type in question.
    else if(authStatus == AVAuthorizationStatusAuthorized){
        NSLog(@"Authorized");
    }
    
    // Explicit user permission is required for media capture, but the user has not yet granted or denied such permission.
    else if(authStatus == AVAuthorizationStatusNotDetermined){
        
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if(granted){
                NSLog(@"Granted access to %@", mediaType);
            }
            else {
                NSLog(@"Not granted access to %@", mediaType);
            }
        }];
        
    }
    
    else {
        NSLog(@"Unknown authorization status");
    }
    return YES;
}
+ (BOOL)canAccessCamera
{
    if ([self iOS7]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        return authStatus == AVAuthorizationStatusAuthorized;
    }
    return YES;
}
+ (BOOL)canAccessAlbum
{
    if ([self iOS6]) {
        return [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized;
    }
    return YES;
}
+ (BOOL)needRequestAccessForCamera
{
    if ([self iOS7]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        return authStatus == AVAuthorizationStatusNotDetermined;
    }
    return NO;
    
}
+ (BOOL)needRequestAccessForAlbum
{
    if ([self iOS6]) {
        return [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined;
    }
    return NO;
}
+ (void)requestAccessForCameraWithCompletion:(void (^)(BOOL granted))handler
{
    if ([self iOS7]) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:handler];
    }
}
+ (void)requestAccessForAlbumWithCompletion:(void (^)(BOOL granted))handler
{
    if ([self iOS6]) {
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (*stop) {
                if (handler) {
                    handler(YES);
                }
                return;
            }
            *stop = TRUE;
        } failureBlock:^(NSError *error) {
            if (handler) {
                handler(NO);
            }
        }];
    }
}
@end
