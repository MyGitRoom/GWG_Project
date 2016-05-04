//
//  Reading.h
//  GWG_Project
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reading : NSObject
@property (nonatomic,strong)NSString * title; //标题
@property (nonatomic,strong)NSString * excerpt;//简述
@property (nonatomic,strong)NSString * lead;//引导(无显示)
@property (nonatomic,strong)NSString * thumbnail;//图片
@property (nonatomic,strong)NSString * share;//WEBVIEW 页面
@property (nonatomic,strong)NSString * author;//作者
@property (nonatomic,strong)NSString * fm;//音频
@property (nonatomic,strong)NSString * video;//视频
@property (nonatomic,strong)NSString * category;//类型

@end
