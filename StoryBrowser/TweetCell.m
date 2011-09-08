//
//  TweetText.m
//  StoryBrowser
//
//  Created by Simon Watiau on 8/27/11.
//

#import "TweetCell.h"
#import "StoryBrowserAppDelegate.h"
#import "RegexKitLite.h"
#import "ASIHTTPRequest.h"
#import "Tell.h"
#import "NSString+HTML.h"
#import "ASIDownloadCache.h"
#import "Utils.h"

NSDateFormatter* formatter;
@implementation TweetCell
@synthesize tweetText,avatar,author,date,mask,bird,req;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (formatter==nil){
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMMM dd, yyyy 'at' hh:mm"];
        }else{
            [formatter retain];
        }

        
        
        // Tweet
        self.tweetText = [[[UILabel alloc] init] autorelease];
        self.tweetText.font = [UIFont fontWithName:@"Georgia" size:19] ;
        self.tweetText.highlightedTextColor=[UIColor whiteColor];
        self.tweetText.frame = CGRectMake(27, 8, 266, 70000);
        self.tweetText.lineBreakMode=UILineBreakModeWordWrap;
        self.tweetText.numberOfLines=0;
        self.tweetText.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:self.tweetText];

        
        // Quote
        UILabel* quote= [[UILabel alloc] initWithFrame:CGRectMake(2, 0, 22, 60)];
        quote.font = [UIFont fontWithName:@"Georgia" size:60];
        quote.textColor=[UIColor lightGrayColor];
        quote.text=@"“";
        quote.highlightedTextColor=[UIColor whiteColor];
        quote.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:quote];
        [quote release];
       
        // Avatar
        self.avatar=[[[UIImageView alloc] init] autorelease];
        self.avatar.frame = CGRectMake(267, -15, 44, 44);
        self.avatar.backgroundColor=[UIColor whiteColor];
        self.avatar.clipsToBounds=YES;
        self.avatar.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
        self.avatar.layer.cornerRadius=2.0f;
        [self addSubview:self.avatar];      
        
        // Avatar mask
        self.mask = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mask_44.png"]] autorelease];
        self.mask.frame=self.avatar.frame;
        self.mask.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:self.mask];
        
        // Author name
        self.author = [[[UILabel alloc] init] autorelease];
        self.author.textAlignment=UITextAlignmentRight;
        self.author.textColor=[UIColor darkGrayColor];
        self.author.backgroundColor=[UIColor clearColor];
        self.author.font = [UIFont fontWithName:@"ArialMT" size:16]  ;
        self.author.frame=CGRectMake(0, -8, 242, 16);
        self.author.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
        self.author.highlightedTextColor=[UIColor whiteColor];
        [self addSubview:self.author];
        
        // Date
        self.date = [[[UILabel alloc] init] autorelease];
        self.date.font = [UIFont fontWithName:@"ArialMT" size:12];
        self.date.textColor = [UIColor lightGrayColor];
        self.date.frame=CGRectMake(0, 13, 262, 12);
        self.date.textAlignment=UITextAlignmentRight;
        self.date.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
        self.date.backgroundColor=[UIColor clearColor];
        self.date.highlightedTextColor=[UIColor whiteColor];
        [self.contentView addSubview:self.date];
        // Bird
        self.bird = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"twitter_favicon.png"]] autorelease];
        self.bird.frame=CGRectMake(244,-7, 18, 12);
        self.bird.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:self.bird];
        
    }
    return self;
}



-(void)loadElement:(NSDictionary*)element{
    if (self.req!=nil){
        [self.req clearDelegatesAndCancel];
        [self.req cancel];
        self.req= nil;
    }
    self.avatar.image=nil;
    self.tweetText.frame=CGRectMake(27, 8, 266, 70000);
    // Tweet
    [self.tweetText setText:[[element objectForKey:@"title"]stringByDecodingHTMLEntities]];
    [self.tweetText sizeToFit];
    
    // Avatar
    NSURL* avatarLink  =[NSURL URLWithString:[[element objectForKey:@"author"] objectForKey:@"avatar"]];

    self.req = [ASIHTTPRequest requestWithURL:avatarLink];
    [self.req setDelegate:self];
    [self.req setDidFinishSelector:@selector(avatarDownloaded:)];
    [self.req setDidFailSelector:@selector(avatarDownloadFailed:)];
    [[Tell netQueue] addOperation:self.req];
    
    // Author
    self.author.text=[[element objectForKey:@"author"] objectForKey:@"username"];
    
    // Date
    NSDate *tweetDate = [NSDate dateWithTimeIntervalSince1970:[[element objectForKey:@"created_at"] intValue]];
    self.date.text=[formatter stringFromDate:tweetDate];

}



+(CGFloat)heightForElement:(NSDictionary*) element{
    UILabel* txt = [[[UILabel alloc] initWithFrame:CGRectMake(27, 8, 266, 70000)] autorelease];
    txt.font = [UIFont fontWithName:@"Georgia" size:19] ;
    txt.numberOfLines=0; 
    txt.lineBreakMode=UILineBreakModeWordWrap;
    [txt setText:[[element objectForKey:@"title"] stringByDecodingHTMLEntities]];
    [txt sizeToFit];
    return txt.frame.size.height+80;
   
}

-(void)avatarDownloaded:(ASIHTTPRequest*) request{
    self.avatar.contentMode=UIViewContentModeScaleAspectFill;
    self.avatar.image=[UIImage imageWithData:[request responseData]];
}


-(void)avatarDownloadFailed:(ASIHTTPRequest*)request{
    self.avatar.contentMode=UIViewContentModeCenter;
    self.avatar.image=[UIImage imageNamed:@"failed_35.png"];
    self.avatar.alpha=1;
}

-(void)dealloc{
    if(self.req!=nil){
        [self.req clearDelegatesAndCancel];
        [self.req cancel];
        self.req=nil;
    }
    self.tweetText=nil;
    self.avatar=nil;
    self.author=nil;
    self.date=nil;
    self.mask=nil;
    self.bird=nil;
    
    if ([formatter retainCount]==1){
        [formatter release];
        formatter=nil;
    }else{
        [formatter release];
    }
    
    [super dealloc];
}
@end



