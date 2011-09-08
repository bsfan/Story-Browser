//
//  TweetViews.h
//  StoryBrowser
//
//


#import "BaseElementViews.h"
#import <UIKit/UIKit.h>
#import "Three20/Three20.h"
#import "ASIHTTPRequest.h"
UIImageView* avatar;
TTStyledTextLabel* text;
ASIHTTPRequest* req;
@interface TweetViews : BaseElementViews
@property(nonatomic,retain) UIImageView* avatar;
@property(nonatomic,retain) ASIHTTPRequest* req;
@property(nonatomic,retain) TTStyledTextLabel* text;
@end
