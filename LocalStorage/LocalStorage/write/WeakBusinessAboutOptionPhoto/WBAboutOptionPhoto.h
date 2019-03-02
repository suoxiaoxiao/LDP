//
//  WBAboutOptionPhoto.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/12/10.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

/**
 
 用协议  协议
 
 
 //协议类   定制协议
 //协议类的功能: 把写好的文件
 // 半业务
 //第一种协议:  写文件---->读文件---->给出第一层模型, 元模型 这个不是映射协议,,这个协议比较死,是对于元数据的处理协议
 
 //完全是业务
 //第二种协议:  元模型---->UI模型 =======> map协议  相当于映射协议
 
 //实现协议: 不是业务
 基协议: 空实现, 为了后期
 
 故基协议 ----> (元数据协议) 办业务 -----> (业务映射协议)全业务
 
 //扩展 ====== > 完全是业务层, 放出去
 :
 后期扩展使用-->集成基协议去做模型扩展
 
 这个口怎么放?????????
  ||
  ||
  ||
  VV
 
 入口  =====  出口
 显示第一种模型协议 -----> 再是第二种模型协议
 
 
 数据走向
  原图二进制data ----------经过第一层协议---------->暴露出来元模型
                                                    |
                   这里面的过程需要隐蔽掉               |
        |----------<-----------------------<--------|
        |
        V
  暴露出来的元模型---------经过第二层协议--------->UI使用的模型

 

 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WBAboutOptionPhoto : NSObject

+ (instancetype)sharedInstance;

//- (void)test_encode;
//- (NSArray *)test_decode;

@end

NS_ASSUME_NONNULL_END
