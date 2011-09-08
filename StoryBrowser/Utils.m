#import "Utils.h"
#import "RegexKitLite.h"
#import "QuartzCore/QuartzCore.h"
@implementation Utils

+(NSString*)prepareForStyledLabel:(NSString*) source{
    NSString* cleanedSource = source;
    /*
     cleanedSource =  [cleanedSource stringByReplacingOccurrencesOfRegex:@"http://[^\\s]+" usingBlock:^NSString *(NSInteger captureCount, NSString * const capturedStrings[captureCount], const NSRange capturedRanges[captureCount], volatile BOOL * const stop) {
     return [capturedStrings[0] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
     }];
    */
    cleanedSource =  [cleanedSource stringByReplacingOccurrencesOfRegex:@"&(?![a-z]{1,5};)" usingBlock:^NSString *(NSInteger captureCount, NSString * const capturedStrings[captureCount], const NSRange capturedRanges[captureCount], volatile BOOL * const stop) {
        return [capturedStrings[0] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    }];
    cleanedSource = [cleanedSource stringByReplacingOccurrencesOfRegex:@"(@|#)([a-zA-Z0-9_]+)" usingBlock:^NSString *(NSInteger captureCount, NSString * const capturedStrings[captureCount], const NSRange capturedRanges[captureCount], volatile BOOL * const stop) {
        
        NSString* search=@"";
        if ([capturedStrings[1] isEqualToString:@"#"]){
            search = @"search?q=";
        }
        
        return [NSString stringWithFormat:@"<a href='http://twitter.com/%@%@'>%@</a>",search,capturedStrings[2],capturedStrings[0]];
    }];
    return cleanedSource;
}



static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+(UIImage *)roundedImage:(UIImage*)img withRadius:(int) cornerRadius inRect:(CGSize) size withOverlay:(UIImage*)imageOverlay usingIdentifier:(NSString*)identifier{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"StoryBrowser_%@.png",identifier]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSLog(@"from cache");
        return [UIImage imageWithContentsOfFile:path];
    }
    UIImage* resizedImage = nil;
    UIImage* roundedImage=nil;
	UIImage *newImage = nil;
    
    UIGraphicsBeginImageContext(size);
        UIImageView* view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        view.contentMode=UIViewContentModeScaleAspectFit;
        view.image = img;
        [view drawRect:view.frame];        
        resizedImage = [UIGraphicsGetImageFromCurrentImageContext() retain];
    UIGraphicsEndImageContext();
    [view release];
    
    int w = resizedImage.size.width;
    int h = resizedImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextBeginPath(context);
        CGRect rect = CGRectMake(0, 0, resizedImage.size.width, resizedImage.size.height);
        addRoundedRectToPath(context, rect, cornerRadius, cornerRadius);
        CGContextClosePath(context);
        CGContextClip(context);
        CGContextDrawImage(context, CGRectMake(0, 0, w, h), resizedImage.CGImage);
        CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    roundedImage = [[UIImage imageWithCGImage:imageMasked] retain];
    
    UIGraphicsBeginImageContext(size);
        [roundedImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        [imageOverlay drawInRect:CGRectMake(0, 0, size.width, size.height)];
        newImage = [UIGraphicsGetImageFromCurrentImageContext()retain];
    UIGraphicsEndImageContext();
    CGImageRelease(imageMasked);
    [roundedImage release];


    NSData* imgData = UIImagePNGRepresentation(newImage);
    NSLog(@"%@",path);
    NSError* error = nil;
    if ([imgData writeToURL:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@",path]] atomically:YES]){
    }else{
        NSLog(@"error %@",error);
    }
    return newImage;
}

@end
