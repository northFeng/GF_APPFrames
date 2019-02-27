//
//  GFVCCellDemo.m
//  GFAPP
//
//  Created by gaoyafeng on 2019/2/27.
//  Copyright © 2019 North_feng. All rights reserved.
//

#import "GFVCCellDemo.h"

@interface GFVCCellDemo ()<UITableViewDelegate,UITableViewDataSource>

///
@property (nonatomic,strong,nullable) UITableView *tableView;

@end

@implementation GFVCCellDemo

{
    NSMutableArray *_arrayMutable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //创建tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 84, 375, 700) style:UITableViewStylePlain];
    //背景颜色
    self.tableView.backgroundColor = [UIColor greenColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.editing = YES;//设置此属性才会出现系统移动cell样式出来！！！
    
    
    [self.view addSubview:self.tableView];
    
    
    //防止UITableView被状态栏压下20
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //self.tableView.adjustedContentInset =
    }
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    _arrayMutable = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        NSString *title = [NSString stringWithFormat:@"--->第%d行",i];
        [_arrayMutable addObject:title];
    }
}

#pragma mark - UITableView&&代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrayMutable.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = _arrayMutable[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

#pragma mark - cell 的编辑代理 ————> 控制cell编辑 样式！！

///默认返回UITableViewCellEditingStyleDelete
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

/**
 ///左滑按钮为系统按钮时，这里设置 按钮文字(默认 “删除”)
 - (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
 
 return @"删除";
 }
 */

/**
 ///自定义左滑按钮（可设置多个按钮）
 - (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
 
 //滑动添加按钮 ，按钮的点击事件也在这里进行处理
 return @[];
 }
 */

/** ios11
 ///cell左边按钮
 - (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
 
 }
 ///cell右边按钮
 - (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
 
 }
 */

/**
 ///移动
 - (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
 
 
 }
 */

//** 赋值 、粘贴
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender{
    
    return YES;
    /** 控制菜单上的选项
     if (action == @selector(cut:)) {
     return YES;
     }else if (action == @selector(copy:)){
     return YES;
     }else if (action == @selector(paste:)){
     return YES;
     }else if (action == @selector(select:)){
     return YES;
     }else if (action == @selector(selectAll:)){
     return YES;
     }else{
     return [super canPerformAction:action withSender:sender];
     }
     */
}

///点击菜单上选项触发的代理
- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender{
    
    if (action ==@selector(copy:)) {
        [UIPasteboard generalPasteboard].string = [_arrayMutable objectAtIndex:indexPath.row];
    }
    
    if (action ==@selector(cut:)) {
        
        [UIPasteboard generalPasteboard].string = [_arrayMutable objectAtIndex:indexPath.row];
        [_arrayMutable replaceObjectAtIndex:indexPath.row withObject:@""];
    }
    
    if (action == @selector(paste:)) {
        NSString *pasteString = [UIPasteboard generalPasteboard].string;
        NSString *tmpString = [NSString stringWithFormat:@"%@%@",[_arrayMutable objectAtIndex:indexPath.row],pasteString];
        [_arrayMutable replaceObjectAtIndex:indexPath.row withObject:tmpString];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}


/**
 - (BOOL)tableView:(UITableView *)tableView canFocusRowAtIndexPath:(NSIndexPath *)indexPath{
 
 return YES;
 }
 - (BOOL)tableView:(UITableView *)tableView shouldUpdateFocusInContext:(UITableViewFocusUpdateContext *)context{
 
 return YES;
 }
 - (void)tableView:(UITableView *)tableView didUpdateFocusInContext:(UITableViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator{
 
 
 }
 */



#pragma mark - dataSource 代理
// Editing

///控制是否可以编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

///控制删除 左滑 && 点击系统删除按钮事件
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_arrayMutable removeObjectAtIndex:indexPath.row];
    
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
}

// Moving/reordering

///控制是否可以移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    //移动cell前交换数据源
    [_arrayMutable exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
}


@end
