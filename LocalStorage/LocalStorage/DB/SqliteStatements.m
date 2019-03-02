//
//  SqliteStatements.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/8/17.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "SqliteStatements.h"
#import <objc/runtime.h>
#import "DBSecurity.h"
#import "NSString+HXAddtions.h"
#import "NSString+DBProperty.h"
#import "NSObject+ClassAuxiliaryMethod.h"

@implementation SqliteStatements

+ (instancetype)sharedInstance
{
    static SqliteStatements *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SqliteStatements alloc] init];
    });
    return instance;
}

- (NSString *)createTableStatementsForTableName:(NSString *)tableName propertyCls:(Class)cls
{
    /*
     create table if not exists 表名
     (
     字段名 类型(字符个数，可以省略) primary key autoincrement,
     字段名 类型(字符个数，可以省略) null(可以省略),
     字段名 类型(字符个数，可以省略) not null(可以省略),
     字段名 类型(字符个数，可以省略) not null(可以省略)
     );
     注意类型有integer,text,blob,boolean,varchar等
     例如：
     create table if not exists Book
     (
     id integer primary key autoincrement,
     name text,
     url text,
     des text
     );
     */
    
    NSArray *array = [cls getAllPropertyOfSelfClass];
    NSMutableString *mstring = [[NSMutableString alloc] init];
    [mstring appendString:@"CREATE TABLE IF NOT EXISTS "];
    [mstring appendString:tableName];
    [mstring appendString:@" (id integer PRIMARY KEY AUTOINCREMENT"];
    
    for (int i = 0; i < array.count; i = i+2) {
        
        [mstring appendString:@", "];
        NSString *name = array[i];
        NSString *property = array[i + 1];
        [mstring appendString:name];
        [mstring appendString:@" "];
        [mstring appendString:[property getDBMarkingOfPropertyAttribute]];
        [mstring appendString:@" NOT NULL"];
        
    }
    [mstring appendString:@");"];
    
    NSLog(@"%@",mstring);
    
    return mstring;
    
}

- (NSString *)insertTableViewStatementsForTableName:(NSString *)tableName propertyModel:(id)model
{
    NSMutableString *mstring = [[NSMutableString alloc] init];
    
    /*
     - 格式: INSERT INTO 表名(字段名1,字段名2,...) VALUES(字段1的值,字段2的值,...);
     INSERT INTO t_Student(name,studyId) VALUES('小明3',109);
     */
    [mstring appendString:@"INSERT INTO "];
    [mstring appendString:tableName];
    [mstring appendString:@"("];
    NSArray *array = [[model class] getAllPropertyOfSelfClass];
    
    for (int i = 0; i < array.count; i = i+2) {
        
        if (i > 0) {
            [mstring appendString:@","];
        }
        NSString *name = array[i];
        [mstring appendString:name];
    }
    
    [mstring appendString:@")"];
    [mstring appendString:@" VALUES("];
    
    for (int i = 0; i < array.count; i = i+2) {
        
        NSString *name = array[i];
        NSString *property = array[i + 1];
        NSString *text = [property getDBMarkingOfPropertyAttribute];
        
        if (i > 0) {
            [mstring appendString:@","];
        }
         //加密
        if ([text isEqualToString:@"text"]) {
            
            //这里不一定是NSString
            //两种处理方式NSDictionary NSMutableDictionary NSMutableArray  NSArray
            id value = [model valueForKey:name];
            if (value == nil) {
                value = @"";
            }
            NSString *stringvalue;
            
            if ([value isKindOfClass:[NSString class]]) {
                
                stringvalue = value;
                
            }else if ([value isKindOfClass:[NSDictionary class]] ||
                      [value isKindOfClass:[NSArray class]]) {
               
                stringvalue = [NSString jsonStringWithObject:value];
                
            }
            
            NSData *data = [stringvalue dataUsingEncoding:NSUTF8StringEncoding];
            NSString *resultvalue = [[DBSecurity sharedInstance] sr_encryotionOfString:data];
            [mstring appendString:@"'"];
            [mstring appendString:resultvalue];
            [mstring appendString:@"'"];
            
            continue;
            
        }else if ([text isEqualToString:@"integer"]) {
            
            //整数
            NSInteger value = [[model valueForKey:name] integerValue];
            NSString *stringvalue = [NSString stringWithFormat:@"%ld",value];
            [mstring appendString:stringvalue];
            
        }else if ([text isEqualToString:@"real"]) {
            
            //浮点数
            float value = [[model valueForKey:name] floatValue];
            NSString *stringvalue = [NSString stringWithFormat:@"%f",value];
            [mstring appendString:stringvalue];

        }else if ([text isEqualToString:@"blob"]) {
            
            NSInteger value = [[model valueForKey:name] integerValue];
            NSString *stringvalue = [NSString stringWithFormat:@"%ld",value];
            [mstring appendString:stringvalue];
        }
        
    }
    
    [mstring appendString:@")"];
    
    NSLog(@"%@",mstring);
    
    return mstring;
    
}

- (NSString *)readTable:(NSString *)tableName
{
    return [NSString stringWithFormat:@"select * from %@",tableName];
}

- (NSString *)updateTable:(NSString *)tableName forUpdates:(NSMutableArray *)updates
{
    NSMutableString *mstring = [NSMutableString string];
    
    [mstring appendString:@"ALTER TABLE "];
    [mstring appendString:tableName];
    [mstring appendString:@" ADD"];
    
    for (int i = 0; i < updates.count; i = i+2) {
        
        NSString *name = updates[i];
        NSString *property = updates[i + 1];
        
        NSString *text = [property getDBMarkingOfPropertyAttribute];
        [mstring appendString:@" "];
        [mstring appendString:name];
        [mstring appendString:@" "];
        [mstring appendString:text];
    }
    
    NSLog(@"%@",mstring);
    
    return mstring;
}

- (NSString *)existTable:(NSString *)tableName
{
    NSMutableString *mstring = [NSMutableString string];
    
    [mstring appendFormat:@"select count(*) as 'count' from sqlite_master where type ='table' and name = %@",tableName];
    
    return mstring;
    
}

@end
