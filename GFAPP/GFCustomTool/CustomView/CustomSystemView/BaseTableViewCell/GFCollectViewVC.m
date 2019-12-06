//
//  GFCollectViewVC.m
//  GFAPP
//
//  Created by 峰 on 2019/8/4.
//  Copyright © 2019 North_feng. All rights reserved.
//

#import "GFCollectViewVC.h"

@interface GFCollectViewVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

///<#title#>
@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation GFCollectViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UICollectionViewLayout 可以获取整个UICollectionView上的任意地方的view的 布局属性——>UICollectionViewLayoutAttributes
    //创建一个layout布局类 设置各个item，header，footer,内边距 各个属性的设置
    //UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    GFCollectionViewFlowLayout *layout = [[GFCollectionViewFlowLayout alloc] init];
    layout.itemCount = 100;
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;//UICollectionViewScrollDirectionHorizontal;
    //设置每个item的大小为100*100
    //layout.itemSize = CGSizeMake(150, 200);
    //layout.minimumLineSpacing = 20;//随着 布局方向的间距
    //layout.minimumInteritemSpacing = 30;//随着布局 反方向
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 10, 20);
    
    
    //创建collectionView 通过一个布局策略layout来创建
    UICollectionView * collect = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    //代理设置
    collect.delegate = self;
    collect.dataSource = self;
    //注册item类型 这里使用系统的类型
    [collect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    
    //注册head
    //[_collectionView registerClass:[CBHomeHeadCellView Class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headCell"];
    
    [self.view addSubview:collect];
}



//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 100;
}

//这是正确的方法
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    
    return cell;
}


//返回每组的头视图 || 尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        //头视图
        /**
                 //自己定义的head但是必须继承UICollectionReusableView
        CBCellHeadView *headerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headView" forIndexPath:indexPath];
        if (headerView == nil) {
            headerView = [[CBCellHeadView alloc] init];
            headerView.backgroundColor = [UIColor clearColor];
        }
        headerView.titleLabel.text = [_letterArray gf_getItemWithIndex:indexPath.section];
         */
        
    }else if(kind == UICollectionElementKindSectionFooter){
        
    }
    return nil;
}

//是否可以移动
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//移动cell触发的代理
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath{
    
}

/**  UICollectionViewDelegateFlowLayout 布局代理
 //控制没个cell的大小
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
 
 //每组的内边距
 - (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
 
 //每组 随着布局方向的间距
 - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
 
 //每组 随着布局方向的 垂直间距
 - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
 
 //每组header的大小
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
 
 //每组footer的大小
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;
 */

@end


#pragma mark - ************************* 重写布局方法 *************************
@implementation GFCollectionViewFlowLayout
{
    //这个数组就是我们自定义的布局配置数组
    NSMutableArray * _attributeAttay;
}

//数组的相关设置在这个方法中
//布局前的准备会调用这个方法
-(void)prepareLayout{
    
    _attributeAttay = [[NSMutableArray alloc]init];
    [super prepareLayout];
    
    //演示方便 我们设置为静态的2列
    //计算每一个item的宽度
    float WIDTH = ([UIScreen mainScreen].bounds.size.width - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing)/2;
    
    //定义数组保存每一列的高度
    //这个数组的主要作用是保存每一列的总高度，这样在布局时，我们可以始终将下一个Item放在最短的列下面
    CGFloat colHight[2]={self.sectionInset.top,self.sectionInset.bottom};
    //itemCount是外界传进来的item的个数 遍历来设置每一个item的布局
    for (int i=0; i<_itemCount; i++) {
        //设置每个item的位置等相关属性
        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
        //创建一个布局属性类，通过indexPath来创建
        UICollectionViewLayoutAttributes * attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:index];
        //随机一个高度 在40——190之间
        CGFloat hight = arc4random()%150+40;
        //哪一列高度小 则放到那一列下面
        //标记最短的列
        int width=0;
        if (colHight[0]<colHight[1]) {
            //将新的item高度加入到短的一列
            colHight[0] = colHight[0]+hight+self.minimumLineSpacing;
            width=0;
        }else{
            colHight[1] = colHight[1]+hight+self.minimumLineSpacing;
            width=1;
        }
        
        //设置item的位置
        attris.frame = CGRectMake(self.sectionInset.left + (self.minimumInteritemSpacing+WIDTH)*width, colHight[width]-hight - self.minimumLineSpacing, WIDTH, hight);
        [_attributeAttay addObject:attris];
    }
    
    //设置itemSize来确保滑动范围的正确 这里是通过将所有的item高度平均化，计算出来的(以最高的列位标准)
    if (colHight[0] > colHight[1]) {
        self.itemSize = CGSizeMake(WIDTH, (colHight[0]-self.sectionInset.top)*2/_itemCount-self.minimumLineSpacing);
    }else{
        self.itemSize = CGSizeMake(WIDTH, (colHight[1]-self.sectionInset.top)*2/_itemCount-self.minimumLineSpacing);
    }
}

//这个方法中返回我们的布局数组
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return _attributeAttay;
}


@end

