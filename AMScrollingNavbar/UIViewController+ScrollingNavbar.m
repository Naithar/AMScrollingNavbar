//
//  UIViewController+ScrollingNavbar.m
//  ScrollingNavbarDemo
//
//  Created by Andrea on 24/03/14.
//  Copyright (c) 2014 Andrea Mazzini. All rights reserved.
//

#define IS_IPHONE_6_PLUS [UIScreen mainScreen].scale == 3
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#import "UIViewController+ScrollingNavbar.h"
#import <objc/runtime.h>

const NSInteger kAMScrollingNavBarOverlayTag = 1900091;

@implementation UIViewController (ScrollingNavbar)

- (void)setUseSuperview:(BOOL)useSuperview { objc_setAssociatedObject(self, @selector(useSuperview), [NSNumber numberWithBool:useSuperview], OBJC_ASSOCIATION_RETAIN);}
- (BOOL)useSuperview { return [objc_getAssociatedObject(self, @selector(useSuperview)) boolValue]; }

- (void)setScrollingNavbarDelegate:(id <AMScrollingNavbarDelegate>)scrollingNavbarDelegate { objc_setAssociatedObject(self, @selector(scrollingNavbarDelegate), scrollingNavbarDelegate, OBJC_ASSOCIATION_ASSIGN); }
- (id <AMScrollingNavbarDelegate>)scrollingNavbarDelegate { return objc_getAssociatedObject(self, @selector(scrollingNavbarDelegate)); }

- (void)setScrollableViewConstraint:(NSLayoutConstraint *)scrollableViewConstraint { objc_setAssociatedObject(self, @selector(scrollableViewConstraint), scrollableViewConstraint, OBJC_ASSOCIATION_RETAIN); }
- (NSLayoutConstraint *)scrollableViewConstraint { return objc_getAssociatedObject(self, @selector(scrollableViewConstraint)); }

- (void)setScrollableHeaderConstraint:(NSLayoutConstraint *)scrollableHeaderConstraint { objc_setAssociatedObject(self, @selector(scrollableHeaderConstraint), scrollableHeaderConstraint, OBJC_ASSOCIATION_RETAIN); }
- (NSLayoutConstraint *)scrollableHeaderConstraint { return objc_getAssociatedObject(self, @selector(scrollableHeaderConstraint)); }

- (void)setScrollableHeaderOffset:(float)scrollableHeaderOffset { objc_setAssociatedObject(self, @selector(scrollableHeaderOffset), [NSNumber numberWithFloat:scrollableHeaderOffset], OBJC_ASSOCIATION_RETAIN); }
- (float)scrollableHeaderOffset { return [objc_getAssociatedObject(self, @selector(scrollableHeaderOffset)) floatValue]; }

- (void)setPanGesture:(UIPanGestureRecognizer *)panGesture { objc_setAssociatedObject(self, @selector(panGesture), panGesture, OBJC_ASSOCIATION_RETAIN); }
- (UIPanGestureRecognizer*)panGesture {	return objc_getAssociatedObject(self, @selector(panGesture)); }

- (void)setScrollableView:(UIView *)scrollableView { objc_setAssociatedObject(self, @selector(scrollableView), scrollableView, OBJC_ASSOCIATION_RETAIN); }
- (UIView *)scrollableView { return objc_getAssociatedObject(self, @selector(scrollableView)); }

- (void)setOverlay:(UIView *)overlay { objc_setAssociatedObject(self, @selector(overlay), overlay, OBJC_ASSOCIATION_RETAIN); }
- (UIView *)overlay { return objc_getAssociatedObject(self, @selector(overlay)); }

- (void)setCollapsed:(BOOL)collapsed
{
    if (collapsed != self.collapsed) {
        if ([self.scrollingNavbarDelegate respondsToSelector:@selector(navigationBarDidChangeToCollapsed:)]) {
            [self.scrollingNavbarDelegate navigationBarDidChangeToCollapsed:collapsed];
        }
    }
    objc_setAssociatedObject(self, @selector(collapsed), [NSNumber numberWithBool:collapsed], OBJC_ASSOCIATION_RETAIN);
}
- (BOOL)collapsed {	return [objc_getAssociatedObject(self, @selector(collapsed)) boolValue]; }

- (void)setExpanded:(BOOL)expanded
{
    if (expanded != self.expanded) {
        if ([self.scrollingNavbarDelegate respondsToSelector:@selector(navigationBarDidChangeToExpanded:)]) {
            [self.scrollingNavbarDelegate navigationBarDidChangeToExpanded:expanded];
        }
    }
    objc_setAssociatedObject(self, @selector(expanded), [NSNumber numberWithBool:expanded], OBJC_ASSOCIATION_RETAIN);
}
- (BOOL)expanded { return [objc_getAssociatedObject(self, @selector(expanded)) boolValue]; }

- (void)setLastContentOffset:(float)lastContentOffset { objc_setAssociatedObject(self, @selector(lastContentOffset), [NSNumber numberWithFloat:lastContentOffset], OBJC_ASSOCIATION_RETAIN); }
- (float)lastContentOffset { return [objc_getAssociatedObject(self, @selector(lastContentOffset)) floatValue]; }

- (void)setMaxDelay:(float)maxDelay { objc_setAssociatedObject(self, @selector(maxDelay), [NSNumber numberWithFloat:maxDelay], OBJC_ASSOCIATION_RETAIN); }
- (float)maxDelay { return [objc_getAssociatedObject(self, @selector(maxDelay)) floatValue]; }

- (void)setDelayDistance:(float)delayDistance { objc_setAssociatedObject(self, @selector(delayDistance), [NSNumber numberWithFloat:delayDistance], OBJC_ASSOCIATION_RETAIN); }
- (float)delayDistance { return [objc_getAssociatedObject(self, @selector(delayDistance)) floatValue]; }

- (void)setShouldScrollWhenContentFits:(BOOL)shouldScrollWhenContentFits { objc_setAssociatedObject(self, @selector(shouldScrollWhenContentFits), [NSNumber numberWithBool:shouldScrollWhenContentFits], OBJC_ASSOCIATION_RETAIN); }
- (BOOL)shouldScrollWhenContentFits {	return [objc_getAssociatedObject(self, @selector(shouldScrollWhenContentFits)) boolValue]; }


// Using (assing) because there is no weak reference for objc_setAssociatedObject()
// objects are not deallocated if not used this way.
- (void)setScrollingSuperview:(UIView*)superview {
    objc_setAssociatedObject(self, @selector(scrollingSuperview), superview, OBJC_ASSOCIATION_ASSIGN);
}
- (UIView*)scrollingSuperview {
    return (UIView*)objc_getAssociatedObject(self, @selector(scrollingSuperview));
}

- (void)setScrollingViewController:(UIViewController*)viewController {
    objc_setAssociatedObject(self, @selector(scrollingViewController), viewController, OBJC_ASSOCIATION_ASSIGN);
}
- (UIViewController*)scrollingViewController {
    return (UIViewController*)objc_getAssociatedObject(self, @selector(scrollingViewController));
}


- (void)setScrollableViewConstraint:(NSLayoutConstraint *)constraint withOffset:(CGFloat)offset
{
    self.scrollableHeaderConstraint = constraint;
    self.scrollableHeaderOffset = offset;
}

- (void)followScrollView:(UIView *)scrollableView
{
    [self followScrollView:scrollableView withDelay:0];
}

- (void)followScrollView:(UIView *)scrollableView withDelay:(float)delay
{
    [self followScrollView:scrollableView usingTopConstraint:nil withDelay:delay];
}

- (void)followScrollView:(UIView *)scrollableView usingTopConstraint:(NSLayoutConstraint *)constraint
{
    [self followScrollView:scrollableView usingTopConstraint:constraint withDelay:0];
}

- (void)followScrollView:(UIView *)scrollableView usingTopConstraint:(NSLayoutConstraint *)constraint withDelay:(float)delay
{
    self.scrollableView = scrollableView;
    self.scrollableViewConstraint = constraint;
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.panGesture setMaximumNumberOfTouches:1];
    
    [self.panGesture setDelegate:self];
    [self.scrollableView addGestureRecognizer:self.panGesture];
    
    self.expanded = YES;
    
    /* The navbar fadeout is achieved using an overlay view with the same barTintColor.
     this might be improved by adjusting the alpha component of every navbar child */
    UIViewController *viewController = [self scrollingViewController] ?: self;
    UINavigationController *navigationController = ([viewController
                                                     isKindOfClass:[UINavigationController class]]
                                                    ? (UINavigationController*)viewController
                                                    : viewController.navigationController);

    CGRect frame = navigationController.navigationBar.frame;
    frame.origin = CGPointZero;
    self.overlay = [[UIView alloc] initWithFrame:frame];

    if (navigationController.navigationBar.barTintColor) {
        [self.overlay setBackgroundColor:navigationController.navigationBar.barTintColor];
    } else if ([UINavigationBar appearance].barTintColor) {
        [self.overlay setBackgroundColor:[UINavigationBar appearance].barTintColor];
    } else {
        NSLog(@"[%s]: %@", __PRETTY_FUNCTION__, @"[AMScrollingNavbarViewController] Warning: no bar tint color set");
    }
    
    if ([navigationController.navigationBar isTranslucent]) {
        NSLog(@"[%s]: %@", __PRETTY_FUNCTION__, @"[AMScrollingNavbarViewController] Warning: the navigation bar should not be translucent");
    }
    
    [self.overlay setUserInteractionEnabled:NO];
    [self.overlay setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.overlay setTag:kAMScrollingNavBarOverlayTag];
    [self.overlay setAlpha:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    self.maxDelay = delay;
    self.delayDistance = delay;
    self.shouldScrollWhenContentFits = NO;
}

- (void)stopFollowingScrollView
{
    [self showNavBarAnimated:NO];
    [self.scrollableView removeGestureRecognizer:self.panGesture];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
    self.scrollableView = nil;
    self.panGesture = nil;

    [self setScrollingSuperview:nil];
    [self setScrollingViewController:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)didBecomeActive:(id)sender
{
    // This works fine in iOS8 without the ugly delay. Oh well.
    NSTimeInterval time = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") ? 0 : 0.1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.view.window) {
            return;
        }
//        if (self.expanded) {
            [self showNavbar];
//        } else if (self.collapsed) {
//            self.collapsed = NO;
//            self.expanded = YES;
//            [self hideNavbarAnimated:NO];
//        }
    });
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    UIViewController *viewController = [self scrollingViewController] ?: self;
    UINavigationController *navigationController = ([viewController
                                                     isKindOfClass:[UINavigationController class]]
                                                    ? (UINavigationController*)viewController
                                                    : viewController.navigationController);

    CGRect frame = self.overlay.frame;
    frame.size.height = navigationController.navigationBar.frame.size.height;
    self.overlay.frame = frame;
    
    [self updateSizingWithDelta:0];
}

- (float)deltaLimit
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || IS_IPHONE_6_PLUS) {
        return ([[UIApplication sharedApplication] isStatusBarHidden]) ? 44 : 24;
    } else {
        if ([[UIApplication sharedApplication] isStatusBarHidden]) {
            return (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? 44 : 32);
        } else {
            return (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? 24 : 12);
        }
    }
}

- (float)statusBar
{
    return ([[UIApplication sharedApplication] isStatusBarHidden]) ? 0 : 20;
}

- (float)navbarHeight
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || IS_IPHONE_6_PLUS) {
        return ([[UIApplication sharedApplication] isStatusBarHidden]) ? 44 : 64;
    } else {
        if ([[UIApplication sharedApplication] isStatusBarHidden]) {
            return (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? 44 : 32);
        } else {
            return (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? 64 : 52);
        }
    }
}

- (void)hideNavbar
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self hideNavbarAnimated:YES];
}

- (void)hideNavbarAnimated:(BOOL)animated
{
    if (!self.view.window) {
        return;
    }
    
    if (self.scrollableView != nil) {
        if (self.expanded) {
            if (!self.scrollableViewConstraint) {
                // Frame version
                CGRect rect = [self scrollView].frame;
                rect.origin.y = self.navbarHeight;
                [self scrollView].frame = rect;
            }
            [UIView animateWithDuration:animated ? 0.1 : 0 animations:^{
                [self scrollWithDelta:self.navbarHeight];

                UIView *animationSuperview = [self scrollingSuperview] ?: self.view;
                [animationSuperview layoutIfNeeded];
            }];
        } else {
            [self updateNavbarAlpha:self.navbarHeight];
        }
    }
}

- (void)showNavBarAnimated:(BOOL)animated
{
    if (!self.view.window) {
        return;
    }

    __weak typeof(self.panGesture) weakGesture = self.panGesture;

    if (self.scrollableView != nil) {
        BOOL isTracking = weakGesture.state == UIGestureRecognizerStateBegan
        || weakGesture.state == UIGestureRecognizerStateChanged;

        if (self.collapsed || isTracking) {
            weakGesture.enabled = NO;
            if (!self.scrollableViewConstraint) {
                // Frame version
                CGRect rect = [self scrollView].frame;
                rect.origin.y = 0;
                [self scrollView].frame = rect;
            }
            [UIView animateWithDuration:animated ? 0.1 : 0 animations:^{
                self.scrollableHeaderConstraint.constant = 0;
                self.lastContentOffset = 0;
                self.delayDistance = -self.navbarHeight;
                [self scrollWithDelta:-self.navbarHeight];

                UIView *animationSuperview = [self scrollingSuperview] ?: self.view;
                [animationSuperview layoutIfNeeded];
            } completion:^(BOOL finished) {
                weakGesture.enabled = YES;
            }];
        } else {
            [self updateNavbarAlpha:self.navbarHeight];
        }
    }
}

- (void)showNavbar
{
    [self showNavBarAnimated:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)setScrollingEnabled:(BOOL)enabled
{
    self.panGesture.enabled = enabled;
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    CGPoint translation = [gesture translationInView:[self.scrollableView superview]];
    
    float delta = self.lastContentOffset - translation.y;
    self.lastContentOffset = translation.y;
    
    if ([self checkRubberbanding:delta]) {
        [self scrollWithDelta:delta];
    }
    
    if ([gesture state] == UIGestureRecognizerStateEnded || [gesture state] == UIGestureRecognizerStateCancelled) {
        // Reset the nav bar if the scroll is partial
        [self checkForPartialScroll];
        [self checkForHeaderPartialScroll];
        self.lastContentOffset = 0;
    }
}

- (BOOL)checkRubberbanding:(CGFloat)delta
{
    // Prevents the navbar from moving during the 'rubberband' scroll
    if (delta < 0) {
        if ([self contentoffset].y + self.scrollableView.frame.size.height > [self contentSize].height) {
            if (self.scrollableView.frame.size.height < [self contentSize].height) { // Only if the content is big enough
                return NO;
            }
        }
    } else {
        if ([self contentoffset].y < 0) {
            return NO;
        }
    }
    return YES;
}

- (void)scrollWithDelta:(CGFloat)delta
{
    UIViewController *viewController = [self scrollingViewController] ?: self;
    UINavigationController *navigationController = ([viewController
                                                     isKindOfClass:[UINavigationController class]]
                                                    ? (UINavigationController*)viewController
                                                    : viewController.navigationController);

    CGRect frame = navigationController.navigationBar.frame;
    
    // Scrolling the view up, hiding the navbar
    if (delta > 0) {
        if (!self.shouldScrollWhenContentFits && !self.collapsed) {
            if (self.scrollableView.frame.size.height >= [self contentSize].height) {
                return;
            }
        }
        if (self.collapsed) {
            if (self.scrollableHeaderConstraint.constant > -self.scrollableHeaderOffset) {
                self.scrollableHeaderConstraint.constant -= delta;

                [self restoreContentoffset:delta];

                if (self.scrollableHeaderConstraint.constant < -self.scrollableHeaderOffset) {
                    self.scrollableHeaderConstraint.constant = -self.scrollableHeaderOffset;
                }

                UIView *animationSuperview = [self scrollingSuperview] ?: self.view;
                [animationSuperview layoutIfNeeded];
            }
            return;
        }
        
        if (self.expanded) {
            self.expanded = NO;
        }
        
        if (frame.origin.y - delta < -self.deltaLimit) {
            delta = frame.origin.y + self.deltaLimit;
        }
        
        frame.origin.y = MAX(-self.deltaLimit, frame.origin.y - delta);
        navigationController.navigationBar.frame = frame;
        
        if (frame.origin.y == -self.deltaLimit) {
            self.collapsed = YES;
            self.expanded = NO;
            self.delayDistance = self.maxDelay;
        }
        
        [self updateSizingWithDelta:delta];
        [self restoreContentoffset:delta];
    }
    
    // Scrolling the view down, revealing the navbar
    if (delta < 0) {
        if (self.expanded) {
            if (self.scrollableHeaderConstraint.constant < 0) {
                self.scrollableHeaderConstraint.constant -= delta;

                [self restoreContentoffset:delta];

                if (self.scrollableHeaderConstraint.constant > 0) {
                    self.scrollableHeaderConstraint.constant = 0;
                }
                UIView *animationSuperview = [self scrollingSuperview] ?: self.view;
                [animationSuperview layoutIfNeeded];
            }
            return;
        }
        
        if (self.collapsed) {
            self.collapsed = NO;
        }
        
        self.delayDistance += delta;
        
        if (self.delayDistance > 0 && self.maxDelay < [self scrollView].contentOffset.y) {
            return;
        }
        
        if (frame.origin.y - delta > self.statusBar) {
            delta = frame.origin.y - self.statusBar;
        }
        frame.origin.y = MIN(20, frame.origin.y - delta);
        navigationController.navigationBar.frame = frame;
        
        if (frame.origin.y == self.statusBar) {
            self.expanded = YES;
            self.collapsed = NO;
        }
        
        [self updateSizingWithDelta:delta];
        [self restoreContentoffset:delta];
    }
}

- (UIScrollView *)scrollView
{
    UIScrollView *scroll;
    if ([self.scrollableView respondsToSelector:@selector(scrollView)]) {
        scroll = [self.scrollableView performSelector:@selector(scrollView)];
    } else if ([self.scrollableView isKindOfClass:[UIScrollView class]]) {
        scroll = (UIScrollView *)self.scrollableView;
    }
    return scroll;
}

- (void)restoreContentoffset:(float)delta
{
    // Hold the scroll steady until the navbar appears/disappears
    CGPoint offset = [[self scrollView] contentOffset];

    [[self scrollView] setContentOffset:(CGPoint){offset.x, offset.y - delta}];
//    if ([[self scrollView] respondsToSelector:@selector(translatesAutoresizingMaskIntoConstraints)] && [self scrollView].translatesAutoresizingMaskIntoConstraints) {
//        [[self scrollView] setContentOffset:(CGPoint){offset.x, offset.y - delta}];
//    } else {
//        [[self scrollView] setContentOffset:(CGPoint){offset.x, offset.y - delta}];
//    }
}

- (CGPoint)contentoffset
{
    return [[self scrollView] contentOffset];
}

- (CGSize)contentSize
{
    return [[self scrollView] contentSize];
}

- (void)checkForHeaderPartialScroll
{
    CGFloat offset = 0;
    if (self.scrollableHeaderConstraint.constant <= -self.scrollableHeaderOffset / 2) {
        offset = -self.scrollableHeaderOffset;
    } else {
        offset = 0;
    }

//    gives > 10 seconds
//    NSTimeInterval duration = ABS((self.scrollableHeaderConstraint.constant - self.scrollableHeaderOffset) * 0.2);

    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.scrollableHeaderConstraint.constant = offset;
        UIView *animationSuperview = [self scrollingSuperview] ?: self.view;
        [animationSuperview layoutIfNeeded];
    } completion:nil];
}

- (void)checkForPartialScroll
{
    UIViewController *viewController = [self scrollingViewController] ?: self;
    UINavigationController *navigationController = ([viewController
                                                     isKindOfClass:[UINavigationController class]]
                                                    ? (UINavigationController*)viewController
                                                    : viewController.navigationController);

    CGFloat pos = navigationController.navigationBar.frame.origin.y;
    __block CGRect frame = navigationController.navigationBar.frame;



    
    // Get back down
    if (pos >= (self.statusBar - frame.size.height / 2)) {
        CGFloat delta = frame.origin.y - self.statusBar;
        NSTimeInterval duration = ABS((delta / (frame.size.height / 2)) * 0.2);
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            frame.origin.y = self.statusBar;
            navigationController.navigationBar.frame = frame;
            
            self.expanded = YES;
            self.collapsed = NO;
            
            [self updateSizingWithDelta:delta];
        } completion:nil];
    } else {
        // And back up
        CGFloat delta = frame.origin.y + self.deltaLimit;
        NSTimeInterval duration = ABS((delta / (frame.size.height / 2)) * 0.2);
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            frame.origin.y = -self.deltaLimit;
            navigationController.navigationBar.frame = frame;
            
            self.expanded = NO;
            self.collapsed = YES;
            
            [self updateSizingWithDelta:delta];
        } completion:nil];
    }
}

- (void)updateSizingWithDelta:(CGFloat)delta
{
    [self updateNavbarAlpha:delta];
    
    // At this point the navigation bar is already been placed in the right position, it'll be the reference point for the other views'sizing

    UIViewController *viewController = [self scrollingViewController] ?: self;
    UINavigationController *navigationController = ([viewController
                                                     isKindOfClass:[UINavigationController class]]
                                                    ? (UINavigationController*)viewController
                                                    : viewController.navigationController);

    CGRect frameNav = navigationController.navigationBar.frame;
    
    // Move and expand (or shrink) the superview of the given scrollview
    UIView *scrollingSuperview = [self scrollingSuperview] ?: (self.useSuperview
                                                               ? self.scrollableView.superview
                                                               : self.scrollableView);

    CGRect frame = [scrollingSuperview frame];

    frame.origin.y = frameNav.origin.y + frameNav.size.height;
    
    if (self.scrollableViewConstraint) {
        self.scrollableViewConstraint.constant = -1 * ([self navbarHeight] - frame.origin.y);
    } else {
        frame.size.height = [UIScreen mainScreen].bounds.size.height - frame.origin.y;
        scrollingSuperview.frame = frame;
    }

    UIView *animationSuperview = [self scrollingSuperview] ?: self.view;
    [animationSuperview layoutIfNeeded];
}

- (void)updateNavbarAlpha:(CGFloat)delta
{
    UIViewController *viewController = [self scrollingViewController] ?: self;
    UINavigationController *navigationController = ([viewController
                                                     isKindOfClass:[UINavigationController class]]
                                                    ? (UINavigationController*)viewController
                                                    : viewController.navigationController);

    CGRect frame = navigationController.navigationBar.frame;
    float alpha = (frame.origin.y + self.deltaLimit) / frame.size.height;

    [self.overlay removeFromSuperview];
    
    UIView *currentOverlay = [navigationController.navigationBar viewWithTag:kAMScrollingNavBarOverlayTag] ?: self.overlay;
    [currentOverlay setTag:kAMScrollingNavBarOverlayTag];
    [currentOverlay setUserInteractionEnabled:NO];
    [currentOverlay setBackgroundColor:viewController.navigationController.navigationBar.barTintColor];

    if (currentOverlay == self.overlay) {
        [navigationController.navigationBar addSubview:currentOverlay];
    }

    if (self.scrollableView != nil) {
        [navigationController.navigationBar bringSubviewToFront:currentOverlay];
    }
    
    // Change the alpha channel of every item on the navbr. The overlay will appear, while the other objects will disappear, and vice versa
    [currentOverlay setAlpha:1 - alpha];

    [navigationController.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem *obj, NSUInteger idx, BOOL *stop) {
        obj.customView.alpha = alpha;
    }];
    navigationController.navigationItem.leftBarButtonItem.customView.alpha = alpha;
    [navigationController.navigationItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem *obj, NSUInteger idx, BOOL *stop) {
        obj.customView.alpha = alpha;
    }];
    navigationController.navigationItem.rightBarButtonItem.customView.alpha = alpha;
    navigationController.navigationItem.titleView.alpha = alpha;
    navigationController.navigationBar.tintColor = [navigationController.navigationBar.tintColor colorWithAlphaComponent:alpha];
}

@end
