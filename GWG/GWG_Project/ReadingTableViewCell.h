//
//  ReadingTableViewCell.h
//  GWG_Project
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadingTableViewCell : UITableViewCell
/*顶部图片*/
@property (nonatomic,strong)UIImageView * readImageView;
/*分割线*/
@property (nonatomic,strong)UIView * lineView;
/*类型Lab*/
@property (nonatomic,strong)UILabel * typeLabel;
/*主标题*/
@property (nonatomic,strong)UILabel * titleLabel;
/*标题简介*/
@property (nonatomic,strong)UILabel * detailsLabel;
/*作者*/
@property (nonatomic,strong)UILabel * authorLabel;
/*评论视图*/
@property (nonatomic,strong)UIImageView* commentView;
/*评论数量*/
@property (nonatomic,strong)UILabel * commentLabel;
/*收藏视图*/
@property (nonatomic,strong)UIImageView * collectionView;
/*收藏数量*/
@property (nonatomic,strong)UILabel * collectionLabel;
/*阅读数L1*/
@property (nonatomic,strong)UILabel * readingLabel1;
/*阅读数L2*/
@property (nonatomic,strong)UILabel * readingLabel2;


@end
