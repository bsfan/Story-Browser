//
//  Tell.m
//  StoryBrowser
//
//  Created by Simon Watiau on 8/25/11.
//

#import "Tell.h"
#import "ASIHTTPRequest.h"
#import "SBJsonParser.h"
#import "WebsiteCell.h"
#import "TweetCell.h"
#import "FbPostCell.h"
#import "RegexKitLite.h"
#import "TextCell.h"
#import "PhotoCell.h"
#import "ASINetworkQueue.h"
#import "Utils.h"
#import "ShowElement.h"
#import "TellHeaderTTStyle.h"
#import "Three20/Three20.h"
#import "VideoCell.h"
ASINetworkQueue* netQueue;
@implementation Tell
@synthesize storyTable,permalink,story,req,totop,selectedRow,pool,drainCountDown;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        netQueue = [[ASINetworkQueue alloc] init];
        [netQueue setMaxConcurrentOperationCount:2];
        [netQueue go];
        [TTStyleSheet setGlobalStyleSheet:[[[TellHeaderTTStyle alloc]  
                                            init] autorelease]]; 


    }
    return self;
}


-(void) loadStory: (NSURL*)link{
    self.permalink=link;
}

+(ASINetworkQueue*)netQueue{
    return netQueue;
}

- (void)viewDidLoad{
    [super viewDidLoad];
self.title=@"Story";
    self.navigationItem.titleView=[[[UIView alloc] init] autorelease];
    NSURL* url  = [self.permalink URLByAppendingPathExtension:@"json"];
    self.req = [ASIHTTPRequest requestWithURL:url];
    [self.req setDelegate:self];
    [self.req setDidFinishSelector:@selector(storyDownloaded:)];
    [self.req setDidFailSelector:@selector(storyDownloadFailed:)];
    [netQueue addOperation:self.req];
    self.storyTable.separatorColor=[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
 
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y>self.storyTable.tableHeaderView.frame.size.height-42){
        self.totop.hidden=FALSE;
    }else{
        self.totop.hidden=TRUE;
    }
}
-(void)storyDownloaded:(ASIHTTPRequest*)request{ 
    self.story = [[[[SBJsonParser alloc] init] autorelease] objectWithString:[request responseString]]; 
    
    // Title
    UILabel* storyTitle = [[UILabel alloc] init] ;
    storyTitle.text = [story objectForKey:@"title"];
    storyTitle.numberOfLines=0;
    storyTitle.frame=CGRectMake(5, 5, 310, 0);
    storyTitle.font = [UIFont fontWithName:@"Georgia" size:20] ;
    storyTitle.backgroundColor=[UIColor clearColor];
    CGSize titleSize=[storyTitle sizeThatFits:CGSizeMake(storyTitle.frame.size.width, 7000)];
    storyTitle.frame=CGRectMake(storyTitle.frame.origin.x, storyTitle.frame.origin.y, storyTitle.frame.size.width, titleSize.height);
    [self.storyTable.tableHeaderView addSubview:storyTitle];
    [storyTitle release];
    
    // Description
    TTStyledTextLabel* description = [[TTStyledTextLabel alloc] init];
    description.font = [UIFont fontWithName:@"Georgia-Italic" size:14] ;
    [description setHtml:[Utils prepareForStyledLabel:[story objectForKey:@"description"]]];
    description.frame=CGRectMake(5, storyTitle.frame.size.height+storyTitle.frame.origin.y+10, 320-5-5, 0);
    CGSize descriptionSize = [description sizeThatFits:CGSizeMake(description.frame.size.width, 700000)];
    description.frame=CGRectMake(description.frame.origin.x, description.frame.origin.y, description.frame.size.width, descriptionSize.height);
    description.textColor=[UIColor darkGrayColor];
    description.backgroundColor=[UIColor clearColor];
    [self.storyTable.tableHeaderView addSubview:description];
    [description release];
    
    
    // Height of the header
    int height= description.frame.origin.y+description.frame.size.height+60;
    if (height<10)height=10;
    self.storyTable.tableHeaderView.frame=CGRectMake(0, 0, 320, height);    
    [self.storyTable setTableHeaderView:self.storyTable.tableHeaderView];    
    [self.storyTable reloadData];
    
    
    
    UIView* noisyBackground = [[UIView alloc]initWithFrame:CGRectMake(0, -2000, 320, 2000+height)];
    noisyBackground.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"noise.png"]];
    
    noisyBackground.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    [self.storyTable.tableHeaderView insertSubview:noisyBackground atIndex:0];
    [noisyBackground release];
    
    
    // Show the table
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.30];
    self.storyTable.alpha=1;
    [self.view viewWithTag:9].hidden=YES;
    [UIView commitAnimations];
}

-(IBAction)scrollToTop:(id)sender{
    [self.storyTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

-(void)storyDownloadFailed:(ASIHTTPRequest*)request{
    [[[[UIAlertView alloc] initWithTitle:@"No connection" message:@"Something went wrong, please check your connectivity and try again" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try again",nil] autorelease] show];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1){
        ASIHTTPRequest* copy = [self.req copy];
        self.req=copy;
        [copy release];
        [[Tell netQueue] addOperation:self.req];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)thumbnailDownloaded:(ASIHTTPRequest*)request{
    UIImageView* thumbnail = (UIImageView*)[request.userInfo objectForKey:@"imageView"];
    thumbnail.image=[UIImage imageWithData:[request responseData]];
}

- (void)viewWillDisappear:(BOOL)animated{
    if (self.req!=nil){
        [self.req clearDelegatesAndCancel];
        [self.req cancel];
        self.req=nil;
    } 
    [netQueue cancelAllOperations];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload{
    [super viewDidUnload];
 
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"heeee");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height=0;
    NSDictionary* element = [[self.story objectForKey:@"elements"] objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    NSString* elementType = [element objectForKey:@"elementClass"];

    if ([elementType isEqualToString:@"website"]){
        height = [WebsiteCell heightForElement:element ];
    }else if ([elementType isEqualToString:@"tweet"]){
        height = [TweetCell heightForElement:element ];
    }else if ([elementType isEqualToString:@"text"]){
        height = [TextCell heightForElement:element ];
    }else if ([elementType isEqualToString:@"fbpost"]){
        height = [FbPostCell heightForElement:element ];
    }else if ([elementType isEqualToString:@"photo"]){
        height = [PhotoCell heightForElement:element ];
    }else if ([elementType isEqualToString:@"video"]){
        
        height = [VideoCell heightForElement:element ];
    }else{
        height = [BaseElementCell heightForElement:element ];
    }
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    NSDictionary* element = [[self.story objectForKey:@"elements"] objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    NSString* elementType = [element objectForKey:@"elementClass"];

    BaseElementCell *cell = (BaseElementCell*) [self.storyTable dequeueReusableCellWithIdentifier:elementType];
    if (!cell){
        if ([elementType isEqualToString:@"tweet"]){
            cell = [(BaseElementCell*)[[TweetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:elementType] autorelease];           
        }else if ([elementType isEqualToString:@"website"]){
             cell  = [(BaseElementCell*)[[WebsiteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:elementType] autorelease];
        }else if ([elementType isEqualToString:@"text"]){
            cell = [(BaseElementCell*)[[TextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:elementType] autorelease];

        }else if ([elementType isEqualToString:@"photo"]){
            cell = [(BaseElementCell*)[[PhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:elementType] autorelease];
        }else if ([elementType isEqualToString:@"fbpost"]){
            cell = [(BaseElementCell*)[[FbPostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:elementType] autorelease];
        }else if ([elementType isEqualToString:@"video"]){
            NSLog(@"videoCell");
            cell = [(BaseElementCell*)[[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:elementType] autorelease];
        }else{
            cell = [(BaseElementCell*)[[BaseElementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"] autorelease];
        }
        

    }
    [((BaseElementCell*)cell) loadElement:element ];
    return (UITableViewCell*)cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [[[self.story objectForKey:@"elements"] allKeys] count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* element = [[self.story objectForKey:@"elements"] objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    NSString* elementType = [element objectForKey:@"elementClass"];
    if ([elementType isEqualToString:@"tweet"]){
        NSString* index =  [NSString stringWithFormat:@"%d",indexPath.row];
        ShowElement* showElement = [[[ShowElement alloc] initWithNibName:@"ShowElement" bundle:nil] autorelease];
        [showElement loadElementWithIndex:index from:self.story];
        [self.navigationController pushViewController:showElement animated:YES];   
    }else if([elementType isEqualToString:@"text"]){
        NSLog(@"nothing");
    }else{
        NSString* link = [element objectForKey:@"permalink"];
        TTWebController* ctr = [[[TTWebController alloc] init] autorelease];
        [ctr openURL:[NSURL URLWithString:link]];
        ctr.hidesBottomBarWhenPushed=NO;
        [self.navigationController pushViewController:ctr animated:YES];
    }
}

-(void) dealloc{
    if (self.req!=nil){
        [self.req clearDelegatesAndCancel];
        [self.req cancel];
        self.req=nil;
    } 
    self.storyTable=nil;
    self.permalink=nil;
    self.story=nil;
    [netQueue cancelAllOperations];
    [netQueue release];
    [super dealloc];
}



@end
