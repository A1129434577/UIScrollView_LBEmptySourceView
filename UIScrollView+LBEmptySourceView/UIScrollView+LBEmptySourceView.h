//
//  UIScrollView+LBEmptySourceView.h
//  TestDome
//
//  Created by 刘彬 on 2020/5/25.
//  Copyright © 2020 刘彬. All rights reserved.
//  UIScrollView添加一个无内容的时候空视图根据数据源（包括header和footer）自动展示与消失的功能。

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (LBEmptySourceView)
@property (nonatomic, assign, readonly) NSUInteger dataSourceCount;//如果是UICollectionView和UITableView，即为数据源个数（包含所有header和footer），如果是UIScrollView，默认为1(默认对UIScrollView不控制)

@property (nonatomic, assign) BOOL    emptySourceViewAvailable;//空视图开关，default NO
@property (nonatomic, assign) BOOL    allowShowEmptySourceViewWhenHaveHeaderOrFooter;//只针对UITableView有效，tableHeaderView和tableFooterView的时候空视图是否显示
@property (nonatomic, strong) UIView *emptySourceView;//通过设置此属性自定义空视图样式

@end

NS_ASSUME_NONNULL_END
