//
//  PullToRefreshScrollerView.h
//  NewsImageTables
//
//  Created by Jason Lam on 12年5月11日.
//  Copyright (c) 2012年 WaveSpread Technology Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefresh.h"

@interface PullToRefreshScrollerView : UIScrollView<PullToRefresh,UIScrollViewDelegate>
{
    
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    
    
    BOOL isDragging;
    BOOL isLoading;
    

    id<UIScrollViewDelegate> __externalDelegate;
    //id<UIScrollViewDelegate> _delegate;
}

@end
