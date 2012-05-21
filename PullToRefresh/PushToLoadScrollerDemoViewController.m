//
//  PushToLoadScrollerDemoViewController.m
//  PullToRefresh
//
//  Created by Jason Lam on 12年5月21日.
//  Copyright (c) 2012年 WaveSpread Technology Limited. All rights reserved.
//

#import "PushToLoadScrollerDemoViewController.h"

@interface PushToLoadScrollerDemoViewController ()

@end

@implementation PushToLoadScrollerDemoViewController

-(void) loadLatestDataFor:(id<PushToLoad>)object{
    [self performSelector:@selector(updateItem) withObject:nil afterDelay:2.0];
}
//remove this, call stopLoading when data ready , it means "loadingCompleted" 
- (void)updateItem {
    // Add a new time
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *now = [dateFormatter stringFromDate:[NSDate date]];
    lblLastClock.text = now;
    
    [pScrollView stopPushLoading];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Push Scroller";
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [pScrollView setupStrings];
    [pScrollView addPushToLoadFooter];
    [pScrollView setContentSize:CGSizeMake(1, 600)];
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
