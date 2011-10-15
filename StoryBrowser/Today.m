//
//  Today.m
//  StoryBrowser
//
//  Created by Simon Watiau on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Today.h"

@implementation Today

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Today";
    UIImageView* logo =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    logo.frame=CGRectMake(0, 0, [UIImage imageNamed:@"logo.png"].size.width+40, [UIImage imageNamed:@"logo.png"].size.height);
    logo.contentMode=UIViewContentModeCenter;
    self.navigationItem.titleView=logo;
    [logo release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
