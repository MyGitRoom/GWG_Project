//
//  TypeOfMovieTableViewCell.m
//  GWG_Project
//
//  Created by lanou on 16/4/30.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "TypeOfMovieTableViewCell.h"

@implementation TypeOfMovieTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc]init];
        self.imageV = [[UIImageView alloc]init];
        self.blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.effectview = [[UIVisualEffectView alloc]initWithEffect:self.blur];
        
        [self.contentView addSubview:self.imageV];
        
        [self.contentView addSubview:self.effectview];
        
        [self.contentView addSubview:self.titleLabel];
    }

    return  self ;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    self.imageV.layer.cornerRadius = 8 ;
    self.imageV.layer.masksToBounds = YES ;
    
    self.titleLabel.frame = CGRectMake(9, KCellHeight-41, KCellWidth, 30);
    self.titleLabel.textAlignment = NSTextAlignmentLeft ;
    self.titleLabel.textColor = [UIColor whiteColor];
    
    self.imageV.frame = CGRectMake(6, 0, KCellWidth-15, KCellHeight-8);
    
    self.effectview.frame = self.imageV.frame ;
    self.effectview.alpha = 0.4 ;

}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
