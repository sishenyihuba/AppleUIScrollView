//
//  AppleUIScrollView.m
//  AppleUIScrollView
//
//  Created by daixl on 2019/7/30.
//  Copyright © 2019 daixl. All rights reserved.
//

#import "AppleUIScrollView.h"
#import <pop/POP.h>

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
            //for X-axis  just scroll in vertical direction
//            CGFloat newBoundsOriginX = bounds.origin.x - translation.x;
//            CGFloat minBoundsOriginX = 0.0;
//            CGFloat maxBoundsOriginX = self.contentSize.width - bounds.size.width;
//            bounds.origin.x = fmax(minBoundsOriginX, fmin(newBoundsOriginX, maxBoundsOriginX));

            //for Y-axis
            CGFloat newBoundsOriginY = bounds.origin.y - translation.y;
            CGFloat minBoundsOriginY = 0.0;
            CGFloat maxBoundsOriginY = self.contentSize.height - bounds.size.height;
            bounds.origin.y = fmax(minBoundsOriginY, fmin(newBoundsOriginY, maxBoundsOriginY));

            self.bounds = bounds;
        }
            break;
        case UIGestureRecognizerStateEnded: {
            CGPoint velocity =  [panGesture velocityInView:self];
            if (self.bounds.size.width > self.contentSize.width) {
                velocity.x = 0;
            }
            if (self.bounds.size.height > self.contentSize.height) {
                velocity.y = 0;
            }
            velocity.x = -velocity.x;
            velocity.y = -velocity.y;
            velocity.x = 0;     // just scroll in vertical direction

            POPDecayAnimation *decayAnimation = [POPDecayAnimation animationWithPropertyNamed:kPOPViewBounds];
            decayAnimation.clampMode = kPOPAnimationClampBoth;
            POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"com.rounak.boundsY" initializer:^(POPMutableAnimatableProperty *prop) {
                // read value
                prop.readBlock = ^(id obj, CGFloat values[]) {
                    NSLog(@"readBlock values: %f", values[0]);
                    values[0] = [obj bounds].origin.x;
                    values[1] = [obj bounds].origin.y;
                };
                // write value
                prop.writeBlock = ^(id obj, const CGFloat values[]) {
                    CGRect tempBounds = [obj bounds];
                    NSLog(@"writeBlock values: %f", values[0]);
                    tempBounds.origin.x = values[0];
                    tempBounds.origin.y = values[1];
                    [obj setBounds:tempBounds];
                };
                // dynamics threshold
                prop.threshold = 0.01;
            }];
            decayAnimation.property = prop;
            decayAnimation.velocity = [NSValue valueWithCGPoint:velocity];
            [self pop_addAnimation:decayAnimation forKey:@"decelerate"];
        }
            break;
        default:
            break;
    }

}

@end
