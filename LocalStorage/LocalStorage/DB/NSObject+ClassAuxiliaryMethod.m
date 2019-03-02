//
//  NSObject+ClassAuxiliaryMethod.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/8/20.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "NSObject+ClassAuxiliaryMethod.h"
#import <objc/runtime.h>

@implementation NSObject (ClassAuxiliaryMethod)

+ (NSArray *)getAllPropertyOfSelfClass
{
    
    Class cls = self;
    
    if (cls == nil) {
        return @[];
    }
    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    
    if ([cls isEqual:[NSObject class]]) {
        
        return @[];
        
    }
    
    [mArray addObjectsFromArray:[[cls superclass] getAllPropertyOfSelfClass]];
    
    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数
    
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    
    for (int i = 0; i < count; i++) {
        
        // objc_property_t 属性类型
        objc_property_t property = properties[i];
        // 获取属性的名称 C语言字符串
        const char *cName = property_getName(property);
        const char *cProperty = property_getAttributes(property);
        
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        NSString *propertystr = [NSString stringWithCString:cProperty
                                                   encoding:NSUTF8StringEncoding];
        
        [mArray addObject:name];
        [mArray addObject:propertystr];
    }
    
    return mArray.copy;
}

@end
