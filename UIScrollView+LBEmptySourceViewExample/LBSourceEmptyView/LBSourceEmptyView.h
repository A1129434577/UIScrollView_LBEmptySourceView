//
//  LBSourceEmptyView.h
//  TestDome
//
//  Created by 刘彬 on 2019/12/25.
//  Copyright © 2019 刘彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, LBSourceEmptyViewType) {
    LBSourceEmptyViewTypeNoData = 0,
    LBSourceEmptyViewTypeNoNetwork,
};

@interface LBSourceEmptyView : UIView
@property (nonatomic, assign) LBSourceEmptyViewType type;

-(void)setEmptyViewTitle:(NSString * _Nullable)emptyViewTitle forType:(LBSourceEmptyViewType )type;
-(void)setEmptyViewImage:(UIImage * _Nullable)emptyViewImage forType:(LBSourceEmptyViewType )type;
-(void)setEmptyViewButtonTitle:(NSString * _Nullable)emptyViewButtonTitle forType:(LBSourceEmptyViewType )type;

/// 按钮点击block回调
@property (nonatomic, copy)void (^emptyViewButtonAction)(void);

@end

NS_ASSUME_NONNULL_END
