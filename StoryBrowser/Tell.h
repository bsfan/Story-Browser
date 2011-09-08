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
IBOutlet UITableView* storyTable;
NSURL* permalink;
NSDictionary* story;
ASIHTTPRequest* req;
IBOutlet UIButton* totop;
NSAutoreleasePool* pool;
NSIndexPath* selectedRow;
int drainCountDown;
@interface Tell : UIViewController<UITableViewDataSource>
    @property(nonatomic,retain) IBOutlet UITableView* storyTable;
    @property(nonatomic,retain) NSURL* permalink;
    @property(nonatomic,retain) NSDictionary* story;
    @property(nonatomic,retain) ASIHTTPRequest* req;
    @property(nonatomic,retain) IBOutlet UIButton* totop;
    @property(nonatomic,retain) NSIndexPath* selectedRow;
    @property(nonatomic,assign) NSAutoreleasePool* pool;
    @property(nonatomic,assign) int drainCountDown;
    -(void) loadStory: (NSURL*)permalink;
    +(ASINetworkQueue*)netQueue;
    -(IBAction)scrollToTop:(id)sender;
@end


