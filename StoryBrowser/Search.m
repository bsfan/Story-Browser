//
//  Search.m
//  StoryBrowser
//
//  Created by Simon Watiau on 8/25/11.
//

#import "Search.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "Tell.h"
#import "ASIDownloadCache.h"
#import "RegexKitLite.h"
#import <Foundation/Foundation.h>
#import "SearchLine.h"
@implementation Search

@synthesize resultsTable, searchBar, stories, avatarDLqueue, topicsReq, searchReq, logo, topicsScrollView, topicsView,cancelBeforeReuse,firstSearch;


-(id)init{
    self = [super init];
    if (self){
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload{
    
    if(self.searchReq!=nil){
        [self.searchReq clearDelegatesAndCancel];
        [self.searchReq cancel];
        self.searchReq=nil;
    }
    
    if(self.topicsReq!=nil){
        [self.topicsReq clearDelegatesAndCancel];
        [self.topicsReq cancel];
        self.topicsReq=nil;
    }
    
    [self.avatarDLqueue cancelAllOperations];
    self.avatarDLqueue = nil;
    self.logo=nil;
    self.resultsTable=nil;
    self.searchBar=nil;
    self.stories=nil;
    self.avatarDLqueue=nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if(self.searchBar.frame.origin.x!=0){
        [UIView animateWithDuration:0.3f animations:^{
            self.logo.alpha=0;
            self.searchBar.tintColor=[UIColor lightGrayColor];
            self.searchBar.frame=CGRectMake(0, 0,305, self. searchBar.frame.size.height);
            [self.searchBar layoutSubviews];
        }];
    }
    
    return true;
}

- (void)search{
    NSString* searchString = [self.searchBar.text lowercaseString];
    if ([searchString hasPrefix:@"#"]){
        searchString =[searchString substringFromIndex:1];
    }
    
    searchString=[searchString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    if ([searchString isEqualToString:@""]){
        searchString=@"storify";
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://storify.com/topics/%@.json",searchString]];
    self.searchReq = [ASIHTTPRequest requestWithURL:url];
    [self.searchReq setDelegate:self];
    [self.searchReq setDidFinishSelector:@selector(searchDone:)];
    [self.searchReq setDidFailSelector:@selector(searchFailed:)];
    [self.searchReq startAsynchronous];
}

-(void)restoreSearchBar{
    [self.searchBar resignFirstResponder];
    if (self.searchBar.frame.origin.x!=110){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.30];
        self.logo.alpha=1;
        self.searchBar.frame=CGRectMake(110, 0, 270, self.searchBar.frame.size.height);
        [self.searchBar layoutSubviews];
        [UIView commitAnimations];
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self search];
    [self restoreSearchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self restoreSearchBar];
}


-(void)refreshTopics:(id) sender{
    if (self.topicsReq!=nil){
        [self.topicsReq clearDelegatesAndCancel];
        [self.topicsReq cancel];
    }
    
    NSURL *url = [NSURL URLWithString:@"http://storify.com/stats/top/topics.json"];
    self.topicsReq = [ASIHTTPRequest requestWithURL:url];
    [self.topicsReq setDelegate:self];
    [self.topicsReq setDidFinishSelector:@selector(topicsDownloaded:)];    
    [self.topicsReq setDidFailSelector:@selector(topicsDownloadFailed:)];    
    [self.topicsReq startAsynchronous];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    firstSearch=true;
    self.avatarDLqueue = [[[ASINetworkQueue alloc] init] autorelease];
    [self.avatarDLqueue go];
    self.view.clipsToBounds=YES;
    self.navigationController.navigationBar.clipsToBounds=YES;
    self.topicsScrollView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"noise.png"]];
    self.title=@"Search";
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.logo = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 108, 43)] autorelease];
    self.logo.image=[UIImage imageNamed:@"logo.png"];
    self.logo.contentMode=UIViewContentModeScaleAspectFit;
    self.searchBar.frame=CGRectMake(110, 0, 280, 44);
    [contentView addSubview:self.logo];
    [contentView addSubview:self.searchBar];
    self.navigationItem.titleView=contentView;
    [contentView release];
    NSURL *url = [NSURL URLWithString:@"http://storify.com/stats/top/topics.json"];
    self.topicsReq = [ASIHTTPRequest requestWithURL:url];
    [self.topicsReq setDelegate:self];
    [self.topicsReq setDidFinishSelector:@selector(topicsDownloaded:)];    
    [self.topicsReq setDidFailSelector:@selector(topicsDownloadFailed:)];    
    [self.topicsReq startAsynchronous];
    /*
    self.topicsView.frame=CGRectMake(self.topicsView.frame.origin.x, self.topicsView.frame.origin.y-self.topicsView.frame.size.height, self.topicsView.frame.size.width, self.topicsView.frame.size.height);
    
    self.resultsTable.frame=CGRectMake(self.resultsTable.frame.origin.x, self.resultsTable.frame.origin.y-self.topicsView.frame.size.height, self.resultsTable.frame.size.width, self.resultsTable.frame.size.height+self.topicsView.frame.size.height);
    */
    
    UIView* container = [[UIView alloc] init];
    UIButton* refresh = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [refresh setImage:[UIImage imageNamed:@"UIButtonBarRefresh"] forState:UIControlStateNormal];
    refresh.clipsToBounds=YES;
    [refresh setTitleColor:[UIColor colorWithRed:0.50 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    [refresh setBackgroundImage:[UIImage imageNamed:@"noisy_bar_background.png"] forState:UIControlStateNormal];
    refresh.layer.cornerRadius=10;
    refresh.frame=CGRectMake(7, 7, 44, 44);
    [refresh addTarget:self action:@selector(refreshTopics:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:refresh];
    
    UILabel* label=[[UILabel alloc] init];
    label.text=@"Topics :";
    label.frame=CGRectMake(56, 4, 80, 50);
    label.backgroundColor=[UIColor clearColor];
    [container addSubview:label];
    [label release];
    container.frame=CGRectMake(0, 0, 320, 44);
    [self.topicsScrollView addSubview:container];
    [container release];
}

-(void) topicsDownloadFailed:(ASIHTTPRequest*)request{
    UIAlertView* alert  =[[[UIAlertView alloc] initWithTitle:@"No connection" message:@"Something went wrong, please check your connectivity and try again" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try again",nil] autorelease] ;
    alert.tag=1;
    [alert show];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1){
        if (actionSheet.tag==1){
            ASIHTTPRequest* copy = [self.topicsReq copy];
            self.topicsReq=copy;
            [copy release];
            [self.topicsReq startAsynchronous];
        }else{
            ASIHTTPRequest* copy = [self.searchReq copy];
            self.searchReq=copy;
            [copy release];
            [self.searchReq startAsynchronous];
        }
    }
}




-(void) topicsDownloaded:(ASIHTTPRequest*)request{
    NSString* response = [request responseString];
    response  = [response stringByReplacingOccurrencesOfString:@"\"totalHits\" : undefined" withString:@"\"totalHits\" : 0"];
    
    SBJsonParser* parser= [[SBJsonParser alloc] init];
    NSArray* tops =  [parser objectWithString:response]; 
    [parser release];
    
    int shouldStartAt=130;
    UIView* container = [[self.topicsScrollView subviews] objectAtIndex:0];
    NSArray* views = [container subviews];
    for (int i=2;i<[views count];i++){
        [[views objectAtIndex:i] removeFromSuperview];
    }
    
    for (NSDictionary* top in tops){
        NSString* name = [[top objectForKey:@"name"] substringFromIndex:1];
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:name forState:UIControlStateNormal];
        [button addTarget:self action:@selector(topicSelected:) forControlEvents:UIControlEventTouchUpInside];
        button.clipsToBounds=YES;
        CGSize buttonSize = [button sizeThatFits:CGSizeMake(70000, 44)];
        button.frame=CGRectMake(shouldStartAt, 7, buttonSize.width, 44);
        [button setTitleColor:[UIColor colorWithRed:0.50 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"noisy_bar_background.png"] forState:UIControlStateNormal];
        button.layer.cornerRadius=10;
        shouldStartAt+=buttonSize.width+10;
        button.alpha=0;
        [container addSubview:button];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.30];
        button.alpha=1;
        [UIView commitAnimations];
    }
    
    
    container.frame=CGRectMake(0, 0, shouldStartAt, 44);
    self.topicsScrollView.contentSize=container.frame.size;

    
    
    if (firstSearch){
        [self search];
    }
    /*
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.30];
    CGRect topicsViewNewSize =  self.topicsView.frame;
    topicsViewNewSize.origin.y= topicsViewNewSize.origin.y+topicsViewNewSize.size.height;
    self.topicsView.frame=topicsViewNewSize;
    CGRect newFrame = self.resultsTable.frame;
    newFrame.size.height=newFrame.size.height-self.topicsView.frame.size.height;
    newFrame.origin.y=newFrame.origin.y+self.topicsView.frame.size.height;
    self.resultsTable.frame=newFrame;
    [UIView commitAnimations];
     */
}

-(void)topicSelected:(id) sender{
    UIButton* button =(UIButton*) sender;
    self.searchBar.text=button.titleLabel.text;
    [self restoreSearchBar];
    [self search];
}

-(void)searchDone:(ASIHTTPRequest *)request{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.stories =  [[[[[SBJsonParser alloc] init] autorelease] objectWithString:[request responseString]] objectForKey:@"stories"];
    [self.resultsTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self.resultsTable reloadData];
    firstSearch=false;
    
}

-(void)searchFailed:(ASIHTTPRequest *)request{
    [[[[UIAlertView alloc] initWithTitle:@"No connection" message:@"Something went wrong, please check your connectivity and try again" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try again",nil] autorelease] show];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.stories==nil){
        return 0;
    }else{
        return [self.stories count];
    }
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* title = [[self.stories objectAtIndex:indexPath.row] objectForKey:@"title"];
    UILabel* txt = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 70000)];
    txt.lineBreakMode=UILineBreakModeWordWrap;
    txt.font=[UIFont fontWithName:@"TimesNewRomanPSMT" size:18];
    txt.numberOfLines=0;
    [txt setText:title];
    [txt sizeToFit];

    int height=  txt.frame.size.height+10;
    [txt release];
    if (height<55){
        height=55;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Tell* tell = [[[Tell alloc] initWithNibName:@"Tell" bundle:nil] autorelease];
    NSDictionary* story = [self.stories objectAtIndex:indexPath.row];
    NSString* permalink = [story objectForKey:@"permalink"];
    [tell loadStory:[NSURL URLWithString:permalink]];
    [self.resultsTable deselectRowAtIndexPath:indexPath animated:YES];
    if (self.searchReq!=nil){
        [self.searchReq clearDelegatesAndCancel];
        [self.searchReq cancel];
    }
    if (self.topicsReq!=nil){
        [self.topicsReq clearDelegatesAndCancel];
        [self.topicsReq cancel];
    }
    [avatarDLqueue cancelAllOperations];
    [self.navigationController pushViewController:tell animated:YES];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"searchLine";
    SearchLine *cell = (SearchLine *) [self.resultsTable dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil){
        cell = [[[SearchLine alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    NSDictionary* story =[self.stories objectAtIndex:indexPath.row];
    [cell loadLine:[NSURL URLWithString:[[story objectForKey:@"author"] objectForKey:@"avatar"]] title:[story objectForKey:@"title"] queue:self.avatarDLqueue];

    return cell;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.resultsTable reloadData];
    [super viewWillAppear:animated];
}
-(void) dealloc{
    self.resultsTable=nil;
    self.searchBar=nil;
    self.stories=nil;
    self.avatarDLqueue=nil;
    self.searchReq=nil;
    self.topicsReq=nil;
    self.logo=nil;
    self.topicsView=nil;
    self.topicsScrollView=nil;
    self.cancelBeforeReuse=nil;
    [super dealloc];
}

@end
