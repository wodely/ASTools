//
//  TakePhotosTool.h
//  HTHXBB
//
//  Created by aisino on 2018/3/21.
//  Copyright © 2017年 hardy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TakePhotosTool : NSObject


/* 说明
 * UIImagePickerController 弹出的界面默认为英文字体
 * Targets下面，打开info， 找到“Localization native development region”， 选择China即可。就能改为中文。
 
 使用例子:
 1. 在某sVc页面中直接调用TakePhotosTool的某个静态方法
     [TakePhotosTool takePhotoWithCamera];
    或 [TakePhotosTool pickPhotosFromSavedPhotosAlbum:self];
    或 [TakePhotosTool pickPhotosFromSavedPhotosAlbum:self]
 
 2. 在sVc页面需要添加<UINavigationControllerDelegate，UIImagePickerControllerDelegate>这个代理申明。
    @interface sVc() <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
 
 3. 实现- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info的代理方法。
 
     选中图片之后的回调
     *  #pragma mark -- UIImagePickerControllerDelegate
     *  - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
     *  {
     *     NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
     *     if ([mediaType isEqualToString:@"public.image"])
     *     {
     *        // 原图
     *        //        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
     *        // 编辑过的图片,图片质量差些
     *        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
     *        NSLog(@"");
     *     }
     *     else if ([mediaType isEqualToString:@"public.movie"])
     *     {
     *        NSURL *videoUrl = [info objectForKey:@"UIImagePickerControllerMediaURL"];
     *        NSData *data = [NSData dataWithContentsOfURL:videoUrl];
     *     }
     *
     *     [picker dismissViewControllerAnimated:YES completion:^{
     *
     *     }];
     *   }
     */



/**
 UIImagePickerController 拍照
 
 @param vc presentView出UIImagePickerController的UIViewController
 
 p.s. 需要在vc页面处添加UINavigationControllerDelegate，UIImagePickerControllerDelegate代理。
 */
+(void)takePhotoWithCamera:(UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate> *)vc;

+(void)takePhotoWithCamera:(UIView<UINavigationControllerDelegate,UIImagePickerControllerDelegate> *)view presentVC:(UIViewController *)vc;
/**
 UIImagePickerController 获取相簿（默认只有照片,如果显示视频，需要设置MediaTypes）
 
 照片、视频已经进行分类，会分多个文件夹
 
 @param vc presentView出UIImagePickerController的UIViewController
 
 p.s. 需要在vc页面处添加UINavigationControllerDelegate，UIImagePickerControllerDelegate代理。
 */
+ (void)pickPhotosFromPhotoLibrary:(UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate> *)vc;


/**
 UIImagePickerController 获取照片（默认只有照片,如果显示视频，需要设置MediaTypes）

 照片直接按照拍摄时间显示，不会分多个文件夹
 
 @param vc presentView出UIImagePickerController的UIViewController
 
 p.s. 需要在vc页面处添加UINavigationControllerDelegate，UIImagePickerControllerDelegate代理。
 */
+ (void)pickPhotosFromSavedPhotosAlbum:(UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate> *)vc;


+(void)pickPhotosFromSavedPhotosAlbum:(UIView<UINavigationControllerDelegate,UIImagePickerControllerDelegate> *)view presentVC:(UIViewController *)vc;

@end
