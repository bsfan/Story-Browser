//
//  AppTTStyle.m
//  StoryBrowser
//
//  Created by Simon Watiau on 8/27/11.
//

#import "TellHeaderTTStyle.h"

@implementation TellHeaderTTStyle

- (id)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}


-(UIColor*)linkTextColor{
    return  [UIColor blueColor];
}

- (TTStyle*)linkText:(UIControlState)state {
    if (state == UIControlStateHighlighted) {
        return
        [TTInsetStyle styleWithInset:UIEdgeInsetsMake(-3, -4, -3, -4) next:
         [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:4.5] next:
          [TTSolidFillStyle styleWithColor:[UIColor colorWithWhite:0.75 alpha:1] next:
           [TTInsetStyle styleWithInset:UIEdgeInsetsMake(3, 4, 3, 4) next:
            [TTTextStyle styleWithColor:self.linkTextColor next:nil]]]]];        
    } else {
        //return [TTTextStyle styleWithColor:self.linkTextColor next:nil];
        TTTextStyle* style = [TTTextStyle styleWithColor:self.linkTextColor next:nil];
        style.font = [UIFont fontWithName:@"Georgia-Italic" size:14];
        return style;
        
    }
}

@end
