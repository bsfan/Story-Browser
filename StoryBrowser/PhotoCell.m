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
@implementation PhotoCell
@synthesize photo,photoTitle,req,photoDescription;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Photo
        self.photo=[[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 310, 310)] autorelease];
        self.photo.contentMode=UIViewContentModeScaleAspectFill; 
        self.photo.backgroundColor=[UIColor whiteColor];
        //self.photo.clipsToBounds=YES;
        //self.photo.layer.cornerRadius=33.0f;
        [self.contentView addSubview:self.photo];
        // Photo mask
        UIImageView* mask = [[UIImageView alloc] initWithFrame:self.photo.frame];
        mask.image=[UIImage imageNamed:@"mask_310.png"];
        //[self.contentView addSubview:mask];
        [mask release];
        
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
    if (self.req!=nil){
        [self.req clearDelegatesAndCancel];
        [self.req cancel];
        self.req= nil;
    }
    self.photo.image=nil;
    self.req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[[element objectForKey:@"image"] objectForKey:@"src"]]];
    [self.req setDelegate:self];
    self.req.queuePriority=NSOperationQueuePriorityHigh;
    [self.req setDidFinishSelector:@selector(imageDownloaded:)];
    [self.req setDidFailSelector:@selector(imageDownloadFailed:)];
    [[Tell netQueue] addOperation:self.req];
    // Photo title
    self.photoTitle.text= [element objectForKey:@"title"];
    self.photoTitle.frame=CGRectMake(5, 320, 310, 20);
    
    // Photo Description
    self.photoDescription.text= [element objectForKey:@"description"];
    self.photoDescription.frame=CGRectMake(5, 345, 310, 7000);
    [self.photoDescription sizeToFit];
    
}

-(void)imageDownloaded:(ASIHTTPRequest*) request{
    [self performSelectorInBackground:@selector(setImg:) withObject:request];
    
    
}
-(void)setImg:(ASIHTTPRequest*) request{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    UIImage*  image = [Utils roundedImage:[UIImage imageWithData:[request responseData]] withRadius:30 inRect:CGSizeMake(310, 310) withOverlay:[UIImage imageNamed:@"mask_310.png"] usingIdentifier:[request.url.absoluteString md5]];
    self.photo.contentMode=UIViewContentModeScaleToFill;
    self.photo.image=image;
    [pool release];
}

-(void)imageDownloadFailed:(ASIHTTPRequest*)request{
    self.photo.contentMode=UIViewContentModeCenter;
    self.photo.image=[UIImage imageNamed:@"failed_200.png"];
}

+(CGFloat)heightForElement:(NSDictionary*) element{
    UILabel* txt = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 310, 70000000)] autorelease];
    txt.text = [element objectForKey:@"description"];
    txt.numberOfLines=0;
    txt.font=[UIFont fontWithName:@"Arial-ItalicMT" size:14];
    txt.lineBreakMode=UILineBreakModeWordWrap;
    [txt sizeToFit];
   
    return txt.frame.size.height+355;
}

-(void)dealloc{
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
