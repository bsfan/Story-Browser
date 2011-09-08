//
//  Search.h
//  StoryBrowser
//
//  Created by Simon Watiau on 8/25/11.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
IBOutlet UITableView* resultsTable;
IBOutlet UISearchBar* searchBar;
ASIHTTPRequest* searchReq;
ASIHTTPRequest* topicsReq;
ASINetworkQueue* avatarDLqueue;
NSMutableDictionary* cancelBeforeReuse;
NSArray *stories;
UIImageView* logo;
IBOutlet UIScrollView* topicsScrollView;
IBOutlet UIView* topicsView;
BOOL firstSearch;
@interface Search : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
    @property(nonatomic,retain) IBOutlet UITableView* resultsTable;
    @property(nonatomic,retain) IBOutlet UISearchBar* searchBar;
    @property(nonatomic,retain) NSArray* stories;
    @property(nonatomic,retain) ASINetworkQueue* avatarDLqueue;
    @property(nonatomic,retain) ASIHTTPRequest* searchReq;
    @property(nonatomic,retain) ASIHTTPRequest* topicsReq;
    @property(nonatomic,retain) UIImageView* logo;
    @property(nonatomic,retain) IBOutlet UIView* topicsView;
    @property(nonatomic,retain) IBOutlet UIScrollView* topicsScrollView;
    @property(nonatomic,retain) NSMutableDictionary* cancelBeforeReuse;
    @property(nonatomic,assign) BOOL firstSearch;
@end
