//
//  NSString+Encrypt.h
//  CommunityService
//
//  Created by duanzd on 15/10/26.
//  Copyright (c) 2015年 movitech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encrypt)

-(NSString *) aes256_encrypt:(NSString *)key;
-(NSString *) aes256_decrypt:(NSString *)key;
@end
