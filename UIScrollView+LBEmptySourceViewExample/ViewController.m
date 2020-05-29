//
//  ViewController.m
//  UIScrollView+LBEmptySourceViewExample
//
//  Created by 刘彬 on 2020/5/26.
//  Copyright © 2020 刘彬. All rights reserved.
//

#import "ViewController.h"
#import "MJRefreshNormalHeader+LBEmptySourceViewAuto.h"
#import "LBSourceEmptyView.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, assign) NSUInteger sourceCount;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.emptySourceView = [[LBSourceEmptyView alloc] init];
    tableView.emptySourceViewAvailable = YES;
    [self.view addSubview:tableView];
    
    MJWeakSelf
    __weak typeof(tableView) weakTableView = tableView;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (weakSelf.sourceCount) {
                weakSelf.sourceCount = 0;
            }else{
                weakSelf.sourceCount = 100;
            }
            
            [weakTableView reloadData];
            
            [weakTableView.mj_header endRefreshing];
        });
    }];
    tableView.mj_header = header;;
}

#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _sourceCount;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"UIScrollView+LBEmptySourceView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}


@end
