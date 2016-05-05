//
//  TechnologyTableViewCell.m
//  GWG_Project
//
//  Created by Wcg on 16/5/5.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "TechnologyTableViewCell.h"

@implementation TechnologyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageV = [[UIImageView alloc]init];
        [self.contentView addSubview:_imageV];
        _lab = [[UILabel alloc]init];
        [self.contentView addSubview:_lab];
        
        
    }
    return self;
    
    
}


-(void)layoutSubviews
{
    [super subviews];
   
    _imageV.frame = CGRectMake(0, 0,KCellWidth , KCellHeight);
    _lab.frame = CGRectMake(0, 0, KCellWidth-100, 80);
    _lab.center = self.contentView.center;
    _lab.numberOfLines = 2;
    _lab.textAlignment = NSTextAlignmentCenter;
    _lab.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];//字体加粗
    _lab.textColor = [UIColor whiteColor];
}










- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
