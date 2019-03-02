//
//  WBAboutOptionPhoto.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/10.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "WBAboutOptionPhoto.h"

//#import "WBMetadataVideo.h"
//#import "WBMetadataPhoto.h"
//#import "WBMetadataLivePhoto.h"



@implementation WBAboutOptionPhoto

+ (instancetype)sharedInstance
{
    static WBAboutOptionPhoto *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)test_encode
{
    
    //
//    WBMetadataVideo *video = [WBMetadataVideo new];
//    video.filePath = @"this is video filePath";
////    [array addObject:video];
//
//    WBMetadataPhoto *photo = [WBMetadataPhoto new];
//    photo.filePath = @"this is photo filePath";
////    [array addObject:photo];
//
//    WBMetadataPhoto *photo1 = [[WBMetadataPhoto alloc] init];
//    photo1.filePath = @"this is livePhoto placehpld filePath";
////
//    WBMetadataVideo *video1 = [WBMetadataVideo new];
//    video1.filePath = @"this is livePhoto video filePath";
//
//    WBMetadataLivePhoto *livePhoto = [WBMetadataLivePhoto new];
//    livePhoto.placehold = photo1;
//    livePhoto.video = video1;
    
//    [array addObject:livePhoto];
    
    
    NSString *home = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [home stringByAppendingPathComponent:@"photo.data"]; //注：保存文件的扩展名可以任意取，不影响。
     NSString *videoPath = [home stringByAppendingPathComponent:@"video.data"]; //注：保存文件的扩展名可以任意取，不影响。
     NSString *livePath = [home stringByAppendingPathComponent:@"livePhoto.data"]; //注：保存文件的扩展名可以任意取，不影响。
    
    NSLog(@"%@",NSHomeDirectory());
    //归档
//    if (@available(iOS 11.0, *)) {
//        [NSKeyedArchiver archivedDataWithRootObject:photo requiringSecureCoding:YES error:nil];
//        [NSKeyedArchiver archivedDataWithRootObject:video requiringSecureCoding:YES error:nil];
//        [NSKeyedArchiver archivedDataWithRootObject:livePhoto requiringSecureCoding:YES error:nil];
//    } else {
    if (@available(iOS 10.0, *)) {
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] init];
//        [archiver]
//        [NSKeyedArchiver archiveRootObject:photo toFile:filePath];
//        [NSKeyedArchiver archiveRootObject:video toFile:videoPath];
//        [NSKeyedArchiver archiveRootObject:livePhoto toFile:livePath];
//        [archiver finishEncoding];
    } else {
        // Fallback on earlier versions
    }
        // Fallback on earlier versions
//    }
    
}
- (NSArray *)test_decode
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *home = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [home stringByAppendingPathComponent:@"photo.data"]; //注：保存文件的扩展名可以任意取，不影响。
    NSString *videoPath = [home stringByAppendingPathComponent:@"video.data"]; //注：保存文件的扩展名可以任意取，不影响。
    NSString *livePath = [home stringByAppendingPathComponent:@"livePhoto.data"]; //注：保存文件的扩展名可以任意取，不影响。
    
//    [NSKeyedUnarchiver unarchivedObjectOfClass:<#(nonnull Class)#> fromData:<#(nonnull NSData *)#> error:<#(NSError * _Nullable __autoreleasing * _Nullable)#>]
//    WBMetadataPhoto *photo = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
//    SXWBMetadataBase *video = [NSKeyedUnarchiver unarchiveObjectWithFile:videoPath];
//   SXWBMetadataBase *live  = [NSKeyedUnarchiver unarchiveObjectWithFile:livePath];
//    [array addObject:photo];
//    [array addObject:video];
//    [array addObject:live];
    return array;
}

@end
