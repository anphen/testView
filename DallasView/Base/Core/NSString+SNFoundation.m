//
//  NSString+SNFoundation.m
//  SNFoundation
//
//  Created by liukun on 14-3-3.
//  Copyright (c) 2014年 liukun. All rights reserved.
//

#import "NSString+SNFoundation.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "SystemInfo.h"
#import "DefineConstant.h"

@implementation NSString (SNFoundation)

/*
 * 取得一个串的 ‘separateString’之前部分
 * 2015/12/14
 * @xzoscar
 */
- (NSString *)prefixStringWithSeparate:(NSString *)separateString {
    if (!IsStrEmpty(separateString)) {
        NSRange range = [self rangeOfString:separateString];
        if (range.length > 0) {
            return [self substringToIndex:range.location];
        }
    }
    return self;
}


+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict addingPercentEscapes:(BOOL)add
{
    NSMutableArray * pairs = [NSMutableArray array];
	for ( NSString * key in [dict keyEnumerator] )
	{
        id value = [dict valueForKey:key];
        if ([value isKindOfClass:[NSNumber class]])
        {
            value = [value stringValue];
        }
        else if ([value isKindOfClass:[NSString class]])
        {
            
        }
        else
        {
            continue;
        }
		
		[pairs addObject:[NSString stringWithFormat:@"%@=%@",
                          add?[key URLEncoding]:key,
                          add?[value URLEncoding]:value]];
	}
	
	return [pairs componentsJoinedByString:@"&"];
}

- (NSDictionary*)queryDictionaryUsingEncodingQR:(NSStringEncoding)encoding
{
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:self];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [[[kvPair objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:encoding] trim];
            NSString* value = [[[kvPair objectAtIndex:1]
                                stringByReplacingPercentEscapesUsingEncoding:encoding] trim];
            if (value != nil && key != nil) {
                [pairs setObject:value forKey:key];
            }
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}


- (NSDictionary*)queryDictionaryUsingEncoding:(NSStringEncoding)encoding
{
	NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
	NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
	NSScanner* scanner = [[NSScanner alloc] initWithString:self];
	while (![scanner isAtEnd]) {
		NSString* pairString = nil;
		[scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
		[scanner scanCharactersFromSet:delimiterSet intoString:NULL];
		NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
		if (kvPair.count == 2) {
			NSString* key = [[[kvPair objectAtIndex:0]
                              stringByReplacingPercentEscapesUsingEncoding:encoding] trim];
			NSString* value = [[[kvPair objectAtIndex:1]
                                stringByReplacingPercentEscapesUsingEncoding:encoding] trim];
            if (value != nil && key != nil) {
                [pairs setObject:value forKey:key];
            }
		}
	}
	
	return [NSDictionary dictionaryWithDictionary:pairs];
}

- (NSDictionary *)queryDictionaryWithSNRouterRuleUsingEncoding:(NSStringEncoding)encoding {
    //初始化结果
    NSMutableDictionary *pairs = [NSMutableDictionary dictionary];
    //判断是否是解析一个页面路由规则的url
    if ([self rangeOfString:@"adTypeCode="].location != NSNotFound) {
        //判断adTypeCode是否是1002
        if ([self rangeOfString:@"adTypeCode=1002"].location != NSNotFound) {
            [pairs setObject:@"1002" forKey:@"adTypeCode"];
            
            NSRange range = [self rangeOfString:@"adId="];
            if (range.location != NSNotFound) {
                [pairs setObject:[self substringFromIndex:(range.location + 5)] forKey:@"adId"];
            }
        }
        else {
            //其它的情况，字符串里包含问号，则用&替换?号
            NSString *newString = [self stringByReplacingOccurrencesOfString:@"?" withString:@"&"];
            [pairs setDictionary:[newString queryDictionaryUsingEncoding:encoding]];
        }
    }
    else {
        [pairs setDictionary:[self queryDictionaryUsingEncoding:encoding]];
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}

- (NSString *)urlByAppendingDict:(NSDictionary *)params
{
    NSURL *parsedURL = [NSURL URLWithString:self];
	NSString *queryPrefix = parsedURL.query ? @"&" : @"?";
	NSString *query = [NSString queryStringFromDictionary:params addingPercentEscapes:YES];
	return [NSString stringWithFormat:@"%@%@%@", self, queryPrefix, query];
}

- (NSString *)urlByAppendingDictNoEncode:(NSDictionary *)params
{
    NSURL *parsedURL = [NSURL URLWithString:self];
	NSString *queryPrefix = parsedURL.query ? @"&" : @"?";
	NSString *query = [NSString queryStringFromDictionary:params addingPercentEscapes:NO];
	return [NSString stringWithFormat:@"%@%@%@", self, queryPrefix, query];
}

- (NSString *)URLEncoding
{
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)ebuyURLEncoding
{
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)URLDecoding
{
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)trim
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isEmpty
{
	return [self length] > 0 ? NO : YES;
}

- (BOOL)eq:(NSString *)other
{
	return [self isEqualToString:other];
}

- (BOOL)isValueOf:(NSArray *)array
{
	return [self isValueOf:array caseInsens:NO];
}

- (BOOL)isValueOf:(NSArray *)array caseInsens:(BOOL)caseInsens
{
	NSStringCompareOptions option = caseInsens ? NSCaseInsensitiveSearch : 0;
	
	for ( NSObject * obj in array )
	{
		if ( NO == [obj isKindOfClass:[NSString class]] )
			continue;
		
		if ( [(NSString *)obj compare:self options:option] == NSOrderedSame )
			return YES;
	}
	
	return NO;
}

- (NSString *)trimDotZero
{
    NSRange range = [self rangeOfString:@"."];
    if (!range.length) {
        return self;
    }
    
    NSString * pattern = @"[0\.]*0$";
    NSRegularExpression * reg = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
   return [reg stringByReplacingMatchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length) withTemplate:@""];
}

-(NSString *)containNumber
{
    NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString * containNumber =[self stringByTrimmingCharactersInSet:nonDigits];
    return containNumber;
}


- (NSString *)getterToSetter
{
    NSRange firstChar, rest;
    firstChar.location  = 0;
    firstChar.length    = 1;
    rest.location       = 1;
    rest.length         = self.length - 1;
    
    return [NSString stringWithFormat:@"set%@%@:",
            [[self substringWithRange:firstChar] uppercaseString],
            [self substringWithRange:rest]];
}


- (NSString *)setterToGetter
{    
    NSRange firstChar, rest;
    firstChar.location  = 3;
    firstChar.length    = 1;
    rest.location       = 4;
    rest.length         = self.length - 5;
    
    return [NSString stringWithFormat:@"%@%@",
            [[self substringWithRange:firstChar] lowercaseString],
            [self substringWithRange:rest]];
}

- (NSString *)formatJSON
{
    int indentLevel = 0;
    BOOL inString    = NO;
    char currentChar = '\0';
    char *tab = "    ";
    
    NSUInteger len = [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    const char *utf8 = [self UTF8String];
    NSMutableData *buf = [NSMutableData dataWithCapacity:(NSUInteger)(len * 1.1f)];
    
    for (int i = 0; i < len; i++)
    {
        currentChar = utf8[i];
        switch (currentChar) {
            case '{':
            case '[':
                if (!inString) {
                    [buf appendBytes:&currentChar length:1];
                    [buf appendBytes:"\n" length:1];
                    
                    for (int j = 0; j < indentLevel+1; j++) {
                        [buf appendBytes:tab length:strlen(tab)];
                    }
                    
                    indentLevel += 1;
                } else {
                    [buf appendBytes:&currentChar length:1];
                }
                break;
            case '}':
            case ']':
                if (!inString) {
                    indentLevel -= 1;
                    [buf appendBytes:"\n" length:1];
                    for (int j = 0; j < indentLevel; j++) {
                        [buf appendBytes:tab length:strlen(tab)];
                    }
                    [buf appendBytes:&currentChar length:1];
                } else {
                    [buf appendBytes:&currentChar length:1];
                }
                break;
            case ',':
                if (!inString) {
                    [buf appendBytes:",\n" length:2];
                    for (int j = 0; j < indentLevel; j++) {
                        [buf appendBytes:tab length:strlen(tab)];
                    }
                } else {
                    [buf appendBytes:&currentChar length:1];
                }
                break;
            case ':':
                if (!inString) {
                    [buf appendBytes:":" length:1];
                } else {
                    [buf appendBytes:&currentChar length:1];
                }
                break;
            case ' ':
            case '\n':
            case '\t':
            case '\r':
                if (inString) {
                    [buf appendBytes:&currentChar length:1];
                }
                break;
            case '"':
                
                if (i > 0 && utf8[i-1] != '\\')
                {
                    inString = !inString;
                }
                
                [buf appendBytes:&currentChar length:1];
                break;
            default:
                [buf appendBytes:&currentChar length:1];
                break;
        }
    }
    
    return [[NSString alloc] initWithData:buf encoding:NSUTF8StringEncoding];
}

+ (NSString *)GUIDString
{
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    if (theUUID!=NULL) {
        CFRelease(theUUID);
    }
	return (__bridge_transfer NSString *)string;
}

- (NSString *)removeHtmlTags
{
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"<[^>]+>" options:0 error:NULL];
    return [regex stringByReplacingMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length) withTemplate:@""];
}

- (BOOL)has4ByteChar
{
    __block BOOL has4Byte = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              
                              if ([substring lengthOfBytesUsingEncoding:NSUTF8StringEncoding] >= 4)
                              {
                                  has4Byte = YES;
                                  *stop = YES;
                              }
                          }];
    return has4Byte;
}

- (BOOL)isAsciiString
{
    return [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == [self length];
}

#pragma #mark ------

+ (CGFloat)getHeightWithString:(NSString *)string font:(UIFont *)font lineBreakModel:(int)breakModel limitWidth:(CGFloat)width
{
    if (!font) {
        return 0;
    }
    
    CGFloat height =0;
    if (IOS7_OR_LATER) {
        CGRect  rect =[string boundingRectWithSize:CGSizeMake(width, INT32_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
        height = rect.size.height;
    }else{
        CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, INT32_MAX) lineBreakMode:breakModel];
        height = size.height;
    }
    return ceilf(height);
    
}

+ (CGFloat)getWidthWithString:(NSString *)string font:(UIFont *)font lineBreakModel:(int)breakModel
{
    if (!font) {
        return 0;
    }
    
    CGFloat width =0;
    if (IOS7_OR_LATER) {
        CGRect  rect =[string boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, font.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
        width = rect.size.width;
    }else{
        CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, font.lineHeight) lineBreakMode:breakModel];
        width = size.width;
    }
    
    return ceilf(width);
}

/*!
 @author 徐韦, 16-03-10 14:03:42
 
 @brief 单行字符串size计算,\
 Single line, no wrapping,Truncation based on the NSLineBreakMode.
 
 @param font
 @param lineBreakMode default [UIFont systemFontOfSize:14] if nil
 
 @return CGSzie()
 
 @since 5.0 version
 */
- (CGSize)sizeOfSingleLineWithFont:(UIFont *)font {
    UIFont *drawFont = font;
    if (nil == drawFont) {
        drawFont = [UIFont systemFontOfSize:14];
    }
    
    return ([self sizeWithAttributes:@{NSFontAttributeName:drawFont}]);
}

/*!
 @author 徐韦, 16-03-10 09:03:53
 
 @brief 推算字符串size
 
 @param font          default [UIFont systemFontOfSize:14] if nil
 @param size          限制尺寸
 @param lineBreakMode lineBreakMode description
 
 @return CGSzie()
 
 @since 5.0 version
 */
- (CGSize)sizeWithFont:(UIFont *)font limitedSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode {
    CGSize retSize = CGSizeZero;
    if (IOS7_OR_LATER) {
        NSDictionary *attr = @{NSFontAttributeName:(nil==font)?[UIFont systemFontOfSize:14]:font};
        CGRect  rect =[self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attr
                                         context:nil];
        retSize = rect.size;
    }else{
        retSize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
    }
    return retSize;
}

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
            lineBreakMode:(NSLineBreakMode)lineBreakMode {
    return ([self sizeWithFont:font limitedSize:size lineBreakMode:lineBreakMode]).height;
}

/*!
 @author 徐韦, 16-03-10 15:03:42
 
 @brief Single line, no wrapping. Truncation based on the NSLineBreakMode.
 
 @param point default [UIFont systemFontOfSize:14] if nil
 @param font  font description
 
 @since 5.0 version
 */
- (void)drawOfSingleLineAtPoint:(CGPoint)point withFont:(UIFont *)font {
    UIFont *drawFont = font;
    if (nil == drawFont) {
        drawFont = [UIFont systemFontOfSize:14];
    }
    
    [self drawAtPoint:point withAttributes:@{NSFontAttributeName:drawFont}];
}

@end


#pragma mark -----------------------------

@implementation NSString (SNEncryption)

- (NSString *)MD5Hex
{
	const char *str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

- (NSData *)hexStringToData
{
    if (!self.length) {
        return nil;
    }
    
    const char *ch = [[self lowercaseString] cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* data = [[NSMutableData alloc] initWithCapacity:strlen(ch)/2];
    while (*ch)
    {
        char byte = 0;
        if ('0' <= *ch && *ch <= '9')
        {
            byte = *ch - '0';
        }
        else if ('a' <= *ch && *ch <= 'f')
        {
            byte = *ch - 'a' + 10;
        }
        ch++;
        byte = byte << 4;
        if (*ch)
        {
            if ('0' <= *ch && *ch <= '9')
            {
                byte += *ch - '0';
            } else if ('a' <= *ch && *ch <= 'f')
            {
                byte += *ch - 'a' + 10;
            }
            ch++;
        }
        
        [data appendBytes:&byte length:1];
    }
    
    return data;
}

@end
