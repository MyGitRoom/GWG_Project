//
//  MyTableViewCell.m
//  GWG_Project
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "MyTableViewCell.h"

@interface MyTableViewCell ()

@end

@implementation MyTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.imageV = [[UIImageView alloc]init];
        [self.contentView addSubview:self.imageV];
        self.titleLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.titleLab];
        self.introLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.introLab];
        self.countLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.countLab];
    }
    return self;
}

- (void) layoutSubviews
{
    self.imageV.frame = CGRectMake(5, 5, 110, 110);
    
    self.titleLab.frame = CGRectMake(120, 10, 100, 40);
    self.titleLab.font = [UIFont boldSystemFontOfSize:20];
    
    self.introLab.frame = CGRectMake(120, 60, 250, 30);
    self.introLab.font = [UIFont systemFontOfSize:15];
    [self.introLab setTintColor:[UIColor lightGrayColor]];
    
    self.countLab.frame = CGRectMake(200, 10, 100, 30);
    self.countLab.font = [UIFont systemFontOfSize:15];
    [self.countLab setTintColor:[UIColor lightGrayColor]];
    self.countLab.backgroundColor = [UIColor redColor];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
