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
@implementation VideoCell
@synthesize preview,videoTitle,videoDescription,req;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Photo
        self.preview=[[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 310, 234)] autorelease];
        self.preview.contentMode=UIViewContentModeScaleAspectFill; 
        self.preview.backgroundColor=[UIColor whiteColor];
        //self.preview.clipsToBounds=YES;
        //self.preview.layer.cornerRadius=15.0f;
        [self.contentView addSubview:self.preview];
        // Photo mask
       // UIImageView* mask = [[UIImageView alloc] initWithFrame:self.preview.frame];
        //mask.image=[UIImage imageNamed:@"video_mask.png"];
        //[self.contentView addSubview:mask];
        //[mask release];
        
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
    if (self.req!=nil){
        [self.req clearDelegatesAndCancel];
        [self.req cancel];
        self.req= nil;
    }
    self.preview.image=nil;
    self.req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[[element objectForKey:@"thumbnail"] stringByReplacingOccurrencesOfString:@"default.jpg" withString:@"0.jpg"]]];
    [self.req setDelegate:self];
    self.req.queuePriority=NSOperationQueuePriorityHigh;
    [self.req setDidFinishSelector:@selector(imageDownloaded:)];
    [self.req setDidFailSelector:@selector(imageDownloadFailed:)];
    [[Tell netQueue] addOperation:self.req];
    // Photo title
    self.videoTitle.text= [element objectForKey:@"title"];

    
    // Photo Description
    self.videoDescription.text= [element objectForKey:@"description"];
    self.videoDescription.frame=CGRectMake(5, 270, 310, 7000);
    [self.videoDescription sizeToFit];
    
}

-(void)imageDownloaded:(ASIHTTPRequest*) request{
    [self performSelectorInBackground:@selector(setImg:) withObject:request];
}

-(void)setImg:(ASIHTTPRequest*)request{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    UIImage*  image = [Utils roundedImage:[UIImage imageWithData:[request responseData]] withRadius:15 inRect:CGSizeMake(310, 234) withOverlay:[UIImage imageNamed:@"video_mask.png"] usingIdentifier:[request.url.absoluteString md5]];
    self.preview.contentMode=UIViewContentModeScaleAspectFill;
    self.preview.image=image;
    [pool release];

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
