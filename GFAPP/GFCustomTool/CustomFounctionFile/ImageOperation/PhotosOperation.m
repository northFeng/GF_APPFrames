//
//  PhotosOperation.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/6/12.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "PhotosOperation.h"

#import <Photos/Photos.h>

/** 相册名字 */
//static NSString * const GFCollectionName = @"风-Photos";


@implementation PhotosOperation


#pragma mark - 查询相册中的图片
/**
 * 查询所有的图片 
 */
- (void)searchAllImages:(blockGetImage)blockImages{
    
    //存储总的照片
    NSMutableArray *totalImageArray = [NSMutableArray array];
    
    // 判断授权状态
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 遍历所有的自定义相册
            PHFetchResult<PHAssetCollection *> *collectionResult0 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
            
            for (PHAssetCollection *collection in collectionResult0) {
                
                //查询某个相册里面的所有图片
                NSMutableArray *imageArray = [self searchAllImagesInCollection:collection];
                
                [totalImageArray addObject:imageArray];
            }
            
            // 获得相机胶卷的图片(上面的循环包含了这个相机胶卷相册)
            PHFetchResult<PHAssetCollection *> *collectionResult1 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
            for (PHAssetCollection *collection in collectionResult1) {
                if (![collection.localizedTitle isEqualToString:@"Camera Roll"]) continue;

                //查询相机相册中照片
                NSMutableArray *imageArray = [self searchAllImagesInCollection:collection];
                
                [totalImageArray addObject:imageArray];
                break;
            }
            
            blockImages(totalImageArray);
        });
    }];
}

/**
 * 查询某个相册里面的所有图片
 */
- (NSMutableArray *)searchAllImagesInCollection:(PHAssetCollection *)collection
{
    // 采取同步获取图片（只获得一次图片）
    PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
    imageOptions.synchronous = YES;
    
    NSLog(@"相册名字：%@", collection.localizedTitle);
    
    NSMutableArray *imageArrayInfo = [NSMutableArray array];
    
    [imageArrayInfo addObject:collection.localizedTitle];//添加标题
    
    // 遍历这个相册中的所有图片
    PHFetchResult<PHAsset *> *assetResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    for (PHAsset *asset in assetResult) {
        // 过滤非图片
        if (asset.mediaType != PHAssetMediaTypeImage) continue;
        
        // 图片原尺寸
        CGSize targetSize = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
        // 请求图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeDefault options:imageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            //添加到数组中
            [imageArrayInfo addObject:result];
            
            //存储拿过来的图片image
            NSLog(@"图片：%@ %@", result, [NSThread currentThread]);
        }];
    }
    
    return imageArrayInfo;
}



#pragma mark - 保存图片到自定义相册

/**
 * 保存图片到相册
 */
- (void)saveImage:(UIImage *)saveImage photoName:(NSString *)photoName{
    // 判断授权状态
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = nil;
            
            // 保存相片到相机胶卷
            __block PHObjectPlaceholder *createdAsset = nil;
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                
                //保存的image
                //createdAsset = [PHAssetCreationRequest creationRequestForAssetFromImage:[UIImage imageNamed:@"logo"]].placeholderForCreatedAsset;
                createdAsset = [PHAssetCreationRequest creationRequestForAssetFromImage:saveImage].placeholderForCreatedAsset;
                
            } error:&error];
            
            if (error) {
                NSLog(@"保存失败：%@", error);
                return;
            }
            
            // 拿到自定义的相册对象
            PHAssetCollection *collection = [self collection:photoName];
            if (collection == nil) return;
            
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                [[PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection] insertAssets:@[createdAsset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
            } error:&error];
            
            if (error) {
                NSLog(@"保存失败：%@", error);
            } else {
                NSLog(@"保存成功");
            }
        });
    }];
}



/**
 * 获得自定义的相册对象
 */
- (PHAssetCollection *)collection:(NSString *)photosName;
{
    // 先从已存在相册中找到自定义相册对象
    PHFetchResult<PHAssetCollection *> *collectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collectionResult) {
        //查询相册
//        if ([collection.localizedTitle isEqualToString:GFCollectionName]) {
//            return collection;
//        }
        if ([collection.localizedTitle isEqualToString:photosName]) {
            return collection;
        }
    }
    
    // 新建自定义相册
    __block NSString *collectionId = nil;
    NSError *error = nil;
    
    //修改
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        collectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:photosName].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    if (error) {
        NSLog(@"获取相册【%@】失败", photosName);
        return nil;
    }
    
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionId] options:nil].lastObject;
}

@end
