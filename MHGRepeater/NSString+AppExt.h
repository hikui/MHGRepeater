//
//  NSObject+AppExt.h
//  iOSFramework
//
//  Created by 缪和光 on 13-6-11.
//  Copyright (c) 2013年 缪和光. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AppExt)

/** 计算字符串的md5值 */
- (NSString *)MD5;

/** 计算SHA512 */
- (NSString *)SHA512;

/** 去掉字符串两端的空白字符 */
- (NSString *) trim;

/** 对字符串URLencode编码 */
- (NSString *)URLEncoding;

/** 对字符串URLdecode解码 */
- (NSString *)URLDecoding;

/** 判断一个字符串是否全由字母组成 */
- (BOOL)isAllletters;

/** 字符串是不是一个纯整数型 */
- (BOOL)isPureInt;

/** 获取 UTF8 编码的 NSData 值 */
- (NSData *)toUTF8Data;

@end