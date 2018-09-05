//
//  DefineConstant.h
//  BlueBoxDemo
//
//  Created by 刘坤 on 12-7-28.
//  Copyright (c) 2012年 Suning. All rights reserved.
//
#import <UIKit/UIKit.h>

#ifndef DEFINE_CONSTANT_H
#define DEFINE_CONSTANT_H  1

#define IOS10_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending )
#define IOS9_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending )
#define IOS8_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending )
#define IOS7_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending )
#define IOS6_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending )
#define IOS5_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"5.0" options:NSNumericSearch] != NSOrderedAscending )
#define IOS4_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"4.0" options:NSNumericSearch] != NSOrderedAscending )
#define IOS3_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"3.0" options:NSNumericSearch] != NSOrderedAscending )

#define IS_IPAD         (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
#define IS_IPHONE_5     [SNSystemInfo is_iPhone_5];

#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)

#define kColorWithHexString(hex)  [UIColor colorWithHexString:hex]

#define kRandomColor  [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width

#define GetHeight(h)  (h) * kScreenWidth / 320
#define GetWidth(w)   (w) * kScreenWidth / 320

#define Get375Height(h)  (h) * kScreenWidth / 375
#define Get375Width(w)   (w) * kScreenWidth / 375

#define kDeviceWidth    (kScreenWidth<kScreenHeight?kScreenWidth:kScreenHeight)
#define kDeviceHeight   (kScreenWidth<kScreenHeight?kScreenHeight:kScreenWidth)

#define Get414Length(l)  (l) * kDeviceWidth / 414

#define kWByWAndUnit(w,u)  ((w) * kScreenWidth /((u)*1.0))
#define kHByHAndUnit(h,u)  ((h) * kScreenWidth /((u)*1.0))

#define widthScale    kScreenWidth/320

#define HSVCOLOR(h,s,v) [UIColor colorWithHue:h saturation:s value:v alpha:1]
#define HSVACOLOR(h,s,v,a) [UIColor colorWithHue:h saturation:s value:v alpha:a]

#define iPhone5OrLater (kScreenHeight > 480)

#define ScreenWidthMoreThan320 (kScreenWidth > 320)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750,1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iOS7 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)?YES:NO)
#define ApplicationScreenHeight ([[UIScreen mainScreen] bounds].size.height - (iOS7?0:20))
#define ApplicationScreenWidth ([[UIScreen mainScreen] bounds].size.width)


////打印
#ifdef DEBUG
#       define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#       define DLog(...)
#endif





//是否为空或是[NSNull null]
#define NotNilAndNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

//字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
//数组是否为空
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))


#define OC(str) [NSString stringWithCString:(str) encoding:NSUTF8StringEncoding]

//16进制色值参数转换
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//block 声明
#ifdef NS_BLOCKS_AVAILABLE
typedef void (^SNBasicBlock)(void);
typedef void (^SNOperationCallBackBlock)(BOOL isSuccess, NSString *errorMsg, NSString *errorCode, NSString *isNeedImageCode, NSString *isRightImageCode);
typedef void (^SNArrayBlock)(NSArray *list);
typedef void (^SNCustomButtons)(NSString *callBack);
typedef void (^BBBasicBlock)(void);
#endif




//便捷方式创建NSNumber类型
#undef	__INT
#define __INT( __x )			[NSNumber numberWithInt:(int)__x]

#undef	__UINT
#define __UINT( __x )			[NSNumber numberWithUnsignedInt:(NSUInteger)__x]

#undef	__FLOAT
#define	__FLOAT( __x )			[NSNumber numberWithFloat:(float)__x]

#undef	__DOUBLE
#define	__DOUBLE( __x )			[NSNumber numberWithDouble:(double)__x]

//便捷创建NSString
#undef  STR_FROM_INT
#define STR_FROM_INT( __x )     [NSString stringWithFormat:@"%d", (__x)]

#undef  STR_FROM_NSINT
#define STR_FROM_NSINT( __x )     [NSString stringWithFormat:@"%ld", (__x)]

//线程执行方法
#define Foreground_Begin  dispatch_async(dispatch_get_main_queue(), ^{
#define Foreground_End    });

#define Background_Begin  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{\
                                @autoreleasepool {
#define Background_End          }\
                          });



//单例创建
#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}


//arc custom retain and release
#define ARCRetain(...) void *retainedThing = (__bridge_retained void *)__VA_ARGS__; retainedThing = retainedThing
#define ARCRelease(...) void *retainedThing = (__bridge void *) __VA_ARGS__; id unretainedThing = (__bridge_transfer id)retainedThing; unretainedThing = nil


extern NSString* EncodeStringFromDic(NSDictionary *dic, NSString *key);
extern NSNumber* EncodeNumberFromDic(NSDictionary *dic, NSString *key);
extern NSDictionary *EncodeDicFromDic(NSDictionary *dic, NSString *key);
extern NSArray      *EncodeArrayFromDic(NSDictionary *dic, NSString *key);
extern NSArray      *EncodeArrayFromDicUsingParseBlock(NSDictionary *dic, NSString *key, id(^parseBlock)(NSDictionary *innerDic));

/**
 * SN_EXTERN user this as extern
 */
#if !defined(SN_EXTERN)
#  if defined(__cplusplus)
#   define SN_EXTERN extern "C"
#  else
#   define SN_EXTERN extern
#  endif
#endif

/**
 * SN_INLINE user this as static inline
 */
#if !defined(SN_INLINE)
# if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901L
#  define SN_INLINE static inline
# elif defined(__cplusplus)
#  define SN_INLINE static inline
# elif defined(__GNUC__)
#  define SN_INLINE static __inline__
# else
#  define SN_INLINE static
# endif
#endif


#if !__has_feature(objc_arc)

/*safe release*/
#undef TT_RELEASE_SAFELY
#define TT_RELEASE_SAFELY(__REF) \
{\
if (nil != (__REF)) \
{\
CFRelease(__REF); \
__REF = nil;\
}\
}

//view安全释放
#undef TTVIEW_RELEASE_SAFELY
#define TTVIEW_RELEASE_SAFELY(__REF) \
{\
if (nil != (__REF))\
{\
[__REF removeFromSuperview];\
CFRelease(__REF);\
__REF = nil;\
}\
}

//释放定时器
#undef TT_INVALIDATE_TIMER
#define TT_INVALIDATE_TIMER(__TIMER) \
{\
[__TIMER invalidate];\
[__TIMER release];\
__TIMER = nil;\
}

#else

/*safe release*/
#undef TT_RELEASE_SAFELY
#define TT_RELEASE_SAFELY(__REF) \
{\
if (nil != (__REF)) \
{\
__REF = nil;\
}\
}

//view安全释放
#define TTVIEW_RELEASE_SAFELY(__REF) \
{\
if (nil != (__REF))\
{\
[__REF removeFromSuperview];\
__REF = nil;\
}\
}

//释放定时器
#define TT_INVALIDATE_TIMER(__TIMER) \
{\
[__TIMER invalidate];\
__TIMER = nil;\
}

#endif

//国际化
#undef L
#define L(key) \
[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]

//arc 支持performSelector:
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define HTTP_TIMEOUT 20


#endif      //--------------------------------endLine
