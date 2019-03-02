//
//  ViewController.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/8/16.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

/*
 需要储存照片  照片展示, 缩放, 功能
 需要储存视频  视频播放, 快进, 小屏播放, 置顶功能
 需要储存音乐  音乐播放器, 歌词同步, 快进功能, 置顶功能
 安全登录  == > {
                 私人登陆
                 普通登录
                }
 展示的界面不一样, 多账户系统  ===> 多账户数据库
 数据库储存的仅仅是文件索引和路径
 本地储存的二进制数据进行加密, 可以使Base64, 这里的key值是有特定的字符串加密
 
 */

/**
 12.10
 今日已完成从相册选择照片, 视频, LivePhoto文件,
 完成写文件操作, 读文件操作
 需要完成:
 读取文件中还原显示所需要的数据
 图片根据源文件生成缩略图, 大图
 视频是路径
 
 LivePhoto,还没想好怎么保存?????
 -----> LivePhoto 分为 placeholdImage +  视频fileURL 可创建LivePhoto
 保存LivePhoto可分别保存视频和placeholdImage来组合成LivePhoto
 
 那么针对去保存这个需要一个plist文件来保存这些文件路径

 元模型设计:
 针对于Photo:
 {
 filePath: 源数据路径
 }
 视频:
 {
 filePath: 元数据路径
 }
 LivePhoto
 {
 placeholdFilePath: 照片路径
 LivePhotoVideoFilePath: 视频路径
 }
 
 业务数据构造层:
 根据Photo元模型做出真是业务层的数据模型
 根据video元模型做出真是业务层的数据模型
 根据LivePhoto元模型做出真是业务层的数据模型
 
 
 Photo     }                      {  UIPhoto
 Video     |----> constructor --->|  UIVideo
 LivePhoto }                      {  UILivePhoto
 
                                    UIPhoto数据设计:
                                    {
                                        originImage: 原图 懒加载
                                        largeImage: 大图
                                        thunmbImage: 缩略图
                                    }
 
                                    UIVideo数据设计:
                                    {
                                        filePath: 视频路径
                                        AVAsset: (看需要是否需要做成AVAsset)
                                    }
 
                                    UILivePhoto数据设计:
                                    {
                                        PHLivePhoto:LivePhoto数据 (用大图做placehold)
                                    }
 */

#import "ViewController.h"
#import "TestTableModel.h"
#import "DBTable.h"
#import "SourceSecurity.h"
#import <AVFoundation/AVFoundation.h>
#import "Write.h"
#import <Photos/Photos.h>
#import "CollectionViewCell.h"
#import "MemoryMonitoring.h"
#import "OptionPhoto/CorePhoto.h"
#import <ImageIO/ImageIO.h>
//#import "OptionPhoto/CorePhoto/CorePhotoAsset.h"
#import "OptionPhoto/CorePhoto/UIImage+compression.h"
#import "AlbumViewController.h"
#import "CorePhoto.h"

#import "WBAboutOptionPhoto.h"


@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CorePhotoConfigDelegate>
@property (strong, nonatomic) UICollectionView *collection;
@property (nonatomic , strong) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

//@property (nonatomic , strong) MPMoviePlayerViewController *mp;
@end

@implementation ViewController
{
    size_t _width, _height;

    UIImageOrientation _orientation;

    CGImageSourceRef _imageSource;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (IBAction)jumpaction:(id)sender {
    
    CorePhotoNavigationController *navi = [[CorePhotoNavigationController alloc] initWithRootViewController:[CorePhotoRootViewController new]];
    [SXCorePhotoConfig sharedInstance].isNeedPhototLive = YES;
    [SXCorePhotoConfig sharedInstance].delegate = self;
    [self.navigationController presentViewController:navi animated:YES completion:^{
        
    }];
}

- (void)sxCorePhotoSelectedAssets:(NSMutableArray<CoreAssetBaseItem *> *)array
{
     NSLog(@"%s 调用开始时间: %@",__func__,[NSDate date]);
    
    //这里的内存情况使用OK
    //这里进行保存本地
    //这里的保存本地图片得保存原图对于图片来说
    for (CoreAssetBaseItem *item in array) {
        
        if ([item isKindOfClass:[CorePhotoItem class]]) {
            CorePhotoItem *sub = (CorePhotoItem *)item;
            //源图数据
            //这里出现问题
            //TODO: 写文件内存会产生遗留
            NSLog(@"%f 前 使用内存",[MemoryMonitoring getDeviceUseMemory]);
            [sub gainOriginImage:^(NSData * _Nonnull origin) {
                //写照片
                [[Write sharedInstance] asyncWritePhotoToFileName:[sub.localIdentifier stringByReplacingOccurrencesOfString:@"/" withString:@"&"] fileData:origin security:0 complateBlock:^(BOOL ret, NSString *filePath, DataSecurityType security) {
                    
                    NSLog(@"%@",filePath);
                    NSData *seadata = [NSData dataWithContentsOfFile:filePath];
                    //读取照片
                    [[Write sharedInstance] readSecurityFileName:[sub.localIdentifier stringByReplacingOccurrencesOfString:@"/" withString:@"&"]
                                                        fileData:seadata
                                                        fileType:WriteTypePhoto
                                                     fileQuality:WriteTypeQualityArtwork
                                                        security:security
                                                   complateBlock:^(BOOL ret, NSString *temPath, NSData *data) {

                                                       if (ret) {
                                                           NSLog(@"读取成功");
                                                           NSLog(@"读取路径: %@",temPath);
                                                           
                                                           UIImage *image = [UIImage imageWithData:data];
                                                           
                                                           CorePhotoItem *item = [CorePhotoItem new];
                                                           item.thumbnailImage = [UIImage sx_thbum_compressImageWith:image];
                                                           [self.dataArray addObject:item];
                                                           NSLog(@"%f 后使用内存",[MemoryMonitoring getDeviceUseMemory]); dispatch_async(dispatch_get_main_queue(), ^{

                                                               [self.collection reloadData];
                                                               NSLog(@"%f 最后使用内存",[MemoryMonitoring getDeviceUseMemory]);

                                                           });
                                                       }
                                                   }];
                }];
            }];
        }
    }
}

static const size_t kBytesPerPixel = 4;
static const size_t kBitsPerComponent = 8;
- (nullable UIImage *)decodedImageWithImage:(nullable UIImage *)image
{
    @autoreleasepool{
        //获取传入的UIImage对应的CGImageRef（位图）
        CGImageRef imageRef = image.CGImage;
        //获取彩色空间
        CGColorSpaceRef colorspaceRef = CGImageGetColorSpace(imageRef);
        
        //获取高和宽
        size_t width = CGImageGetWidth(imageRef);
        size_t height = CGImageGetHeight(imageRef);
        //static const size_t kBytesPerPixel = 4
        // 每个像素占4个字节大小 共32位 (RGBA)
        size_t bytesPerRow = kBytesPerPixel * width;
        
        // kCGImageAlphaNone is not supported in CGBitmapContextCreate.
        // Since the original image here has no alpha info, use kCGImageAlphaNoneSkipLast
        // to create bitmap graphics contexts without alpha info.
        //初始化bitmap graphics context 上下文
        CGContextRef context = CGBitmapContextCreate(NULL,
                                                     width,
                                                     height,
                                                     kBitsPerComponent,
                                                     bytesPerRow,
                                                     colorspaceRef,
                                                     kCGBitmapByteOrderDefault|kCGImageAlphaNoneSkipLast);
        if (context == NULL) {
            return image;
        }
        // Draw the image into the context and retrieve the new bitmap image without alpha
        //将CGImageRef对象画到上面生成的上下文中，且将alpha通道移除
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
        //使用上下文创建位图
        CGImageRef imageRefWithoutAlpha = CGBitmapContextCreateImage(context);
        //从位图创建UIImage对象
        UIImage *imageWithoutAlpha = [UIImage imageWithCGImage:imageRefWithoutAlpha
                                                         scale:image.scale
                                                   orientation:image.imageOrientation];
        //释放CG对象
        CGContextRelease(context);
        CGImageRelease(imageRefWithoutAlpha);
        
        return imageWithoutAlpha;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[WBAboutOptionPhoto sharedInstance] test_encode];
//    NSArray *array = [[WBAboutOptionPhoto sharedInstance] test_decode];
//    NSLog(@"%@",array);
//    DBTable *table = [[DBTable alloc] initWithTableName:@"test" withPropertyClass:TestTableModel.class];
//
//    TestTableModel *model = [[TestTableModel alloc] init];
//    model.identifie = @"identifie";
//    model.size = 1;
//    model.flo = 0.12f;
//    model.lon = 200;
//    model.isload = YES;
//    model.width = 2000;
//    model.dict = [NSDictionary dictionaryWithObjectsAndKeys:@"jieguo",@"key", nil];
//    model.array = [NSMutableArray arrayWithObjects:@"1",@"3",@"5", nil];
//    model.path = @"path";
//    model.filePath = @"filepath";
//    model.ceshiupdate = @"测试升级";
//    [table insertModel:model];
//
//    NSArray *array = [table getDataList];
//
//    for (int i = 0; i < array.count; i++) {
//        TestTableModel *model = array[i];
//        NSLog(@"%f",model.flo);
//    }
//    NSLog(@"");
    
//    NSString *oldString = @"23456786543245676543";
//    NSData *yuanlaiData = [oldString dataUsingEncoding:NSUTF8StringEncoding];
    
//    [self testWritePhoto];
    NSLog(@"1");
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        NSLog(@"2");
    }];
    NSLog(@"3");
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(70, 70);

    self.collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];

    self.collection.dataSource = self;
    self.collection.delegate = self;
    [self.collection registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CustomCollectionViewCellID"];

    [self.view addSubview:self.collection];
//    __weak typeof(self)weakSelf = self;
//    [[CorePhotoAsset sharedInstance] gainAlbums:^(NSArray<CoreAlbumItem *> * _Nonnull param,NSError *error) {
//        if (error) {
//            NSLog(@"error%@",error);
//            return ;
//        }
//        [weakSelf.dataArray addObjectsFromArray:param];
//        [weakSelf.collection reloadData];
//    }];
}

- (void)testWritePhoto
{
    UIImage *image = [UIImage imageNamed:@"timg.jpeg"];
    NSData *imagedata = UIImageJPEGRepresentation(image, 1);
    NSString *path = @"timg.jpeg";
    
    [[Write sharedInstance] asyncWriteToFileName:path
                                        fileData:imagedata
                                        fileType:WriteTypePhoto
                                     fileQuality:WriteTypeQualityArtwork
                                        security:DataSecurityTypeAES
                                   complateBlock:^(BOOL ret, NSString *filePath, DataSecurityType security) {
        
                                       if (ret) {
                                           NSLog(@"保存成功");
                                           
                                           NSLog(@"保存路径: %@",filePath);
                                           
                                           NSData *seadata = [NSData dataWithContentsOfFile:filePath];
                                           
                                           //读取照片
                                           [[Write sharedInstance] readSecurityFileName:path
                                                                               fileData:seadata
                                                                               fileType:WriteTypePhoto
                                                                            fileQuality:WriteTypeQualityArtwork
                                                                               security:security
                                                                          complateBlock:^(BOOL ret, NSString *temPath, NSData *data) {
                                               
                                               if (ret) {
                                                   NSLog(@"读取成功");
                                                   NSLog(@"读取路径: %@",temPath);
                                                   
                                                   [self.imageView setImage:[UIImage imageWithContentsOfFile:temPath]];
                                               }
                                               
                                           }];
                                           
                                       }
                                       
    }];
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCollectionViewCellID" forIndexPath:indexPath];
    
    NSObject *item = self.dataArray[indexPath.row];
    
    if ([item isKindOfClass:[CoreAlbumItem class]]) {
        CoreAlbumItem *obj = (CoreAlbumItem *)item;
        
        [cell.image setImage:obj.coverPhoto];
        
    }
    
    if ([item isKindOfClass:[CorePhotoItem class]]) {
        CorePhotoItem *obj = (CorePhotoItem *)item;
//        if (obj.thumbFile) {
//            [cell.image setImage:[UIImage imageWithContentsOfFile:obj.thumbFile]];
//        }else{
//            [cell.image setImage:obj.thumbnailImage];
//        }
        [cell.image setImage:obj.thumbnailImage];
    }
    
    if ([item isKindOfClass:[CoreVideoItem class]]) {
        CoreVideoItem *obj = (CoreVideoItem *)item;
        [cell.image setImage:obj.coverImage];
    }
    if (@available(iOS 9.1, *)) {
        if ([item isKindOfClass:[CoreLivePhotoItem class]]) {
            CoreLivePhotoItem *obj = (CoreLivePhotoItem *)item;
            [cell.image setImage:obj.coverImage];
        }
    } else {
        // Fallback on earlier versions
    }
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    CoreAlbumItem *item = self.dataArray[indexPath.row];
//    
//    AlbumViewController *vc = [AlbumViewController new];
//    
//    vc.item = item;
//    
//    [self.navigationController pushViewController:vc animated:YES];
}
@end
