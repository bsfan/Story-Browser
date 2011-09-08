//
//  NSString+md5.m
//  StoryBrowser
//
//  Created by Simon Watiau on 9/7/11.
//

#import "NSString+md5.h"
#import "CommonCrypto/CommonDigest.h"
@implementation NSString (md5)

- (NSString *)md5 {

    const char* str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;

}

@end
