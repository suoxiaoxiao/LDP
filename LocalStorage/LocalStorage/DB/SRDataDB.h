//
//  SRDataDB.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/8/17.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@interface SRDataDB : NSObject

+ (instancetype)sharedInstance;

- (FMDatabase *)currentDataBase;

- (NSString *)dbpath;

@end
