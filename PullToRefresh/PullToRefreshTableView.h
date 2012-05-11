//
//  PullToRefreshTableView.h
//  NewsImageTables
//
//  Created by Jason Lam on 12年5月11日.
//  Copyright (c) 2012年 WaveSpread Technology Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefresh.h"


@interface PullToRefreshTableView : UITableView<PullToRefresh,UIScrollViewDelegate,UITableViewDelegate>
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
    
    id<UITableViewDelegate> __externalDelegate;
}
@end