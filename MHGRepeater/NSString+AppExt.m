//
//  NSObject+AppExt.m
//  iOSFramework
//
//  Created by 缪和光 on 13-6-11.
//  Copyright (c) 2013年 缪和光. All rights reserved.
//

#import "NSString+AppExt.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (AppExt)

/** 计算字符串的md5值 */
- (NSString *)MD5
{
    if(self == nil || [self length] == 0){
		return nil;
	}
    
	const char *src = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
    
	CC_MD5(src, strlen(src), result);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x",result[i]];
    }
    
    return output;
}

/** 计算SHA512 */
- (NSString *)SHA512
{
    if(self == nil || [self length] == 0){
		return nil;
	}
    const char *src = [self UTF8String];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(src, strlen(src), digest);
    NSMutableString* output = [NSMutableString  stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
    
}

/** 去掉字符串两端的空白字符 */
- (NSString *) trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/** 对字符串URLencode编码 */
- (NSString *)URLEncoding
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)self,NULL,
                                                                                             (CFStringRef)@";/?:@&=$+{}<>,",kCFStringEncodingUTF8));
	return result;
}

/** 对字符串URLdecode解码 */
- (NSString *)URLDecoding
{
    NSString* result = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return result;
}

/** 判断一个字符串是否全由字母组成 */
- (BOOL)isAllletters
{
    NSString *regPattern = @"[a-zA-Z]+";
	NSPredicate *testResult = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regPattern];
	return [testResult evaluateWithObject:self];
}

/** 字符串是不是一个纯整数型 */
- (BOOL)isPureInt
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

/** 获取 UTF8 编码的 NSData 值 */
- (NSData *)toUTF8Data
{
    if ([self length] < 1) {
        return [NSData data];
    }
    
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

@end