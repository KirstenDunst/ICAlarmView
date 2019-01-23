//
//  NSString+Extends.m
//  AlarmView
//
//  Created by 曹世鑫 on 2019/1/23.
//  Copyright © 2019 宗盛商业. All rights reserved.
//

#import "NSString+Extends.h"
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>

@implementation NSString (Extends)

// 字典转json字符串方法
+ (NSString *)convertToJsonData:(NSDictionary *)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        //        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

+ (NSString *)changeBase64ThenRemoveSpaceAndNewlineWithData:(NSData *)data{
    // 转成base64
    NSString *encodedImgStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *final = [NSString stringWithFormat:@"data:image/png;base64,%@",encodedImgStr];
    NSString *temp = [final stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

+ (NSString *)stringWithDicData:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    if (parseError) {
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//付呗贷中获取设备的ip
+ (NSString *)deviceWANIPAddress{
    NSURL *ipURL = [NSURL URLWithString:@"http://ip.taobao.com/service/getIpInfo.php?ip=myip"];
    NSData *data = [NSData dataWithContentsOfURL:ipURL];
    if (data) {
        NSDictionary *ipDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *ipStr = nil;
        if (ipDic && [ipDic[@"code"] integerValue] == 0) { //获取成功
            ipStr = ipDic[@"data"][@"ip"];
        }
        return (ipStr ? ipStr : @"");
    }else{
        return nil;
    }
}

// md5加密
+ (NSString *)md5:(NSString *)str{
    NSString *resultStr = nil;
    const char *cStr = [str UTF8String];//指针不能变，cStr指针变量本身可以变化
    unsigned char result[16];//这里可以CC_MD5_DIGEST_LENGTH宏代替16，这里不明白为什么写16后面我有解释的！
    CC_MD5(cStr, (unsigned int)strlen(cStr), result);
    resultStr = [NSString stringWithFormat:
                 @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                 result[0], result[1], result[2], result[3],
                 result[4], result[5], result[6], result[7],
                 result[8], result[9], result[10], result[11],
                 result[12], result[13], result[14], result[15]
                 ];
    return [resultStr lowercaseString];
}

- (UIImage *)base64StringConversionImage {
    NSData *imageData = [[NSData alloc]initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}

- (NSInteger)getNumberInString {
    NSScanner *scanner = [NSScanner scannerWithString:self];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    NSInteger number;
    [scanner scanInteger:&number];
    return number;
    /**
     NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
     int remainSecond =[[urlString stringByTrimmingCharactersInSet:nonDigits] intValue];
     */
}

+ (NSString *)notRounding:(CGFloat)price afterPoint:(NSInteger)position {
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

- (BOOL)mobilePhoneNumberVerification {
    NSString *mobile = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11 || [[mobile substringToIndex:1] integerValue] != 1) {
        return NO;
    }
    return YES;
}

- (BOOL)checkPassword:(NSInteger)minDigits maxDigits:(NSInteger)maxDigits {
    //谓词
    NSString *pattern = [NSString stringWithFormat:@"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{%zd,%zd}",minDigits,maxDigits];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

- (BOOL)isNumText:(NSInteger)minDigits maxDigits:(NSInteger)maxDigits {
    NSString * regex = [NSString stringWithFormat:@"^\\d{%zd,%zd}$",minDigits,maxDigits];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self];
    //    if (isMatch) {
    //        return YES;
    //    }else{
    //        return NO;
    //    }
    return isMatch;
}


- (BOOL)checkPasswordContainsLetterOrdigital:(NSInteger)minDigits maxDigits:(NSInteger)maxDigits {
    BOOL result = NO;
    if ([self length] >= minDigits && [self length] <= maxDigits){
        //数字条件
        NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
        
        //符合数字条件的有几个
        NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:self
                                                                           options:NSMatchingReportProgress
                                                                             range:NSMakeRange(0, self.length)];
        
        //英文字条件
        NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
        
        //符合英文字条件的有几个
        NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:self
                                                                                 options:NSMatchingReportProgress
                                                                                   range:NSMakeRange(0, self.length)];
        
        if (tNumMatchCount >= 1 && tLetterMatchCount >= 1){
            result = YES;
        }
        
    }
    return result;
}

- (BOOL)oldMobilePhoneNumberVerification {
    NSString *mobile = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *mobileRules = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *unicomRules = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *telecomRules = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRules];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", unicomRules];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telecomRules];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}

- (BOOL)isChinese {
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)includeChinese {
    for(int i = 0; i < [self length];i++)
    {
        int a = [self characterAtIndex:i];
        if( a > 0x4e00&& a < 0x9fff){
            return YES;
        }
    }
    return NO;
}

- (CGSize)sizeWithFont:(UIFont *)font maxH:(CGFloat)maxH {
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(MAXFLOAT, maxH);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW {
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
