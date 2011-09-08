//
//  ShowElement.m
//  StoryBrowser
//
//  Created by Simon Watiau on 9/6/11.
//

#import "ShowElement.h"
#import "TweetViews.h"
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
    UIView* noisyBackground = [[UIView alloc]initWithFrame:CGRectMake(0, -2000, 320, 2250)];
    noisyBackground.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"noise.png"]];
    
    noisyBackground.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    [self.titleView insertSubview:noisyBackground atIndex:0];
    [noisyBackground release];
    self.titleView.backgroundColor=[UIColor clearColor];
    
    NSDictionary* currentElement = [[self.story objectForKey:@"elements"] objectForKey:[NSString stringWithFormat:@"%d",self.currentIndex]];
    NSString* type = [currentElement objectForKey:@"elementClass"];
    if ([type isEqualToString:@"tweet"]){
        self.elementViews=[[[TweetViews alloc] init]autorelease];
    }else {
        self.elementViews=[[[BaseElementViews alloc] init] autorelease];
    }
    
    [self.elementViews loadElement:currentElement];
    UIView* tView = [self.elementViews titleView];
    UIView* cView = [self.elementViews contentView];
    self.titleView.frame=CGRectMake(0, 0, 320,tView.frame.size.height+12);
    [self.titleView addSubview:tView];
    self.contentView.frame=CGRectMake(0, self.titleView.frame.size.height, 320,cView.frame.size.height);
    [self.contentView addSubview:cView];
    
    self.scrollView.contentSize=CGSizeMake(320, self.titleView.frame.size.height+self.contentView.frame.size.height);

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.elementViews scroll];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

-(IBAction) openPermalink{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open as web page",@"Open in Safari",nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString* link = [[[self.story objectForKey:@"elements"] objectForKey:[NSString stringWithFormat:@"%d",currentIndex]] objectForKey:@"permalink"];

    switch (buttonIndex) {
        case 0:
            NSLog(@"bug");            
            TTWebController* ctr = [[[TTWebController alloc] init] autorelease];
            [ctr openURL:[NSURL URLWithString:link]];
            ctr.hidesBottomBarWhenPushed=NO;
            [self.navigationController pushViewController:ctr animated:YES];
            break;
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
            break;
            
        default:
            break;
    }
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
