//
//  WriteFileMacro.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/8/20.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#ifndef WriteFileMacro_h
#define WriteFileMacro_h


/*
 思路:
 1: 因为是写东西所以需要多线程操作, 保证多线程
 2: 有三种东西需要写入程序 1: 照片 2: 视频 3: 音乐
 3: 支持与电脑连接的储存: 所以需要检测这个,其中数据库储存的仅仅是路径, 文件有文件的地方,文件以源文件储存,不会加密
 4: 多文件写入文件
 
 写文件
 
 1. 获取文件 ----> 从相册获取照片或者视频
            ----> 从ituns上传输
 2. 将文件存储到沙河临时文件中
 2. 加密文件 -----> 利用SourceSecurity 加密
 3. 写入沙河中 这一步才算储存成功
 4. 将路径保存到指定数据库表中

 
 读文件
 1. 读取数据库表中数据
 2. 根据path读取到文件数据
 3. 将文件数据解密存储到硬盘中中的自键文件夹, 之后退出程序会将自建临时文件夹清空, 这个地址与文件存储地址产生映射表
 4. 展示到界面
 */

//这样优点, 消耗内存低,加载快,对于图片可直接将图片储存在内存中,对于视频则不储存在内存
//这样缺点, 占用手机硬盘存储空间


/**
 写文件类型

 - WriteTypePhoto: 照片
 - WriteTypeVideo: 视频
 - WriteTypeMp3: 歌曲
 - WriteTypeFile: 文件
 */
typedef NS_ENUM(NSUInteger, WriteType) {
    WriteTypePhoto,
    WriteTypeVideo,
    WriteTypeMp3,
    WriteTypeFile,
};

/**
 图片写入质量

 - WriteTypePhotoQualityArtwork: 原图
 - WriteTypePhotoQualityThumbnail: 缩略图
 - WriteTypePhotoQualityNone: WriteTypePhotoQualityArtwork
 */
typedef NS_ENUM(NSUInteger, WriteTypeQuality) {
    WriteTypeQualityArtwork,
    WriteTypeQualityThumbnail,
    WriteTypeQualityNone = WriteTypeQualityArtwork,
};


/**
 加密方式

 - DataSecurityTypeBase64: Base64加密
 - DataSecurityTypeAES: AES加密
 - DataSecurityTypeExclusiveOrBase64: 异或加base64
 - DataSecurityTypeExclusiveOrAes: 异或加AES加密
 */
typedef NS_ENUM(NSUInteger, DataSecurityType) {
    DataSecurityTypeBase64,
    DataSecurityTypeAES,
    DataSecurityTypeExclusiveOrBase64,
    DataSecurityTypeExclusiveOrAes,
};

#endif /* WriteFileMacro_h */
