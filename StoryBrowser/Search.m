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
#import "GANTracker.h"
ASINetworkQueue* avatarDLqueue;
@implementation Search

@synthesize table, stories,cancelBeforeReuse,searchedString,request,defaultImage;

+(ASINetworkQueue*)queue{
    return avatarDLqueue;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        avatarDLqueue=[[ASINetworkQueue alloc] init];
        [avatarDLqueue go];
    }
    return self;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)search{
    NSString* searchString = [self.searchedString lowercaseString];
    if ([searchString hasPrefix:@"#"]){
        searchString =[searchString substringFromIndex:1];
    }
    
    searchString=[searchString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    if ([searchString isEqualToString:@""]){
        searchString=@"storify";
    }
    NSURL *url = [NSURL URLWithString:self.searchedString];
    self.request = [ASIHTTPRequest requestWithURL:url];
    [self.request setDelegate:self];
    [self.request setCachePolicy:ASIFallbackToCacheIfLoadFailsCachePolicy];
    [self.request setDidFinishSelector:@selector(searchDone:)];
    [self.request setDidFailSelector:@selector(searchFailed:)];
    [self.request startAsynchronous];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self search];

}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1){
            ASIHTTPRequest* copy = [self.request copy];
            self.request=copy;
            [copy release];
            [self.request startAsynchronous];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)searchDone:(ASIHTTPRequest *)request{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    self.stories =  [[[[[SBJsonParser alloc] init] autorelease] objectWithString:[request responseString]] objectForKey:@"stories"];
    if ([self.stories count]==0){
        self.table.hidden=TRUE;
    }else{
        self.table.hidden=FALSE;
    }
    [self.table scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self.table reloadData];
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
    [self.table deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary* story = [self.stories objectAtIndex:indexPath.row];
    NSString* permalink = [story objectForKey:@"permalink"];
    [tell loadStory:[NSURL URLWithString:permalink]];
    [self.table deselectRowAtIndexPath:indexPath animated:YES];
    [[GANTracker sharedTracker] trackPageview:permalink withError:nil];
    [self.navigationController pushViewController:tell animated:YES];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"searchLine";
    SearchLine *cell = (SearchLine *) [self.table dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil){
        cell = [[[SearchLine alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    NSDictionary* story =[self.stories objectAtIndex:indexPath.row];
    NSURL* url =nil;
    if (defaultImage!=nil){
        url = defaultImage;
    }else{
        url =[NSURL URLWithString:[[story objectForKey:@"author"]objectForKey:@"avatar"]]; 
    }
    [cell loadLine:url title:[story objectForKey:@"title"]];

    return cell;
}

-(void) dealloc{
    self.table=nil;
    self.stories=nil;
    if (self.request!=nil){
        [self.request clearDelegatesAndCancel];
        [self.request cancel];
        self.request=nil;
    }
    if (self.request!=nil){
        [self.request clearDelegatesAndCancel];
        [self.request cancel];
        self.request=nil;
    }
    [avatarDLqueue cancelAllOperations];
    [avatarDLqueue release];
    avatarDLqueue=nil;
    self.cancelBeforeReuse=nil;
    self.searchedString=nil;
    self.defaultImage=nil;
    [super dealloc];
}

@end
