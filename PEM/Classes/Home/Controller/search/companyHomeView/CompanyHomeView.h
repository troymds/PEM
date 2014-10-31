//
//  CompanyHomeView.h
//  PEM
//
//  Created by promo on 14-10-23.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
@class comHomeModel;
@class comPanyModel;

typedef void(^supplyViewClickedBlocl)(comPanyModel *);//supplyRecentlyView 被点击时候的block


@interface CompanyHomeView : UIView
@property (nonatomic, strong) comHomeModel* data;

- (id)initWithBlock:(supplyViewClickedBlocl)block;

@end

