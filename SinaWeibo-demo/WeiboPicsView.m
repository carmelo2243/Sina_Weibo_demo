//
//  WeiboPicsView.m
//  SinaWeibo-demo
//
//  Created by SunZW on 15/8/19.
//  Copyright (c) 2015年 sunzw. All rights reserved.
//

#define picViewW 96 //imageView的宽度
//#define picViewW (picsArray.count == 4 | picsArray.count == 1) ? ((self.frame.size.width - picMargin)/2) : ((self.frame.size.width - 2 * picMargin)/3)
#define picMargin 5 //imageView的间距

#import "WeiboPicsView.h"
#import "WeiboPictureView.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@implementation WeiboPicsView

/**
 *  重写initWithFrame方法
 *
 *  @param count <#count description#>
 */
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //初始化9个子控件
        for (int i = 0; i < 9; i++) {
            WeiboPictureView * picView = [[WeiboPictureView alloc] init];
            picView.userInteractionEnabled = YES;
            picView.tag = i;
            //添加手势
            [picView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureViewTap:)]];
            
            [self addSubview:picView];
        }
    }
    return self;
}

/**
 *  手势的监听方法
 *
 */
- (void)pictureViewTap:(UITapGestureRecognizer *)recognizer {
//    NSLog(@"%d",recognizer.view.tag);
    NSUInteger count = self.picsArray.count;
    // 1.封装图片数据
    NSMutableArray *myphotos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 一个MJPhoto对应一张显示的图片
        MJPhoto *mjphoto = [[MJPhoto alloc] init];
        
        mjphoto.srcImageView = self.subviews[i]; // 来源于哪个UIImageView
        
        WeiboPicture *picture = self.picsArray[i];
        NSString *photoUrl = [picture.thumbnail_pic stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        mjphoto.url = [NSURL URLWithString:photoUrl]; // 图片路径
        
        [myphotos addObject:mjphoto];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = recognizer.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = myphotos; // 设置所有的图片
    [browser show];
}

/**
 *  重写picsArray的setter方法
 *
 *  @param picktures <#picktures description#>
 */
- (void)setPicsArray:(NSArray *)picsArray {
    _picsArray = picsArray;
    
    for (int i = 0; i < self.subviews.count; i++) {
        //取出对应位置的imageView
        WeiboPictureView *picView = self.subviews[i];
        
        //判断这个imageView是否显示
        if (i < picsArray.count) {//
            picView.hidden = NO;//显示图片
            
            //传递模型数据
            picView.picture = picsArray[i];
            
            //设置子控件的frame
            int maxCol = (picsArray.count == 4) ? 2 : 3;//最大列数
            int col = i % maxCol;//列号
            int row = i / maxCol;//行号
//            CGFloat picViewW = (self.frame.size.width - (maxCol - 1) * picMargin)/maxCol;
            CGFloat picViewX = col * (picViewW + picMargin);
            CGFloat picViewY = row * (picViewW + picMargin);
            picView.frame = CGRectMake(picViewX, picViewY, picViewW, picViewW);
            
            // Aspect : 按照图片的原来宽高比进行缩
            // UIViewContentModeScaleAspectFit : 按照图片的原来宽高比进行缩放(一定要看到整张图片)
            // UIViewContentModeScaleAspectFill :  按照图片的原来宽高比进行缩放(只能图片最中间的内容)
            // UIViewContentModeScaleToFill : 直接拉伸图片至填充整个imageView
            
            //判断图片数量，确定缩略图显示方式
            if (picsArray.count == 1) {
                picView.contentMode = UIViewContentModeScaleAspectFit;
                picView.clipsToBounds = NO;//不裁剪子视图
            } else {
                picView.contentMode = UIViewContentModeScaleAspectFill;
                picView.clipsToBounds = YES;//根据父视图的尺寸裁剪子视图
            }
        } else {//隐藏imageView
            picView.hidden = YES;
        }
    }
}

//根据图片的数量获得配图View的尺寸
+ (CGSize)pictureViewSizeWithPicCount:(int)count {
    // 一行最多有3列
    int maxColumns = (count == 4) ? 2 : 3;
    
    //  总行数
    int rows = (count + maxColumns - 1) / maxColumns;
    // 高度
    CGFloat picsH = rows * picViewW + (rows - 1) * picMargin;
    
    // 总列数
    int cols = (count >= maxColumns) ? maxColumns : count;
    // 宽度
    CGFloat picsW = cols * picViewW + (cols - 1) * picMargin;
    
    return CGSizeMake(picsW, picsH);
}
@end














