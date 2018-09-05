//
//  NSString+SNFoundation.h
//  SNFoundation
//
//  Created by liukun on 14-3-3.
//  Copyright (c) 2014年 liukun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (SNFoundation)

/*
 * 取得一个串的 ‘separateString’之前部分
 * 2015/12/14
 * @xzoscar
 */
- (NSString *)prefixStringWithSeparate:(NSString *)separateString;


- (NSString *)urlByAppendingDict:(NSDictionary *)params;
- (NSString *)urlByAppendingDictNoEncode:(NSDictionary *)params;

+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict addingPercentEscapes:(BOOL)add;

- (NSDictionary *)queryDictionaryUsingEncodingQR:(NSStringEncoding)encoding;
- (NSDictionary *)queryDictionaryUsingEncoding:(NSStringEncoding)encoding;
- (NSDictionary *)queryDictionaryWithSNRouterRuleUsingEncoding:(NSStringEncoding)encoding;


- (NSString *)URLEncoding;
- (NSString *)ebuyURLEncoding;
- (NSString *)URLDecoding;

- (NSString *)trim;
- (BOOL)isEmpty;
- (BOOL)eq:(NSString *)other;

- (BOOL)isValueOf:(NSArray *)array;
- (BOOL)isValueOf:(NSArray *)array caseInsens:(BOOL)caseInsens;

- (NSString *)getterToSetter;
- (NSString *)setterToGetter;

- (NSString *)formatJSON;
+ (NSString *)GUIDString;
- (NSString *)removeHtmlTags;

- (BOOL)has4ByteChar;
- (BOOL)isAsciiString;

//addby snping
//5.10 去掉0,5.00去掉.00
@property(nonatomic,strong,readonly)NSString * trimDotZero;

@property(nonatomic,strong,readonly)NSString * containNumber;//字符串中包含的所有数字 ex:dog23dog=>23 dog3dog4=>34

#pragma mark - 计算高度,宽度 addby snping--
//限宽的高度
+ (CGFloat)getHeightWithString:(NSString *)string font:(UIFont *)font lineBreakModel:(int)breakModel limitWidth:(CGFloat)width;

//单行的宽度
+ (CGFloat)getWidthWithString:(NSString *)string font:(UIFont *)font lineBreakModel:(int)breakModel;


/*!
 @author 徐韦, 16-03-10 14:03:42
 
 @brief 单行字符串size计算,\ Single line, no wrapping
 
 @param font
 @param lineBreakMode default [UIFont systemFontOfSize:14] if nil
 
 @return CGSzie()
 
 @since 5.0 version
 */
- (CGSize)sizeOfSingleLineWithFont:(UIFont *)font;

/*!
 @author 徐韦, 16-03-10 09:03:53
 
 @brief 推算字符串size
 
 @param font          default [UIFont systemFontOfSize:14] if nil
 @param size          限制尺寸
 @param lineBreakMode lineBreakMode description
 
 @return CGSzie()
 
 @since 5.0 version
 */
- (CGSize)sizeWithFont:(UIFont *)font
           limitedSize:(CGSize)size
         lineBreakMode:(NSLineBreakMode)lineBreakMode;

/*!
 @author 徐韦, 16-03-10 09:03:53
 
 @brief 推算字符串 height
 
 @param font          default [UIFont systemFontOfSize:14] if nil
 @param size          限制尺寸
 @param lineBreakMode lineBreakMode description
 
 @return height
 
 @since 5.0 version
 */
- (CGFloat)heightWithFont:(UIFont *)font
              limitedSize:(CGSize)size
            lineBreakMode:(NSLineBreakMode)lineBreakMode;

/*!
 @author 徐韦, 16-03-10 15:03:42
 
 @brief Single line, no wrapping. Truncation based on the NSLineBreakMode.
 
 @param point default [UIFont systemFontOfSize:14] if nil
 @param font  font description
 
 @since 5.0 version
 */
- (void)drawOfSingleLineAtPoint:(CGPoint)point withFont:(UIFont *)font;

@end

#pragma mark -

@interface NSString (SNEncryption)

- (NSString *)MD5Hex;
- (NSData *)hexStringToData;    //从16进制的字符串格式转换为NSData

@end

