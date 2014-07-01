//
//  GRPhotoPicker.m
//  Plan
//
//  Created by gamy on 14-4-1.
//  Copyright (c) 2014年. All rights reserved.
//

#import "GMPhotoPicker.h"
#import "GMDevice.h"

@interface GMPhotoPicker()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/**
 *  是否有访问权限
 *
 *  @return BOOL值
 */
- (BOOL)canAccessSource;

/**
 *  是否需要申请访问权限
 *
 *  @return BOOL值
 */
- (BOOL)needRequestForSource;

/**
 *  申请访问权限
 *
 *  @param handler 申请访问权限的回调
 */
- (void)requestForSource:(void (^)(BOOL granted))handler;

/**
 *  在controller中显示picker，和presentInController的区别是不需要进行权限判断
 *
 *  @param controller 在此controller上显示
 *  @see presentInController:
 */
- (void)showPickerInController:(UIViewController *)controller;

/**
 *  如果没有权限，则弹窗显示
 */
- (void)alertDeniedMessage;


@end

@implementation GMPhotoPicker

- (BOOL)canAccessSource
{
    return YES;
}
- (BOOL)needRequestForSource
{
    return NO;
}
- (void)requestForSource:(void (^)(BOOL granted))handler{}

- (void)showPickerInController:(UIViewController *)controller{
    dispatch_async(dispatch_get_main_queue(), ^{
        [controller presentViewController:self.pickerController animated:YES completion:NULL];
    });
}

- (void)alertDeniedMessage{}

- (void)presentInController:(UIViewController *)controller
{
    if ([self canAccessSource]) {
        [self showPickerInController:controller];
    }else if([self needRequestForSource]){
        [self requestForSource:^(BOOL granted) {
            if (granted) {
                [self showPickerInController:controller];
            }
        }];
    }else{
        [self alertDeniedMessage];
    }
}

- (void)showPickerInController:(UIViewController *)controller customBlock:(CustomPickerControllerBlock)customBlock photoBlock:(PhotoPickerBlock)photoBlock
{
    self.photoBlock = photoBlock;
    self.pickerController = [[UIImagePickerController alloc] init];
    self.pickerController.delegate = self;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (image == nil) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    if (self.photoBlock) {
        self.photoBlock(image);
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}



@end



@implementation GMAlbumPicker

- (void)alertDeniedMessage
{
    [UIAlertView bk_alertViewWithTitle:nil message:@"没有权限访问您的照片，可以在“设置-隐私-照片”中启用访问。"];
}

- (BOOL)canAccessSource
{
    return [GMDevice canAccessAlbum];
}
- (BOOL)needRequestForSource
{
    return [GMDevice needRequestAccessForAlbum];
}
- (void)requestForSource:(void (^)(BOOL granted))handler
{
    [GMDevice requestAccessForAlbumWithCompletion:handler];
}

- (void)showPickerInController:(UIViewController *)controller customBlock:(CustomPickerControllerBlock)customBlock photoBlock:(PhotoPickerBlock)photoBlock
{
    [super showPickerInController:controller customBlock:customBlock photoBlock:photoBlock];
    self.pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    __weak typeof(self) wself = self;
    if (customBlock) {
        customBlock(wself.pickerController);
    }
    [self presentInController:controller];
}


+ (void)updatePickerController:(UIImagePickerController *)pickerController
                 allowsEditing:(BOOL)allowsEditing
{
    pickerController.allowsEditing = allowsEditing;
}

@end



@implementation GMCameraPicker


- (void)alertDeniedMessage
{
    [UIAlertView bk_alertViewWithTitle:nil message:@"没有权限使用您的相机，可以在“设置-隐私-相机”中启用访问。"];
}

- (BOOL)canAccessSource
{
    return [GMDevice canAccessCamera];
}
- (BOOL)needRequestForSource
{
    return [GMDevice needRequestAccessForCamera];
}
- (void)requestForSource:(void (^)(BOOL granted))handler
{
    [GMDevice requestAccessForCameraWithCompletion:handler];
}

- (void)showPickerInController:(UIViewController *)controller customBlock:(CustomPickerControllerBlock)customBlock photoBlock:(PhotoPickerBlock)photoBlock
{
    [super showPickerInController:controller customBlock:customBlock photoBlock:photoBlock];
    self.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    __weak typeof(self) wself = self;
    if (customBlock) {
        customBlock(wself.pickerController);
    }
    [self presentInController:controller];
}

+ (void)updatePickerController:(UIImagePickerController *)pickerController allowsEditing:(BOOL)allowsEditing cameraDevice:(UIImagePickerControllerCameraDevice)cameraDevice
{
    pickerController.allowsEditing = allowsEditing;
    if ([UIImagePickerController isCameraDeviceAvailable:cameraDevice]) {
        pickerController.cameraDevice = cameraDevice;        
    }
}

@end

