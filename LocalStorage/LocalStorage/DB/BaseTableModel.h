//
//  BaseTableModel.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/8/17.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseTableModel : NSObject

@property (nonatomic , copy) NSString *identifie;

@property (nonatomic , copy) NSString *filePath;        //加密文件路径
@property (nonatomic , copy) NSString *tmpPath;         //临时文件夹

@property (nonatomic , assign) NSInteger securityType;  //安全类型
@property (nonatomic , assign) NSInteger fileType;      //文件类型
@property (nonatomic , assign) NSInteger quality;       //质量

@end
