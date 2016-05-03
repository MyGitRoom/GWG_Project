//
//  TypeOfMovieTableViewCell.h
//  GWG_Project
//
//  Created by lanou on 16/4/30.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeOfMovieTableViewCell : UITableViewCell

@property (nonatomic ,strong) UILabel *titleLabel ; //标题label
@property (nonatomic ,strong) UIImageView *imageV ; //图片
@property (nonatomic ,strong) UIBlurEffect *blur ; //毛玻璃效果
@property (nonatomic ,strong) UIVisualEffectView *effectview ;
@end
