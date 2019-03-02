//
//  OptionPhotoWriteManager.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/25.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//



/*  将选择的资源加密保存到本地之后返回给外界可用或者设定的模型
    用户获取资源的类型有3种
那么这个协议拥有一个类型字段, 这个字段去区分类型  , 类型会对应结果类型
 如何应对设置在类型中 ,, 类型也会实现一个适配器协议
 
 
 也就是说要拥有两个协议
 
 */


#import <Foundation/Foundation.h>

@class CoreAssetBaseItem;

typedef void(^WriteFilesComplateBlock)(BOOL ret,NSArray *resources);
typedef void(^WriteSingleFileComplateBlock)(BOOL ret,id resource);

NS_ASSUME_NONNULL_BEGIN

@interface OptionPhotoWriteManager : NSObject

- (void)writeToFiles:(NSArray <CoreAssetBaseItem *>*)items complate:(WriteFilesComplateBlock)block;

//写单个文件使用适配器去获取适配之后的模型
- (void)writeToFile:(CoreAssetBaseItem *)item ofAdapter:(id)adapter complate:(WriteSingleFileComplateBlock)block;

- (NSArray *)writeToFiles:(NSArray <CoreAssetBaseItem *>*)item ofAdapter:(id)adapter complate:(WriteFilesComplateBlock)block;

@end

NS_ASSUME_NONNULL_END
