//
//  Tell.h
//  StoryBrowser
//
//  Created by Simon Watiau on 8/25/11.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "GADBannerView.h"
#import "MBProgressHUD.h"
IBOutlet UITableView* storyTable;
NSURL* permalink;
NSDictionary* story;
ASIHTTPRequest* req;
NSIndexPath* selectedRow;
MBProgressHUD* loadingHud;
@interface Tell : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
    @property(nonatomic,retain) IBOutlet UITableView* storyTable;
    @property(nonatomic,retain) NSURL* permalink;
    @property(nonatomic,retain) NSDictionary* story;
    @property(nonatomic,retain) ASIHTTPRequest* req;
    @property(nonatomic,retain) NSIndexPath* selectedRow;
    @property(nonatomic,retain) MBProgressHUD* loadingHud;
    -(void) loadStory: (NSURL*)permalink;
    -(IBAction)scrollToTop:(id)sender;
@end


