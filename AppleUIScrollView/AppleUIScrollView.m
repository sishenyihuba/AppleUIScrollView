//
//  AppleUIScrollView.m
//  AppleUIScrollView
//
//  Created by daixl on 2019/7/30.
//  Copyright © 2019 daixl. All rights reserved.
//

#import "AppleUIScrollView.h"

@interface AppleUIScrollView ()
@property (nonatomic, assign) CGRect startBounds;
@end

@implementation AppleUIScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:pan];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {

    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            self.startBounds = self.bounds;
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [panGesture translationInView:self];
            CGRect bounds = self.startBounds;

            //change UIScrollView bounds
            //for X-axis
            CGFloat newBoundsOriginX = bounds.origin.x - translation.x;
            CGFloat minBoundsOriginX = 0.0;
            CGFloat maxBoundsOriginX = self.contentSize.width - bounds.size.width;
            bounds.origin.x = fmax(minBoundsOriginX, fmin(newBoundsOriginX, maxBoundsOriginX));

            //for Y-axis
            CGFloat newBoundsOriginY = bounds.origin.y - translation.y;
            CGFloat minBoundsOriginY = 0.0;
            CGFloat maxBoundsOriginY = self.contentSize.height - bounds.size.height;
            bounds.origin.y = fmax(minBoundsOriginY, fmin(newBoundsOriginY, maxBoundsOriginY));

            self.bounds = bounds;
        }
            break;
        case UIGestureRecognizerStateEnded:
            break;
        default:
            break;
    }

}

@end
