//
//  TweetViews.m
//  StoryBrowser
//
//  Created by Simon Watiau on 9/6/11.
//

#import "TweetViews.h"
#import "Utils.h"
#import "TweetContentTTStyle.h"
@implementation TweetViews
@synthesize avatar,req,text;
- (id)init{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


-(UIView*) titleView{

    UIView* view = [[[UIView alloc] init] autorelease];
    self.avatar = [[[UIImageView alloc] initWithFrame:CGRectMake(10,10,44,44)] autorelease];
    self.avatar.layer.cornerRadius=2.0f;
    self.avatar.backgroundColor=[UIColor whiteColor];
    self.avatar.clipsToBounds=YES;
    
    UIImageView* mask = [[UIImageView alloc] initWithFrame:self.avatar.frame];
    mask.image=[UIImage imageNamed:@"mask_44.png"];
    [view addSubview:self.avatar];
    [view addSubview:mask];
    [mask release];
    
    NSURL* avatarLink  =[NSURL URLWithString:[[super.element objectForKey:@"author"] objectForKey:@"avatar"]];
    self.req = [ASIHTTPRequest requestWithURL:avatarLink];
    [self.req setDelegate:self];
    [self.req setDidFinishSelector:@selector(avatarDownloaded:)];
    [self.req setDidFailSelector:@selector(avatarDownloadFailed:)];
    [self.req startAsynchronous];
    
    UILabel* name = [[UILabel alloc] initWithFrame:CGRectMake(64,12, 250, 22)];
    name.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
    name.text=[[super.element objectForKey:@"author"] objectForKey:@"name"];
    name.backgroundColor=[UIColor clearColor];
    [view addSubview:name];
    [name release];
    
    UILabel* username = [[UILabel alloc] initWithFrame:CGRectMake(64,30, 250, 22)];
    username.font = [UIFont fontWithName:@"ArialMT" size:14];
    username.backgroundColor=[UIColor clearColor];
    username.text=[NSString stringWithFormat:@"@%@",[[super.element objectForKey:@"author"] objectForKey:@"username"]];
    [view addSubview:username];
    [username release];
    
    
    view.frame=CGRectMake(0, 0, 320, 64);
    return view;
}

-(void)avatarDownloaded:(ASIHTTPRequest*) request{
    self.avatar.contentMode=UIViewContentModeScaleAspectFill;
    self.avatar.image=[UIImage imageWithData:[request responseData]];
}


-(void)avatarDownloadFailed:(ASIHTTPRequest*)request{
    self.avatar.contentMode=UIViewContentModeCenter;
    self.avatar.image=[UIImage imageNamed:@"failed_35.png"];
}


-(UIView*) contentView{
    [TTStyleSheet setGlobalStyleSheet:[[[TweetContentTTStyle alloc]  
                                        init] autorelease]]; 
    UIView* view = [[[UIView alloc] init] autorelease];
    
    self.text = [[[TTStyledTextLabel alloc] initWithFrame:CGRectMake(5, 0, 310, 7000)] autorelease];
    self.text.font = [UIFont fontWithName:@"Georgia" size:25];
    self.text.html=[Utils prepareForStyledLabel:[super.element objectForKey:@"title"]];
    [self.text sizeToFit];
    [view addSubview:self.text];
    
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM dd, yyyy 'at' hh:mm"];

    
    UILabel* date = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 290, 15)];
    NSDate *tweetDate = [NSDate dateWithTimeIntervalSince1970:[[super.element objectForKey:@"created_at"] intValue]];
    date.text=[formatter stringFromDate:tweetDate];
    [formatter release];
    
    date.font = [UIFont fontWithName:@"ArialMT" size:16];
    date.textColor = [UIColor lightGrayColor];
    date.textAlignment=UITextAlignmentRight;
    date.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    date.backgroundColor=[UIColor clearColor];
    [view addSubview:date];
    [date release];
    
    UIImageView* bird = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"twitter_favicon.png"]];
    bird.frame=CGRectMake(295, 0, 18, 12);
    bird.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    [view addSubview:bird];
    [bird release];
    
    view.frame = CGRectMake(0, 0, 320, self.text.frame.size.height+20);
    return view;
}

-(void)scroll{
    NSLog(@"scrollll");
    [self.text setHighlightedNode:nil];
}
-(void) dealloc{
    if (self.req){
        [self.req clearDelegatesAndCancel];
        [self.req cancel];
        self.req=nil;
    }
    self.avatar=nil;
    self.text=nil;
    [super dealloc];
}

@end
