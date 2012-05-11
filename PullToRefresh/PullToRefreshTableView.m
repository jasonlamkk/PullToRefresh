//
//  PullToRefreshTableView.m
//  NewsImageTables
//
//  Created by Jason Lam on 12年5月11日.
//  Copyright (c) 2012年 WaveSpread Technology Limited. All rights reserved.
//

#import "PullToRefreshTableView.h"
#import "PullToRefresh-Private.h"
#import <QuartzCore/QuartzCore.h>

@implementation PullToRefreshTableView

@synthesize RefreshHeaderHeight;
@synthesize dataLoader;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupStrings{
    textPull = [[NSString alloc] initWithString:NSLocalizedString(@"PullDownToRefresh", @"Pull down to refresh...")];
    textRelease = [[NSString alloc] initWithString:NSLocalizedString(@"ReleaseToRefresh", @"Release to refresh...")];
    textLoading = [[NSString alloc] initWithString:NSLocalizedString(@"RefreshLoading", @"Loading...")];
}

- (void)addPullToRefreshHeader {
    if (0==RefreshHeaderHeight) {
        RefreshHeaderHeight = DEFAULT_REFRESH_HEADER_HEIGHT;
    }
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - RefreshHeaderHeight, 320, RefreshHeaderHeight)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, RefreshHeaderHeight)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pullToRefreshArrow.png"]];
    refreshArrow.frame = CGRectMake(floorf((RefreshHeaderHeight - 27.f) / 2.f),
                                    (floorf(RefreshHeaderHeight - 44.f) / 2.f),
                                    27, 44);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    refreshSpinner.color = [UIColor orangeColor];
    refreshSpinner.frame = CGRectMake(floorf(floorf(RefreshHeaderHeight - refreshSpinner.frame.size.width) / 2.f), floorf((RefreshHeaderHeight - refreshSpinner.frame.size.height) / 2.f), refreshSpinner.frame.size.width, refreshSpinner.frame.size.height);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [self addSubview:refreshHeaderView];
}

-(void) setFrame:(CGRect)frame{
    [super setFrame:frame];
    refreshHeaderView.frame = CGRectMake(0, 0 - RefreshHeaderHeight, 320, RefreshHeaderHeight);
}

#pragma mark - delegate handling
-(void) setDelegate:(id<UITableViewDelegate>)delegate{
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
        if (scrollView.contentOffset.y > 0)
            self.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -RefreshHeaderHeight)
            self.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -RefreshHeaderHeight) {
            // User is scrolling above the header
            refreshLabel.text = textRelease;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else { // User is scrolling somewhere within the header
            refreshLabel.text = textPull;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
    
}


// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -RefreshHeaderHeight) {
        // Released above the header
        [self startLoading];
    }
    
    if(__externalDelegate && [__externalDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]){
        [__externalDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    
    
}
#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (__externalDelegate && [__externalDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [__externalDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return self.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (__externalDelegate && [__externalDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        return [__externalDelegate tableView:tableView heightForHeaderInSection:section];
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)] 
        && [self.dataSource tableView:tableView titleForHeaderInSection:section]) {
        return self.sectionHeaderHeight;
    }
    return 0.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (__externalDelegate && [__externalDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
        return [__externalDelegate tableView:tableView heightForFooterInSection:section];
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(tableView:titleForFooterInSection:)] 
        && [self.dataSource tableView:tableView titleForFooterInSection:section]) {
        return self.sectionFooterHeight;
    }
    return 0.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section  // custom view for header. will be adjusted to default or specified header height
{
    if (__externalDelegate && [__externalDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return [__externalDelegate tableView:tableView viewForHeaderInSection:section];
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section   // custom view for footer. will be adjusted to default or specified footer height
{
    
    if (__externalDelegate && [__externalDelegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        return [__externalDelegate tableView:tableView viewForFooterInSection:section];
    }
    return nil;
}

// Accessories (disclosures). 

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_NA,__MAC_NA,__IPHONE_2_0,__IPHONE_3_0){
    if(__externalDelegate && [__externalDelegate respondsToSelector:@selector(tableView:accessoryTypeForRowWithIndexPath:)]){
        return [__externalDelegate tableView:tableView accessoryTypeForRowWithIndexPath:indexPath];
    }
    return [self cellForRowAtIndexPath:indexPath].accessoryType;
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    if (__externalDelegate && [__externalDelegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)]) {
        [__externalDelegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (__externalDelegate && [__externalDelegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
        return [__externalDelegate tableView:tableView willSelectRowAtIndexPath:indexPath];
    }
    return indexPath;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0){
    if (__externalDelegate && [__externalDelegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)]) {
        return [__externalDelegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
    }
    return indexPath;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (__externalDelegate && [__externalDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [__externalDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0){
    
    if (__externalDelegate && [__externalDelegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]) {
        [__externalDelegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
    }
    
}

// Editing

// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (__externalDelegate && [__externalDelegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]) {
        return [__externalDelegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }
    return [self cellForRowAtIndexPath:indexPath].editingStyle;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0){
    
    if (__externalDelegate && [__externalDelegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)]) {
        return [__externalDelegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    }
    return nil;
}

// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (__externalDelegate && [__externalDelegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)]) {
        return [__externalDelegate tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
    }
    return YES;
    
}

// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (__externalDelegate && [__externalDelegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)]) {
        [__externalDelegate tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
    }
}
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (__externalDelegate && [__externalDelegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)]) {
        [__externalDelegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
    }
    
}

// Moving/reordering

// Allows customization of the target row for a particular row as it is being moved/reordered
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    
    if (__externalDelegate && [__externalDelegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)]) {
        return [__externalDelegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
    }
    return proposedDestinationIndexPath;
}

// Indentation

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath // return 'depth' of row for hierarchies
{
    
    if (__externalDelegate && [__externalDelegate respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)]) {
        return [__externalDelegate tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
    return 0;
    
}

// Copy/Paste.  All three methods must be implemented by the delegate.

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0){
    
    if (__externalDelegate && [__externalDelegate respondsToSelector:@selector(tableView:shouldShowMenuForRowAtIndexPath:)]) {
        return [__externalDelegate tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath];
    }
    return NO;
    
}
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0){
    
    if (__externalDelegate && [__externalDelegate respondsToSelector:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:)]) {
        return [__externalDelegate tableView:tableView canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
    return NO;
    
}
- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0){
    
    if (__externalDelegate && [__externalDelegate respondsToSelector:@selector(tableView:performAction:forRowAtIndexPath:withSender:)]) {
        [__externalDelegate tableView:tableView performAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
}

#pragma mark - Data Loading
- (void)startLoading {
    isLoading = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentInset = UIEdgeInsetsMake(RefreshHeaderHeight, 0, 0, 0);
        refreshLabel.text = textLoading;
        refreshArrow.hidden = YES;
        [refreshSpinner startAnimating];
    }];
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    isLoading = NO;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self reloadData];
        
        self.contentInset = UIEdgeInsetsZero;
        UIEdgeInsets tableContentInset = self.contentInset;
        tableContentInset.top = 0.0;
        self.contentInset = tableContentInset;
        [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    } completion:^(BOOL finished) {
        refreshLabel.text = textPull;
        refreshArrow.hidden = NO;
        [refreshSpinner stopAnimating];
    }];
}

- (void)refresh {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    //[self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
    if (self.dataLoader && [self.dataLoader respondsToSelector:@selector(loadLatestDataFor:)]) {
        [self.dataLoader loadLatestDataFor:self];
    }
}

- (void)dealloc {
    [refreshHeaderView release];
    [refreshLabel release];
    [refreshArrow release];
    [refreshSpinner release];
    [textPull release];
    [textRelease release];
    [textLoading release];
    [super dealloc];
}

@end
