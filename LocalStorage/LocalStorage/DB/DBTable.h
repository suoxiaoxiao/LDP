//
//  DBTable.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/8/17.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTableModel.h"
#import "DBSecurity.h"

@interface DBTable : NSObject

- (instancetype)initWithTableName:(NSString *)tableName withPropertyClass:(Class)cls;

- (BOOL)insertModel:(BaseTableModel *)model;

- (NSString *)tableName;

- (NSArray *)getDataList;

- (BOOL)deleteModel:(BaseTableModel *)model;

- (BOOL)addModel:(BaseTableModel *)model;

@end
