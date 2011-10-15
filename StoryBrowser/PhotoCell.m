//
//  PhotoCell.m
//  StoryBrowser
//
//  Created by Simon Watiau on 8/29/11.
//

#import "PhotoCell.h"
#import "ASIHTTPRequest.h"
#import "Tell.h"
#import "ASIDownloadCache.h"
#import "Utils.h"
#import "NSString+md5.h"
#import "UIImage+edit.h"
#import "NSString+HTML.h"
@implementation PhotoCell
@synthesize photo,photoTitle,req,photoDescription,delayRequest,loadingCounter;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.loadingCounter=0;
        // Photo
        self.photo=[[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 300, 300)] autorelease];
        self.photo.contentMode=UIViewContentModeScaleAspectFill; 
        self.photo.backgroundColor=[UIColor whiteColor];
        self.photo.opaque=TRUE;
        [self.contentView addSubview:self.photo];
        
        // Title
        self.photoTitle=[[[UILabel alloc] init] autorelease];
        self.photoTitle.textAlignment=UITextAlignmentCenter;
        self.photoTitle.numberOfLines=1;
        self.photoTitle.frame=CGRectMake(5, 320, 310, 20);
        self.photoTitle.font=[UIFont fontWithName:@"Arial-BoldMT" size:16];
        self.photoTitle.highlightedTextColor=[UIColor whiteColor];
        [self.contentView addSubview:self.photoTitle];
        
        // Description
        self.photoDescription=[[[UILabel alloc] init] autorelease];
        self.photoDescription.textAlignment=UITextAlignmentLeft;
        self.photoDescription.numberOfLines=0;
        self.photoDescription.font=[UIFont fontWithName:@"Arial-ItalicMT" size:14];
        self.photoDescription.textColor=[UIColor darkGrayColor];
        self.photoDescription.highlightedTextColor=[UIColor whiteColor];
        self.photoDescription.lineBreakMode=UILineBreakModeWordWrap;
        [self.contentView addSubview:self.photoDescription];
    }
    return self;
}


-(void)loadElement:(NSDictionary*)element{
    if (self.delayRequest!=nil){
        [delayRequest invalidate];
        self.delayRequest=nil;
    }
    if (self.req!=nil){
        [self.req clearDelegatesAndCancel];
        [self.req cancel];
        self.req= nil;
    }

    self.photo.contentMode=UIViewContentModeScaleToFill;
    NSURL* photoURL = [NSURL URLWithString:[[element objectForKey:@"image"] objectForKey:@"src"]];
    UIImage* image = [UIImage imageFromMemory:[photoURL.absoluteString md5]];
    if (nil==image){
        self.photo.image = [UIImage imageNamed:@"mask_300.png"];
        self.delayRequest = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(initRequest:) userInfo:photoURL repeats:NO];
    }else{
        self.photo.image =image;
    }
    

    // Photo title
    self.photoTitle.text= [[element objectForKey:@"title"] stringByDecodingHTMLEntities];
    self.photoTitle.frame=CGRectMake(5, 320, 310, 20);
    
    // Photo Description
    self.photoDescription.text= [[element objectForKey:@"description"] stringByDecodingHTMLEntities];
    self.photoDescription.frame=CGRectMake(5, 345, 310, 7000);
    [self.photoDescription sizeToFit];
    
}

-(void)initRequest:(NSTimer*)timer{
    UIImage* image = [UIImage imageFromCache:[((NSURL*)self.delayRequest.userInfo).absoluteString md5]];
    if (nil==image){
        self.req = [ASIHTTPRequest requestWithURL:self.delayRequest.userInfo];
        [self.req setDelegate:self];
        self.req.userInfo=[NSDictionary dictionaryWithObject:self.delayRequest.userInfo forKey:@"url"];
        self.req.queuePriority=NSOperationQueuePriorityHigh;
        [self.req setDidFinishSelector:@selector(imageDownloaded:)];
        [self.req setDidFailSelector:@selector(imageDownloadFailed:)];
        [self.req setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
        self.req.threadPriority=0;
        if ([super networkQueue]!=nil){
            [[super networkQueue] addOperation:self.req];
        }
        
    }else{
        self.photo.image=image;
    }
    
}

-(void)imageDownloaded:(ASIHTTPRequest*) request{
    NSURL* url = ((NSURL*)[self.req.userInfo objectForKey:@"url"]);
    NSString* hash = [url.absoluteString md5];
    UIImage* image= [UIImage imageFromCache:hash]; 
    self.loadingCounter++;
    int current = self.loadingCounter;
    if (!image){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            UIImage* image = [[[[UIImage imageWithData:[request responseData]] imageWithSize:CGSizeMake(300,300) ] imageWithRadius:9 ] imageWithMask:[UIImage imageNamed:@"mask_300.png"]];
            [image saveToCacheWithKey:hash];
            if (current==self.loadingCounter){
                dispatch_async(dispatch_get_main_queue(),^{
                    self.photo.image=image;
                });
            }
        });
    }else{
        self.photo.image=image;
    }

    
    
}

-(void)imageDownloadFailed:(ASIHTTPRequest*)request{
    self.photo.contentMode=UIViewContentModeCenter;
    self.photo.image=[UIImage imageNamed:@"failed_200.png"];
}

+(CGFloat)heightForElement:(NSDictionary*) element{
    UILabel* txt = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 310, 70000000)] autorelease];
    txt.text = [[element objectForKey:@"description"] stringByDecodingHTMLEntities];
    txt.numberOfLines=0;
    txt.font=[UIFont fontWithName:@"Arial-ItalicMT" size:14];
    txt.lineBreakMode=UILineBreakModeWordWrap;
    txt.textAlignment=UITextAlignmentLeft;

    [txt sizeToFit];
   
    return txt.frame.size.height+355;
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
    self.photoTitle=nil;
    self.photo=nil;
    self.photoDescription=nil;
    [super dealloc];
}

@end
