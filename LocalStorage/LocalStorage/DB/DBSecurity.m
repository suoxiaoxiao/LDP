//
//  DBSecurity.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/8/16.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//


#import "DBSecurity.h"
#import "NSString+Encrypt.h"

static NSString *const kBaseEncryotionKey = @"kBaseEncryotionKey";
static NSString *const kBaseDecryptionKey = @"kBaseEncryotionKey";

@implementation DBSecurity


+ (instancetype)sharedInstance
{
    static DBSecurity *instance ;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DBSecurity alloc] init];
    });
    
    return instance;
}

- (NSString *)encryotionKey
{
    if (_encryotionKey == nil) {
        return kBaseEncryotionKey;
    }
    return _encryotionKey;
}
- (NSString *)decryptionKey
{
    if (_decryptionKey == nil) {
        return kBaseDecryptionKey;
    }
    return _decryptionKey;
}

- (NSString *)sr_encryotionOfString:(NSData *)msg
{
    //加密
    switch (self.encryotionType) {
        case DBSecurityEncryptionAES:
        {
            NSString *msgstr = [[NSString alloc] initWithData:msg encoding:NSUTF8StringEncoding];
            return [msgstr aes256_encrypt:self.encryotionKey];
        }
            break;
        case DBSecurityEncryptionBase64:
        {
            NSData *data = [msg base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
            
            return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
            break;
    }
    
    return @"";
}
- (NSString *)sr_decryptionOfString:(NSData *)msg
{
    //解密
    switch (self.encryotionType) {
        case DBSecurityEncryptionAES:
        {
            NSString *msgstr = [[NSString alloc] initWithData:msg encoding:NSUTF8StringEncoding];
            return [msgstr aes256_decrypt:self.decryptionKey];
        }
            break;
        case DBSecurityEncryptionBase64:
        {

            NSString *base64string =  [[NSString alloc] initWithData:msg encoding:NSUTF8StringEncoding];
            
            NSData *data = [[NSData alloc] initWithBase64EncodedString:base64string options:NSDataBase64DecodingIgnoreUnknownCharacters];
            
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            return string;
        }
            break;
    }
    
    return @"";
}

@end
