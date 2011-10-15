//
//  ShowElement.m
//  StoryBrowser
//
//  Created by Simon Watiau on 9/6/11.
//

#import "ShowElement.h"
#import "TweetViews.h"
#import "SHK.h"
@implementation ShowElement
@synthesize titleView,scrollView,story,elementViews,contentView,currentIndex;
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
    self.navigationItem.titleView = [[[UIView alloc] init] autorelease];
    
    NSDictionary* currentElement = [[self.story objectForKey:@"elements"] objectForKey:[NSString stringWithFormat:@"%d",self.currentIndex]];
    NSString* type = [currentElement objectForKey:@"elementClass"];
    if ([type isEqualToString:@"tweet"]){
        self.elementViews=[[[TweetViews alloc] init]autorelease];
        self.title=@"Tweet";
    }else {
        self.elementViews=[[[BaseElementViews alloc] init] autorelease];
    }
    
    [self.elementViews loadElement:currentElement];
    UIView* tView = [self.elementViews titleView];
    UIView* cView = [self.elementViews contentView];
    self.titleView.frame=CGRectMake(0, 0, 320,tView.frame.size.height+12);
    [self.view addSubview:tView];


    self.contentView.frame=CGRectMake(0, self.titleView.frame.size.height, 320,cView.frame.size.height);
    [self.contentView addSubview:cView];
    
    self.scrollView.contentSize=CGSizeMake(320, self.titleView.frame.size.height+self.contentView.frame.size.height);
    
    UIView* footer = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.frame.origin.y+self.contentView.frame.size.height, 320, 600)] ;
    footer.backgroundColor=[UIColor whiteColor];
    [self.scrollView addSubview:footer];
    [footer release];
    [self.view bringSubviewToFront:self.scrollView];
    UIBarButtonItem* actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActions:)];
    self.navigationItem.rightBarButtonItem=actionButton;
    [actionButton release];

}



-(void)showActions:(id)sender{
    NSDictionary* currentElement = [[self.story objectForKey:@"elements"] objectForKey:[NSString stringWithFormat:@"%d",self.currentIndex]];
    
	SHKItem *item = [SHKItem URL:[NSURL URLWithString:[currentElement objectForKey:@"permalink"]] title:@""];
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.elementViews scroll];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

-(void)dealloc{
    self.scrollView=nil; 
    self.titleView=nil;
    self.story=nil;
    self.elementViews=nil;
    self.contentView=nil;
    [super dealloc];
}
-(void) loadElementWithIndex:(NSString*) index from:(NSDictionary*)s{
    self.story= s;
    self.currentIndex=[index intValue];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.elementViews cancel];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
