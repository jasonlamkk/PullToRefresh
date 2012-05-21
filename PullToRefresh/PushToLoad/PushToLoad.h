//
//  PushToLoad.h
//  PullToRefresh
//
//  Created by Jason Lam on 12年5月21日.
//  Copyright (c) 2012年 WaveSpread Technology Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_LOADING_FOOTER_HEIGHT 52.0f
@protocol PushToLoad;

@protocol PushToLoadViewLoaderDelegate <NSObject>
-(void) loadLatestDataFor:(id<PushToLoad>) object;
@end

@protocol PushToLoad <NSObject>

@property(nonatomic) CGFloat LoadingFooterHeight;

@property(nonatomic,assign) IBOutlet id<PushToLoadViewLoaderDelegate> footerDataLoader;

- (void) reload;

- (void) startPushLoading;

- (void) stopPushLoading;

- (void) addPushToLoadFooter;

- (void) setupStrings;

@end
