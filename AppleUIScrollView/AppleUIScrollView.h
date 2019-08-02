//
//  AppleUIScrollView.h
//  AppleUIScrollView
//
//  Created by daixl on 2019/7/30.
//  Copyright © 2019 daixl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppleUIScrollView : UIView

@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic) BOOL scrollVertical;
@property (nonatomic) BOOL scrollHorizontal;

@end

NS_ASSUME_NONNULL_END
