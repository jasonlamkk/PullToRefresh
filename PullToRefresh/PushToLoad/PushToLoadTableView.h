//
//  PushToLoadTableView.h
//  PullToRefresh
//
//  Created by Jason Lam on 12年5月21日.
//  Copyright (c) 2012年 WaveSpread Technology Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PushToLoad.h"

@interface PushToLoadTableView : UITableView<PushToLoad,UITableViewDelegate>
{
    NSString *textPush;
    NSString *textRelease;
    NSString *textLoading;
    UIView *loadingFooterView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    
    BOOL isDragging;
    BOOL isLoading;
    
    id<UITableViewDelegate> __externalDelegate;
}


@end
