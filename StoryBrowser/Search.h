//
//  Search.h
//  StoryBrowser
//
//  Created by Simon Watiau on 8/25/11.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
IBOutlet UITableView* table;
ASIHTTPRequest* request;
NSString* searchedString;
NSMutableDictionary* cancelBeforeReuse;
NSURL* defaultImage;
NSArray *stories;
@interface Search : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
    @property(nonatomic,retain) IBOutlet UITableView* table;
    @property(nonatomic,retain) NSArray* stories;
    @property(nonatomic,retain) ASIHTTPRequest* request;
    @property(nonatomic,retain) NSString* searchedString;
    @property(nonatomic,retain) NSURL* defaultImage;
    @property(nonatomic,retain) NSMutableDictionary* cancelBeforeReuse;
    +(ASINetworkQueue*)queue;

@end
