//
//  BaseElementViews.m
//  StoryBrowser
//
//  Created by Simon Watiau on 9/6/11.
//

#import "BaseElementViews.h"

@implementation BaseElementViews
@synthesize element;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)loadElement:(NSDictionary*)el{
    self.element=el;
}

-(UIView*) titleView{
    return [[[UIView alloc] init] autorelease];
}

-(UIView*) contentView{
    return [[[UIView alloc] init] autorelease];
}
-(void)scroll{

}
-(void) cancel{

}
-(void) dealloc{
    self.element=nil;
    [super dealloc];
}

@end
