//
//  FbPostCell.m
//  StoryBrowser
//
//  Created by Simon Watiau on 8/27/11.
//

#import "FbPostCell.h"
#import "ASIHTTPRequest.h"
#import "Tell.h"
#import "RegexKitLite.h"
#import "ASIDownloadCache.h"
#import "Utils.h"
@implementation FbPostCell
@synthesize avatar,postText,date,mask,req,formatter,userName;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Quote
        UILabel* quote= [[UILabel alloc] initWithFrame:CGRectMake(2, 5, 22, 60)];
        quote.font = [UIFont fontWithName:@"Georgia" size:60];
        quote.textColor=[UIColor lightGrayColor];
        quote.text=@"“";
        quote.backgroundColor=[UIColor whiteColor];
        quote.highlightedTextColor=[UIColor whiteColor];
        [self.contentView addSubview:quote];
        [quote release];
        
        // Avatar
        self.avatar = [[[UIImageView alloc] init] autorelease];
        self.avatar.frame=CGRectMake(30, 20, 44 , 44);
        self.avatar.backgroundColor=[UIColor whiteColor];
        self.avatar.layer.cornerRadius=2.0f;
        self.avatar.clipsToBounds=YES;
        [self.contentView addSubview:self.avatar];
        
        // Avatar mask
        self.mask = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mask_44.png"]] autorelease];
        self.mask.frame=self.avatar.frame;
        [self.contentView addSubview:self.mask];

        // User name
        self.userName=[[[UILabel alloc] initWithFrame:CGRectMake(82, 20, 233, 16)] autorelease];
        self.userName.font = [UIFont fontWithName:@"ArialMT" size:16];
        self.userName.textColor =[UIColor darkGrayColor];
        self.userName.highlightedTextColor=[UIColor whiteColor];
        [self.contentView addSubview:self.userName];
        
        // Post text
        self.postText = [[[UILabel alloc] init] autorelease];
        self.postText.font=[UIFont fontWithName:@"Georgia" size:15];
        self.postText.textColor=[UIColor blackColor];
        self.postText.highlightedTextColor=[UIColor blackColor];
        self.postText.numberOfLines=0;
        self.postText.lineBreakMode=UILineBreakModeWordWrap;
        self.postText.backgroundColor=[UIColor clearColor];
        self.postText.highlightedTextColor=[UIColor whiteColor];
        [self.contentView addSubview:self.postText];
        

        // Date
        self.date= [[[UILabel alloc] init] autorelease];
        self.date.font=[UIFont fontWithName:@"ArialMT" size:12];
        self.date.textColor=[UIColor lightGrayColor];
        self.date.textAlignment = UITextAlignmentRight;
        self.date.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
        self.date.frame=CGRectMake(0,16, 297, 14);
        self.date.highlightedTextColor=[UIColor whiteColor];
        [self.contentView addSubview:self.date];
        
        // Facebook icon
        UIImageView* facebook=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"facebook_favicon.png"]] autorelease];
        facebook.frame=CGRectMake(299,15, 12, 12);
        facebook.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:facebook];
        
        self.formatter=[[[NSDateFormatter alloc] init] autorelease];
        [self.formatter setDateFormat:@"MMMM dd, yyyy 'at' hh:mm"];
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
    NSURL* avatarLink = [NSURL URLWithString:[[element objectForKey:@"author"] objectForKey:@"avatar"]] ;
    
    // Avatar
    self.req = [ASIHTTPRequest requestWithURL:avatarLink];
    [self.req setDelegate:self];
    [self.req setDidFinishSelector:@selector(avatarDownloaded:)];
    [self.req setDidFailSelector:@selector(avatarDownloadFailed:)];
    [[Tell netQueue] addOperation:self.req];
    
    // Build post
   
    NSString* name = [[element objectForKey:@"author"] objectForKey:@"name"];
    self.userName.text=name;
    
    NSString* description = [element objectForKey:@"description"];
    self.postText.text=description;
    self.postText.frame= CGRectMake(82, 40, 230, 70000);
    [self.postText sizeToFit];

    
    // Date
    NSDate *postDate = [NSDate dateWithTimeIntervalSince1970:[[element objectForKey:@"created_at"] intValue]];
    self.date.text=[self.formatter stringFromDate:postDate];
    
}


-(void)avatarDownloaded:(ASIHTTPRequest*)request{
    self.avatar.contentMode=UIViewContentModeScaleAspectFill;
    self.avatar.image=[UIImage imageWithData:[request responseData]];
    self.avatar.alpha=1;
}

-(void)avatarDownloadFailed:(ASIHTTPRequest*)request{
    self.avatar.contentMode=UIViewContentModeCenter;
    self.avatar.image=[UIImage imageNamed:@"failed_35.png"];
}

-(void)dealloc{
    if(self.req!=nil){
        [self.req clearDelegatesAndCancel];
        [self.req cancel];
        self.req=nil;
    }
    self.avatar=nil;
    self.mask=nil;
    self.postText=nil;
    self.date=nil;
    self.formatter=nil;
    [super  dealloc];
}

+(CGFloat)heightForElement:(NSDictionary*) element{
    NSString* description = [element objectForKey:@"description"];
    UILabel* txt = [[[UILabel alloc]initWithFrame:CGRectMake(82, 30, 230, 70000)] autorelease];
    txt.numberOfLines=0;
    txt.font=[UIFont fontWithName:@"Georgia" size:15];
    txt.lineBreakMode=UILineBreakModeWordWrap;
    txt.text = description;
    [txt sizeToFit];
    int height = txt.frame.size.height;
    return height+75;
}

@end
