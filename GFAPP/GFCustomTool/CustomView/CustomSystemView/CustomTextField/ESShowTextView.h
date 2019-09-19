//
//  ESShowTextView.h
//  esReadStudent
//  文字展示跟读滑动
//  Created by 峰 on 2019/8/26.
//  Copyright © 2019 AK.ios. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESShowTextView : UIView

///默认文字
@property (nonatomic,copy) NSAttributedString *normalText;

///高亮文字
@property (nonatomic,copy) NSAttributedString *heightText;

///高亮颜色
@property (nonatomic,strong) UIColor *heighColor;

///是否可以点击文字
@property (nonatomic,assign) BOOL isTap;

///文字视图
- (UITextView *)normalTextView;

///设置高亮layer遮罩的size大小，用约束的必须设置！
- (void)setMaskLayerFrame:(CGSize)maskSize;

///显示高亮文字范围（不断调用）
- (void)highlightTextRange:(NSRange)range;

///清楚高亮带动画效果
- (void)clearHighlight;

///清除高亮不带动画
- (void)clearNOAnimationHighlight;

///文字滑动
- (void)scrollTextRangeToVisible:(NSRange)range;

@end

NS_ASSUME_NONNULL_END

/** 用法
 
_textView = [[ESShowTextView alloc] init];
_textView.heighColor = COLOR(@"#3EB453");//高亮颜色
_textView.normalTextView.userInteractionEnabled = NO;
[_textBackImgview addSubview:_textView];

NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
paragraphStyle.lineSpacing = 3;// 字体的行间距
paragraphStyle.alignment = NSTextAlignmentLeft;//两端对齐

NSDictionary *dictionaryNormal = @{NSFontAttributeName:kFontOfCustom(kRegularFont, 20),NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:COLOR(@"#222222")};
NSDictionary *dictionaryHeight = @{NSFontAttributeName:kFontOfCustom(kRegularFont, 20),NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:COLOR(@"#3EB453")};

NSString *wordsStr = model.sentence.length ? model.sentence : @"";
NSAttributedString *attributedNormal = [[NSAttributedString alloc] initWithString:wordsStr attributes:dictionaryNormal];
NSAttributedString *attributedHeight = [[NSAttributedString alloc] initWithString:wordsStr attributes:dictionaryHeight];

_textView.normalText = attributedNormal;
_textView.heightText = attributedHeight;

//每次重新计算文字遮罩高度  _textView = [[ESShowTextView alloc] initWithFrame:CGRect{}];//这种写法不用 设置下面的了
[_textView setMaskLayerFrame:CGSizeMake(ScreenWidth - (95 + 30), model.sentenceHeight)];
 
 */
