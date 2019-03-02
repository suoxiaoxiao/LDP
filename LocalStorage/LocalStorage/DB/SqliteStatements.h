//
//  SqliteStatements.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/8/17.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SqliteStatements : NSObject

+ (instancetype)sharedInstance;

/**
 创建表的sqlite语句

 @param tableName 表的名字
 @param cls 表的字段所对应的类
 @return 创建这个表的sqlite语句
 
 */
- (NSString *)createTableStatementsForTableName:(NSString *)tableName propertyCls:(Class)cls;

/**
 插入数据

 @param tableName 表的名字
 @param model 数据
 @return 插入数据到这个表的sqlite语句
 */
- (NSString *)insertTableViewStatementsForTableName:(NSString *)tableName propertyModel:(id)model;

/**
 读取表中数据

 @param tableName 表名
 @return sqlite语句
 */
- (NSString *)readTable:(NSString *)tableName;

/**
 更新表

 @param tableName 表名
 @param updates 更新的字段和类型
 @return 插入数据到这个表的sqlite语句
 */
- (NSString *)updateTable:(NSString *)tableName forUpdates:(NSMutableArray *)updates;

/**
 是否存在表

 @param tableName 表名
 @return 插入数据到这个表的sqlite语句
 */
- (NSString *)existTable:(NSString *)tableName;

@end
