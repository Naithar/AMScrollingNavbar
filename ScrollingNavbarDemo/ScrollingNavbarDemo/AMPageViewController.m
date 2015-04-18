//
//  AMPageViewController.m
//  ScrollingNavbarDemo
//
//  Created by Naithar on 18.04.15.
//  Copyright (c) 2015 Andrea Mazzini. All rights reserved.
//

#import "AMPageViewController.h"

@interface AMPageViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *pageViewController
;
@property (nonatomic, copy) NSArray *viewControllerArray;
@end

@implementation AMPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title  = @"TODO";

    self.pageViewController = [[UIPageViewController alloc]
                               initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                               options:@{
                                         UIPageViewControllerOptionInterPageSpacingKey : @10
                                         }];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;

    UIViewController *view1 = [[UIViewController alloc] init];
    view1.view.backgroundColor = [UIColor redColor];

    UIViewController *view2 = [[UIViewController alloc] init];
    view2.view.backgroundColor = [UIColor grayColor];

    self.viewControllerArray = @[view1, view2];

    [self.pageViewController setViewControllers:@[self.viewControllerArray.firstObject]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];


    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self.viewControllerArray indexOfObject:viewController];

    if (index - 1 >= 0) {
        return self.viewControllerArray[index-1];
    }


    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self.viewControllerArray indexOfObject:viewController];

    if (self.viewControllerArray.count > index + 1) {
        return self.viewControllerArray[index+1];
    }


    return nil;
}

@end
