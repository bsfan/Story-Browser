//
//  HotTopics.m
//  StoryBrowser
//
//  Created by Simon Watiau on 9/13/11.
//

#import "HotTopics.h"
#import "SBJsonParser.h"
#import "QuartzCore/QuartzCore.h"
#import "Search.h"
#import "GANTracker.h"
@implementation HotTopics
@synthesize request,table,hotTopics,loadingHud,topStories;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    [[GANTracker sharedTracker] trackPageview:@"/HotTopics" withError:nil];
    self.title=@"Hot Topics";
    self.hotTopics=[[[NSArray alloc] init] autorelease];
    UIImageView* logo =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    logo.frame=CGRectMake(0, 0, [UIImage imageNamed:@"logo.png"].size.width+40, [UIImage imageNamed:@"logo.png"].size.height);
    logo.contentMode=UIViewContentModeCenter;
    self.navigationItem.titleView=logo;
    [logo release];
    
    NSURL *url = [NSURL URLWithString:@"http://storify.com/stats/top/topics.json"];
    self.request = [ASIHTTPRequest requestWithURL:url];
    [self.request setDelegate:self];
    [self.request setDidFinishSelector:@selector(topicsDownloaded:)];    
    [self.request setDidFailSelector:@selector(topicsDownloadFailed:)];    
    [self.request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    self.loadingHud = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
	[self.view addSubview:loadingHud];
    loadingHud.labelText = @"Loading...";
	
    [loadingHud showWhileExecuting:@selector(startSynchronous) onTarget:self.request withObject:nil animated:YES];
    
}


-(void)topicsDownloadFailed:(ASIHTTPRequest*)request{
    [[[[UIAlertView alloc] initWithTitle:@"No connection" message:@"Something went wrong, please check your connectivity and try again" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Try again",nil] autorelease] show];
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"What's hot on storify.com";
        break;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [self.hotTopics count];
        break;
        default:
            
            break;
    }
    return 0;
}

-(void)topicsDownloaded:(ASIHTTPRequest*)r{

    NSString* response = [r responseString];
    response  = [response stringByReplacingOccurrencesOfString:@"\"totalHits\" : undefined" withString:@"\"totalHits\" : 0"];
    
    SBJsonParser* parser= [[SBJsonParser alloc] init];
    self.hotTopics =  [parser objectWithString:response]; 
    [parser release];
    [self.table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier=@"topic";
    UITableViewCell* cell=nil;
    switch (indexPath.section) {
        case 0:
            1+1;
            
            NSDictionary* topic = [self.hotTopics objectAtIndex:indexPath.row];            
            cell= [self.table dequeueReusableCellWithIdentifier:identifier];
            if (cell==nil){
                cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                CAGradientLayer *gradient = [CAGradientLayer layer];
                gradient.frame = cell.frame;
                CGColorRef lightLightGray = [[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1] CGColor];
                CGColorRef whiteColor =[[UIColor whiteColor] CGColor];
                gradient.colors = [NSArray arrayWithObjects:(id)lightLightGray,(id)whiteColor,(id)whiteColor,(id)lightLightGray , nil];
                [cell.backgroundView.layer insertSublayer:gradient atIndex:0];
            }
            cell.textLabel.text=[[topic objectForKey:@"name"] substringFromIndex:1];
            if ([topic objectForKey:@"stories"]==1){
                cell.detailTextLabel.text=[NSString stringWithFormat:@"1 story"];
            }else{
                cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ stories",[topic objectForKey:@"stories"]];
            }
        break;

        default:
        break;
    }
    return cell;
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    ASIHTTPRequest* copy = [self.request copy];
    self.request=copy;
    [copy release];
    [self.loadingHud showWhileExecuting:@selector(startSynchronous) onTarget:self.request withObject:nil animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            1+1;
            [self.table deselectRowAtIndexPath:indexPath animated:YES];
            NSString* name = [[self.hotTopics objectAtIndex:indexPath.row] objectForKey:@"name"];
            [[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"/HotTopics/%@",[name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] withError:nil];
            Search* search = [[[Search alloc] initWithNibName:@"Search" bundle:nil] autorelease];
            
            NSString* url = [NSString stringWithFormat:@"http://storify.com/topics/%@.json",[name substringFromIndex:1]];
            search.searchedString=url;
            search.title=[name substringFromIndex:1];
            [self.navigationController pushViewController:search animated:YES];
            break;
            
        default:
            break;
    }
}


- (void)viewDidUnload{
    [super viewDidUnload];
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) dealloc{
    self.request=nil;
    self.table=nil;
    self.hotTopics=nil;
    self.loadingHud=nil;
    [super dealloc];
}
@end
