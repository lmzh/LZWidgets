//
//  LZPopMenuView.m
//  LZWidgets
//
//  Created by benjaminlmz@qq.com on 2019/7/19.
//  Copyright © 2019 Tony. All rights reserved.
//

#import "LZPopMenuView.h"
#import "LZConst.h"
#define tagsValue  1001
#define AlertTime 0.3 //弹出动画时间
#define DropTime 0.3 //落下动画时间

@interface LZPopMenuView()<UITableViewDelegate,UITableViewDataSource,LZPopMenuDelegate>

@property (nonatomic ,strong) UITableView   *itemTableView;
@property (nonatomic ,assign) CGFloat       width;

@property (nonatomic ,assign) CGFloat       cellHeight;

@property (nonatomic ,strong) NSArray       *titleArray;

@property (nonatomic ,strong) UIColor       *itemTextColor;
@property (nonatomic ,strong) UIColor       *bgColor;

@property (nonatomic ,assign) NSTextAlignment  titleAlign;
@property (nonatomic ,assign) POP_STYLE     style;
@property (nonatomic ,assign) DIRECTION     direction;
@end

@implementation LZPopMenuView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setDefaultSettings];
    }
    return self;
}
- (void) setDefaultSettings {
    self.style = DARK;
    self.titleAlign = NSTextAlignmentCenter;
    self.cellHeight = 44;
    self.direction = DOWN;
}
//
+ (LZPopMenuView *)initPopViewRelayOn:(UIView *)view titles:(NSArray*)titles dirction:(DIRECTION)dirction style:(POP_STYLE)style width:(CGFloat)width delegate:(id<LZPopMenuDelegate>)delegate{
    
    CGRect absoluteRect = [view convertRect:view.bounds toView:[UIApplication sharedApplication].keyWindow];    //绝对位置
    LZPopMenuView *popView = [[LZPopMenuView alloc] init];
    
    popView.direction = dirction;
    
    popView.width = width + 20;

    if (dirction == DOWN) {
        [popView setFrame:CGRectMake(absoluteRect.origin.x + absoluteRect.size.width/2 - popView.width/2, absoluteRect.origin.y - popView.cellHeight * titles.count - 20, popView.width, titles.count * popView.cellHeight + 20)];
    }
    else if (dirction == UP) {
        [popView setFrame:CGRectMake(absoluteRect.origin.x + absoluteRect.size.width/2 - popView.width/2, absoluteRect.origin.y + view.frame.size.height, popView.width, titles.count * popView.cellHeight + 20)];
    }
    else if (dirction == LEFT) {
        [popView setFrame:CGRectMake(absoluteRect.origin.x  - popView.width, absoluteRect.origin.y, popView.width, titles.count * popView.cellHeight + 20)];
        [popView setCenter:CGPointMake(popView.center.x, view.center.y)];
    }
    else if (dirction == RIGHT) {
        [popView setFrame:CGRectMake(absoluteRect.origin.x + absoluteRect.size.width, absoluteRect.origin.y , absoluteRect.origin.y - titles.count * popView.cellHeight /2, titles.count * popView.cellHeight + 20)];
        [popView setCenter:CGPointMake(popView.center.x, view.center.y)];
    }

    popView.titleArray = titles;
    
    [popView initUI];
    
    popView.delegate = delegate;
    
    popView.layer.cornerRadius = 5;
    popView.layer.masksToBounds = YES;
    [popView show];
    return popView;
}

- (void)initUI{
    self.backgroundColor = [UIColor clearColor];
    self.itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, _width - 20, _cellHeight * _titleArray.count) style:UITableViewStylePlain];
    self.itemTableView.delegate = self;
    self.itemTableView.dataSource = self;
    self.itemTableView.scrollEnabled = NO;
    self.itemTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.itemTableView.backgroundColor = self.bgColor;
    self.itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;  //隐藏
    [self addSubview:self.itemTableView];
}

// 显示
- (void)show{
    if (self.superview) {
        [self removeFromSuperview];
    }
    UIView *oldView = [[UIApplication sharedApplication].keyWindow viewWithTag:tagsValue];
    if (oldView) {
        [oldView removeFromSuperview];
    }
    UIView *iView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    iView.tag = tagsValue;
    iView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [iView addGestureRecognizer:tap];
    iView.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:iView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.alpha = 0;
    self.transform = CGAffineTransformScale(self.transform,0.1,0.1);
    [UIView animateWithDuration:AlertTime animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    }];
}

//弹出隐藏
- (void)dismiss{
    if (self.superview) {
        [UIView animateWithDuration:DropTime animations:^{
            self.transform = CGAffineTransformScale(self.transform,0.1,0.1);
            self.alpha = 0;
        } completion:^(BOOL finished) {
            UIView *bgview = [[UIApplication sharedApplication].keyWindow viewWithTag:tagsValue];
            if (bgview) {
                [bgview removeFromSuperview];
            }
            [self removeFromSuperview];
        }];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}
#pragma tableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdString = @"popCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdString];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdString];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = self.itemTextColor;
        cell.textLabel.textAlignment = self.titleAlign;
    }
    
    cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

// 设置模式
- (void)setTitleAlign:(NSTextAlignment)titleAlign {
    _titleAlign = titleAlign;
}
- (void)setStyle:(POP_STYLE)style {
    _style = style;
    if (style == DARK) {
        self.itemTextColor = [UIColor whiteColor];
        self.bgColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.7];
    }else {
        self.itemTextColor = [UIColor blackColor];
        self.bgColor = [UIColor whiteColor];
    }
}

- (void)drawRect:(CGRect)rect {
    
    if (self.direction == DOWN) {
        //拿到当前视图准备好的画板
        CGContextRef context = UIGraphicsGetCurrentContext();
        //利用path进行绘制三角形
        CGContextBeginPath(context);//标记
        CGContextMoveToPoint(context, self.bounds.size.width / 2 - 6, self.bounds.size.height - 10);//设置起点
        CGContextAddLineToPoint(context, self.bounds.size.width / 2, self.bounds.size.height);
        CGContextAddLineToPoint(context, self.bounds.size.width / 2 + 6, self.bounds.size.height - 10);
        CGContextClosePath(context);//路径结束标志，不写默认封闭
        [_bgColor setFill]; //设置填充色
        [[UIColor clearColor] setStroke]; //设置边框颜色
        CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path

    }
    else if (self.direction == UP) {
        //拿到当前视图准备好的画板
        CGContextRef context = UIGraphicsGetCurrentContext();
        //利用path进行绘制三角形
        CGContextBeginPath(context);//标记
        CGContextMoveToPoint(context, self.bounds.size.width / 2 - 6, 10);//设置起点
        CGContextAddLineToPoint(context, self.bounds.size.width / 2, 0);
        CGContextAddLineToPoint(context, self.bounds.size.width / 2 + 6, 10);
        CGContextClosePath(context);//路径结束标志，不写默认封闭
        [_bgColor setFill]; //设置填充色
        [[UIColor clearColor] setStroke]; //设置边框颜色
        CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path

    }
    else if (self.direction == LEFT) {
        //拿到当前视图准备好的画板
        CGContextRef context = UIGraphicsGetCurrentContext();
        //利用path进行绘制三角形
        CGContextBeginPath(context);//标记
        CGContextMoveToPoint(context, self.bounds.size.width - 10, self.bounds.size.height/2 - 6);//设置起点
        CGContextAddLineToPoint(context, self.bounds.size.width , self.bounds.size.height/2);
        CGContextAddLineToPoint(context, self.bounds.size.width - 10, self.bounds.size.height/2 + 6);
        CGContextClosePath(context);//路径结束标志，不写默认封闭
        [_bgColor setFill]; //设置填充色
        [[UIColor clearColor] setStroke]; //设置边框颜色
        CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path
        
    }else if (_direction == RIGHT) {
        //拿到当前视图准备好的画板
        CGContextRef context = UIGraphicsGetCurrentContext();
        //利用path进行绘制三角形
        CGContextBeginPath(context);//标记
        CGContextMoveToPoint(context, 10, self.bounds.size.height/2 - 6);//设置起点
        CGContextAddLineToPoint(context, 0, self.bounds.size.height/2);
        CGContextAddLineToPoint(context, 10, self.bounds.size.height/2 + 6);
        CGContextClosePath(context);//路径结束标志，不写默认封闭
        [_bgColor setFill]; //设置填充色
        [[UIColor clearColor] setStroke]; //设置边框颜色
        CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path

    }

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_itemTableView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = _itemTableView.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    _itemTableView.layer.mask = maskLayer;
    
  
}

@end
