//
//  VideoCell.h
//  StoryBrowser
//
//  Created by Simon Watiau on 9/7/11.
//

#import "BaseElementCell.h"
#import "ASIHTTPRequest.h"
UIImageView* preview;
UILabel* videoTitle;
UILabel* videoDescription;
ASIHTTPRequest* req;
@interface VideoCell : BaseElementCell
@property(nonatomic,retain) UIImageView* preview;
@property(nonatomic,retain) UILabel* videoTitle;
@property(nonatomic,retain) UILabel* videoDescription;
@property(nonatomic,retain) ASIHTTPRequest* req;
@end
