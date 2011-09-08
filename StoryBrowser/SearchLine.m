//
//  SearchLine.m
//  StoryBrowser
//
//  Created by Simon Watiau on 9/2/11.
//

#import "SearchLine.h"
#import "SearchLine.h"
#import "ASIDownloadCache.h"
#import "Utils.h"
#import "QuartzCore/QuartzCore.h"
@implementation SearchLine
@synthesize  avatar,title,avatarReq;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatar =[[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 44, 44)] autorelease];
        self.avatar.backgroundColor=[UIColor whiteColor];
        self.avatar.layer.cornerRadius=2.0f;
        self.avatar.clipsToBounds=YES;
        
        // DL layer
        UIImageView* dl = [[UIImageView alloc] initWithFrame:self.avatar.frame];
        
        dl.image = [UIImage imageNamed:@"downloading_35.png"];
        dl.contentMode=UIViewContentModeCenter;
        [self.contentView addSubview:dl];
        [dl release];
        [self.contentView addSubview:self.avatar];
      
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        UIImageView* avatarMask  = [[UIImageView alloc] initWithFrame:self.avatar.frame];
        avatarMask.image=[UIImage imageNamed:@"mask_44.png"];
        
        [self.contentView addSubview:avatarMask];
        [self bringSubviewToFront:avatarMask];
        [avatarMask release];
        
        
        self.title = [[[UILabel alloc] init] autorelease];
        self.title.backgroundColor=[UIColor clearColor];
        self.title.lineBreakMode=UILineBreakModeWordWrap;
        self.title.numberOfLines=0;

        self.title.font=[UIFont fontWithName:@"TimesNewRomanPSMT" size:18];
        [self.contentView addSubview:self.title];
        
    }
    
    return self;
}

-(void)loadLine:(NSURL*)avatarURL title:(NSString*)t queue:(ASINetworkQueue *)queue{
    if (self.avatarReq!=nil){
        [self.avatarReq clearDelegatesAndCancel];
        [self.avatarReq cancel];
        self.avatarReq=nil;
    }
    self.title.text=t;
    self.title.frame=CGRectMake(55, 5, 220, 7000);

    [self.title sizeToFit];
    
    self.avatarReq = [ASIHTTPRequest requestWithURL:avatarURL];
    [self.avatarReq setDelegate:self];
    [self.avatarReq setDidFinishSelector:@selector(avatarDownloaded:)];
    [self.avatarReq setDidFailSelector:@selector(avatarDownloadFailed:)];
    [queue addOperation:self.avatarReq];
    self.avatar.image=nil;
    
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    int height = self.title.frame.size.height+10;
    if (height<54){
        height=54;
    }
    
    self.backgroundView = [[[UIView alloc] init] autorelease];    
    self.backgroundView.frame= CGRectMake(0, 0, 320, height);
    gradientLayer.frame = self.backgroundView.frame;
    CGColorRef lightLightGray = [[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1] CGColor];
    CGColorRef whiteColor = [[UIColor whiteColor] CGColor];
    gradientLayer.colors = [NSArray arrayWithObjects:(id)whiteColor,(id)whiteColor,(id)lightLightGray, nil];


    [self.backgroundView.layer addSublayer:gradientLayer];
}

-(void)avatarDownloaded:(ASIHTTPRequest*)request{    
    self.avatar.image =[UIImage imageWithData:[request responseData]];
    self.avatar.contentMode=UIViewContentModeScaleAspectFill;
}

-(void)avatarFailedDownload:(ASIHTTPRequest*)request{
    NSLog(@"fail");
    
    self.avatar.image=[UIImage imageNamed:@"failed_35.png"];
    self.avatar.contentMode=UIViewContentModeCenter;
}

-(void) dealloc{
    self.title=nil;
    self.avatar=nil;
    self.avatarReq=nil;
    [super dealloc];
}
@end
