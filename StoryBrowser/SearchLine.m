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
#import "UIImage+edit.h"
#import "NSString+md5.h"
#import "Search.h"
@implementation SearchLine
@synthesize  avatar,title,avatarReq,delayRequest;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatar =[[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 44, 44)] autorelease];
        self.avatar.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:self.avatar];
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        self.title = [[[UILabel alloc] init] autorelease];
        self.title.backgroundColor=[UIColor whiteColor];
        self.title.lineBreakMode=UILineBreakModeWordWrap;
        self.title.numberOfLines=0;
        self.title.highlightedTextColor=[UIColor whiteColor];
        self.title.font=[UIFont fontWithName:@"TimesNewRomanPSMT" size:18];
        [self.contentView addSubview:self.title];
    }
    
    return self;
}

-(void)loadLine:(NSURL*)avatarURL title:(NSString*)t{
    if (self.delayRequest!=nil){
        [delayRequest invalidate];
        self.delayRequest=nil;
    }
    if (self.avatarReq!=nil){
        [self.avatarReq clearDelegatesAndCancel];
        [self.avatarReq cancel];
        self.avatarReq=nil;
    }
    self.title.text=t;
    self.title.frame=CGRectMake(55, 5, 220, 7000);

    [self.title sizeToFit];
    if ([avatarURL isFileURL]){
        self.avatar.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:avatarURL]];
        
    }else{
        UIImage* image = [UIImage imageFromCache:[[avatarURL absoluteString] md5]];
        if (nil==image){
            self.avatar.image=[UIImage imageNamed:@"mask_44.png"];        
            self.avatarReq = [ASIHTTPRequest requestWithURL:avatarURL];
            [self.avatarReq setDelegate:self];
            self.avatarReq.userInfo=[NSDictionary dictionaryWithObject:avatarURL forKey:@"url"];
            [self.avatarReq setDidFinishSelector:@selector(avatarDownloaded:)];
            [self.avatarReq setDidFailSelector:@selector(avatarDownloadFailed:)];
            [[Search queue] addOperation:self.avatarReq];
            self.delayRequest=nil;
        }else{
            self.avatar.image=image;
        }
    }
}

-(void)avatarDownloaded:(ASIHTTPRequest*)request{
    UIImage* image = [[[[UIImage imageWithData:[request responseData]] imageWithSize:CGSizeMake(44,44) ] imageWithRadius:2] imageWithMask:[UIImage imageNamed:@"mask_44.png"]];
    
    self.avatar.image = image;
    [image saveToCacheWithKey:[[request.url absoluteString] md5]];
    self.avatarReq=nil;
}

-(void)avatarFailedDownload:(ASIHTTPRequest*)request{
    self.avatar.image=[UIImage imageNamed:@"failed_35.png"];
    self.avatar.contentMode=UIViewContentModeCenter;
}

-(void) dealloc{
    self.title=nil;
    self.avatar=nil;
    if (self.avatarReq!=nil){
        [self.avatarReq clearDelegatesAndCancel];
        [self.avatarReq cancel];
        self.avatarReq=nil;
    }

    [super dealloc];
}
@end
