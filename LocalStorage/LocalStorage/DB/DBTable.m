//
//  DBTable.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/8/17.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "DBTable.h"
#import "SRDataDB.h"
#import <FMDB.h>
#import "SqliteStatements.h"
#import "FMResultSet+DBResult.h"
#import "NSString+DBProperty.h"
#import "NSObject+ClassAuxiliaryMethod.h"

@interface DBTable ()
{
    Class _propertyClass;
}
@property (nonatomic , copy) NSString *tableName;


@end

@implementation DBTable

- (instancetype)initWithTableName:(NSString *)tableName withPropertyClass:(Class)cls
{
    if (self = [super init]) {
                
        FMDatabase *db =  [[SRDataDB sharedInstance] currentDataBase];
        NSAssert(db != nil, @"数据库未打开");
        NSAssert(cls != nil, @"属性类为空");
        
        if (tableName == nil) {
            tableName = [NSString stringWithFormat:@"t_%@", NSStringFromClass(cls)];
        }
        
        self.tableName = tableName;
        _propertyClass = cls;
        
        //查看表是否存在 如存在需要检测是否要升级表
        BOOL ret = [self isTableOK:tableName];
        
        if (ret) {
            //检测表的升级
            BOOL flag = YES;
            NSMutableArray *updateParams = [NSMutableArray array];
            NSArray *array = [cls getAllPropertyOfSelfClass];
            for (int i = 0; i < array.count; i = i+2) {
                
                NSString *name = array[i];
                
                flag = [db columnExists:name inTableWithName:tableName];
                
                if (!flag) {
                    [updateParams addObject:name];
                    NSString *peoperty = array[i+1];
                    [updateParams addObject:peoperty];
                }
            }
            
            if (updateParams.count > 0) {
                
                BOOL worked = [db executeUpdate:[[SqliteStatements sharedInstance] updateTable:tableName forUpdates:updateParams]];
                
                if(worked){
                    NSLog(@"升级成功");
                }else{
                    
                    NSLog(@"升级失败");
                }
            }
        }
        
        //3.创建表
        BOOL result = [db executeUpdate:[[SqliteStatements sharedInstance] createTableStatementsForTableName:tableName propertyCls:cls]];
        
        if (result) {
            NSLog(@"创建表成功");
        } else {
            NSLog(@"创建表失败");
        }
        
        //设值默认的加密方式
        [DBSecurity sharedInstance].encryotionType = DBSecurityEncryptionAES;
        
    }
    return self;
}


/**
 是否存在表

 @param tableName 表名
 */
- (BOOL) isTableOK:(NSString *)tableName
{
    FMResultSet *rs = [[[SRDataDB sharedInstance] currentDataBase] executeQuery:[[SqliteStatements sharedInstance] existTable:tableName]];
    
    while ([rs next])
    {
        NSInteger count = [rs intForColumn:@"count"];
        
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return NO;
}

- (NSString *)tableName
{
    return _tableName;
}

- (BOOL)insertModel:(BaseTableModel *)model
{
    BOOL result = [[[SRDataDB sharedInstance] currentDataBase] executeUpdate:[[SqliteStatements sharedInstance] insertTableViewStatementsForTableName:self.tableName propertyModel:model]];
    
    if (result) {
       
        NSLog(@"插入成功");
        return YES;
    } else {
        
        NSLog(@"插入失败");
        return NO;
    }
    
}

- (NSArray *)getDataList
{
    
    FMResultSet * resultSet = [[[SRDataDB sharedInstance] currentDataBase] executeQuery:[[SqliteStatements sharedInstance] readTable:self.tableName]];
    
    NSMutableArray *marray = [NSMutableArray array];
    
    while ([resultSet next]) {
    
        [marray addObject:[resultSet resultObjectForClass:_propertyClass]];
        
    }
    
    return marray;
}




@end
