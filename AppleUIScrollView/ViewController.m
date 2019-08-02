//
//  ViewController.m
//  AppleUIScrollView
//
//  Created by daixl on 2019/7/30.
//  Copyright © 2019 daixl. All rights reserved.
//

#import "ViewController.h"
#import "AppleUIScrollView.h"

@interface ViewController ()

@property (nonatomic, strong) AppleUIScrollView *customScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.customScrollView = [[AppleUIScrollView alloc] initWithFrame:self.view.bounds];
    self.customScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 2 * self.view.bounds.size.height);

    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(150, 160, 150, 200)];
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(40, 400, 200, 150)];
    UIView *yellowView = [[UIView alloc] initWithFrame:CGRectMake(100, 600, 180, 150)];

    redView.backgroundColor = [UIColor colorWithRed:0.815 green:0.007 blue:0.105 alpha:1];
    greenView.backgroundColor = [UIColor colorWithRed:0.494 green:0.827 blue:0.129 alpha:1];
    blueView.backgroundColor = [UIColor colorWithRed:0.29 green:0.564 blue:0.886 alpha:1];
    yellowView.backgroundColor = [UIColor colorWithRed:0.972 green:0.905 blue:0.109 alpha:1];

    [self.customScrollView addSubview:redView];
    [self.customScrollView addSubview:greenView];
    [self.customScrollView addSubview:blueView];
    [self.customScrollView addSubview:yellowView];

    UIView *redView1 = [[UIView alloc] initWithFrame:CGRectMake(20, 500+20, 100, 100)];
    UIView *greenView1 = [[UIView alloc] initWithFrame:CGRectMake(150, 500+160, 150, 200)];
    UIView *blueView1 = [[UIView alloc] initWithFrame:CGRectMake(40, 500+400, 200, 150)];
    UIView *yellowView1 = [[UIView alloc] initWithFrame:CGRectMake(100, 500+600, 180, 150)];

    redView1.backgroundColor = [UIColor purpleColor];
    greenView1.backgroundColor = [UIColor redColor];
    blueView1.backgroundColor = [UIColor grayColor];
    yellowView1.backgroundColor = [UIColor blackColor];

    [self.customScrollView addSubview:redView1];
    [self.customScrollView addSubview:greenView1];
    [self.customScrollView addSubview:blueView1];
    [self.customScrollView addSubview:yellowView1];

    [self.view addSubview:self.customScrollView];
}


@end
