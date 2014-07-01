//
//  GMPhotoPicker.h
//  Plan
//
//  Created by gamy on 14-4-1.
//  Copyright (c) 2014年. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PhotoPickerBlock) (UIImage *photo);
typedef void (^CustomPickerControllerBlock) (UIImagePickerController *pickerController);

@interface GMPhotoPicker : NSObject

@property(nonatomic, copy)PhotoPickerBlock photoBlock;
@property(nonatomic, strong)UIImagePickerController *pickerController;

- (void)showPickerInController:(UIViewController *)controller
                   customBlock:(CustomPickerControllerBlock)customBlock
                    photoBlock:(PhotoPickerBlock)photoBlock;

@end



/**
 *  照相机选择器
 */
@interface GMCameraPicker : GMPhotoPicker

+ (void)updatePickerController:(UIImagePickerController *)pickerController
                 allowsEditing:(BOOL)allowsEditing
                  cameraDevice:(UIImagePickerControllerCameraDevice)cameraDevice;

@end

/**
 *  相册选择器的祖先类
 */
#pragma mark Album
@interface GMAlbumPicker : GMPhotoPicker

+ (void)updatePickerController:(UIImagePickerController *)pickerController
                 allowsEditing:(BOOL)allowsEditing;

@end



