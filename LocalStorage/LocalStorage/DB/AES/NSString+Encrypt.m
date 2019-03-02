//
//  NSString+Encrypt.m
//  CommunityService
//
//  Created by duanzd on 15/10/26.
//  Copyright (c) 2015年 movitech. All rights reserved.
//

#import "NSString+Encrypt.h"
#import <CommonCrypto/CommonCrypto.h>
#import "NSData+XCSCryptUtil.h"


@implementation NSString(Encrypt)

-(NSString *) aes256_encrypt:(NSString *)key
{
    //这个转码会出现 "\" 转码 出现问题 "\\"   获取的data数据缺失
//    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
//    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
//     NSString *verifiation1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
//     NSString *verifiation2 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
//    NSLog(@"1  === %@  \n  2 ==== %@",verifiation1,verifiation2);
    
    //对数据进行加密
    if (key) {
        NSData *result = [data aes256_encrypt:key];
        
        //转换为2进制字符串
        if (result && result.length > 0) {
            
            Byte *datas = (Byte*)[result bytes];
            NSMutableString *output = [NSMutableString stringWithCapacity:result.length * 2];
            for(int i = 0; i < result.length; i++){
                [output appendFormat:@"%02x", datas[i]];
            }
            return output;
        }

    }
        return nil;
}

-(NSString *) aes256_decrypt:(NSString *)key
{
    //转换为2进制Data
    NSMutableData *data = [NSMutableData dataWithCapacity:self.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < ([self length] / 2); i++) {
        byte_chars[0] = [self characterAtIndex:i*2];
        byte_chars[1] = [self characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    if (key) {
        //对数据进行解密
        NSData* result = [data aes256_decrypt:key];
        if (result && result.length > 0) {
            return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        }
    }
   
    return nil;
}



@end
