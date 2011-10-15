//
//  Newspapers.h
//  StoryBrowser
//
//  Created by Simon Watiau on 9/14/11.
//

#import <UIKit/UIKit.h>
IBOutlet UITableView* table;
NSArray* newspapers;
@interface Newspapers : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain) IBOutlet UITableView* table;
@property(nonatomic,retain) NSArray* newspapers;
-(IBAction)paf:(id)sender;
@end
