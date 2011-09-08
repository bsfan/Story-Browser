//
//  ShowElement.h
//  StoryBrowser
//
//  Created by Simon Watiau on 9/6/11.
//

#import <UIKit/UIKit.h>
#import "BaseElementViews.h"
IBOutlet UIScrollView* scrollView; 
IBOutlet UIView* titleView;
NSDictionary* story;
int currentIndex;
BaseElementViews* elementViews;
UIView* IBOutlet contentView;
@interface ShowElement : UIViewController<UIActionSheetDelegate>
    @property (nonatomic,retain) IBOutlet UIScrollView* scrollView;
    @property (nonatomic,retain) IBOutlet UIView* titleView;
    @property (nonatomic,retain) NSDictionary* story;
    @property (nonatomic,assign) int currentIndex;
    @property (nonatomic,retain) BaseElementViews* elementViews;
    @property (nonatomic,retain) IBOutlet UIView* contentView;
-(void) loadElementWithIndex:(NSString*) index from:(NSDictionary*)story;
-(IBAction) openPermalink;
@end
