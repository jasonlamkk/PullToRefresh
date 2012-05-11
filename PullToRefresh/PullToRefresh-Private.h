//
//  PullToRefresh-Private.h
//  NewsImageTables
//
//  Created by Jason Lam on 12年5月11日.
//  Copyright (c) 2012年 WaveSpread Technology Limited. All rights reserved.
//

#import "PullToRefresh.h"
#import "PullToRefreshScrollerView.h"
#import "PullToRefreshTableView.h"

@interface PullToRefreshScrollerView (PrivateObjects) <PullToRefresh>

- (void)startLoading;
@end

@interface PullToRefreshTableView (PrivateObjects) <PullToRefresh>
- (void)startLoading;
@end