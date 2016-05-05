//
//  WidthAndHeight.h
//  GWG_Project
//
//  Created by lanou on 16/4/29.
//  Copyright © 2016年 关振发. All rights reserved.
//

#ifndef WidthAndHeight_h
#define WidthAndHeight_h

#define KScreenWidth  [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define KCellWidth    self.contentView.frame.size.width
#define KCellHeight   self.contentView.frame.size.height

//设置控制台的高度的
#define kControlBarHeight 300
//设置控制台的y的起点
#define kControlBarOriginY (KScreenHeight-kControlBarHeight)
//带参数的宏的定义
#define kHLColor(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
//设置控制台的中心
#define kControlBarCenterX self.view.center.x
#define kControlBarCenterY (kControlBarOriginY+150)
#define kButtonOffSetX 120

#endif /* WidthAndHeight_h */
