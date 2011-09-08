
#import <Foundation/Foundation.h>

@interface Utils : NSObject
+(NSString*)prepareForStyledLabel:(NSString*) source;
+(UIImage *)roundedImage:(UIImage*)img withRadius:(int) cornerRadius inRect:(CGSize)size withOverlay:(UIImage*)overlay usingIdentifier:(NSString*)identifier;
@end
