//
//  PushToLoadTableDemoViewController.h
//  PullToRefresh
//
//  Created by Jason Lam on 12年5月21日.
//  Copyright (c) 2012年 WaveSpread Technology Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PushToloadTableView.h"

@interface PushToLoadTableDemoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PushToLoadViewLoaderDelegate>
{
    IBOutlet PushToLoadTableView * theTable;
    NSMutableArray *items;

}

@end
