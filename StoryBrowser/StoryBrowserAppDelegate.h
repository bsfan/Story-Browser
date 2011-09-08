//
//  StoryBrowserAppDelegate.h
//  StoryBrowser
//
//  Created by Simon Watiau on 8/25/11.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"
@interface StoryBrowserAppDelegate : NSObject <UIApplicationDelegate,TTNavigatorDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
