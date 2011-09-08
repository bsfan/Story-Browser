//
//  Text.m
//  StoryBrowser
//
//  Created by Simon Watiau on 8/29/11.
//

#import "TextCell.h"
#import "NSString+HTML.h"
#import "RegexKitLite.h"
@implementation TextCell

@synthesize content,backgroundView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds=YES;
        self.contentView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"noise.png"]];
        self.content=[[[UILabel alloc] initWithFrame:CGRectMake(5, 10, 310, 70000)] autorelease];
        self.content.font=[UIFont fontWithName:@"Arial-ItalicMT" size:15];
        self.content.textColor=[UIColor darkGrayColor];
        self.content.lineBreakMode=UILineBreakModeWordWrap;
        self.content.numberOfLines=0;
        self.content.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:self.content];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        UIImageView* topShadow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"generic_shadow_h_b2a.png"]] autorelease];
        topShadow.frame=CGRectMake(0, -2, 320, 6);
        topShadow.autoresizingMask=UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:topShadow];

        UIImageView* bottomShadow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"generic_shadow_h_a2b.png"]] autorelease];

        bottomShadow.frame=CGRectMake(0, 40, 320, 6);// Why 40 ????
        bottomShadow.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;        
        [self.contentView addSubview:bottomShadow];

    }
    return self;
}

-(void)loadElement:(NSDictionary*)element{ 
    NSString* value = [[[[element objectForKey:@"description"] stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"] stringByConvertingHTMLToPlainText] stringByReplacingOccurrencesOfRegex:@"\n +" withString:@"\n"];
    
    self.content.text = value;
    self.content.frame= CGRectMake(5, 10, 310, 70000);
    [self.content sizeToFit];
}

+(CGFloat)heightForElement:(NSDictionary*) element{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 310, 70000)];
    label.lineBreakMode=UILineBreakModeWordWrap;
        NSString* value = [[[[element objectForKey:@"description"] stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"] stringByConvertingHTMLToPlainText] stringByReplacingOccurrencesOfRegex:@"\n +" withString:@"\n"];
    label.text= value;
    label.font=[UIFont fontWithName:@"Arial-ItalicMT" size:15];
    label.numberOfLines=0;
    [label sizeToFit];
    int height = label.frame.size.height;
    [label release];
    return height+20;
}
-(void) dealloc{
    self.content=nil;
    [super dealloc];
}
@end
