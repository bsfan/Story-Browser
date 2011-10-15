//
//  FbPostCell.h
//  StoryBrowser
//
//  Created by Simon Watiau on 8/27/11.
//

#import "BaseElementCell.h"
#import "Three20/Three20.h"
#import "ASIHTTPRequest.h"
UIImageView* avatar;
UILabel* userName;
UILabel* postText;
UILabel *date;
ASIHTTPRequest* req;
NSDateFormatter* formatter;
NSTimer* delayRequest;
@interface FbPostCell : BaseElementCell
    @property(nonatomic,retain) UIImageView* avatar;
    @property(nonatomic,retain) UILabel* postText;
    @property(nonatomic,retain) UILabel* userName;
    @property(nonatomic,retain) UILabel *date;
    @property(nonatomic,retain) ASIHTTPRequest* req;
    @property(nonatomic,retain) NSDateFormatter* formatter;
    @property(nonatomic,retain) NSTimer* delayRequest;
@end
