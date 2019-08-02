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
    self.scrollHorizontal = YES;
    self.scrollVertical = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:pan];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {

    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            [self pop_removeAnimationForKey:@"bounce"];
            [self pop_removeAnimationForKey:@"decelerate"];
            self.startBounds = self.bounds;
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [panGesture translationInView:self];
            CGRect bounds = self.startBounds;

            if (!self.scrollHorizontal) {
                translation.x = 0.0;
            }
            if (!self.scrollVertical) {
                translation.y = 0.0;
            }

            //change UIScrollView bounds
            //for X-axis
            CGFloat newBoundsOriginX = bounds.origin.x - translation.x;
            CGFloat minBoundsOriginX = 0.0;
            CGFloat maxBoundsOriginX = self.contentSize.width - bounds.size.width;
            CGFloat constrainedBoundsOriginX = fmax(minBoundsOriginX, fmin(newBoundsOriginX, maxBoundsOriginX));
            bounds.origin.x = constrainedBoundsOriginX + (newBoundsOriginX - constrainedBoundsOriginX) / 2;

            //for Y-axis
            CGFloat newBoundsOriginY = bounds.origin.y - translation.y;
            CGFloat minBoundsOriginY = 0.0;
            CGFloat maxBoundsOriginY = self.contentSize.height - bounds.size.height;
            CGFloat constrainedBoundsOriginY = fmax(minBoundsOriginY, fmin(newBoundsOriginY, maxBoundsOriginY));
            bounds.origin.y = constrainedBoundsOriginY + (newBoundsOriginY - constrainedBoundsOriginY) / 2;

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

             POPDecayAnimation *decayAnimation = [POPDecayAnimation animation];
            decayAnimation.property = [self boundsOriginProperty];
            decayAnimation.velocity = [NSValue valueWithCGPoint:velocity];
            [self pop_addAnimation:decayAnimation forKey:@"decelerate"];
        }
            break;
        default:
            break;
    }
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];

    BOOL outsideBoundsMinimum = bounds.origin.x < 0.0 || bounds.origin.y < 0.0;
    BOOL outsideBoundsMaximum = bounds.origin.x > self.contentSize.width - bounds.size.width || bounds.origin.y > self.contentSize.height - bounds.size.height;

    if (outsideBoundsMaximum || outsideBoundsMinimum) {
        POPDecayAnimation *decayAnimation = [self pop_animationForKey:@"decelerate"];
        if (decayAnimation) {
            CGPoint target = bounds.origin;
            if (outsideBoundsMinimum) {
                target.x = fmax(target.x, 0.0);
                target.y = fmax(target.y, 0.0);
            } else if (outsideBoundsMaximum) {
                target.x = fmin(target.x, self.contentSize.width - bounds.size.width);
                target.y = fmin(target.y, self.contentSize.height - bounds.size.height);
            }

            NSLog(@"bouncing with velocity: %@", decayAnimation.velocity);

            POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
            springAnimation.property = [self boundsOriginProperty];
            springAnimation.velocity = decayAnimation.velocity;
            springAnimation.toValue = [NSValue valueWithCGPoint:target];
            springAnimation.springBounciness = 0.0;
            springAnimation.springSpeed = 5.0;
            [self pop_addAnimation:springAnimation forKey:@"bounce"];

            [self pop_removeAnimationForKey:@"decelerate"];
        }
    }
}

#pragma mark - Utils
- (POPAnimatableProperty *)boundsOriginProperty
{
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"com.rounak.bounds.origin" initializer:^(POPMutableAnimatableProperty *prop) {
        // read value
        prop.readBlock = ^(id obj, CGFloat values[]) {
            values[0] = [obj bounds].origin.x;
            values[1] = [obj bounds].origin.y;
        };
        // write value
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            CGRect tempBounds = [obj bounds];
            tempBounds.origin.x = values[0];
            tempBounds.origin.y = values[1];
            [obj setBounds:tempBounds];
        };
        // dynamics threshold
        prop.threshold = 0.01;
    }];

    return prop;
}

@end
