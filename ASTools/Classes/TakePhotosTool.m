//
//  TakePhotosTool.m
//  HTHXBB
//
//  Created by aisino on 2018/3/21.
//  Copyright © 2017年 hardy. All rights reserved.
//

#import "TakePhotosTool.h"
#import <MobileCoreServices/UTCoreTypes.h>

@implementation TakePhotosTool

+(void)takePhotoWithCamera:(UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate> *)vc
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
        photoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        photoPicker.allowsEditing = YES;
        photoPicker.delegate = vc;
        photoPicker.showsCameraControls  = YES;
        [vc presentViewController:photoPicker animated:YES completion:nil];
    }
}

+(void)takePhotoWithCamera:(UIView<UINavigationControllerDelegate,UIImagePickerControllerDelegate> *)view presentVC:(UIViewController *)vc{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
        photoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        photoPicker.allowsEditing = YES;
        photoPicker.delegate = view;
        photoPicker.showsCameraControls  = YES;
        [vc presentViewController:photoPicker animated:YES completion:nil];
    }
}

+(void)pickPhotosFromPhotoLibrary:(UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate> *)vc
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
        photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 选择要显示的资源类型
//        photoPicker.mediaTypes = @[(NSString*)kUTTypeImage,(NSString*)kUTTypeMovie];
        photoPicker.allowsEditing = YES;
        photoPicker.navigationBar.translucent = NO;
        photoPicker.delegate = vc;
        [vc presentViewController:photoPicker animated:YES completion:nil];
    }
}
+(void)pickPhotosFromSavedPhotosAlbum:(UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate> *)vc
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
        photoPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        photoPicker.allowsEditing = YES;
        photoPicker.navigationBar.tintColor = [UIColor blackColor];
        photoPicker.navigationBar.translucent = NO;
        photoPicker.delegate = vc;
        [vc presentViewController:photoPicker animated:YES completion:nil];
    }
}

+(void)pickPhotosFromSavedPhotosAlbum:(UIView<UINavigationControllerDelegate,UIImagePickerControllerDelegate> *)view presentVC:(UIViewController *)vc{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
        photoPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        photoPicker.allowsEditing = YES;
        photoPicker.navigationBar.tintColor = [UIColor blackColor];
        photoPicker.navigationBar.translucent = NO;
        photoPicker.delegate = view;
        [vc presentViewController:photoPicker animated:YES completion:nil];
    }
}


@end
