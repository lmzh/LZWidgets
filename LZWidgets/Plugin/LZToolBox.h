//
//  LZToolBox.h
//  LZWidgets
//
//  Created by benjaminlmz@qq.com on 2019/7/19.
//  Copyright © 2019 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface LZToolBox : NSObject
///获取文本宽度
+ (CGFloat)getWidthWithText:(NSString *)text withFontOfSize:(CGFloat)size;
@end

NS_ASSUME_NONNULL_END
