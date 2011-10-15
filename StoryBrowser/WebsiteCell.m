//
//  WebsiteCell.m
//  StoryBrowser
//
//  Created by Simon Watiau on 8/26/11.
//

#import "WebsiteCell.h"
#import "ASIHTTPRequest.h"
#import "Tell.h"
#import "RegexKitLite.h"
#import "Utils.h"
#import "NSString+HTML.h"
#import "ASIDownloadCache.h"
@implementation WebsiteCell
@synthesize title,websiteName,description,req;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
           
        // Title
        self.title = [[[UILabel alloc] init] autorelease] ;
        self.title.numberOfLines=0;
        [self.title setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
        self.title.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:self.title];
        self.title.highlightedTextColor=[UIColor whiteColor];
                
        // Website name
        self.websiteName = [[[UILabel alloc] init] autorelease];
        self.websiteName.font=[UIFont fontWithName:@"Arial-BoldMT" size:12];
        self.websiteName.textColor = [UIColor lightGrayColor];
        self.websiteName.backgroundColor=[UIColor clearColor];
        self.websiteName.numberOfLines=1;
        self.websiteName.frame=CGRectMake(5, 28, 300, 12);
        self.websiteName.highlightedTextColor=[UIColor whiteColor];
        [self.contentView addSubview:self.websiteName];
        
        // Description
        self.description = [[[UILabel alloc] init] autorelease];
        self.description.font=[UIFont fontWithName:@"ArialMT" size:15];
        self.description.textColor = [UIColor blackColor];
        self.description.lineBreakMode=UILineBreakModeWordWrap;
        self.description.backgroundColor = [UIColor clearColor];
        self.description.numberOfLines=0;
        self.description.highlightedTextColor=[UIColor whiteColor];
        [self.contentView addSubview:self.description];
    }
    return self;
}


-(void)loadElement:(NSDictionary*)element{
    if (self.req!=nil){
        [self.req clearDelegatesAndCancel];
        [self.req cancel];
        self.req= nil;
    }

    // Title
    self.title.text=[[element objectForKey:@"title"] stringByRemovingNewLinesAndWhitespace];
    self.title.frame=CGRectMake(5, 6, 305, 70000);
    [self.title sizeToFit];
    
    // Website name
    self.websiteName.text = [[element objectForKey:@"author"] objectForKey:@"name"];
    CGRect websiteNameFrame = self.websiteName.frame;
    websiteNameFrame.origin.y = self.title.frame.size.height+13;
    self.websiteName.frame=websiteNameFrame;
    
    // Description
    self.description.text = [[element objectForKey:@"description"] stringByDecodingHTMLEntities];
    self.description.frame = CGRectMake(5, self.websiteName.frame.origin.y+20, 305, 70000);
    [self.description sizeToFit];
}

-(void) dealloc{
    if(self.req!=nil){
        [self.req clearDelegatesAndCancel];
        [self.req cancel];
        self.req=nil;
    }
    self.title=nil;
    self.description=nil;
    self.websiteName=nil;
    [super dealloc];
}

+(CGFloat)heightForElement:(NSDictionary*) element{
    UILabel* txt =[[[UILabel alloc]initWithFrame:CGRectMake(5, 37, 305, 70000)] autorelease];
    txt.text= [[element objectForKey:@"description"] stringByDecodingHTMLEntities];
    txt.lineBreakMode=UILineBreakModeWordWrap;
    txt.numberOfLines=0;
    [txt setFont: [UIFont fontWithName:@"ArialMT" size:15]] ;
    [txt sizeToFit];    
    int height = txt.frame.size.height;
    txt.frame=CGRectMake(5, 6, 305, 70000);
    [txt setText:[[[element objectForKey:@"title"] stringByDecodingHTMLEntities]stringByRemovingNewLinesAndWhitespace]];
    [txt setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
    [txt sizeToFit];
    return height+txt.frame.size.height+40;
    
}

@end
