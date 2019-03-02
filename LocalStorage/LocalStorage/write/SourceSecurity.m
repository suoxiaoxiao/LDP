//
//  SourceSecurity.m
//  LocalStorage
//
//  Created by 索晓晓 on 2018/8/20.
//  Copyright © 2018年 SXiao.RR. All rights reserved.
//

#import "SourceSecurity.h"
#import "NSString+Encrypt.h"

static NSString *const kExclusiveOrKey = @"exclusiveOrKey";

static NSString *const kAESDataKey = @"aesDataKey";

@implementation SourceSecurity

+ (NSData *)encryotionSecurityData:(NSData *)sourceData
                      securityType:(DataSecurityType)type
{
    NSAssert(sourceData != nil, @"二进制数据位空");
    
    if (sourceData == nil ||
        ![sourceData isKindOfClass:[NSData class]]) {
        return nil;
    }
    
    switch (type) {
        case DataSecurityTypeAES:
        {
            return [self aesEncryotionFromData:sourceData];
        }
            break;
        case DataSecurityTypeBase64:
        {
            return [self base64EncryotionFromData:sourceData];
        }
            break;
        case DataSecurityTypeExclusiveOrAes:
        {
            
            NSData *data = [self exclusiveOrFromData:sourceData];
            
            data = [self aesEncryotionFromData:data];
            
            return data;
        }
            break;
        case DataSecurityTypeExclusiveOrBase64:
        {
            NSData *data = [self exclusiveOrFromData:sourceData];
            return [self base64EncryotionFromData:data];
        }
            break;
        default:
            break;
    }
    
    return [NSData data];
}

+ (NSData *)decryptionSecurityData:(NSData *)sourceData
                      securityType:(DataSecurityType)type
{
    NSAssert(sourceData != nil, @"二进制数据位空");
    
    if (sourceData == nil ||
        ![sourceData isKindOfClass:[NSData class]]) {
        return nil;
    }
    
    switch (type) {
        case DataSecurityTypeAES:
        {
            return [self aesDecryptionFromData:sourceData];
        }
            break;
        case DataSecurityTypeBase64:
        {
            return [self base64DecryptionFromData:sourceData];
        }
            break;
        case DataSecurityTypeExclusiveOrAes:
        {
            
            NSData *data = [self aesDecryptionFromData:sourceData];
            
            data = [self exclusiveOrFromData:data];
            
            return data;
        }
            break;
        case DataSecurityTypeExclusiveOrBase64:
        {
            NSData *data = [self base64DecryptionFromData:sourceData];
            
            return  [self exclusiveOrFromData:data];
        }
            break;
        default:
            break;
    }
    
    
    return [NSData data];
}

/**
 异或加密
 */
+ (NSData *)exclusiveOrFromData:(NSData *)data
{
    Byte  *myByte = (Byte *)[data bytes];
    
    NSData* keyBytes = [kExclusiveOrKey dataUsingEncoding:NSUTF8StringEncoding];
    
    Byte  *keyByte = (Byte *)[keyBytes bytes];
    
    int keyIndex = 0;
    
    for (int i = 0; i < [data length]; i++)
    {
        myByte[i]  = myByte[i] ^ keyByte[keyIndex];
        
        if (++keyIndex == [keyBytes length])//将key的数据从头开始做,这样子会产生规律性
        {
            keyIndex = 0;
        }
        
        if (i > 1000) {
            break;
        }
    }
    
    NSData *result = [NSData dataWithBytes:myByte length:[data length]];
    
    return result;
}

/**
 base64 加密
 */
+ (NSData *)base64EncryotionFromData:(NSData *)data
{
    NSData *base64data = [data base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return base64data;
}
/**
 base64 解密
 */
+ (NSData *)base64DecryptionFromData:(NSData *)data
{
    
    NSData *base64data = [[NSData alloc] initWithBase64EncodedData:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    return base64data;
}

/**
 aes 加密
 */
+ (NSData *)aesEncryotionFromData:(NSData *)data
{
    
    //这边可能是文件, 所以不支持UTF-8编码格式
    NSString *msgstr;
    
    //转成base64 加密
    msgstr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSString *aes = [msgstr aes256_encrypt:kAESDataKey];
    
    NSData *resule = [aes dataUsingEncoding:NSUTF8StringEncoding];
    
    return resule;
}

/**
 aes 解密
 */
+ (NSData *)aesDecryptionFromData:(NSData *)data
{
    NSString *msgstr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *aes = [msgstr aes256_decrypt:kAESDataKey];
    
    //base64解密
   NSData *result = [[NSData alloc] initWithBase64EncodedString:aes options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    return result;
}


@end
