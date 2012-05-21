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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
