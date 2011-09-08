//
//  BaseElementCell.h
//  StoryBrowser
//
//  Created by Simon Watiau on 8/26/11.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>
#import "QuartzCore/QuartzCore.h"
@interface BaseElementCell : UITableViewCell
    
    -(void)loadElement:(NSDictionary*)element;
    +(CGFloat)heightForElement:(NSDictionary*)element;
@end
