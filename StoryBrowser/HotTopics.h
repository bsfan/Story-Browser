//
//  HotTopics.h
//  StoryBrowser
//
//  Created by Simon Watiau on 9/13/11.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import <MapKit/MapKit.h>
ASIHTTPRequest* request;
IBOutlet UITableView* table;
NSArray* hotTopics;
MBProgressHUD* loadingHud;
NSMutableDictionary* topStories;
@interface HotTopics : UIViewController<UITableViewDelegate,UITableViewDataSource>
    @property(nonatomic,retain) ASIHTTPRequest* request;
    @property(nonatomic,retain) IBOutlet UITableView* table;
    @property(nonatomic,retain) NSArray* hotTopics;
    @property(nonatomic,retain) NSMutableDictionary* topStories;
    @property(nonatomic,retain) MBProgressHUD* loadingHud;
@end
