//
//  ASCommonFunction.m
//  hxxdj
//
//  Created by aisino on 2018/4/1.
//  Copyright © 2018年 aisino. All rights reserved.
//

#import "ASCommonFunction.h"

#define UILABEL_LINE_SPACE 6
#define HEIGHT [[UIScreen mainScreen] bounds].size.height

@implementation ASCommonFunction

+ (NSString*)dicToJsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:0 //Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//       jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
//        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        
    }
    return jsonString;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers|kNilOptions
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString *)stringToUFT8:(NSString *)str{
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    return [str stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
}

+ (id)isNull:(id)dataStr {
    //判断数据字符串是否为null,避免崩溃
    if ([dataStr isKindOfClass:[NSNull class]]) {
        return nil;
    } else {
        return dataStr;
    }
}

+ (NSString *)getJSONWith:(NSMutableArray *)strArray{
    NSMutableString *jsonStr = [[NSMutableString alloc]init]  ;
    [jsonStr appendString:@"{"];
    for (NSInteger i = 0; i < strArray.count; i++) {
        NSArray *subArray = [[strArray objectAtIndex:i] componentsSeparatedByString:@"&"];
        if(subArray.count ==2){
            [jsonStr appendFormat:@"\"%@\":\"%@\"",[subArray objectAtIndex:0],[subArray objectAtIndex:1]];
        }
        
        if(i < strArray.count-1){
            [jsonStr appendString:@","];
        }
    }
    [jsonStr appendString:@"}"];
    return [NSString stringWithFormat:@"%@",jsonStr];
}

+ (NSString *)getPureJsonString:(NSString *)str{
    NSMutableString *responseString = [NSMutableString stringWithString:str];
    NSString *character = nil;
    for (int i = 0; i < responseString.length; i ++) {
        character = [responseString substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqualToString:@"\""])
            [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
    }
    return responseString;
}


//手机号码的正则表达式
+ (BOOL) isValidateMobile:(NSString *)mobile{
    return mobile.length == 11;
//    //手机号以13、14、15、16、17、18开头，八个\d数字字符
//    NSString *phoneRegex = @"^(0|86|17951)?(13|14|16|15|17|18|19)\\d{9}$";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

//url正则表达式  
+ (BOOL)isValidateURL:(NSString *)urlStr {
    NSString *urlRegex = @"[[^(?:(http[s]?):)?//([^:/\?]+)(?::(\d+))?([^\?]*)\??(.*)]]";
    NSPredicate * urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",urlRegex];
    return [urlTest evaluateWithObject:urlStr];
}

+ (BOOL)isChineseName:(NSString *)chineseName
{
    if (chineseName.length == 0) return NO;
    NSString *regex = @"^[\u4e00-\u9fa5]{0,}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:chineseName];
}




+(BOOL)isValidateIdentityCard:(NSString *)value
{
    
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSInteger length =0;
    
    if (!value) {
        
        return NO;
        
    }else {
        
        length = value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41",@"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    
    BOOL areaFlag =NO;
    
    for (NSString *areaCode in areasArray) {
        
        if ([areaCode isEqualToString:valueStart2]) {
            
            areaFlag =YES;
            
            break;
            
        }
        
    }
    
    if (!areaFlag) {
        
        return false;
        
    }
    //生日部分的编码
    NSRegularExpression *regularExpression;
    
    NSUInteger numberofMatch;
    
    NSInteger year =0;
    
    switch (length) {
            
        case 15:
            
            year = [value substringWithRange:NSMakeRange(8,2)].intValue +1900;
            
            if (year %400 ==0 || (year %100 !=0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                     
                                                                        options:NSRegularExpressionCaseInsensitive
                                     
                                                                          error:nil];//测试出生日期的合法性
                
            }else {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                     
                                                                        options:NSRegularExpressionCaseInsensitive
                                     
                                                                          error:nil];//测试出生日期的合法性
                
            }
            //numberofMatch:匹配到得字符串的个数
            numberofMatch = [regularExpression numberOfMatchesInString:value
                             
                                                               options:NSMatchingReportProgress
                             
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                
                return YES;
                
            }else {
                
                return NO;
                
            }
            
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            
            if (year %400 ==0 || (year %100 !=0 && year %4 ==0)) {
                
                //原来的@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                     
                                                                        options:NSRegularExpressionCaseInsensitive
                                     
                                                                          error:nil];//测试出生日期的合法性
                
            }else {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                     
                                                                        options:NSRegularExpressionCaseInsensitive
                                     
                                                                          error:nil];//测试出生日期的合法性
                
            }
            
            numberofMatch = [regularExpression numberOfMatchesInString:value
                             
                                                               options:NSMatchingReportProgress
                             
                                                                 range:NSMakeRange(0, value.length)];
            //验证校验位
            if(numberofMatch >0) {
                
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                
                int Y = S %11;
                
                NSString *M =@"F";
                
                NSString *JYM =@"10X98765432";
                
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    
                    return YES;// 检测ID的校验位
                    
                }else {
                    
                    return NO;
                    
                }
                
            }else {
                
                return NO;
                
            }
            
        default:
            
            return false;
    }
}
//银行卡号校验
+ (BOOL)isValidateBankCardNo:(NSString*)cardNum{
//    银行卡号有效性问题Luhn算法
//    *  现行 16 位银联卡现行卡号开头 6 位是 622126～622925 之间的，7 到 15 位是银行自定义的，
//    *  可能是发卡分行，发卡网点，发卡序号，第 16 位是校验码。
//    *  16 位卡号校验位采用 Luhm 校验方法计算：
//    *  1，将未带校验位的 15 位卡号从右依次编号 1 到 15，位于奇数位号上的数字乘以 2
//    *  2，将奇位乘积的个十位全部相加，再加上所有偶数位上的数字
//    https://blog.csdn.net/hmxiao_1983/article/details/29845911

    NSString * lastNum = [[cardNum substringFromIndex:(cardNum.length-1)] copy];//取出最后一位
    
    NSString * forwardNum = [[cardNum substringToIndex:(cardNum.length -1)] copy];//前15或18位
    
    
    NSMutableArray * forwardArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i=0; i<forwardNum.length; i++) {
        
        NSString * subStr = [forwardNum substringWithRange:NSMakeRange(i, 1)];
        
        [forwardArr addObject:subStr];
        
    }
    
    
    
    NSMutableArray * forwardDescArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i =(forwardArr.count-1); i> -1; i--) {//前15位或者前18位倒序存进数组
        
        [forwardDescArr addObject:forwardArr[i]];
        
    }
    
    
    
    NSMutableArray * arrOddNum = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 < 9
    
    NSMutableArray * arrOddNum2 = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 > 9
    
    NSMutableArray * arrEvenNum = [[NSMutableArray alloc] initWithCapacity:0];//偶数位数组
    
    
    
    for (int i=0; i< forwardDescArr.count; i++) {
        
        NSInteger num = [forwardDescArr[i] intValue];
        
        if (i%2) {//偶数位
            
            [arrEvenNum addObject:[NSNumber numberWithInt:num]];
            
        }else{//奇数位
            
            if (num * 2 < 9) {
                
                [arrOddNum addObject:[NSNumber numberWithInt:num * 2]];
                
            }else{
                
                NSInteger decadeNum = (num * 2) / 10;
                
                NSInteger unitNum = (num * 2) % 10;
                
                [arrOddNum2 addObject:[NSNumber numberWithInt:unitNum]];
                
                [arrOddNum2 addObject:[NSNumber numberWithInt:decadeNum]];
                
            }
            
        }
        
    }
    
    
    
    __block  NSInteger sumOddNumTotal = 0;
    
    [arrOddNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        
        sumOddNumTotal += [obj integerValue];
        
    }];
    
    
    
    __block NSInteger sumOddNum2Total = 0;
    
    [arrOddNum2 enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        
        sumOddNum2Total += [obj integerValue];
        
    }];
    
    
    
    __block NSInteger sumEvenNumTotal =0 ;
    
    [arrEvenNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        
        sumEvenNumTotal += [obj integerValue];
        
    }];
    
    
    
    NSInteger lastNumber = [lastNum integerValue];
    
    
    
    NSInteger luhmTotal = lastNumber + sumEvenNumTotal + sumOddNum2Total + sumOddNumTotal;
    
    
    
    return (luhmTotal%10 ==0)?YES:NO;
    
}

+ (BOOL)isTaxCode:(NSString *)taxCode
{
    if (taxCode.length != 15 && taxCode.length != 18 &&taxCode.length != 17&&taxCode.length != 21&& taxCode.length != 20)  return NO;
    NSString *emailRegex = @"^[0-9A-Za-z]*$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:taxCode];
}


/**
 /////  和当前时间比较
 ////   1）1分钟以内 显示        :    刚刚
 ////   2）1小时以内 显示        :    X分钟前
 ///    3）今天或者昨天 显示      :    今天 09:30   昨天 09:30
 ///    4) 今年显示              :   09月12日
 ///    5) 大于本年      显示    :    2013-09-09
 **/

+ (NSString *)formateDate:(NSString *)dateString withFormate:(NSString *)formate
{
        // 设置时间格式
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formate];
        
        // 当前时间（手机本地时间）
        NSDate * nowDate = [NSDate date];
        
        // 1. 传入进来的时间字符串(服务器时间) - > NSDate
        NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
        
        // 2. 传入进来的时间和本机时间对比 --> 时间差（秒）
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        
        // 3. 利用时间差，判断是今天、昨天、今年、非今年
        NSString *dateStr = @"";
        if(time<=60*60*24) // 相差一天时间
        {
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            NSString *need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *now_yMd =  [dateFormatter stringFromDate:nowDate];
            
            if ([need_yMd isEqualToString:now_yMd])  //日期一样是今天
            {
                [dateFormatter setDateFormat:@"HH:mm:ss"];
                dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }
            else // 相差24小时，日期不一样是昨天
            {
                [dateFormatter setDateFormat:@"HH:mm:ss"];
                dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }
        }
        else
        {
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear])  // 同一年
            {
                [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
            else
            {
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; // 不在同一年
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
    
    return dateStr;
}

+ (NSTimeInterval)compareCurrentTimeWithTimeStr:(NSString *)timeStr withDateFormateStr:(NSString *)dateFormateStr {
    // 设置时间格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormateStr];
    
    // 当前时间（手机本地时间）
    NSDate * nowDate = [NSDate date];
    
    // 1. 传入进来的时间字符串(服务器时间) - > NSDate
    NSDate * needFormatDate = [dateFormatter dateFromString:timeStr];
    
    // 2. 传入进来的时间和本机时间对比 --> 时间差（秒）
    NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
    
    return time;
}

+ (NSString *)nowTimeDate
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* strDate = [formatter stringFromDate:[NSDate date]];
    return strDate;
}

//时间格式转换
+ (NSString *)NSDateToNSString:(NSDate *)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString* strDate = [formatter stringFromDate:date];
    return strDate;
}

+ (NSString *)NSDateToNSString2:(NSDate *)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* strDate = [formatter stringFromDate:date];
    return strDate;
}
+ (NSString *)NSDateToNSString3:(NSDate *)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString* strDate = [formatter stringFromDate:date];
    return strDate;
}

+ (NSString *)NSDateToNSString4:(NSDate *)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString* strDate = [formatter stringFromDate:date];
    return strDate;
}

+ (NSString *)NSDateToNSString5:(NSDate *)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmSS"];
    NSString* strDate = [formatter stringFromDate:date];
    return strDate;
}

+ (NSString *)NSDateToNSStringWithHMS:(NSDate *)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString* strDate = [formatter stringFromDate:date];
    return strDate;
}

+ (NSString *)NSDateToNSStringWithHM:(NSDate *)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString* strDate = [formatter stringFromDate:date];
    return strDate;
}

+ (NSString *)NSDateToNSStringWithHM2:(NSDate *)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString* strDate = [formatter stringFromDate:date];
    return strDate;
}

+ (NSString *)NSStringToDateIntegerWithFormatter:(NSString *)formatterType dateString :(NSString *)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatterType];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:dateString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp ;
}


+ (NSString *)NSStringWithDateString:(NSString *)dateString dateStringFormatter:(NSString *)dateStringFormatter toFormatter:(NSString *)toFormatter{
    //设置转换格式
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:dateStringFormatter];
    //NSString转NSDate
    NSDate*date=[formatter dateFromString:dateString];
    [formatter setDateFormat:toFormatter];
    
    return [formatter stringFromDate:date];
}


+(NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

+ (NSDate *)NSStringToNSDate:(NSString *)timeStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:timeStr];
    return date;
}

// 千位符函数
+ (NSString *)separatedStrWithStr:(NSString *)string
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    double value = [string doubleValue];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [formatter stringFromNumber:@(value)];
}

+ (NSString *)separatedFloatStrWithStr:(NSString *)string
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    double value = [string doubleValue];
    [formatter setPositiveFormat:@"###,##0.00;"];
    return [formatter stringFromNumber:@(value)];
}
// 删除末尾0
+ (NSString *)deleteZeroWithString:(NSString *)str
{
    NSMutableString *string = [[NSMutableString alloc]initWithFormat:@"%@",str];
    NSArray *array_1 = [string componentsSeparatedByString:@"."];
    if (array_1.count == 2) {
        for (int i =0; i <1000; i++)
        {
            NSLog(@"%ld",(unsigned long)string.length);
            NSLog(@"%@",[string substringWithRange:NSMakeRange(string.length -1, 1)]);
            if ([[string substringWithRange:NSMakeRange(string.length -1, 1)] isEqualToString:@"0"])
            {
                [string deleteCharactersInRange:NSMakeRange(string.length -1 , 1)];
            }
            else if([[string substringWithRange:NSMakeRange(string.length -1, 1)] isEqualToString:@"."])
            {
                [string deleteCharactersInRange:NSMakeRange(string.length -1, 1)];
                i= 10000;
            }
            else
            {
                i= 10000;
            }
        }
    }
    NSArray *array_2 = [string componentsSeparatedByString:@"."];
    if (array_2.count == 2) {
        NSString *intStr = [array_2 objectAtIndex:0];
        intStr = [self separatedStrWithStr:intStr];
        NSString *dotStr = [array_2 objectAtIndex:1];
        string = [[NSMutableString alloc]initWithFormat:@"%@.%@",intStr,dotStr];
    }else{
        string = [[NSMutableString alloc]initWithFormat:@"%@",[self separatedStrWithStr:string]];
    }
    return (NSString *)string;
}


+ (NSArray *)getPlistArrayByplistName:(NSString *)plistName{
    NSString *path= [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray *array =[[NSArray alloc] initWithContentsOfFile:path];
    return array;
}





+ (NSString *)getRandomString{
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < 25; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    NSLog(@"%@", string);
    return string;
}


/*
 通过arc4random() 获取0到x-1之间的整数的代码如下：
 int value = arc4random() % x;
 获取1到x之间的整数的代码如下:
 int value = (arc4random() % x) + 1;
 */

+ (NSString *)getRandomNumberWithCount:(NSInteger)countNumber{
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < countNumber; i++) {
        int figure = arc4random() % 10;
        NSString *tempString = [NSString stringWithFormat:@"%d", figure];
        string = [string stringByAppendingString:tempString];
    }
    NSLog(@"%@", string);
    return string;
    
}

//NSRoundPlain,   // Round up on a tie ／／貌似取整
//
//NSRoundDown,    // Always down == truncate  ／／只舍不入
//
//NSRoundUp,      // Always up    ／／ 只入不舍
//
//NSRoundBankers  // on a tie round so last digit is even  貌似四舍五入


+(NSDecimalNumber *)roundUp:(NSDecimalNumber *)number afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = number;
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return roundedOunces;
}

+(NSDecimalNumber *)roundUp:(NSDecimalNumber *)number{
    
    NSDecimalNumber * n =[self roundDown:number afterPoint:3];
    
    return [self roundUp:n afterPoint:2];
}

+ (NSDecimalNumber *)roundDown:(NSDecimalNumber *)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = price;
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return roundedOunces;
}


//给UILabel设置行间距和字间距
-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILABEL_LINE_SPACE; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
}

//计算UILabel的高度(带有行间距的情况)
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILABEL_LINE_SPACE;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}


+(BOOL)isDay:(NSString *)timeStr{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [format dateFromString:timeStr];
    return [[NSCalendar currentCalendar] isDateInToday:date];
}

+(BOOL)isThisYear:(NSString *)timeStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return [timeStr containsString:[currentDateStr substringWithRange:NSMakeRange(0, 4)]];
}
    
+(BOOL)isEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isEmpty:(id)obj
{
    if ([obj isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    else if (!obj)
    {
        return YES;
    }
    else if ([obj isEqual:@""])
    {
        return YES;
    }
    else if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSMutableString class]] )
    {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [obj stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSMutableArray class]])
    {
        if ([(NSArray*)obj count] <= 0)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return NO;
}

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    
    if(!text) return CGSizeZero;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
}

+ (NSString *)getNoBlankText:(NSString *)origiText
{
    if ([self isEmpty:origiText]) return @"";
    origiText = [origiText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    origiText = [origiText stringByReplacingOccurrencesOfString:@" " withString:@""];
    return origiText;
}
+ (NSString *)getUpcaseText:(NSString *)origiText
{
    if ([self isEmpty:origiText]) return @"";
    origiText = [origiText uppercaseString];
    return origiText;
}
+ (int)getTextCharLength:(NSString *)origiText
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [origiText dataUsingEncoding:enc];
    return (int)[da length] ;
}
+ (NSMutableAttributedString *)getDifColorStr:(NSString *)originalStr
                                     difColor:(UIColor *)difColor
                                        range:(NSRange)range
{
    NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:originalStr];
    [str3 addAttribute:NSForegroundColorAttributeName value:difColor range:range];
    return str3;
}


+ (NSMutableAttributedString *)getDiffontSizeStr:(NSString *)originalStr
                                       fontSize1:(UIFont *)fontSize1
                                       fontSize2:(UIFont *)fontSize2
                                           range:(NSRange)range
{
    NSArray *arr = [originalStr componentsSeparatedByString:@"."];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:originalStr];
    if (arr.count >= 2)
    {
        NSString *str1 = [arr objectAtIndex:0];
        NSString *str2 = [arr objectAtIndex:1];
        
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(str1.length+1,str2.length)];
    }
    return attrString;
}

+(NSMutableAttributedString *)getDiffontSizeStrArr:(NSArray *)strArr
                                           fontArr:(NSArray *)fontArr
                                          colorArr:(NSArray *)colorArr
{
    NSMutableString * mutStr = [NSMutableString string];
    
    for (NSString * str in strArr) {
        [mutStr appendString:str];
    }
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:mutStr];
    
    for (int i = 0; i<strArr.count; i++) {
        NSString * str = strArr[i];
        NSDictionary * strDic = @{NSForegroundColorAttributeName:colorArr[i],NSFontAttributeName:fontArr[i]};
        [attributedStr addAttributes:strDic range:[mutStr rangeOfString:str]];
    }
    return attributedStr;
}




//小数点后边的位数是否合法
+ (BOOL)getPointString:(NSString *)string length:(NSInteger)length {
    /*
     * 不能输入.0-9以外的字符。
     * 设置输入框输入的内容格式
     * 只能有一个小数点
     * 小数点后最多能输入两位
     * 如果第一位是.则前面加上0.
     * 如果第一位是0则后面必须输入点，否则不能输入。
     */
    // 判断是否有小数点
    if ([string containsString:@"."]) {
        NSArray *array = [string componentsSeparatedByString:@"."];
        if (array.count > 2) {
            return NO;
        } else {
            NSString * str = array[1];
            if (str.length > length) {
                return NO;
            }
        }
    } else{
        return YES;
    }
    return YES;
}



#pragma mark - 获取条形码
+(UIImage*)createBarImageWithOrderStr:(NSString*)str{
    // 创建条形码
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    // 恢复滤镜的默认属性
    [filter setDefaults];
    // 将字符串转换成NSData
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    // 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    // 将CIImage转换成UIImage，并放大显示
    UIImage* image =  [UIImage imageWithCIImage:outputImage scale:1.0 orientation:UIImageOrientationUp];
    return image;
}

+ (CIImage *)barcodeImageWithContent:(NSString *)content{
    CIFilter *qrFilter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    [qrFilter setValue:contentData forKey:@"inputMessage"];
    [qrFilter setValue:@(0.00) forKey:@"inputQuietSpace"];
    CIImage *image = qrFilter.outputImage;
    return image;
}

void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}


+ (UIImage *)barcodeImageWithContent:(NSString *)content codeImageSize:(CGSize)size{
    CIImage *image = [self barcodeImageWithContent:content];
    CGRect integralRect = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size.width/CGRectGetWidth(integralRect), size.height/CGRectGetHeight(integralRect));
    
    size_t width = CGRectGetWidth(integralRect)*scale;
    size_t height = CGRectGetHeight(integralRect)*scale;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:integralRect];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, integralRect, bitmapImage);
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


#pragma mark - 获取条形码
+ (UIImage *)generateQRCodeWithInputMessage:(NSString *)inputMessage
                                      Width:(CGFloat)width
                                     Height:(CGFloat)height{
    NSData *inputData = [inputMessage dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:inputData forKey:@"inputMessage"];
    //    [filter setValue:@"H" forKey:@"inputCorrectionLevel"]; // 设置二维码不同级别的容错率
    
    CIImage *ciImage = filter.outputImage;
    // 消除模糊
    CGFloat scaleX = MIN(width, height)/ciImage.extent.size.width;
    CGFloat scaleY = MIN(width, height)/ciImage.extent.size.height;
    ciImage = [ciImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    UIImage *returnImage = [UIImage imageWithCIImage:ciImage];
    return returnImage;
}



#define FileHashDefaultChunkSizeForReadingData 1024*8

+(NSString*)getFileMD5WithPath:(NSString*)path

{
    
    return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)path, FileHashDefaultChunkSizeForReadingData);
    
}



CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData) {
    
    // Declare needed variables
    
    CFStringRef result = NULL;
    
    CFReadStreamRef readStream = NULL;
    
    // Get the file URL
    
    CFURLRef fileURL =
    
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  
                                  (CFStringRef)filePath,
                                  
                                  kCFURLPOSIXPathStyle,
                                  
                                  (Boolean)false);
    
    if (!fileURL) goto done;
    
    // Create and open the read stream
    
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            
                                            (CFURLRef)fileURL);
    
    if (!readStream) goto done;
    
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    
    if (!didSucceed) goto done;
    
    // Initialize the hash object
    
    CC_MD5_CTX hashObject;
    
    CC_MD5_Init(&hashObject);
    
    // Make sure chunkSizeForReadingData is valid
    
    if (!chunkSizeForReadingData) {
        
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
        
    }
    
    // Feed the data to the hash object
    
    bool hasMoreData = true;
    
    while (hasMoreData) {
        
        uint8_t buffer[chunkSizeForReadingData];
        
        CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
        
        if (readBytesCount == -1) break;
        
        if (readBytesCount == 0) {
            
            hasMoreData = false;
            
            continue;
            
        }
        
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
        
    }
    
    // Check if the read operation succeeded
    
    didSucceed = !hasMoreData;
    
    // Compute the hash digest
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5_Final(digest, &hashObject);
    
    // Abort if the read operation failed
    
    if (!didSucceed) goto done;
    
    // Compute the string result
    
    char hash[2 * sizeof(digest) + 1];
    
    for (size_t i = 0; i < sizeof(digest); ++i) {
        
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
        
    }
    
    result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
    
    
    
done:
    
    if (readStream) {
        
        CFReadStreamClose(readStream);
        
        CFRelease(readStream);
        
    }
    
    if (fileURL) {
        
        CFRelease(fileURL);
        
    }
    
    return result;
    
}


+(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode, //ECB模式
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,     //没有补码
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        //return [GTMBase64 stringByEncodingData:resultData];
        return [self hexStringFromData:resultData];
        
    }
    free(buffer);
       return nil;
}


+(NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key
{   char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

//    NSData *data = [[NSData alloc] initWithBase64EncodedString:encryptText options:NSDataBase64DecodingIgnoreUnknownCharacters];//base64解码
    NSData *data= [self dataForHexString:encryptText];

    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);

    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionECBMode|kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize, &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        NSString *str = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        return str;
    }
    free(buffer); return nil;
}

+ (NSString *)hexStringFromData:(NSData *)data {
    Byte *bytes = (Byte *)[data bytes];
    // 下面是Byte 转换为16进制。
    NSString *hexStr = @"";
    for(int i=0; i<[data length]; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i] & 0xff]; //16进制数
        newHexStr = [newHexStr uppercaseString];
        
        if([newHexStr length] == 1) {
            newHexStr = [NSString stringWithFormat:@"0%@",newHexStr];
        }
        
        hexStr = [hexStr stringByAppendingString:newHexStr];
        
    }
    return hexStr;
}


//十六进制转Data
+ (NSData*)dataForHexString:(NSString*)hexString
{
    if (hexString == nil) {
        
        return nil;
    }
    
    const char* ch = [[hexString lowercaseString] cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* data = [NSMutableData data];
    while (*ch) {
        if (*ch == ' ') {
            continue;
        }
        char byte = 0;
        if ('0' <= *ch && *ch <= '9') {
                   
                   byte = *ch - '0';
               }else if ('a' <= *ch && *ch <= 'f') {
                   
                   byte = *ch - 'a' + 10;
               }else if ('A' <= *ch && *ch <= 'F') {
                   
                   byte = *ch - 'A' + 10;
                   
               }
               
               ch++;
               
               byte = byte << 4;
               if (*ch) {
                          
                          if ('0' <= *ch && *ch <= '9') {
                              
                              byte += *ch - '0';
                              
                          } else if ('a' <= *ch && *ch <= 'f') {
                              
                              byte += *ch - 'a' + 10;
                              
                          }else if('A' <= *ch && *ch <= 'F'){
                              
                              byte += *ch - 'A' + 10;
                              
                          }
                          
                          ch++;
                          
                      }
                      
                      [data appendBytes:&byte length:1];
                      
                  }
                  
                  return data;
}



@end
