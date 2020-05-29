//
//  LBSourceEmptyView.m
//  TestDome
//
//  Created by 刘彬 on 2019/12/25.
//  Copyright © 2019 刘彬. All rights reserved.
//

#import "LBSourceEmptyView.h"

@interface LBSourceEmptyView ()
@property (nonatomic, strong) UIImageView *emptyImageView;
@property (nonatomic ,strong) UILabel *emptyViewTitleLabel;
@property (nonatomic ,strong) UIButton *emptyViewButton;

@property (nonatomic, strong) NSMutableDictionary *noDataConfig;
@property (nonatomic, strong) NSMutableDictionary *noNetworkConfig;
@end

@implementation LBSourceEmptyView
- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _noDataConfig = [NSMutableDictionary dictionary];
        _noNetworkConfig = [NSMutableDictionary dictionary];
        
        
        UIImageView *emptyImageView = [[UIImageView alloc] init];
        emptyImageView.contentMode  = UIViewContentModeScaleAspectFill;
        [self addSubview:emptyImageView];
        self.emptyImageView = emptyImageView;
        
        UILabel *emptyViewTitleLabel = [[UILabel alloc] init];
        emptyViewTitleLabel.numberOfLines = 0;
        emptyViewTitleLabel.font = [UIFont systemFontOfSize:15];
        emptyViewTitleLabel.textAlignment = NSTextAlignmentCenter;
        emptyViewTitleLabel.textColor = [UIColor grayColor];
        [self addSubview:emptyViewTitleLabel];
        self.emptyViewTitleLabel = emptyViewTitleLabel;

        UIButton *actionButton = [[UIButton alloc] init];
        actionButton.layer.cornerRadius = 5;
        [actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        actionButton.titleLabel.font     = [UIFont systemFontOfSize:15];
        [actionButton addTarget:self action:@selector(actionButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:actionButton];
        self.emptyViewButton = actionButton;
        
        [self setEmptyViewImage:[UIImage imageNamed:@"no_data_icon"] forType:LBSourceEmptyViewTypeNoData];
        [self setEmptyViewTitle:@"暂无数据" forType:LBSourceEmptyViewTypeNoData];
        [self setEmptyViewButtonTitle:nil forType:LBSourceEmptyViewTypeNoData];
        
        
        [self setEmptyViewImage:nil forType:LBSourceEmptyViewTypeNoNetwork];
        [self setEmptyViewTitle:@"当前网络不稳定，请稍后再试" forType:LBSourceEmptyViewTypeNoNetwork];
        [self setEmptyViewButtonTitle:nil forType:LBSourceEmptyViewTypeNoNetwork];
        
        self.type = LBSourceEmptyViewTypeNoData;
    }
    return self;
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    [self layoutAllSubviews];
}

-(void)layoutAllSubviews{
    if (self.superview) {
        self.frame = CGRectMake(0, 0, CGRectGetWidth(self.superview.bounds), CGRectGetHeight(self.superview.bounds));
        
        self.emptyImageView.frame = CGRectMake((CGRectGetWidth(self.superview.bounds)-55)/2, CGRectGetHeight(self.frame)/2-60, 55, 60);

        CGFloat emptyViewTitleHeight = [self.emptyViewTitleLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.superview.bounds), MAXFLOAT)].height;
        self.emptyViewTitleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.emptyImageView.frame)+15, CGRectGetWidth(self.superview.bounds), emptyViewTitleHeight);

        CGFloat emptyViewButtonWidth;
        if (self.emptyViewButton.currentTitle) {
            emptyViewButtonWidth = [self.emptyViewButton sizeThatFits:CGSizeMake(CGRectGetWidth(self.superview.bounds), 30)].width+20*2;
        }else{
            emptyViewButtonWidth = 0;
        }
        self.emptyViewButton.frame = CGRectMake((CGRectGetWidth(self.superview.bounds)-emptyViewButtonWidth)/2, CGRectGetMaxY(self.emptyViewTitleLabel.frame)+25, emptyViewButtonWidth, 45);
    }
}

-(void)setEmptyViewTitle:(NSString *)emptyViewTitle forType:(LBSourceEmptyViewType)type{
    switch (type) {
        case LBSourceEmptyViewTypeNoData:
            [_noDataConfig setValue:emptyViewTitle forKey:NSStringFromSelector(@selector(emptyViewTitleLabel))];
            break;
        case LBSourceEmptyViewTypeNoNetwork:
            [_noNetworkConfig setValue:emptyViewTitle forKey:NSStringFromSelector(@selector(emptyViewTitleLabel))];
            break;
            
        default:
            break;
    }
}

-(void)setEmptyViewImage:(UIImage *)emptyViewImage forType:(LBSourceEmptyViewType)type{
    switch (type) {
        case LBSourceEmptyViewTypeNoData:
            [_noDataConfig setValue:emptyViewImage forKey:NSStringFromSelector(@selector(emptyImageView))];
            break;
        case LBSourceEmptyViewTypeNoNetwork:
            [_noNetworkConfig setValue:emptyViewImage forKey:NSStringFromSelector(@selector(emptyImageView))];
            break;
            
        default:
            break;
    }
}

-(void)setEmptyViewButtonTitle:(NSString *)emptyViewButtonTitle forType:(LBSourceEmptyViewType)type{
    switch (type) {
        case LBSourceEmptyViewTypeNoData:
            [_noDataConfig setValue:emptyViewButtonTitle forKey:NSStringFromSelector(@selector(emptyViewButton))];
            break;
        case LBSourceEmptyViewTypeNoNetwork:
            [_noNetworkConfig setValue:emptyViewButtonTitle forKey:NSStringFromSelector(@selector(emptyViewButton))];
            break;
            
        default:
            break;
    }
}


-(void)setType:(LBSourceEmptyViewType)type{
    _type = type;
    
    
    NSDictionary *currentConfig;
    switch (type) {
        case LBSourceEmptyViewTypeNoData:
        {
            currentConfig = _noDataConfig;
        }
            
            break;
        case LBSourceEmptyViewTypeNoNetwork:
        {
            currentConfig = _noNetworkConfig;
        }
            break;
            
        default:
            break;
    }
    
    self.emptyImageView.image = [currentConfig valueForKey:NSStringFromSelector(@selector(emptyImageView))];
    self.emptyViewTitleLabel.text = [currentConfig valueForKey:NSStringFromSelector(@selector(emptyViewTitleLabel))];
    [self.emptyViewButton setTitle:[currentConfig valueForKey:NSStringFromSelector(@selector(emptyViewButton))] forState:UIControlStateNormal];
    [self layoutAllSubviews];
}

-(void)actionButtonAction{
    !_emptyViewButtonAction ? : _emptyViewButtonAction();
}

@end
