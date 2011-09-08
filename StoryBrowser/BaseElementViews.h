//
//  BaseElementViews.h
//  StoryBrowser
//
//  Created by Simon Watiau on 9/6/11.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>
#import "QuartzCore/QuartzCore.h"
NSDictionary* element;
@interface BaseElementViews : UIViewController
    @property(nonatomic,retain) NSDictionary *element;

    -(void)loadElement:(NSDictionary*)element;
    -(UIView*) titleView;
    -(UIView*) contentView;
    -(void)scroll;
    -(void)cancel;
@end

