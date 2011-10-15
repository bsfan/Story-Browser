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
#import "UIImage+edit.h"
#import "NSString+md5.h"
#import "NSString+HTML.h"
@implementation FbPostCell
@synthesize avatar,postText,date,req,formatter,userName,delayRequest;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Quote
        UILabel* quote= [[UILabel alloc] initWithFrame:CGRectMake(2, 0, 22, 60)];
        quote.font = [UIFont fontWithName:@"Georgia" size:60];
        quote.textColor=[UIColor lightGrayColor];
        quote.text=@"“";
        quote.backgroundColor=[UIColor whiteColor];
        quote.highlightedTextColor=[UIColor whiteColor];
        [self.contentView addSubview:quote];
        [quote release];
        
        // Avatar
        self.avatar = [[[UIImageView alloc] init] autorelease];
        self.avatar.frame=CGRectMake(30, 15, 44 , 44);
        self.avatar.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:self.avatar];
        
     

        // User name
        self.userName=[[[UILabel alloc] initWithFrame:CGRectMake(82, 15, 233, 16)] autorelease];
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
        self.date.frame=CGRectMake(0,25, 295, 14);
        self.date.highlightedTextColor=[UIColor whiteColor];
        [self.contentView addSubview:self.date];
        
        // Facebook icon
        UIImageView* facebook=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"facebook_favicon.png"]] autorelease];
        facebook.frame=CGRectMake(299,24, 12, 12);
        facebook.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:facebook];
        
        self.formatter=[[[NSDateFormatter alloc] init] autorelease];
        [self.formatter setDateFormat:@"MMMM dd, yyyy 'at' hh:mm"];
    }
    return self;
}

-(void)loadElement:(NSDictionary*)element{
    if (self.delayRequest!=nil){
        [self.delayRequest invalidate];
        self.delayRequest=nil;
    }
    if (self.req!=nil){
        [self.req clearDelegatesAndCancel];
        [self.req cancel];
        self.req= nil;
    }
    self.avatar.image=nil;
    NSURL* avatarLink = [NSURL URLWithString:[[element objectForKey:@"author"] objectForKey:@"avatar"]] ;
    
    // Avatar
    self.avatar.contentMode=UIViewContentModeScaleToFill;
    UIImage* image =[UIImage imageFromMemory:[avatarLink.absoluteString md5]];
    if (nil==image){
        self.avatar.image=[UIImage imageNamed:@"mask_44.png"];
        self.delayRequest = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(initRequest:) userInfo:avatarLink repeats:NO];
    }else{
        self.avatar.image=image;
    }
    // Build post
   
    NSString* name = [[element objectForKey:@"author"] objectForKey:@"name"];
    self.userName.text=name;
    
    NSString* description = [[element objectForKey:@"description"] stringByDecodingHTMLEntities];
    self.postText.text=description;
    self.postText.frame= CGRectMake(82, 35, 230, 70000);
    [self.postText sizeToFit];

    
    // Date
    NSDate *postDate = [NSDate dateWithTimeIntervalSince1970:[[element objectForKey:@"created_at"] intValue]];
    self.date.text=[self.formatter stringFromDate:postDate];
    
}

-(void)initRequest:(NSTimer*)timer{
    UIImage* image = [UIImage imageFromCache: [((NSURL*)self.delayRequest.userInfo).absoluteString md5]];
    if (nil==image){
        self.req = [ASIHTTPRequest requestWithURL:timer.userInfo];
        [self.req setDelegate:self];
        self.req.userInfo=[NSDictionary dictionaryWithObject:self.delayRequest.userInfo forKey:@"url"];
        [self.req setDidFinishSelector:@selector(avatarDownloaded:)];
        [self.req setDidFailSelector:@selector(avatarDownloadFailed:)];
        [[super networkQueue] addOperation:self.req];
        self.delayRequest=nil;
    }else{
        self.avatar.image=image;
    }
}

-(void)avatarDownloaded:(ASIHTTPRequest*)request{
    
    UIImage* image = [[[[UIImage imageWithData:[request responseData]] imageWithSize:CGSizeMake(44,44) ] imageWithRadius:4 ] imageWithMask:[UIImage imageNamed:@"mask_44.png"]];
    self.avatar.image=image;

    [image saveToCacheWithKey:[((NSURL*)[request.userInfo objectForKey:@"url"]).absoluteString md5]];
}

-(void)avatarDownloadFailed:(ASIHTTPRequest*)request{
    self.avatar.contentMode=UIViewContentModeCenter;
    self.avatar.image=[UIImage imageNamed:@"failed_35.png"];
}

-(void)dealloc{
    if (self.delayRequest!=nil){
        [self.delayRequest invalidate];
        self.delayRequest=nil;
    }
    if(self.req!=nil){
        [self.req clearDelegatesAndCancel];
        [self.req cancel];
        self.req=nil;
    }
    self.avatar=nil;
    self.postText=nil;
    self.date=nil;
    self.formatter=nil;
    [super  dealloc];
}

+(CGFloat)heightForElement:(NSDictionary*) element{
    NSString* description = [[element objectForKey:@"description"] stringByDecodingHTMLEntities];
    UILabel* txt = [[[UILabel alloc]initWithFrame:CGRectMake(82, 30, 230, 70000)] autorelease];
    txt.numberOfLines=0;
    txt.font=[UIFont fontWithName:@"Georgia" size:15];
    txt.lineBreakMode=UILineBreakModeWordWrap;
    txt.text = description;
    [txt sizeToFit];
    int height = txt.frame.size.height;
    if (height<20){
        height=20;
    }
    return height+65;
}

@end
