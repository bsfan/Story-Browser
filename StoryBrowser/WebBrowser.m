//
//  WebBrowser.m
//  StoryBrowser
//
//  Created by Simon Watiau on 9/28/11.
//

#import "WebBrowser.h"
#import "SHK.h"
@implementation WebBrowser
@synthesize toolbar, webView, backButton, forwardButton, refreshButton, stopButton, currentUrl, pageTitle;
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
    self.pageTitle=@"";
    UIActivityIndicatorView* spinner =
    [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
    [spinner startAnimating];
    UIBarButtonItem* spinnerButton = [[UIBarButtonItem alloc] initWithCustomView:spinner];

    self.navigationItem.rightBarButtonItem = spinnerButton;

    self.backButton =[[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backIcon.png"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(backAction)] autorelease];
    self.backButton.enabled = NO;
    self.forwardButton =
    [[UIBarButtonItem alloc] initWithImage:
     [UIImage imageNamed:@"forwardIcon.png"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(forwardAction)];
    
    self.forwardButton.enabled = NO;
    self.refreshButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                      UIBarButtonSystemItemRefresh target:self action:@selector(refreshAction)] autorelease];

    self.stopButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                   UIBarButtonSystemItemStop target:self action:@selector(stopAction)] autorelease];
    
    UIBarButtonItem* actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                     UIBarButtonSystemItemAction target:self action:@selector(shareAction)];
    
    UIBarItem* space = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                         UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    self.toolbar.items = [NSArray arrayWithObjects:
                      self.backButton,
                      space,
                      self.forwardButton,
                      space,
                      self.refreshButton,
                      space,
                      actionButton,
                      nil];
}


- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request
 navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)backAction {
    [self.webView goBack];
}

- (void)forwardAction {
    [self.webView goForward];
}

- (void)refreshAction {
    [self.webView reload];
}

- (void)stopAction {
    [self.webView stopLoading];
}

- (void)shareAction {
    SHKItem *item = [SHKItem URL:self.currentUrl title:self.pageTitle];
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)webViewDidStartLoad:(UIWebView*)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSMutableArray* items = [NSMutableArray arrayWithArray:self.toolbar.items];
    [items replaceObjectAtIndex:4 withObject:self.stopButton];
    self.toolbar.items = items;
    self.backButton.enabled = [self.webView canGoBack];
    self.forwardButton.enabled = [self.webView canGoForward];
}

- (void)webViewDidFinishLoad:(UIWebView*)webView {
   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSMutableArray* items = [NSMutableArray arrayWithArray:self.toolbar.items];
    [items replaceObjectAtIndex:4 withObject:self.refreshButton];
    self.toolbar.items = items;
    self.pageTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.backButton.enabled = [self.webView canGoBack];
    self.forwardButton.enabled = [self.webView canGoForward];
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
    [self webViewDidFinishLoad:self.webView];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // e.g. self.myOutlet = nil;
}

-(void) dealloc{
    self.toolbar=nil;
    self.webView=nil;
    self.backButton=nil;
    self.forwardButton=nil;
    self.refreshButton=nil;
    self.stopButton=nil;
    self.currentUrl=nil;
    self.pageTitle=nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
