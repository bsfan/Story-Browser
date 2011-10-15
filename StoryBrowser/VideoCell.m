//
//  VideoCell.m
//  StoryBrowser
//
//  Created by Simon Watiau on 9/7/11.
//

#import "VideoCell.h"
#import "Utils.h"
#import "NSString+md5.h"
#import "Tell.h"
#import "UIImage+edit.h"
#import "NSString+HTML.h"
@implementation VideoCell
@synthesize preview,videoTitle,videoDescription,req,delayRequest,loadingCounter;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.loadingCounter=0;
        // Photo
        self.preview=[[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 300, 232)] autorelease];
        self.preview.contentMode=UIViewContentModeScaleAspectFill; 
        self.preview.backgroundColor=[UIColor whiteColor];

        [self.contentView addSubview:self.preview];
        
        
        // Title
        self.videoTitle=[[[UILabel alloc] init] autorelease];
        self.videoTitle.textAlignment=UITextAlignmentCenter;
        self.videoTitle.numberOfLines=1;
        self.videoTitle.frame=CGRectMake(5, 245, 310, 20);
        self.videoTitle.font=[UIFont fontWithName:@"Arial-BoldMT" size:16];
        self.videoTitle.highlightedTextColor=[UIColor whiteColor];
        [self.contentView addSubview:self.videoTitle];
        
        // Description
        self.videoDescription=[[[UILabel alloc] init] autorelease];
        self.videoDescription.textAlignment=UITextAlignmentLeft;
        self.videoDescription.numberOfLines=0;
        self.videoDescription.font=[UIFont fontWithName:@"Arial-ItalicMT" size:14];
        self.videoDescription.textColor=[UIColor darkGrayColor];
        self.videoDescription.highlightedTextColor=[UIColor whiteColor];
        [self.contentView addSubview:self.videoDescription];
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
    

    NSURL* url = [NSURL URLWithString:[[element objectForKey:@"thumbnail"] stringByReplacingOccurrencesOfString:@"default.jpg" withString:@"0.jpg"]];
    
    self.preview.contentMode=UIViewContentModeScaleToFill;
    UIImage* image = [UIImage imageFromMemory:[url.absoluteString md5]];
    if (nil==image){
        self.preview.image=[UIImage imageNamed:@"video_mask.png"];
        self.delayRequest = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(initRequest:) userInfo:url repeats:NO];
    }else{
        self.preview.image=image;
    }
    
    // Photo title
    self.videoTitle.text= [[[element objectForKey:@"title"] stringByDecodingHTMLEntities] stringByConvertingHTMLToPlainText];

    
    // Photo Description
    self.videoDescription.text= [[[element objectForKey:@"description"] stringByDecodingHTMLEntities] stringByConvertingHTMLToPlainText];
    self.videoDescription.frame=CGRectMake(5, 270, 310, 7000);
    [self.videoDescription sizeToFit];
    
}


-(void)initRequest:(NSTimer*)timer{
    UIImage* image  = [UIImage imageFromCache:[((NSURL*)self.delayRequest.userInfo).absoluteString md5]];
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
        self.preview.image=image;
    }
    
}



-(void)imageDownloaded:(ASIHTTPRequest*) request{
    NSURL* url = ((NSURL*)[self.req.userInfo objectForKey:@"url"]);
    NSString* hash = [url.absoluteString md5];
    UIImage* image=  [UIImage imageFromCache:hash];
    self.loadingCounter++;
    int current = self.loadingCounter;
    if (!image){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            UIImage* image= [[[[UIImage imageWithData:[request responseData]] imageWithSize:CGSizeMake(300,232) ] imageWithRadius:7 ] imageWithMask:[UIImage imageNamed:@"video_mask.png"]];
            [image saveToCacheWithKey:hash];
            if (current==self.loadingCounter){
                dispatch_async(dispatch_get_main_queue(),^{
                    self.preview.image=image;
                });
            }
        });
    }


}


-(void)imageDownloadFailed:(ASIHTTPRequest*)request{
    self.preview.contentMode=UIViewContentModeCenter;
    self.preview.image=[UIImage imageNamed:@"failed_200.png"];
}

+(CGFloat)heightForElement:(NSDictionary*) element{
    UILabel* txt = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 310, 70000000)] autorelease];
    txt.text = [element objectForKey:@"description"];
    txt.numberOfLines=0;
    txt.font=[UIFont fontWithName:@"Arial-ItalicMT" size:14];
    [txt sizeToFit];
    return txt.frame.size.height+280;
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
    self.videoTitle=nil;
    self.preview=nil;
    self.videoDescription=nil;
    [super dealloc];
}




@end
