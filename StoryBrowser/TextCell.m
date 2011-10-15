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

        self.contentView.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        self.content=[[[UILabel alloc] initWithFrame:CGRectMake(5, 10, 310, 70000)] autorelease];
        self.content.font=[UIFont fontWithName:@"Arial-ItalicMT" size:15];
        self.content.textColor=[UIColor darkGrayColor];
        self.content.lineBreakMode=UILineBreakModeWordWrap;
        self.content.numberOfLines=0;
        self.content.backgroundColor=self.contentView.backgroundColor;
        [self.contentView addSubview:self.content];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
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
