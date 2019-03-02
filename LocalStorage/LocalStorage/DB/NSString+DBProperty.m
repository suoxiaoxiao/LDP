//
//  NSString+DBProperty.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/8/20.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "NSString+DBProperty.h"

@implementation NSString (DBProperty)


- (NSString *)getDBMarkingOfPropertyAttribute
{
    //注意类型有integer,text,blob,boolean,varchar等text->字符串类型 integer->整型 real->浮点型
    if ([self containsString:@"NSString"] ||
        [self containsString:@"&"] ||
        [self containsString:@"C"]) {
        
        return @"text";
    }
    
    if ([self containsString:@"Ti"] ||
        [self containsString:@"Tq"]) {
        return @"integer";
    }
    if ([self containsString:@"Tf"]) {
        return @"real";
    }
    if ([self containsString:@"TB"]) {
        return @"blob";
    }
    
    return @"text";
    
    /*
     flo,
     "Tf,N,V_flo", float
     
     size,
     "Ti,N,V_size", int
     lon,
     "Tq,N,V_lon", long
     width,
     "Tq,N,V_width", nsinteger
     
     isload,
     "TB,N,V_isload", bool
     
     identifie,
     "T@\"NSString\",C,N,V_identifie",
     dict,
     "T@\"NSDictionary\",&,N,V_dict",
     array,
     "T@\"NSMutableArray\",&,N,V_array",
     path,
     "T@\"NSString\",C,N,V_path",
     filePath,
     "T@\"NSString\",&,N,V_filePath"
     
     @property (nonatomic , assign) int size;
     @property (nonatomic , assign) float flo;
     @property (nonatomic , assign) long lon;
     @property (nonatomic , assign) BOOL isload;
     @property (nonatomic , assign) NSInteger width;
     @property (nonatomic , strong) NSDictionary *dict;
     @property (nonatomic , strong) NSMutableArray *array;
     @property (nonatomic , copy)   NSString *path;
     @property (nonatomic , strong) NSString *filePath;
     */
    
}

@end
