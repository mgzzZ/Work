//
//  NSString+helpers.h
//  what2
//
//  Created by Mz on 15/5/12.
//  Copyright (c) 2015年 Mz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (helpers)
- (BOOL)isValidPhone;
- (BOOL)isNumber;
- (BOOL)isNilOrEmpty;
- (BOOL)isValidPassword;

- (BOOL)isEmpty;
/**
*  用来将手机号码加密 例如13000000000加密成130****0000
*
*/
- (NSString *)mobilePhoneNumberEncrypt;

/**
*  url编码
*
*/
- (NSString *)urlEncode;

//- (NSString *)utf8String;

- (NSString *)stringByAddingSpaceBetweenCharacters;

- (NSRange) rangeOfUTFCurrentLength:(NSUInteger)currentLength withMaxLength:(NSInteger) maxLength;
/**
 *  去掉首尾空格以及换行
 *
 *  @return 去掉空格和换行之后的字符串
 */
- (NSString *)clearSpaceAndReturn;

- (CGSize)stringSizeWithFont:(UIFont *)font;

@end
