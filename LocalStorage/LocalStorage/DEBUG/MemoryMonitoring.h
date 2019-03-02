//
//  MemoryMonitoring.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/11/28.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MemoryMonitoring : NSObject

//使用内存 M
+ (double)getDeviceUseMemory;
//设备内存 M
+ (double)getDeviceAllMemory;

@end

NS_ASSUME_NONNULL_END
