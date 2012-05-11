//
//  PullToRefreshDemoViewController.m
//  NewsImageTables
//
//  Created by Jason Lam on 12年5月11日.
//  Copyright (c) 2012年 WaveSpread Technology Limited. All rights reserved.
//

#import "PullToRefreshDemoViewController.h"

@interface PullToRefreshDemoViewController ()

@end

@implementation PullToRefreshDemoViewController

-(void) loadLatestDataFor:(id<PullToRefresh>)object{
    [self performSelector:@selector(updateItem) withObject:nil afterDelay:2.0];
}
//remove this, call stopLoading when data ready , it means "loadingCompleted" 
- (void)updateItem {
    // Add a new time
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *now = [dateFormatter stringFromDate:[NSDate date]];
    lblLastClock.text = now;
    
    [pScrollView stopLoading];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"Scroller";
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [pScrollView setContentSize:CGSizeMake(1, 1000)]
    ;
    [pScrollView addPullToRefreshHeader];
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
