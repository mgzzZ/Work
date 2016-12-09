//
//  NSString+helpers.m
//  what2
//
//  Created by Mz on 15/5/12.
//  Copyright (c) 2015年 Mz. All rights reserved.
//

#import "NSString+helpers.h"

@implementation NSString (helpers)
- (BOOL)isValidPhone
{
    //手机号以13， 15，18, 177开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((177)|(13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

- (BOOL)isNumber
{
    NSCharacterSet*cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString*filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [self isEqualToString:filtered];
}

-(BOOL)isNilOrEmpty
{
    return (!self || [self isEmpty] );
}

//判断是否是空字符串
-(BOOL)isEmpty
{
    return [self isEqualToString:@""];
}

- (BOOL)isValidPassword
{
    NSString *regex = @"^[(~!@#$%^&*()_+<>?:,./;'a-zA-Z0-9)]{0,20}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [mobileTest evaluateWithObject:self];
}

//用来将手机号码加密 例如13000000000加密成130****0000
- (NSString *)mobilePhoneNumberEncrypt
{
    if ([self isValidPhone]) {
        NSMutableString *mStr = [NSMutableString stringWithString:self];
        [mStr replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        return [NSString stringWithString:mStr];
    }else{
        
    }
    
    return @"";
}

- (NSString *)urlEncode
{

    //https://github.com/AFNetworking/AFNetworking/pull/555
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, CFSTR("."), CFSTR(":/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8);
    return result;
}

//- (NSString *)utf8String
//{
//    return [NSString stringWithUTF8String:[self UTF8String]];
//}
- (NSString *)stringByAddingSpaceBetweenCharacters
{
    NSMutableString *muStr = [self mutableCopy];
    [muStr enumerateSubstringsInRange:NSMakeRange(0, muStr.length) options:NSStringEnumerationByComposedCharacterSequences | NSStringEnumerationSubstringNotRequired usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        if (substringRange.location > 0) {
            [muStr insertString:@" " atIndex:substringRange.location];
        }
    }];
    return [muStr copy];
}
- (NSRange) rangeOfUTFCurrentLength:(NSUInteger)currentLength withMaxLength:(NSInteger) maxLength
{
    NSUInteger codeUnit = 0;
    NSRange result;
    for(NSUInteger ix = 0; ix <= currentLength; ix++)
    {
        if (ix) {
            result = [self rangeOfComposedCharacterSequenceAtIndex:codeUnit];
            if (codeUnit + result.length > maxLength) {
                break;
            }
            codeUnit += result.length;
            
        }
    }
    return NSMakeRange(0, codeUnit);
}
- (NSString *)clearSpaceAndReturn
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (CGSize)stringSizeWithFont:(UIFont *)font
{
    NSDictionary *attributes = @{NSFontAttributeName : font};
    CGSize textSize = [self boundingRectWithSize:CGSizeMake(NSIntegerMax, NSIntegerMax) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    return textSize;
}



@end
