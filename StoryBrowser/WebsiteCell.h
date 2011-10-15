//
//  WebsiteCell.h
//  StoryBrowser
//
//  Created by Simon Watiau on 8/26/11.
//

#import <UIKit/UIKit.h>
#import "BaseElementCell.h"
#import "Three20/Three20.h"
#import "ASIHTTPRequest.h"

UILabel* title;
UILabel* websiteName;
UILabel* description;
ASIHTTPRequest* req;
@interface WebsiteCell : BaseElementCell
    @property(nonatomic,retain) UILabel* title;
    @property(nonatomic,retain) UILabel* websiteName;
    @property(nonatomic,retain) UILabel* description;
    @property(nonatomic,retain) ASIHTTPRequest* req;
@end
