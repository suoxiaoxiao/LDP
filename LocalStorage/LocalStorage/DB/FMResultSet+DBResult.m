//
//  FMResultSet+DBResult.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/8/20.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "FMResultSet+DBResult.h"
#import "NSString+DBProperty.h"
#import "NSObject+ClassAuxiliaryMethod.h"
#import "DBSecurity.h"
#import <objc/runtime.h>

@implementation FMResultSet (DBResult)

- (id)resultObjectForClass:(Class)cls
{
    NSAssert(cls != nil, @"FMResultSet+DBResult cls不能为空");
    
    id obj = [[cls alloc] init];
    
    //这是这个类的所有属性
    NSArray *array = [cls getAllPropertyOfSelfClass];
    
    for (int i = 0; i < array.count; i = i+2) {
        
        NSString *name = array[i];
        id result = [self objectForColumn:name];
        
        if (result == nil || [result isKindOfClass:[NSNull class]]) {
            continue;
        }
        
        NSString *property = array[i + 1];
        NSString *text = [property getDBMarkingOfPropertyAttribute];
        if ([text isEqualToString:@"integer"] ||
            [text isEqualToString:@"blob"] ||
            [text isEqualToString:@"real"]) {
            [obj setValue:result forKey:name];
        }
        if ([text isEqualToString:@"text"]) {
//            identifie,
//            "T@\"NSString\",C,N,V_identifie",
//            dict,
//            "T@\"NSDictionary\",&,N,V_dict",
//            array,
//            "T@\"NSMutableArray\",&,N,V_array",
//            path,
//            "T@\"NSString\",C,N,V_path",
//            filePath,
//            "T@\"NSString\",&,N,V_filePath"
            if ([property containsString:@"NSDictionary"]) {
                
                //解密
                NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
                NSString *decrptionStr = [[DBSecurity sharedInstance] sr_decryptionOfString:data];
                
                //设值
                if (decrptionStr == nil) {
                    [obj setValue:[NSDictionary dictionary] forKey:name];
                    continue;
                }
                NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:[decrptionStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                
                [obj setValue:resultDict forKey:name];
                
            }else if([property containsString:@"NSMutableDictionary"]){
                
                //解密
                NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
                NSString *decrptionStr = [[DBSecurity sharedInstance] sr_decryptionOfString:data];
                
                //设值
                if (decrptionStr == nil) {
                    [obj setValue:[NSMutableDictionary dictionary] forKey:name];
                    continue;
                }
                
                NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:[decrptionStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                
                [obj setValue:[NSMutableDictionary dictionaryWithDictionary:resultDict] forKey:name];
                
            }else if([property containsString:@"NSArray"]){
                
                //解密
                NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
                NSString *decrptionStr = [[DBSecurity sharedInstance] sr_decryptionOfString:data];
                
                //设值
                if (decrptionStr == nil) {
                    [obj setValue:[NSArray array] forKey:name];
                    continue;
                }
                
                NSArray *resultArr = [NSJSONSerialization JSONObjectWithData:[decrptionStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                
                [obj setValue:resultArr forKey:name];
                
            }else if([property containsString:@"NSMutableArray"]){
                
                //解密
                NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
                NSString *decrptionStr = [[DBSecurity sharedInstance] sr_decryptionOfString:data];
                
                //设值
                if (decrptionStr == nil) {
                    [obj setValue:[NSMutableArray array] forKey:name];
                    continue;
                }
                
                NSArray *resultArr = [NSJSONSerialization JSONObjectWithData:[decrptionStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                
                [obj setValue:[NSMutableArray arrayWithArray:resultArr] forKey:name];
                
            }else if([property containsString:@"NSString"]){
                
                //解密
                NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
                NSString *decrptionStr = [[DBSecurity sharedInstance] sr_decryptionOfString:data];
                
                //设值
                if (decrptionStr == nil) {
                    [obj setValue:[NSString string] forKey:name];
                    continue;
                }
                
                [obj setValue:decrptionStr forKey:name];
                
            }
            
            
        }
        
    }
    
    
    /*
     {
     array = 5211668b6abf6c26449a15aa01199886;
     dict = 4a95a7874551f474b960beed6d41d013;
     filePath = 5e5936bc30a70ec6110e1996cee811fa;
     flo = "0.12";
     id = 1;
     identifie = 1d00811480f82a5fc3bfc31d057de3fa;
     isload = 1;
     lon = 200;
     path = 1228d48840ee00fcc12ee35125793ac4;
     size = 1;
     width = 2000;
     }
     */
    
    
    //自增长ID
    //        int idNum = [resultSet intForColumn:@"id"];
    
    //        NSString *name = [resultSet objectForColumnName:@"name"];
    //        int age = [resultSet intForColumn:@"age"];
    //        NSString *sex = [resultSet objectForColumnName:@"sex"];
    //        NSLog(@"学号：%@ 姓名：%@ 年龄：%@ 性别：%@",@(idNum),name,@(age),sex);
    
    return obj;
}



@end
