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
@synthesize favicon,title,websiteName,description,req;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
           
        // Title
        self.title = [[[UILabel alloc] init] autorelease] ;
        [self.title setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
        self.title.frame= CGRectMake(5, 6, 310, 15);
        self.title.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:self.title];
    
        
        
        // Favicon
        self.favicon = [[[UIImageView alloc] init] autorelease];
        self.favicon.backgroundColor=[UIColor whiteColor];
        self.favicon.frame = CGRectMake(5, 25, 16, 16);
        [self.contentView addSubview:self.favicon];

        
        // Website name
        self.websiteName = [[[UILabel alloc] init] autorelease];
        self.websiteName.font=[UIFont fontWithName:@"Arial-BoldMT" size:12];
        self.websiteName.textColor = [UIColor lightGrayColor];
        self.websiteName.backgroundColor=[UIColor clearColor];
        self.websiteName.numberOfLines=1;
        self.websiteName.frame=CGRectMake(25, 28, 300, 12);
        [self.contentView addSubview:self.websiteName];
        
        // Description
        self.description = [[[UILabel alloc] init] autorelease];
        self.description.font=[UIFont fontWithName:@"ArialMT" size:15];
        self.description.textColor = [UIColor blackColor];
        self.description.lineBreakMode=UILineBreakModeWordWrap;
        self.description.backgroundColor = [UIColor clearColor];
        self.description.numberOfLines=0;
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
    self.favicon.image=nil;

    // Title
    self.title.text=[element objectForKey:@"title"];

    
    NSURL* faviconLink = [NSURL URLWithString:[element objectForKey:@"favicon"]];
    self.req = [ASIHTTPRequest requestWithURL:faviconLink];
    [self.req setDelegate:self];
    [self.req setDidFinishSelector:@selector(faviconDownloaded:)];
    [self.req setDidFailSelector:@selector(faviconDownloadFailed:)];
    [[Tell netQueue] addOperation:self.req];

    // Website name
    self.websiteName.text = [element objectForKey:@"source"];
    
    // Description
    self.description.text = [[element objectForKey:@"description"] stringByDecodingHTMLEntities];
    self.description.frame = CGRectMake(5, 47, 310, 70000);
    [self.description sizeToFit];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    if(selected){
        self.title.textColor=[UIColor whiteColor];
        self.websiteName.textColor=[UIColor whiteColor];
        self.description.textColor=[UIColor whiteColor];
    }else{
        self.title.textColor=[UIColor blackColor];
        self.websiteName.textColor=[UIColor darkGrayColor];
        self.description.textColor=[UIColor blackColor];
    }
    [super setSelected:selected animated:animated];
}

-(void) dealloc{
    if(self.req!=nil){
        [self.req clearDelegatesAndCancel];
        [self.req cancel];
        self.req=nil;
    }
    self.favicon=nil;
    self.title=nil;
    self.description=nil;
    self.websiteName=nil;
    [super dealloc];
}

+(CGFloat)heightForElement:(NSDictionary*) element{
    UILabel* txt =[[[UILabel alloc]initWithFrame:CGRectMake(5, 37, 310, 70000)] autorelease];
    txt.text= [[element objectForKey:@"description"] stringByDecodingHTMLEntities];
    txt.lineBreakMode=UILineBreakModeWordWrap;
    txt.numberOfLines=0;
    [txt setFont: [UIFont fontWithName:@"ArialMT" size:15]] ;
    [txt sizeToFit];    
    return txt.frame.size.height+70;
}


-(void)faviconDownloaded:(ASIHTTPRequest*) request{
    self.favicon.image=[UIImage imageWithData:[request responseData]];
}


-(void)faviconDownloadFailed:(ASIHTTPRequest*)request{
    self.favicon.image=[UIImage imageNamed:@"failed_15.png"];
}
@end
