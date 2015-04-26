//
//  AMPageViewController.m
//  ScrollingNavbarDemo
//
//  Created by Naithar on 18.04.15.
//  Copyright (c) 2015 Andrea Mazzini. All rights reserved.
//

#import "UIViewController+ScrollingNavbar.h"
#import "AMPageViewController.h"

@interface AMPageViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource, UITableViewDataSource>

@property (nonatomic, strong) UIPageViewController *pageViewController
;
@property (nonatomic, copy) NSArray *viewControllerArray;
@end

@implementation AMPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title  = @"Page view controller";

    self.pageViewController = [[UIPageViewController alloc]
                               initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                               options:@{
                                         UIPageViewControllerOptionInterPageSpacingKey : @10
                                         }];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;

    self.view.backgroundColor = [UIColor blackColor];
    self.pageViewController.view.backgroundColor = [UIColor blackColor];

    UIViewController *leftViewControler = [[UIViewController alloc] init];
    UITableView *leftTableView = [[UITableView alloc] initWithFrame:leftViewControler.view.bounds];
    leftTableView.dataSource = self;
    leftTableView.backgroundColor = [UIColor redColor];
    [leftViewControler.view addSubview:leftTableView];
    [leftViewControler setScrollingSuperview:self.view];
    [leftViewControler setScrollingViewController:self];
    [leftViewControler followScrollView:leftTableView withDelay:60];

    UIViewController *rightViewController = [[UIViewController alloc] init];
    UITableView *rightTableView = [[UITableView alloc] initWithFrame:leftViewControler.view.bounds];
    rightTableView.dataSource = self;
    rightTableView.backgroundColor = [UIColor grayColor];
    [rightViewController.view addSubview:rightTableView];
    [rightViewController setScrollingSuperview:self.view];
    [rightViewController setScrollingViewController:self];
    [rightViewController followScrollView:rightTableView withDelay:60];

    self.viewControllerArray = @[leftViewControler, rightViewController];

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", indexPath];
    return cell;
}

@end
