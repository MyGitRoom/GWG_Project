//
//  MovieCollectionViewCell.m
//  GWG_Project
//
//  Created by lanou on 16/4/30.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "MovieCollectionViewCell.h"

@implementation MovieCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self ) {
        self.titleLabel = [[UILabel alloc]init];
        
        self.imageView = [[UIImageView alloc]init];
        
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLabel];
    }
    return  self ;

}


-(void)layoutSubviews {

    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(20, 30, 100, 30);
    self.titleLabel.center = self.contentView.center ;
    
    self.imageView.frame = CGRectMake(0, 0, KCellWidth, KCellHeight);
   
    self.contentView.layer.cornerRadius = 5 ;
    self.contentView.layer.masksToBounds = YES ;
//    self.contentView.layer.borderWidth = 1 ;

}





@end
