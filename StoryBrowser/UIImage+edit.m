//
//  UIImage+edit.m
//  StoryBrowser
//
//  Created by Simon Watiau on 9/10/11.
//

#import "UIImage+edit.h"
#import <UIKit/UIKit.h>

NSCache* inMemoryCache;
@implementation UIImage (graphicEdit)
static NSString* version=@"12";


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


-(UIImage *)imageWithRadius:(int)cornerRadius{

    UIImage* finalImage;
    int w = self.size.width;
    int h = self.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextBeginPath(context);
    CGRect rect = CGRectMake(0, 0, w, h);
    addRoundedRectToPath(context, rect, cornerRadius, cornerRadius);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), self.CGImage);
    CGImageRef imageRoundedCGRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    finalImage = [UIImage imageWithCGImage:imageRoundedCGRef] ;
    CGImageRelease(imageRoundedCGRef);
    return finalImage;
}




-(UIImage *)imageWithMask:(UIImage*) mask {
       
	UIImage *maskedImage = nil;
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);

    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [mask drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    maskedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return maskedImage;
}



-(UIImage *)imageWithSize:(CGSize)size{

    UIImage *sourceImage = self;
    UIImage *newImage = nil;        
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, size) == NO) 
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) 
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        }
        else 
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }       
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) 
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


-(void)saveToCacheWithKey:(NSString*) identifier{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"StoryBrowser%@_UIImage_%@.png",version,identifier]];
    
    if (inMemoryCache==nil){
        inMemoryCache=[[NSCache alloc] init];
    }
    [inMemoryCache setObject:self forKey:identifier];

    NSData* imgData = UIImagePNGRepresentation(self);
    NSError* error=nil;
    if (![imgData writeToFile:path options:NSDataWritingAtomic error:&error]){
        NSLog(@"merde %@",[error localizedDescription]);
    }
}



+(UIImage*) imageFromMemory:(NSString*)identifier{
    if (inMemoryCache==nil){
        inMemoryCache=[[NSCache alloc] init];
    }

    UIImage* image = [inMemoryCache objectForKey:identifier];
    if (image!=nil){
        return image;
    }
    return nil;
}

+(UIImage*) imageFromCache:(NSString*)identifier{
    if (inMemoryCache==nil){
        inMemoryCache=[[NSCache alloc] init];
    }
    UIImage* image = [inMemoryCache objectForKey:identifier];
    if (image!=nil){
        return image;
    }
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"StoryBrowser%@_UIImage_%@.png",version,identifier]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]){
        image =  [UIImage imageWithContentsOfFile:path];
        [inMemoryCache setObject:image forKey:identifier];
        return image;
    }else{
        return nil;
    }

}



+(void) clearCacheForVersion:(NSString*)oldVersion{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cachePath error:nil];
    NSArray *cached = [dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"self BEGINSWITH 'StoryBrowser%@_UIImage_'",oldVersion]]];
    

    for (NSString* file in cached){
        NSError* error;
        if(![[NSFileManager defaultManager] removeItemAtPath:[cachePath stringByAppendingPathComponent:file] error:&error]){
            NSLog(@"fail %@",[error localizedDescription]);
        }else{
            NSLog(@"%@ deleted",file);
        }
    }
}
@end
