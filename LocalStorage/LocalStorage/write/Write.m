//
//  Write.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/8/20.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "Write.h"
#import "SourceSecurity.h"

@interface Write ()
{
    dispatch_queue_t _writeQueue;
    dispatch_queue_t _readQueue;
    dispatch_semaphore_t _semaphore;
    NSString *_photoFile;
    NSString *_videoFile;
    NSString *_musicFile;
    NSString *_fileFile;
    NSString *_photoTmpFile;
    NSString *_videoTmpFile;
    NSString *_musicTmpFile;
    NSString *_fileTmpFile;
}

@end


@implementation Write

+ (instancetype)sharedInstance
{
    static Write *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Write alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _writeQueue = dispatch_queue_create("writefile.com", DISPATCH_QUEUE_CONCURRENT);
        _readQueue = dispatch_queue_create("readfile.com", DISPATCH_QUEUE_CONCURRENT);
        _semaphore = dispatch_semaphore_create(1);
       
        //视频文件夹
        {
            NSString *before = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            before = [before stringByAppendingPathComponent:@"video"];
            _videoFile = before;
            [self creatFileWithPath:before];
        }
        //临时视频文件夹
        {
            NSString *before = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            before = [before stringByAppendingPathComponent:@"tmp"];
            before = [before stringByAppendingPathComponent:@"video"];
            _videoTmpFile = before;
            [self creatFileWithPath:_videoTmpFile];
        }
        
        //照片文件夹
        {
            NSString *before = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            before = [before stringByAppendingPathComponent:@"photo"];
            _photoFile = before;
            [self creatFileWithPath:before];
        }
        //临时照片文件夹
        {
            NSString *before = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            before = [before stringByAppendingPathComponent:@"tmp"];
            before = [before stringByAppendingPathComponent:@"photo"];
            _photoTmpFile = before;
            [self creatFileWithPath:_photoTmpFile];
        }
        
        //音乐文件夹
        {
            NSString *before = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            before = [before stringByAppendingPathComponent:@"music"];
            _musicFile = before;
            [self creatFileWithPath:before];
        }
        //临时音乐文件夹
        {
            NSString *before = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            before = [before stringByAppendingPathComponent:@"tmp"];
            before = [before stringByAppendingPathComponent:@"music"];
            _musicTmpFile = before;
            [self creatFileWithPath:_musicTmpFile];
        }
        
        //文件文件夹
        {
            NSString *before = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            before = [before stringByAppendingPathComponent:@"file"];
            _fileFile = before;
            [self creatFileWithPath:before];
        }
        //临时文件文件夹
        {
            NSString *before = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            before = [before stringByAppendingPathComponent:@"tmp"];
            before = [before stringByAppendingPathComponent:@"file"];
            _fileTmpFile = before;
            [self creatFileWithPath:_fileTmpFile];
        }
        
        
    }
    return self;
}

//创建文件
- (BOOL)creatFileWithPath:(NSString *)filePath
{
    BOOL isSuccess = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL temp = [fileManager fileExistsAtPath:filePath];
    if (temp) {
        return YES;
    }
    
    NSError *error;
    
    isSuccess = [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        NSLog(@"creat File Failed. errorInfo:%@",error);
    }
    
    return isSuccess;
}

/**********************************PHOTO**********************************/
/*
 * 写照片
 */
- (void)syncWritePhotoToFileName:(NSString *)fileName
                        fileData:(NSData *)fileData
                        security:(DataSecurityType)security
{
    [self syncWriteToFileName:fileName
                     fileData:fileData
                     fileType:WriteTypePhoto
                  fileQuality:WriteTypeQualityArtwork
                     security:security];
}
- (void)asyncWritePhotoToFileName:(NSString *)fileName
                         fileData:(NSData *)fileData
                         security:(DataSecurityType)security
                    complateBlock:(WriteComplateBlock)block
{
    [self asyncWriteToFileName:fileName
                      fileData:fileData
                      fileType:WriteTypePhoto
                   fileQuality:WriteTypeQualityArtwork
                      security:security
                 complateBlock:block];
}


/**********************************VIDEO***********************************/
/*
 * 写视频
 */
- (void)syncWriteVideoToFileName:(NSString *)fileName
                        fileData:(NSData *)fileData
                        security:(DataSecurityType)security
{
    [self syncWriteToFileName:fileName
                     fileData:fileData
                     fileType:WriteTypeVideo
                  fileQuality:WriteTypeQualityArtwork
                     security:security];
}
- (void)asyncWriteVideoToFileName:(NSString *)fileName
                         fileData:(NSData *)fileData
                         security:(DataSecurityType)security
                    complateBlock:(WriteComplateBlock)block
{
    [self asyncWriteToFileName:fileName
                      fileData:fileData
                      fileType:WriteTypeVideo
                   fileQuality:WriteTypeQualityArtwork
                      security:security
                 complateBlock:block];
}


/**********************************MUSIC***********************************/
/*
 * 写音频
 */
- (void)syncWriteMusicToFileName:(NSString *)fileName
                        fileData:(NSData *)fileData
                        security:(DataSecurityType)security
{
    [self syncWriteToFileName:fileName
                     fileData:fileData
                     fileType:WriteTypeMp3
                  fileQuality:WriteTypeQualityArtwork
                     security:security];
}
- (void)asyncWriteMusicToFileName:(NSString *)fileName
                         fileData:(NSData *)fileData
                         security:(DataSecurityType)security
                    complateBlock:(WriteComplateBlock)block
{
    [self asyncWriteToFileName:fileName
                      fileData:fileData
                      fileType:WriteTypeMp3
                   fileQuality:WriteTypeQualityArtwork
                      security:security
                 complateBlock:block];
}

/**********************************FILE***********************************/
/*
 * 写文件
 */
- (void)syncWriteFileToFileName:(NSString *)fileName
                       fileData:(NSData *)fileData
                       security:(DataSecurityType)security
{
    [self syncWriteToFileName:fileName
                     fileData:fileData
                     fileType:WriteTypeFile
                  fileQuality:WriteTypeQualityArtwork
                     security:security];
}
- (void)asyncWriteFileToFileName:(NSString *)fileName
                        fileData:(NSData *)fileData
                        security:(DataSecurityType)security
                   complateBlock:(WriteComplateBlock)block
{
    [self asyncWriteToFileName:fileName
                      fileData:fileData
                      fileType:WriteTypeFile
                   fileQuality:WriteTypeQualityArtwork
                      security:security
                 complateBlock:block];
}


/**
 同步写文件
 
 @param fileName 文件路径
 @param fileData 文件二进制数据
 @param writeType 文件类型
 @param quality 质量
 @param security 安全加密方式
 */
- (void)syncWriteToFileName:(NSString *)fileName
                   fileData:(NSData *)fileData
                   fileType:(WriteType)writeType
                fileQuality:(WriteTypeQuality)quality
                   security:(DataSecurityType)security
{
    __weak typeof(_semaphore)weakSema = _semaphore;
    dispatch_async(_writeQueue, ^{
        dispatch_semaphore_wait(weakSema, DISPATCH_TIME_FOREVER);
        
        NSString *filePath = [self getSaveFileForFileName:fileName
                                                writeType:writeType
                                                    isTmp:NO];
        
        NSData *data = [SourceSecurity encryotionSecurityData:fileData securityType:security];
        
        [data writeToFile:filePath atomically:NO];
        
        dispatch_semaphore_signal(weakSema);
    });
}

/**
 异步写文件
 
 @param fileName 文件路径
 @param fileData 文件二进制数据
 @param writeType 文件类型
 @param quality 质量
 */
- (void)asyncWriteToFileName:(NSString *)fileName
                    fileData:(NSData *)fileData
                    fileType:(WriteType)writeType
                 fileQuality:(WriteTypeQuality)quality
                    security:(DataSecurityType)security
               complateBlock:(WriteComplateBlock)block
{
    dispatch_async(_writeQueue, ^{
        
        NSData *data = [SourceSecurity encryotionSecurityData:fileData securityType:security];
        
        NSString *filePath = [self getSaveFileForFileName:fileName
                                                writeType:writeType
                                                    isTmp:NO];
        
        NSError *error = nil;
        
        [data writeToFile:filePath options:NSDataWritingAtomic error:&error];
        
        BOOL ret =  YES;//[data writeToFile:filePath atomically:NO];
        
        if (error) {
            ret = NO;
            NSLog(@"写文件报错error: %@",error);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (block) {
                block(ret,filePath,security);
            }
            
        });
        
    });
}

- (void)readSecurityFileName:(NSString *)fileName
            fileData:(NSData *)fileData
            fileType:(WriteType)writeType
         fileQuality:(WriteTypeQuality)quality
            security:(DataSecurityType)security
       complateBlock:(ReadComplateBlock)block
{
    
     NSString *weadTmpFile = [self getSaveFileForFileName:fileName
                                                              writeType:writeType
                                                                  isTmp:YES];
    
    dispatch_async(_readQueue, ^{
        
        NSData *data = [SourceSecurity decryptionSecurityData:fileData securityType:security];
        BOOL ret = data != nil;
        if (ret) {

            [data writeToFile:weadTmpFile atomically:NO];
            
            dispatch_async(dispatch_get_main_queue(), ^{

                if (block) {
                    block(YES,weadTmpFile,data);
                }
                
            });
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (block) {
                    block(NO,nil,nil);
                }
                
            });
        }
        
        
    });
}
/**
 异步取出文件
 这个方法是给出文件名称,会自动取出加密的内容并解密到临时文件夹,给出外界临时文件夹的内容和二进制数据
 
 @param fileName 文件名称加后缀
 @param writeType 文件类型
 @param quality 质量
 @param security 安全
 @param block 完成回调
 */
- (void)readFileName:(NSString *)fileName
            fileType:(WriteType)writeType
         fileQuality:(WriteTypeQuality)quality
            security:(DataSecurityType)security
       complateBlock:(ReadComplateBlock)block
{
    dispatch_async(_readQueue, ^{
       
        NSString *filePath = [self getSaveFileForFileName:fileName
                                                   writeType:writeType
                                                       isTmp:NO];
        NSString *tmpFilePath = [self getSaveFileForFileName:fileName
                                                writeType:writeType
                                                    isTmp:NO];
        
        NSData *seadata = [NSData dataWithContentsOfFile:filePath];
        
        
        NSData *data = [SourceSecurity decryptionSecurityData:seadata securityType:security];
        
        BOOL ret = data != nil;
        
        if (ret) {
            
            [data writeToFile:tmpFilePath atomically:NO];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (block) {
                    block(YES,tmpFilePath,data);
                }
                
            });
        
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (block) {
                    block(NO,nil,nil);
                }
                
            });
        }
        
    });
}

- (NSString *)getSaveFileForFileName:(NSString *)fileName writeType:(WriteType)writeType isTmp:(BOOL)isTmp
{
    switch (writeType) {
        case WriteTypePhoto:
        {
            if (isTmp) {
                return [_photoTmpFile stringByAppendingPathComponent:fileName];
            }
            return [_photoFile stringByAppendingPathComponent:fileName];
        }
            break;
        case WriteTypeVideo:
        {
            if (isTmp) {
                return [_videoTmpFile stringByAppendingPathComponent:fileName];
            }
            return [_videoFile stringByAppendingPathComponent:fileName];
        }
            break;
        case WriteTypeMp3:
        {
            if (isTmp) {
                return [_musicTmpFile stringByAppendingPathComponent:fileName];
            }
            return [_musicFile stringByAppendingPathComponent:fileName];
        }
            break;
        case WriteTypeFile:
        {
            if (isTmp) {
                return [_fileTmpFile stringByAppendingPathComponent:fileName];
            }
            return [_fileFile stringByAppendingPathComponent:fileName];
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

@end
