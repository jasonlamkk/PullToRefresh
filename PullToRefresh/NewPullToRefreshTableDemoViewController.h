//
//  NewPullToRefreshTableDemoViewController.h
//  NewsImageTables
//
//  Created by Jason Lam on 12年5月11日.
//  Copyright (c) 2012年 WaveSpread Technology Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshTableView.h"

@interface NewPullToRefreshTableDemoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PullToRefreshViewLoaderDelegate>
{
    IBOutlet PullToRefreshTableView * theTable;
    NSMutableArray *items;
}

@end
