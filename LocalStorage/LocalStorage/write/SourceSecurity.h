//
//  SourceSecurity.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/8/20.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WriteFileMacro.h"

@interface SourceSecurity : NSObject

+ (NSData *)encryotionSecurityData:(NSData *)sourceData
            securityType:(DataSecurityType)type;

+ (NSData *)decryptionSecurityData:(NSData *)sourceData
                      securityType:(DataSecurityType)type;

@end
