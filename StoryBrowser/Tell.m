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
#import "SHK.h"
#import "NSString+HTML.h"
#import "GANTracker.h"
#import "GADBannerView.h"
#import "MBProgressHUD.h"
@implementation Tell
@synthesize storyTable,permalink,story,req,selectedRow,loadingHud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [BaseElementCell initNetworkQueue];
    }
    return self;
}


-(void) loadStory: (NSURL*)link{
    self.permalink=link;
    
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title=@"Story";
    [UIImage imageNamed:@"mask_300.png"];
    [UIImage imageNamed:@"video_mask.png"];
    [UIImage imageNamed:@"mask_44.png"];
    [UIImage imageNamed:@"twitter_favicon.png"];
    [UIImage imageNamed:@"facebook_favicon.png"];
    self.navigationItem.titleView=[[[UIView alloc] init] autorelease];
    self.storyTable.separatorColor=[UIColor groupTableViewBackgroundColor];
    self.storyTable.tableFooterView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,50)] autorelease];
    UIView* whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 600)];
    whiteView.backgroundColor=[UIColor whiteColor];
    [self.storyTable.tableFooterView addSubview:whiteView];
    GADBannerView* banner = [[GADBannerView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [banner setAdUnitID:@"a14e6fa9c1cf2d5"];
    [banner setRootViewController:self];
    [self.storyTable.tableFooterView addSubview:banner];
    [banner loadRequest:[GADRequest request]];
    [banner release];
    [whiteView release];    
    
    
    NSURL* url  = [self.permalink URLByAppendingPathExtension:@"json"];
    self.req = [ASIHTTPRequest requestWithURL:url];
    [self.req setDelegate:self];
    [self.req setDidFinishSelector:@selector(storyDownloaded:)];
    [self.req setDidFailSelector:@selector(storyDownloadFailed:)];
    //    [netQueue addOperation:self.req];
    self.loadingHud = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
	[self.view addSubview:loadingHud];
    loadingHud.labelText = @"Loading...";
	
    [loadingHud showWhileExecuting:@selector(startSynchronous) onTarget:self.req withObject:nil animated:YES];
}


-(void)showActions:(id)sender{
	SHKItem *item = [SHKItem URL:self.permalink title:[story objectForKey:@"title"]];
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
}



-(void)storyDownloaded:(ASIHTTPRequest*)request{ 
    self.story = [[[[SBJsonParser alloc] init] autorelease] objectWithString:[request responseString]]; 
    UIBarButtonItem* actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActions:)];
    
    self.navigationItem.rightBarButtonItem=actionButton;
    [actionButton release];

    
    // Title
    UILabel* storyTitle = [[UILabel alloc] init] ;
    storyTitle.textColor=[UIColor darkTextColor];

    storyTitle.text = [story objectForKey:@"title"];
    storyTitle.numberOfLines=0;
    storyTitle.frame=CGRectMake(10, 9, 320-15, 0);
    storyTitle.font = [UIFont fontWithName:@"Georgia" size:20] ;
    storyTitle.backgroundColor=[UIColor clearColor];
    CGSize titleSize=[storyTitle sizeThatFits:CGSizeMake(storyTitle.frame.size.width, 7000)];
    storyTitle.frame=CGRectMake(storyTitle.frame.origin.x, storyTitle.frame.origin.y, storyTitle.frame.size.width, titleSize.height);
    [self.view addSubview:storyTitle];
    [storyTitle release];
    
    // Description
    UILabel* description = [[UILabel alloc] init];
    description.numberOfLines=0;
    [description setLineBreakMode:UILineBreakModeWordWrap];
    description.font = [UIFont fontWithName:@"Georgia-Italic" size:14] ;
    [description setText:[[story objectForKey:@"description"] stringByDecodingHTMLEntities]];
    description.frame=CGRectMake(10, storyTitle.frame.size.height+storyTitle.frame.origin.y+6, 320-15, 0);
    CGSize descriptionSize = [description sizeThatFits:CGSizeMake(description.frame.size.width, 700000)];
    description.frame=CGRectMake(description.frame.origin.x, description.frame.origin.y, description.frame.size.width, descriptionSize.height);
    description.textColor=[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    description.backgroundColor=[UIColor clearColor];
    [self.view addSubview:description];
    [description release];
    
    
    // Height of the header
    int height= description.frame.origin.y+description.frame.size.height+10;
    if (height<10)height=10;
    self.storyTable.tableHeaderView.frame=CGRectMake(0, 0, 320, height);  
  
    [self.storyTable setTableHeaderView:self.storyTable.tableHeaderView];     
    [self.storyTable reloadData];
    
    [self.view bringSubviewToFront:self.storyTable];
    [self.view bringSubviewToFront:self.loadingHud];
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
        [self.loadingHud removeFromSuperview];
        self.loadingHud = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
        [self.view addSubview:loadingHud];
        loadingHud.labelText = @"Loading";

        [loadingHud showWhileExecuting:@selector(startSynchronous) onTarget:self.req withObject:nil animated:YES];
        //[[Tell netQueue] addOperation:self.req];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)thumbnailDownloaded:(ASIHTTPRequest*)request{
    UIImageView* thumbnail = (UIImageView*)[request.userInfo objectForKey:@"imageView"];
    thumbnail.image=[UIImage imageWithData:[request responseData]];
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
            cell = [(BaseElementCell*)[[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:elementType] autorelease];
        }else{
            cell = [(BaseElementCell*)[[BaseElementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"] autorelease];
        }
        

    }
    [((BaseElementCell*)cell) loadElement:element ];
    UIView* background = [[UIView alloc] init] ;
    background.backgroundColor=[UIColor whiteColor];    
    cell.backgroundView=background;
    [background release];

    return (UITableViewCell*)cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [[[self.story objectForKey:@"elements"] allKeys] count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* element = [[self.story objectForKey:@"elements"] objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    [self.storyTable deselectRowAtIndexPath:indexPath animated:YES];
    NSString* elementType = [element objectForKey:@"elementClass"];
    if ([elementType isEqualToString:@"tweet"]){
        NSString* index =  [NSString stringWithFormat:@"%d",indexPath.row];
        ShowElement* showElement = [[[ShowElement alloc] initWithNibName:@"ShowElement" bundle:nil] autorelease];
        [showElement loadElementWithIndex:index from:self.story];
        [self.navigationController pushViewController:showElement animated:YES];   
    }else if([elementType isEqualToString:@"text"]){
            [[GANTracker sharedTracker] trackPageview:@"/story/text" withError:nil];
    }else{
        [[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"/story/%@",elementType ] withError:nil];
        NSString* link = [element objectForKey:@"permalink"];
        TTWebController* ctr = [[[TTWebController alloc] init] autorelease];
        [ctr openURL:[NSURL URLWithString:link]];
        ctr.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:ctr animated:YES];
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [self.loadingHud removeFromSuperview];
}


-(void) dealloc{
    [self.req clearDelegatesAndCancel];
    [self.req cancel];
    [BaseElementCell stopNetworkQueue];
    self.req=nil;
    self.loadingHud=nil;
    self.storyTable=nil;
    self.permalink=nil;
    self.story=nil;

    [super dealloc];
}



@end
