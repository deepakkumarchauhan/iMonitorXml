//
//  AESCrypto.h
//  Mobiloitte
//
//  Created by Sunil Verma on 01/11/16.
//  Copyright © 2016 Sunil Verma. All rights reserved.
//

#import <Foundation/Foundation.h>

//AES Encryption Key
#define kEncryptionKey      @"iMonitorApplicationEncryptionKey"


@interface AESCrypto : NSObject

+ (NSString *) AES128EncryptString:(NSString*)plaintext withKey:(NSString*)key;
+ (NSString *) AES128DecryptString:(NSString *)ciphertext withKey:(NSString*)key;

+ (NSString *)SHA256:(NSString *)key;
+ (NSString *)MD5:(NSString *)key;


@end
