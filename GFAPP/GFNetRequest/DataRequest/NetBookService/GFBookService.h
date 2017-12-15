//
//  GFBookService.h
//  GFNetWorkRequest
//  图书接口
//  Created by XinKun on 2017/7/31.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "GFBaseService.h"

@interface GFBookService : GFBaseService


///post请求
- (void)postItemListWithItemPage:(NSInteger)page resultBack:(GFServiceBackArrayBlock)resultBack;


//data返回来的 是 字典
- (void)getFoundZLDetailInfoidString:(NSString *)idString result:(GFServiceBackArrayBlock)resultBack;


@end

/**
 
#pragma mark - Network Request  网络请求
- (void)requestData:(NSInteger)page {
    
    WS(weakSelf);
    //提示图
    if (!self.promptView) {
        self.promptView = [[XKPromptView alloc] initWithFrame:weakSelf.tableView.bounds];
        [self.tableView addSubview:self.promptView];
        [self.promptView setPromptImageName:NETWORK_NOT_IMAGE promptText:NETWORK_NOT_TITLE suggestText:NETWORK_NOT_SUGGEST];
        self.promptView.hidden = YES;
    }
    
    self.promptViewTwo = nil;
    if (!self.promptViewTwo) {
        self.promptViewTwo = [[XKPromptView alloc] initWithFrame:weakSelf.tableView.bounds];
        [self.tableView addSubview:self.promptViewTwo];
        [self.promptViewTwo setPromptImageName:DATA_NULL_IMAGE promptText:DATA_NULL_TITLE suggestText:@"搜索结果为空"];
        self.promptViewTwo.hidden = YES;
    }
    if ([[XKNetwork sharedInstance] getNetworkStatus] != XK_NETWORK_STATUS_NONE ) {
        //开启等待视图
        [XKWait startAnimatingFromSuperView:self.tableView info:nil];
        
        _tableView.userInteractionEnabled = NO;
        [[XKManager sharedInstance].booksService bookGetPaperListWithOrderType:_indexBtn categoryListArray:_arraySearch page:page resultBack:^(XKServiceResult *result, NSArray *items) {
            
            if (XK_RESULT_CODE_SUCCESS == result.resultCode) {
                
                if (page == 1) {
                    [weakSelf.arrayData removeAllObjects];
                }
                
                for (GFPaperModel *model in items) {
                    if (model!=nil) {
                        [weakSelf.arrayData addObject:model];
                    }
                }
                //处理footer
                if (items.count == 10) {
                    weakSelf.tableView.mj_footer.hidden = NO;
                }else{
                    if (page != 1) {
                        [XKWait stopAnimating:@"已无更多数据"];
                    }
                    weakSelf.tableView.mj_footer.hidden = YES;
                }
                
            }else{
                weakSelf.page--;
                [XKWait stopAnimating:result.resultDesc];
                
            }
            //处理提示图
            [weakSelf promptImageHandle:result];
            
            [weakSelf.tableView reloadData];
            
        }];
        
    }else{
        
        //结束等待视图
        self.page--;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        weakSelf.promptView.hidden = NO;
        weakSelf.promptViewTwo.hidden = YES;
        
        [XKWait stopAnimating:@"网络连接失败"];
        
    }
    
}

#pragma mark - 提示图的处理
- (void)promptImageHandle:(XKServiceResult *)result{
    
    //统一处理
    self.tableView.userInteractionEnabled = YES;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    //数据判断
    if (self.arrayData.count) {
        //有数据
        self.promptView.hidden = YES;
        self.promptViewTwo.hidden = YES;
    }else{
        //无数据
        if (XK_RESULT_CODE_SUCCESS == result.resultCode) {
            //请求成功
            self.promptView.hidden = YES;
            self.promptViewTwo.hidden = NO;
        }else{
            //请求失败
            self.promptView.hidden = NO;
            self.promptViewTwo.hidden = YES;
        }
    }
    
    [XKWait stopAnimating:nil];
    
}
 
 */
