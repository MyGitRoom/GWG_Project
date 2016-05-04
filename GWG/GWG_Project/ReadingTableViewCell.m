//
//  ReadingTableViewCell.m
//  GWG_Project
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "ReadingTableViewCell.h"

@implementation ReadingTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _readImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_readImageView];
        _lineView = [[UIView alloc]init];
        [self.contentView addSubview:_lineView];
        _typeLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_typeLabel];
        _titleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_titleLabel];
        _detailsLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_detailsLabel];
        _authorLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_authorLabel];
        _commentView = [[UIImageView alloc]init];
        [self.contentView addSubview:_commentView];
        _commentLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_commentLabel];
        _collectionView = [[UIImageView alloc]init];
        [self.contentView addSubview:_collectionView];
        _collectionLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_collectionLabel];
        _readingLabel1 = [[UILabel alloc]init];
        [self.contentView addSubview:_readingLabel1];
        _readingLabel2 = [[UILabel alloc]init];
        [self.contentView addSubview:_readingLabel2];
    }
    return self;
}


-(void)layoutSubviews
{
    [super subviews];
    
    _readImageView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight/2.5);
    _readImageView.backgroundColor = [UIColor grayColor];
    
    
    _lineView.frame = CGRectMake(0, KScreenHeight/2.5, KScreenWidth, 2);
    _lineView.backgroundColor =[UIColor colorWithRed:0.765 green:0.620 blue:0.259 alpha:1.000];
    
    
    _typeLabel.frame = CGRectMake(KScreenWidth/8*3, KScreenHeight/2.5+2, KScreenWidth/4, 20);
    _typeLabel.textColor = [UIColor whiteColor];
    _typeLabel.text = @"T O  R E A D";
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    _typeLabel.font = [UIFont systemFontOfSize:9];
    _typeLabel.backgroundColor =[UIColor colorWithRed:0.765 green:0.620 blue:0.259 alpha:0.8];
    
    
    _titleLabel.frame = CGRectMake(KScreenWidth/4-20, KScreenHeight/2-20, KScreenWidth/2+40, 100);
//    _titleLabel.backgroundColor = [UIColor lightGrayColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
//    _titleLabel.text = @"如果北京城可以折叠";
    _titleLabel.numberOfLines = 2;
    _titleLabel.font = [UIFont systemFontOfSize:35];
    
    
    
    _detailsLabel.frame = CGRectMake(KScreenWidth/8, KScreenHeight/3*2, KScreenWidth*3/4, KScreenWidth/8*3);
//    _detailsLabel.backgroundColor = [UIColor lightGrayColor];
    _detailsLabel.textAlignment = NSTextAlignmentCenter;
    _detailsLabel.font = [UIFont systemFontOfSize:17];
    _detailsLabel.numberOfLines= 0;

//    _detailsLabel.text = @"如果北京城分层折叠,不同阶层的人分居不同层,你喜欢的女孩和你在不同层,你要追求她....不是异地恋那么简单--关于同城一层恋的故事.";
    

    
    _authorLabel.frame = CGRectMake(KScreenWidth/4, KScreenHeight/10*9, KScreenWidth/2, 40);
//    _authorLabel.backgroundColor = [UIColor grayColor];
    _authorLabel.textAlignment = NSTextAlignmentCenter;
//    _authorLabel.text = @"郝静芳";
}









- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
