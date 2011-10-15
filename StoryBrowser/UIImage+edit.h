//
//  UIImage+edit.h
//  StoryBrowser
//
//  Created by Simon Watiau on 9/10/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIImage (graphicEdit)

-(UIImage *)imageWithRadius:(int)cornerRadius;
-(UIImage *)imageWithMask:(UIImage*) mask;
-(UIImage *)imageWithSize:(CGSize)size;
+(UIImage*) imageFromCache:(NSString*)identifier;
+(UIImage*) imageFromMemory:(NSString*)identifier;
-(void)saveToCacheWithKey:(NSString*) identifier;
+(void) clearCacheForVersion:(NSString*)oldVersion;
@end
