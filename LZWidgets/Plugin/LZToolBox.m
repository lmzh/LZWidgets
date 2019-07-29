//
//  LZToolBox.m
//  LZWidgets
//
//  Created by benjaminlmz@qq.com on 2019/7/19.
//  Copyright © 2019 Tony. All rights reserved.
//

#import "LZToolBox.h"

@implementation LZToolBox
// 获取文本宽度（文本自适应）
+(CGFloat)getWidthWithText:(NSString *)text withFontOfSize:(CGFloat)size {
    CGRect rect = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil];
    
    return rect.size.width;
}
@end
