//
//  Write.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/8/20.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WriteFileMacro.h"


typedef void(^WriteComplateBlock)(BOOL ret,NSString *filePath,DataSecurityType security);
typedef void(^ReadComplateBlock)(BOOL ret,NSString *temPath,NSData *data);

@interface Write : NSObject

+ (instancetype)sharedInstance;

/**********************************PHOTO**********************************/
/*
 * 写照片
 */
- (void)syncWritePhotoToFileName:(NSString *)fileName
                        fileData:(NSData *)fileData
                        security:(DataSecurityType)security;
- (void)asyncWritePhotoToFileName:(NSString *)fileName
                         fileData:(NSData *)fileData
                         security:(DataSecurityType)security
                    complateBlock:(WriteComplateBlock)block;


/**********************************VIDEO***********************************/
/*
 * 写视频
 */
- (void)syncWriteVideoToFileName:(NSString *)fileName
                        fileData:(NSData *)fileData
                        security:(DataSecurityType)security;
- (void)asyncWriteVideoToFileName:(NSString *)fileName
                         fileData:(NSData *)fileData
                         security:(DataSecurityType)security
                    complateBlock:(WriteComplateBlock)block;


/**********************************MUSIC***********************************/
/*
 * 写音频
 */
- (void)syncWriteMusicToFileName:(NSString *)fileName
                        fileData:(NSData *)fileData
                        security:(DataSecurityType)security;
- (void)asyncWriteMusicToFileName:(NSString *)fileName
                         fileData:(NSData *)fileData
                         security:(DataSecurityType)security
                    complateBlock:(WriteComplateBlock)block;

/**********************************FILE***********************************/
/*
 * 写文件
 */
- (void)syncWriteFileToFileName:(NSString *)fileName
                       fileData:(NSData *)fileData
                       security:(DataSecurityType)security;
- (void)asyncWriteFileToFileName:(NSString *)fileName
                        fileData:(NSData *)fileData
                        security:(DataSecurityType)security
                   complateBlock:(WriteComplateBlock)block;


/**
 同步写文件
 
 @param fileName 文件名称加后缀
 @param fileData 文件二进制数据
 @param writeType 文件类型
 @param quality 质量
 @param security 加密方式
 */
- (void)syncWriteToFileName:(NSString *)fileName
                   fileData:(NSData *)fileData
                   fileType:(WriteType)writeType
                fileQuality:(WriteTypeQuality)quality
                   security:(DataSecurityType)security;


/**
 异步写文件
 
 @param fileName 文件名称加后缀
 @param fileData 文件二进制数据
 @param writeType 文件类型
 @param quality 质量
 @param security 加密方式
 @param block 完成回调
 */
- (void)asyncWriteToFileName:(NSString *)fileName
                    fileData:(NSData *)fileData
                    fileType:(WriteType)writeType
                 fileQuality:(WriteTypeQuality)quality
                    security:(DataSecurityType)security
               complateBlock:(WriteComplateBlock)block;


/**
 这个方法是拿到加密的数据进行读取加密后的内容
 还方法为异步读取数据并会写入临时文件夹

 @param fileName 文件名称加后缀
 @param fileData 取出的数据
 @param writeType 写入时的类型
 @param quality 质量
 @param security 安全
 @param block 完成回调
 */
- (void)readSecurityFileName:(NSString *)fileName
            fileData:(NSData *)fileData
            fileType:(WriteType)writeType
         fileQuality:(WriteTypeQuality)quality
            security:(DataSecurityType)security
       complateBlock:(ReadComplateBlock)block;

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
       complateBlock:(ReadComplateBlock)block;

@end
