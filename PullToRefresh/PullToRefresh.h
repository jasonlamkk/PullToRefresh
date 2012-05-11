//
//  PullToRefresh.h
//  NewsImageTables
//
//  Created by Jason Lam on 12年5月11日.
//  Copyright (c) 2012年 WaveSpread Technology Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_REFRESH_HEADER_HEIGHT 52.0f

@protocol PullToRefresh;

@protocol PullToRefreshViewLoaderDelegate <NSObject>
-(void) loadLatestDataFor:(id<PullToRefresh>) object;
@end

@protocol PullToRefresh <NSObject>

@property(nonatomic) CGFloat RefreshHeaderHeight;

@property(nonatomic,assign) IBOutlet id<PullToRefreshViewLoaderDelegate> dataLoader;

- (void) refresh;

- (void) stopLoading;

- (void)addPullToRefreshHeader;
@end

