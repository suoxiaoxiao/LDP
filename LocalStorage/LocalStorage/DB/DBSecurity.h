//
//  DBSecurity.h
//  LocalStorage
//
//  Created by 索晓晓 on 2018/8/16.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DBSecurityEncryption) {
    DBSecurityEncryptionAES,
    DBSecurityEncryptionBase64,
};

@interface DBSecurity : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic , assign)  DBSecurityEncryption encryotionType;

@property (nonatomic , copy) NSString *encryotionKey;
@property (nonatomic , copy) NSString *decryptionKey;

- (NSString *)sr_encryotionOfString:(NSData *)msg;
- (NSString *)sr_decryptionOfString:(NSData *)msg;

@end
