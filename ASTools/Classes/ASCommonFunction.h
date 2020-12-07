//
//  ASCommonFunction.h
//  hxxdj
//
//  Created by aisino on 2018/4/1.
//  Copyright © 2018年 aisino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>
@interface ASCommonFunction : NSObject
+ (NSString *)dicToJsonString:(id)object;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString *)stringToUFT8:(NSString *)str;
+ (id)isNull:(id)dataStr;

+ (NSString *)getPureJsonString:(NSString *)str;

+ (NSString *)getJSONWith:(NSMutableArray *)strArray;

+ (BOOL)isValidateMobile:(NSString *)mobile;
+ (BOOL)isValidateEmail:(NSString *)email;
+ (BOOL)isValidateURL:(NSString *)urlStr;
// 身份证校验
+ (BOOL)isValidateIdentityCard:(NSString *)identityCard;
//银行卡号校验
+ (BOOL)isValidateBankCardNo:(NSString*)cardNum;

// 支持中文和字母
+ (BOOL)isChineseName:(NSString *)chineseName;

//时间转换
+ (NSString *)nowTimeDate; // 现在时间
+ (NSString *)NSDateToNSString:(NSDate *)date;
+ (NSString *)NSDateToNSString2:(NSDate *)date;
+ (NSString *)NSDateToNSString3:(NSDate *)date;
+ (NSString *)NSDateToNSString5:(NSDate *)date;
+ (NSString *)NSDateToNSStringWithHM:(NSDate *)date;
+ (NSString *)NSDateToNSStringWithHM2:(NSDate *)date;
+ (NSString *)NSDateToNSStringWithHMS:(NSDate *)date ;
+ (NSString *)NSDateToNSString4:(NSDate *)date;
+ (NSString *)NSStringToDateIntegerWithFormatter:(NSString *)formatterType dateString :(NSString *)dateString;
+ (NSString *)NSStringWithDateString:(NSString *)dateString dateStringFormatter:(NSString *)dateStringFormatter toFormatter:(NSString *)toFormatter;
+ (NSString *)timeFormatted:(int)totalSeconds;
+ (NSDate *)NSStringToNSDate:(NSString *)timeStr;

/**
 @param dateString 时间字符串
 @param formate 时间格式
 @return  
 */
+ (NSString *)formateDate:(NSString *)dateString withFormate:(NSString *)formate;

//获取当前时间和服务器时间的时间差
+ (NSTimeInterval)compareCurrentTimeWithTimeStr:(NSString *)timeStr withDateFormateStr:(NSString *)dateFormateStr;

//钱的千位符转换
+ (NSString *)separatedStrWithStr:(NSString *)string;
+ (NSString *)separatedFloatStrWithStr:(NSString *)string;
+ (NSString *)deleteZeroWithString:(NSString *)str;

//plist文件转换对象
+ (NSArray *)getPlistArrayByplistName:(NSString *)plistName;
//获得一个随机字符串，位数自己定
+ (NSString *)getRandomString;
//获取一个随机数字，位数自己定
+ (NSString *)getRandomNumberWithCount:(NSInteger)countNumber;

//四舍五入，取小数点后几位
+(NSDecimalNumber *)roundUp:(NSDecimalNumber *)number afterPoint:(int)position;
// 从小数点后第三位四舍五入，取小数点后两位
+(NSDecimalNumber *)roundUp:(NSDecimalNumber *)number;

//取小数点后几位，不四舍五入
+(NSDecimalNumber *)roundDown:(NSDecimalNumber *)price afterPoint:(int)position;


//给UILabel设置行间距和字间距
+(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font;
//计算UILabel的高度(带有行间距的情况)
+(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width;

//判断汉字
- (BOOL)isChinese;//判断是否是纯汉字

- (BOOL)includeChinese;//判断是否含有汉字

// 判断是否为税号
+ (BOOL)isTaxCode:(NSString *)taxCode;

//判断是不是今天
+(BOOL)isDay:(NSString*)timeStr;
//判断是不是今年
+(BOOL)isThisYear:(NSString*)timeStr;

+(BOOL)isEmail:(NSString *)email;


/**
 判断一个对象是否为空
 @param obj 任意类型的对象
 @return YES-空值 NO-非空值
 */
+ (BOOL)isEmpty:(id)obj;



/**
 字符串大小

 @param text 字符串
 @param font 字符串显示的文字大小
 @param  maxSize 文字显示的预计区域
 @return 字符串大小
 */
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;


/**
 去除字符串中的空格

 @param origiText 字符串
 @return 没有空格的字符串
 */
+ (NSString *)getNoBlankText:(NSString *)origiText;

/**
 字符串小写转大写

 @param origiText 字符串
 @return 大写字符串
 */
+ (NSString *)getUpcaseText:(NSString *)origiText;


//小数点后边的位数是否合法
+ (BOOL)getPointString:(NSString *)string length:(NSInteger)length;

/**
 中英文混排字符串所占的字符长度
 
 英文、数字 -> 1个字符长度
 中文 ->2个字符长度

 @param origiText 中英文混排字符串
 @return 字符长度
 */
+ (int)getTextCharLength:(NSString *)origiText;


/**
 根据范围给一个字符串设置不同的颜色

 @param originalStr 原始字符串
 @param difColor 目标颜色
 @param range 目标范围
 @return 字符串
 */
+ (NSMutableAttributedString *)getDifColorStr:(NSString *)originalStr
                                     difColor:(UIColor *)difColor
                                        range:(NSRange)range;

+ (NSMutableAttributedString *)getDiffontSizeStr:(NSString *)originalStr
                                   fontSize1:(UIFont *)fontSize1
                                   fontSize2:(UIFont *)fontSize2
                                       range:(NSRange)range;

+(NSMutableAttributedString *)getDiffontSizeStrArr:(NSArray *)strArr
                                           fontArr:(NSArray *)fontArr
                                          colorArr:(NSArray *)colorArr;



/*
 * 通过 String生成  条形码
 */

+(UIImage*)createBarImageWithOrderStr:(NSString*)str;


+ (UIImage *)barcodeImageWithContent:(NSString *)content codeImageSize:(CGSize)size;
/*
 * 通过 String生成 二维码
 */

+ (UIImage *)generateQRCodeWithInputMessage:(NSString *)inputMessage
                                      Width:(CGFloat)width
                                     Height:(CGFloat)height;

/*
* 通过 path 获取文件MD5值
*/
+(NSString*)getFileMD5WithPath:(NSString*)path;


/**
 ** ASE 加密
 * plainText 被加密的字符串
 * key 秘钥
 */
+(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key;

/**
** ASE 解密
* encryptText 被解密的字符串
* key 秘钥
*/

+(NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key;


@end
