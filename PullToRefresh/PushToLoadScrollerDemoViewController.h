//
//  PushToLoadScrollerDemoViewController.h
//  PullToRefresh
//
//  Created by Jason Lam on 12年5月21日.
//  Copyright (c) 2012年 WaveSpread Technology Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PushToLoadScrollerView.h"

@interface PushToLoadScrollerDemoViewController : UIViewController<PushToLoadViewLoaderDelegate>
{
    IBOutlet PushToLoadScrollerView * pScrollView;
    
    IBOutlet UILabel * lblLastClock;
}
@end
