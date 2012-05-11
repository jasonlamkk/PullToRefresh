//
//  PullToRefreshDemoViewController.h
//  NewsImageTables
//
//  Created by Jason Lam on 12年5月11日.
//  Copyright (c) 2012年 WaveSpread Technology Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshScrollerView.h"


@interface PullToRefreshDemoViewController : UIViewController<PullToRefreshViewLoaderDelegate,UIScrollViewDelegate>
{
    IBOutlet PullToRefreshScrollerView * pScrollView;
    
    IBOutlet UILabel * lblLastClock;
}
@end
