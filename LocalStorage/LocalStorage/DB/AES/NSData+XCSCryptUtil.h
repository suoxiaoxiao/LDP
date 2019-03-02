//
//  NSData+XCSCryptUtil.h
//  CommunityService
//
//  Created by duanzd on 15/10/26.
//  Copyright (c) 2015年 movitech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (XCSCryptUtil)

-(NSData *) aes256_encrypt:(NSString *)key;
-(NSData *) aes256_decrypt:(NSString *)key;
@end
