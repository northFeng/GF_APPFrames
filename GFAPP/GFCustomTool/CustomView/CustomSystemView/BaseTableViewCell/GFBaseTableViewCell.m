//
//  XKFoundTableViewCell.m
//  Lawpress
//
//  Created by XinKun on 2017/3/23.
//  Copyright © 2017年 彬万. All rights reserved.
//

#import "GFBaseTableViewCell.h"

@implementation GFBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - 视图布局
///初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //数据初始化
        
        [self createView];
        
    }
    return self;
}


///创建布局视图
- (void)createView{
    
    
    //添加约束
    [self addLyaout];
}

///添加约束
- (void)addLyaout{
    
    
}


///赋值  总之：cell只是为了展示数据和样式的！ 数据和样式 是 数据model来控制！！
- (void)setCellData:(id)cellData{

    self.cellModel = cellData;//一个cell对应一个自己的model
    
    //1.恢复 cell 原样
    
    
    //2.赋值
    
    
    //3.改变状态   （cell只负责展示！！！！cell的数据 和 样式 由数据model来决定------>我们通过改变model的值来，让tableview 刷新数据 来控制 cell的样式变化）
    
    //4.根据是否登录在此做 状态 变化  -----> 这样 外部viewController 在登录变化时 只进行 刷新数据就可！！ 警告！：外部请求数据 必须 进行处理-->统统设置成 为登录的状态  ----> 刷新cell时，在cell里赋值 进行 登录和数据库 判断！！！！！！从而改变 model的值！！！
    
    //与本地数据库进行对比
//    if ([[GFCoreDataBoughtInfoService sharedService] getOneInfoWithUserId:[XKManager sharedInstance].currentUser.userId resourcesId:bookModel.Id typeId:bookModel.typeItem]) {
//        self.buyButton.hidden = YES;
//    }else {
//        bookModel.isAddToShoppingCart = [[GFCoreDataShopCartService sharedService] getOneInfoResourcesId:bookModel.Id typeId:bookModel.typeItem];
//        self.buyButton.hidden = NO;
//        [self.buyButton setSelected:bookModel.isAddToShoppingCart];
//        if (!bookModel.isAddToShoppingCart) {
//            [_buyButton setUserInteractionEnabled:YES];
//        }
//    }
    
    //5.cell的高度，也放进model中，类似聊天那个demo中一样，因为在cell的高度不是固定的而是变化的时候，在刷新数据，和上拉和下拉加载的时候，有时候 刷新完 tableView.contentOffx 虽然没变，但是 回不到原来位置  / 为了 精准，把计算的cell高度放到model中，然数据去控制cell的样式
    
    /*
    //行高
    - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        if (_dataModel) {
            
            if (_dataModel.materialList) {
                XKFoundHomeModel *foundModel = _dataModel.materialList[indexPath.row];
                
                return foundModel.cellHeight;
            }else{
                
                return 0;
            }
        }
        
        return 0;
    }
    */
    
}



////赋值返回cell的高度
//- (CGFloat)setData:(id)cellData{
//
//    //恢复原样
//    _line.hidden = NO;
//    
//    CGFloat titleHeight = [XKFactoryView getTextHeight:_labelTitle.text textFont:15 lineSpacing:3 textWidth:kScreenWidth-30];
//    
//    titleHeight = titleHeight > 42 ? 42 : titleHeight;
//
//    这种返回的不行！！！！！！！！！！！！！！！！
//    return CGRectGetMaxY(_authorLabel.frame)+12.5;
//    必须！！！！！ 为实实在在的 具体数字 去返回去  (在cell没有显示出来之前，cell的frame是空的，所有的以cell的frame为基础建立的长度和宽度都不起作用)
//    return 279+titleHeight+descripHeight;
//    return 36 + titleHeight;
//}


///更新约束
- (void)updateLayout{
    
    
    
}


///改变cell的样式
- (void)changCellSubViews{
    
}


#pragma mark - 业务处理





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
