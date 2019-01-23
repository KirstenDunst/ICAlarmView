//
//  NSString+Extends.h
//  AlarmView
//
//  Created by 曹世鑫 on 2019/1/23.
//  Copyright © 2019 宗盛商业. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extends)

//字典转字符串的方法(去除内部的空格以及换行)
+ (NSString *)convertToJsonData:(NSDictionary *)dict;

//字典转字符串形式（单纯的字典转为data然后再进一步转为字符串逻辑，不去除内部的空格以及换行）
+ (NSString *)stringWithDicData:(NSDictionary *)dic;

// md5加密
+ (NSString *)md5:(NSString *)str;

// 将data转成base64然后去除base64字符串中换行符，空格符
//（可以结合UIImageJPEGRepresentation生成对图片转字符串的base64编码处理）后台需要的图片是base64位的字符串类型
+ (NSString *)changeBase64ThenRemoveSpaceAndNewlineWithData:(NSData *)data;

//付呗贷中获取设备的ip
+ (NSString *)deviceWANIPAddress;

//图片base字符串转图片
- (UIImage *)base64StringConversionImage;

//获取字符串中的数字
- (NSInteger)getNumberInString;

/**
 获取指定小数点位数
 
 @param price    源数据
 @param position 精确的小数点位数
 @return 指定小数点数字
 */
+ (NSString *)notRounding:(CGFloat)price afterPoint:(NSInteger)position;

/**
 手机号验证
 
 @return 是否有效(YES 有效，NO 无效)
 */
- (BOOL)mobilePhoneNumberVerification;

/**
 密码校验(只能包含字母和数字)
 
 @param minDigits 最小位数
 @param maxDigits 最大位数
 @return 是否有效
 */
- (BOOL)checkPassword:(NSInteger)minDigits maxDigits:(NSInteger)maxDigits;

/**
 是否是纯数字
 @param minDigits 最小位数
 @param maxDigits 最大位数
 @return 是否有效
 */
- (BOOL)isNumText:(NSInteger)minDigits maxDigits:(NSInteger)maxDigits;

/**
 密码校验(至少包含字母和数字)
 
 @param minDigits 最小位数
 @param maxDigits 最大位数
 */
- (BOOL)checkPasswordContainsLetterOrdigital:(NSInteger)minDigits maxDigits:(NSInteger)maxDigits;

/**
 判断是否是纯汉字
 
 @return 是返回YES，否则NO
 */
- (BOOL)isChinese;

/**
 判断是否含有汉字
 
 @return 是返回YES，否则NO
 */
- (BOOL)includeChinese;

/**
 获取文字排列大小宽度
 
 @param font 字体大小
 @param maxH 高度
 @return 计算大小
 */
- (CGSize)sizeWithFont:(UIFont *)font maxH:(CGFloat)maxH;

/**
 获取文字排列大小高度
 
 @param font 字体大小
 @param maxW 宽度
 @return 计算大小
 */
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;

@end

NS_ASSUME_NONNULL_END
