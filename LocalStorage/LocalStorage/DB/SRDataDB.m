//
//  SRDataDB.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/8/17.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "SRDataDB.h"

static NSString *const dbname = @"SRDataDB.sqlite";


@implementation SRDataDB

static FMDatabase *db;

+ (instancetype)sharedInstance
{
    static SRDataDB *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SRDataDB alloc] init];

    });
    return instance;
}

- (FMDatabase *)currentDataBase
{
    if (db) {
        return db;
    }
    
    db = [FMDatabase databaseWithPath:[self dbpath]];
    
    if ([db open]) {
       
        NSLog(@"打开数据库成功");
        
        return db;
        
    } else {
        
        NSLog(@"打开数据库失败");
        
        return nil;
    }
    
    
}

- (NSString *)dbpath
{
    //1.获取数据库文件的路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //设置数据库名称
    NSString *fileName = [path stringByAppendingPathComponent:dbname];
    
    NSLog(@"数据库%@",fileName);
    
    return fileName;
}

@end
