//
//  PushToLoadScrollerView.m
//  PullToRefresh
//
//  Created by Jason Lam on 12年5月21日.
//  Copyright (c) 2012年 WaveSpread Technology Limited. All rights reserved.
//

#import "PushToLoadScrollerView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PushToLoadScrollerView

@synthesize LoadingFooterHeight;
@synthesize footerDataLoader;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupStrings{
    textPush = [[NSString alloc] initWithString:NSLocalizedString(@"PushUpToRefresh", @"Push up to refresh...")];
    textRelease = [[NSString alloc] initWithString:NSLocalizedString(@"ReleaseToRefresh", @"Release to refresh...")];
    textLoading = [[NSString alloc] initWithString:NSLocalizedString(@"RefreshLoading", @"Loading...")];
}

//override
-(void) setContentSize:(CGSize)contentSize{
    [super setContentSize:contentSize];
    loadingFooterView.frame = CGRectMake(0, contentSize.height, self.frame.size.width, LoadingFooterHeight);
    //refreshLabel.frame = CGRectMake(0, contentSize.height, self.frame.size.width, LoadingFooterHeight);
}
- (void) addPushToLoadFooter{
    if (0==LoadingFooterHeight) {
        LoadingFooterHeight = DEFAULT_LOADING_FOOTER_HEIGHT;
    }
    loadingFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, LoadingFooterHeight)];
    
    loadingFooterView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, loadingFooterView.frame.size.width, loadingFooterView.frame.size.height)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pullToRefreshArrow.png"]];
    refreshArrow.transform = CGAffineTransformMakeScale(1, -1);
    refreshArrow.frame = CGRectMake(floorf((LoadingFooterHeight - 27.f) / 2.f),
                                    (floorf(LoadingFooterHeight - 44.f) / 2.f),
                                    27, 44);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    refreshSpinner.color = [UIColor orangeColor];
    refreshSpinner.frame = CGRectMake(floorf(floorf(LoadingFooterHeight - refreshSpinner.frame.size.width) / 2.f), floorf((LoadingFooterHeight - refreshSpinner.frame.size.height) / 2.f), refreshSpinner.frame.size.width, refreshSpinner.frame.size.height);
    refreshSpinner.hidesWhenStopped = YES;
    
    [loadingFooterView addSubview:refreshLabel];
    [loadingFooterView addSubview:refreshArrow];
    [loadingFooterView addSubview:refreshSpinner];
    [self addSubview:loadingFooterView];
}
/*
-(void) setFrame:(CGRect)frame{
    [super setFrame:frame];
    refreshHeaderView.frame = CGRectMake(0, 0 - RefreshHeaderHeight, 320, RefreshHeaderHeight);
}*/

#pragma mark - delegate handling
-(void) setDelegate:(id<UIScrollViewDelegate>)delegate{
    __externalDelegate = delegate;
    super.delegate = self;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_2){
    // any zoom scale changes
    if(__externalDelegate && [__externalDelegate respondsToSelector:@selector(scrollViewDidZoom:)]){
        [__externalDelegate scrollViewDidZoom:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0){
    // called on finger up if the user dragged. velocity is in points/second. targetContentOffset may be changed to adjust where the scroll view comes to rest. not called when pagingEnabled is YES
    if(__externalDelegate && [__externalDelegate respondsToSelector:@selector(scrollViewDidZoom:)]){
        [__externalDelegate scrollViewDidZoom:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // called when scroll view grinds to a halt
    if(__externalDelegate && [__externalDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]){
        [__externalDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
    if (__externalDelegate && [__externalDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [__externalDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    // return a view that will be scaled. if delegate returns nil, nothing happens
    if (__externalDelegate && [__externalDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
        return [__externalDelegate viewForZoomingInScrollView:scrollView];
    }
    return nil;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_2){
    // called before the scroll view begins zooming its content
    if (__externalDelegate && [__externalDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]){
        [__externalDelegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{
    // scale between minimum and maximum. called after any 'bounce' animations
    if (__externalDelegate && [__externalDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [__externalDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    // return a yes if you want to scroll to the top. if not defined, assumes YES
    if (__externalDelegate && [__externalDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [__externalDelegate scrollViewShouldScrollToTop:scrollView];
    }
    return YES;
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    // called when scrolling animation finished. may be called immediately if already at top
    if (__externalDelegate && [__externalDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        return [__externalDelegate scrollViewDidScrollToTop:scrollView];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // called on finger up as we are moving
    if (isLoading) return;
    isDragging = YES;
    
    // called on start of dragging (may require some time and or distance to move)
    if(__externalDelegate && [__externalDelegate respondsToSelector:@selector(scrollViewDidZoom:)]){
        [__externalDelegate scrollViewDidZoom:scrollView];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // any offset changes
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y+scrollView.frame.size.height < scrollView.contentSize.height)
            self.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y+scrollView.frame.size.height > LoadingFooterHeight+self.contentSize.height)
            self.contentInset = UIEdgeInsetsMake(0, 0, LoadingFooterHeight, 0);
    } else if (isDragging && scrollView.contentOffset.y+scrollView.frame.size.height > self.contentSize.height) {
        
        NSLog(@"scrollViewDidScroll:\r\n\
              %f>%f",scrollView.contentOffset.y,LoadingFooterHeight+self.contentSize.height);
    
        
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y+scrollView.frame.size.height > LoadingFooterHeight+self.contentSize.height) {
            // User is scrolling above the header
            refreshLabel.text = textRelease;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        } else { // User is scrolling somewhere within the header
            refreshLabel.text = textPush;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
    
}


// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y+scrollView.frame.size.height >= LoadingFooterHeight+self.contentSize.height) {
        // Released above the header
        [self startPushLoading];
    }
    
    if(__externalDelegate && [__externalDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]){
        [__externalDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    
    
}


- (void) startPushLoading{
    isLoading = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentInset = UIEdgeInsetsMake(0, 0, LoadingFooterHeight, 0);
        refreshLabel.text = textLoading;
        refreshArrow.hidden = YES;
        [refreshSpinner startAnimating];
    }];
    // Refresh action!
    [self reload];
}

- (void) stopPushLoading {
    isLoading = NO;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentInset = UIEdgeInsetsZero;
        UIEdgeInsets tableContentInset = self.contentInset;
        tableContentInset.top = 0.0;
        self.contentInset = tableContentInset;
        [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);//CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    } completion:^(BOOL finished) {
        refreshLabel.text = textPush;
        refreshArrow.hidden = NO;
        [refreshSpinner stopAnimating];
    }];
    
}

- (void)reload {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    //[self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
    if (self.footerDataLoader && [self.footerDataLoader respondsToSelector:@selector(loadLatestDataFor:)]) {
        [self.footerDataLoader loadLatestDataFor:self];
    }
}

- (void)dealloc {
    [loadingFooterView release];
    [refreshLabel release];
    [refreshArrow release];
    [refreshSpinner release];
    [textPush release];
    [textRelease release];
    [textLoading release];
    [super dealloc];
}


@end