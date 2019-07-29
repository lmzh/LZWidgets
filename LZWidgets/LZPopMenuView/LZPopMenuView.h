//
//  LZPopMenuView.h
//  LZWidgets
//
//  Created by benjaminlmz@qq.com on 2019/7/19.
//  Copyright © 2019 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DIRECTION) {
    UP,
    DOWN,
    LEFT,
    RIGHT,
};

typedef NS_ENUM(NSUInteger, POP_STYLE) {
    DARK,
    WHITE
};

typedef NS_ENUM(NSUInteger, TITLE_ALIGEN) {
    ALIGEN_LEFT,
    ALIGEN_CENTER,
    ALIGEN_RIGHT,
};

@protocol LZPopMenuDelegate <NSObject>

@optional

@end
@interface LZPopMenuView : UIView
@property (nonatomic ,weak)id<LZPopMenuDelegate> delegate;

+ (LZPopMenuView *)initPopViewRelayOn:(UIView *)view titles:(NSArray*)titles dirction:(DIRECTION)dirction style:(POP_STYLE)style width:(CGFloat)size delegate:(id<LZPopMenuDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
