//
//  UIScrollView+LBEmptySourceView.m
//  TestDome
//
//  Created by 刘彬 on 2020/5/25.
//  Copyright © 2020 刘彬. All rights reserved.
//

#import "UIScrollView+LBEmptySourceView.h"
#import <objc/runtime.h>

static NSString *DataSourceCountKey = @"DataSourceCountKey";
static NSString *EmptySourceViewKey = @"EmptySourceViewKey";
static NSString *EmptySourceViewAvailableKey = @"EmptySourceViewAvailableKey";
static NSString *AllowShowEmptySourceViewWhenHaveHeaderOrFooterKey = @"AllowShowEmptySourceViewWhenHaveHeaderOrFooterKey";


@implementation UIScrollView (LBEmptySourceView)
-(UIView *)emptySourceView{
    return objc_getAssociatedObject(self, &EmptySourceViewKey);
}
-(void)setEmptySourceView:(UIView *)emptySourceView{
    objc_setAssociatedObject(self, &EmptySourceViewKey, emptySourceView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)emptySourceViewAvailable{
    return [objc_getAssociatedObject(self, &EmptySourceViewAvailableKey) boolValue];
}
-(void)setEmptySourceViewAvailable:(BOOL)emptySourceViewAvailable{
    objc_setAssociatedObject(self, &EmptySourceViewAvailableKey, @(emptySourceViewAvailable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)allowShowEmptySourceViewWhenHaveHeaderOrFooter{
    return [objc_getAssociatedObject(self, &AllowShowEmptySourceViewWhenHaveHeaderOrFooterKey) boolValue];
}
-(void)setAllowShowEmptySourceViewWhenHaveHeaderOrFooter:(BOOL)allowShowEmptySourceViewWhenHaveHeaderOrFooter{
    objc_setAssociatedObject(self, &AllowShowEmptySourceViewWhenHaveHeaderOrFooterKey, @(allowShowEmptySourceViewWhenHaveHeaderOrFooter), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSUInteger)dataSourceCount{
    return [objc_getAssociatedObject(self, &DataSourceCountKey) unsignedIntegerValue];
}
-(void)setDataSourceCount:(NSUInteger)dataSourceCount{
    objc_setAssociatedObject(self, &DataSourceCountKey, @(dataSourceCount), OBJC_ASSOCIATION_ASSIGN);
}


+(void)swizzleInstance:(BOOL)isInstance class:(Class )originalClass withClass:(Class )swizzledClass method:(SEL )originalSelector withMethod:(SEL )swizzledSelector{
    
    originalClass = isInstance?originalClass:object_getClass(originalClass);//关键
    
    Method originalMethod;
    Method swizzledMethod;
    
    BOOL respondsMethod = NO;
    if (isInstance) {
        originalMethod = class_getInstanceMethod(originalClass, originalSelector);
        swizzledMethod = class_getInstanceMethod(swizzledClass, swizzledSelector);
        respondsMethod = [originalClass instancesRespondToSelector:swizzledSelector];
    }else{
        originalMethod = class_getClassMethod(originalClass, originalSelector);
        swizzledMethod = class_getClassMethod(swizzledClass, swizzledSelector);
        respondsMethod = [originalClass respondsToSelector:swizzledSelector];
    }
    
    BOOL registerMethod = class_addMethod(originalClass,
    swizzledSelector,
    method_getImplementation(swizzledMethod),
    method_getTypeEncoding(swizzledMethod));
    
    if (respondsMethod == NO) {
        respondsMethod = registerMethod;
    }
    if (!respondsMethod) {
        return;
    }
    
    if (isInstance) {
        swizzledMethod = class_getInstanceMethod(originalClass, swizzledSelector);
    }else{
        swizzledMethod = class_getClassMethod(originalClass, swizzledSelector);
    }
    
    if (!swizzledMethod) {
        return;
    }
    
    BOOL didAddMethod = class_addMethod(originalClass,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(originalClass,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}



+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstance:YES class:UIScrollView.class withClass:self method:@selector(setFrame:) withMethod:@selector(LBEmptySourceView_SetFrame:)];
        
        [self swizzleInstance:YES class:UITableView.class withClass:self method:@selector(setTableHeaderView:) withMethod:@selector(LBEmptySourceView_SetTableHeaderView:)];
        [self swizzleInstance:YES class:UITableView.class withClass:self method:@selector(setTableFooterView:) withMethod:@selector(LBEmptySourceView_SetTableFooterView:)];
                
        NSArray<Class> *classArray = @[UITableView.class,UICollectionView.class];
        [classArray enumerateObjectsUsingBlock:^(Class  _Nonnull class, NSUInteger idx, BOOL * _Nonnull stop) {
            [self swizzleInstance:YES class:class withClass:self method:@selector(reloadData) withMethod:@selector(LBEmptySourceView_TableViewReloadData)];
        }];
    });
}

-(void)LBEmptySourceView_SetFrame:(CGRect)frame{
    [self LBEmptySourceView_SetFrame:frame];
    
    if (![self isKindOfClass:UITableView.class] && ![self isKindOfClass:UICollectionView.class]) {
        self.dataSourceCount = 1;
    }
}

-(void)LBEmptySourceView_SetTableHeaderView:(UIView *)tableHeaderView{
    [self LBEmptySourceView_SetTableHeaderView:tableHeaderView];
    
    [self showOrHiddenEmptySourceView];
}

-(void)LBEmptySourceView_SetTableFooterView:(UIView *)tableHeaderView{
    [self LBEmptySourceView_SetTableFooterView:tableHeaderView];
    [self showOrHiddenEmptySourceView];
}

-(void)LBEmptySourceView_TableViewReloadData{
    [self LBEmptySourceView_TableViewReloadData];
    
    [self showOrHiddenEmptySourceView];
}

-(void)showOrHiddenEmptySourceView{
    if (self.emptySourceViewAvailable == NO) {
        return;
    }
    
    if ([self respondsToSelector:@selector(dataSource)]) {
        self.dataSourceCount = 0;
        if ([self isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)self;
            if (self.allowShowEmptySourceViewWhenHaveHeaderOrFooter == NO) {
                //不允许有tableHeaderView和tableFooterView的时候显示空时图，那么有tableHeaderView和tableFooterView的时候个数+1
                if (tableView.tableHeaderView &&
                    !tableView.tableHeaderView.hidden &&
                    !CGSizeEqualToSize(tableView.tableHeaderView.bounds.size, CGSizeZero)) {
                    self.dataSourceCount += 1;
                }
                
                if (tableView.tableFooterView &&
                    !tableView.tableFooterView.hidden &&
                    !CGSizeEqualToSize(tableView.tableFooterView.bounds.size, CGSizeZero)) {
                    self.dataSourceCount += 1;
                }
            }
            
            id <UITableViewDataSource> dataSource = tableView.dataSource;
            id <UITableViewDelegate> delegate = tableView.delegate;

            
            if (dataSource && delegate) {
                NSInteger sections = 1;
                
                if ([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
                    sections = [dataSource numberOfSectionsInTableView:tableView];
                }
                
                if ([dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
                    for (NSInteger section = 0; section < sections; section++) {
                        NSUInteger sectionRowsNumber = [dataSource tableView:tableView numberOfRowsInSection:section];
                        self.dataSourceCount += sectionRowsNumber;
                        
                        if (sectionRowsNumber == 0) {
                            //如果section的rows为零，那么如果sectionHeader和sectionFooter存在的时候个数+1
                            
                            if ([delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)] &&
                                [delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
                                if ([delegate tableView:tableView heightForHeaderInSection:section]>0 &&
                                    [delegate tableView:tableView viewForHeaderInSection:section]) {
                                    self.dataSourceCount += 1;
                                }
                            }
                            
                            if ([delegate respondsToSelector:@selector(tableView:heightForFooterInSection:)] &&
                                [delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
                                if ([delegate tableView:tableView heightForFooterInSection:section]>0 &&
                                    [delegate tableView:tableView viewForFooterInSection:section]) {
                                    self.dataSourceCount += 1;
                                }
                            }
                            
                        }
                    }
                }
            }
            
            
        }
        else if ([self isKindOfClass:[UICollectionView class]]) {
            UICollectionView *collectionView = (UICollectionView *)self;
            
            UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
            BOOL haveSectionHeader = [flowLayout respondsToSelector:@selector(headerReferenceSize)] && !CGSizeEqualToSize(flowLayout.headerReferenceSize, CGSizeZero);
            
            
            BOOL haveSectionFooter = [flowLayout respondsToSelector:@selector(footerReferenceSize)] && !CGSizeEqualToSize(flowLayout.footerReferenceSize, CGSizeZero);
            
            
            id <UICollectionViewDataSource> dataSource = collectionView.dataSource;
            id <UICollectionViewDelegateFlowLayout> delegate = (id <UICollectionViewDelegateFlowLayout>)collectionView.delegate;

            
            if (dataSource && delegate) {
                NSInteger sections = 1;
                
                if ([dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
                    sections = [dataSource numberOfSectionsInCollectionView:collectionView];
                }
                
                if ([dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
                    for (NSInteger section = 0; section < sections; section++) {
                        
                        NSUInteger sectionItemsNumber = [dataSource collectionView:collectionView numberOfItemsInSection:section];
                        self.dataSourceCount += sectionItemsNumber;
                        
                        if (sectionItemsNumber == 0) {
                            //如果section的items为零，那么如果sectionHeader和sectionFooter存在的时候个数+1
                            if ([delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
                                haveSectionHeader = !CGSizeEqualToSize([delegate collectionView:collectionView layout:flowLayout referenceSizeForHeaderInSection:section], CGSizeZero);
                            }
                            
                            if ([delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
                                haveSectionFooter = !CGSizeEqualToSize([delegate collectionView:collectionView layout:flowLayout referenceSizeForFooterInSection:section], CGSizeZero);
                            }
                            
                            
                            if ([dataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
                                
                                if (haveSectionHeader) {
                                    if ([dataSource collectionView:collectionView viewForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:sectionItemsNumber inSection:section]]) {
                                        self.dataSourceCount += 1;
                                    }
                                }
                                
                                if (haveSectionFooter) {
                                    if ([dataSource collectionView:collectionView viewForSupplementaryElementOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:sectionItemsNumber inSection:section]]) {
                                        self.dataSourceCount += 1;
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
            
            
        }
        
        if (self.dataSourceCount) {
            [self.emptySourceView removeFromSuperview];
        }else{
            if (self.emptySourceView.superview == nil) {
                [self addSubview:self.emptySourceView];
            }
        }
    }
}
@end
