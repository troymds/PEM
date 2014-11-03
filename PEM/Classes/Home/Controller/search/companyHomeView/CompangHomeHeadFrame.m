//
//  CompangHomeHeadFrame.m
//  PEM
//
//  Created by promo on 14-10-23.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "CompangHomeHeadFrame.h"
#import "comHomeModel.h"


#define KIcon  12


@implementation CompangHomeHeadFrame
- (void)setData:(comHomeModel *)data
{
    _data = data;
    //利用数据计算所有子控件的frame
    // 整个view的宽度
    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width - KViewBorderWidth * 2;
    
    // 1 图片
    CGFloat imageX = KViewBorderWidth;
    CGFloat imageY = KViewBorderWidth;
    CGSize imageSize = [self iconSizeWithType:kIconTypeDefault];
    _imageFrame = CGRectMake(imageX, imageY, imageSize.width, imageSize.height);
    
    // 2 公司名称
    CGFloat companyX = CGRectGetMaxX(_imageFrame) + KBoardWitch;
    CGFloat companyY = imageY;
    CGSize companySize = [data.name sizeWithFont:[UIFont systemFontOfSize:PxFont(20)] constrainedToSize:CGSizeMake(viewWidth-companyX, MAXFLOAT)];
    _companyNameFrame = (CGRect){{companyX,companyY},companySize};
    
    
    //3 vip  vipIconFrame
    CGFloat vipX = 0;
    CGFloat vipY = 0;
    if (companySize.width + KVIPW > viewWidth-companyX) {
        //vip在公司名字下一行
        //1 计算第二行显示的字数
        NSUInteger len;
        if ([data.name rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound  ) {// 公司名称包含数字
            len = data.name.length - (KNumberOfText + 1 );
        }else{
            len = data.name.length - KNumberOfText;
        }
        if (len == 0) {
            vipY = CGRectGetMaxY(_companyNameFrame);
            vipX = companyX;
        }else
        {
            //2 计算每个字的宽度和高度
            CGFloat WordW = [data.name sizeWithFont:[UIFont systemFontOfSize:PxFont(20)] constrainedToSize:CGSizeMake(viewWidth-companyX, MAXFLOAT)].width/data.name.length;
            CGFloat wordH = [data.name sizeWithFont:[UIFont systemFontOfSize:PxFont(20)] constrainedToSize:CGSizeMake(viewWidth-companyX, MAXFLOAT)].height/2;
            
            vipX = companyX + len * WordW + KWordSpace;
            vipY = CGRectGetMaxY(_companyNameFrame) - wordH;
        }
    }else
    {
        vipX = CGRectGetMaxX(_companyNameFrame);
        vipY = companyY;
    }
    _vipIconFrame = CGRectMake(vipX, vipY, KVIPW, KVIPH);
    //4 ePlatformFrame
    
    CGFloat ePlatFormY = CGRectGetMaxY(_imageFrame) - KEplatFormH;
    CGFloat ePlatFormX = companyX;
    _ePlatformFrame = CGRectMake(ePlatFormX, ePlatFormY, KEPlatFormW, KEplatFormH);
    
    // line 1
    _firstLineFrame = CGRectMake(0 , CGRectGetMaxY(_imageFrame) + KViewBorderWidth, kWidth, KLineH);
    
    CGFloat telX;
    CGFloat telY;
    CGFloat urlX; //webUr
    CGFloat urlY; //webUr
    CGFloat addressX; //address
    CGFloat addressY; //address
    CGFloat mainBusinessX = imageX;
    CGFloat mainBusinessY;
    
    CGFloat companyIntrudctionY;
    CGFloat startXX = imageX + KIcon + KBoardWitch*2;
  
    // 1 如果3个都空白，则没有第二条线

    NSInteger telLen = data.tel.length;
    NSInteger webLen = data.website.length;
    NSInteger addressLen = data.addr.length;
    if (telLen == 0 && webLen == 0 && addressLen == 0) {
        _telFrame = CGRectNull;
        _webUrlFrame = CGRectNull;
        _addressFrame = CGRectNull;
        _secLineFrame = CGRectNull;

        mainBusinessY = CGRectGetMaxY(_firstLineFrame) + KViewBorderWidth + KMainFont;
        _mainFrame = CGRectMake(imageX, CGRectGetMaxY(_firstLineFrame) + KViewBorderWidth, 250, KMainFont);
        
        CGSize mainBusinesssize = [data.mainRun sizeWithFont:[UIFont systemFontOfSize:PxFont(20)] constrainedToSize:CGSizeMake(viewWidth, MAXFLOAT)];
        _mainBusinessFrame = (CGRect){{mainBusinessX,mainBusinessY},mainBusinesssize};
        
        _thirdLineFrame = CGRectMake(0, CGRectGetMaxY(_mainBusinessFrame) + KViewBorderWidth,kWidth,KLineH);
        
        companyIntrudctionY = CGRectGetMaxY(_thirdLineFrame) + KViewBorderWidth  + KMainFont;
        CGFloat companyIntrudctionX = mainBusinessX;
        CGSize companyIntrudctionsize = [data.introduction sizeWithFont:[UIFont systemFontOfSize:PxFont(20)] constrainedToSize:CGSizeMake(viewWidth, MAXFLOAT)];
        _companyIntrudctionFrame = (CGRect){{companyIntrudctionX,companyIntrudctionY},companyIntrudctionsize};
        
        _fourthLineFrame = CGRectMake(0, CGRectGetMaxY(_companyIntrudctionFrame) + KViewBorderWidth,kWidth,KLineH);

    }else
    { // tel you
        if (telLen != 0) {
            telX = startXX;
            telY = CGRectGetMaxY(_firstLineFrame ) + KViewBorderWidth;
            _telFrame = CGRectMake(telX, telY, 250, 15);
            // web  you
            if (webLen != 0) {
                urlX = startXX;
                urlY = CGRectGetMaxY(_telFrame) + KViewBorderWidth;
                _webUrlFrame = CGRectMake(startXX, urlY, 250, 15);
                {// address  you
                    if (addressLen != 0) {
                        addressX = urlX;
                        addressY = CGRectGetMaxY(_webUrlFrame) + KViewBorderWidth;
                        _addressFrame = CGRectMake(startXX, addressY, 250, 15);
                    }
                }
            }else
            {// web  mei you
                if (addressLen != 0) { // address  you
                    addressX = urlX;
                    addressY = CGRectGetMaxY(_telFrame) + KViewBorderWidth;
                    _addressFrame = CGRectMake(startXX, addressY, 250, 15);
                }
            }
        }else
        {//tel  meiyou
            if (webLen != 0) {//  web  you
                urlX = startXX;
                urlY = CGRectGetMaxY(_firstLineFrame) + KViewBorderWidth;
                _webUrlFrame = CGRectMake(startXX, urlY, 250, 15);
                if (addressLen != 0) {// add  you
                    addressX = urlX;
                    addressY = CGRectGetMaxY(_webUrlFrame) + KViewBorderWidth;
                    _addressFrame = CGRectMake(startXX, addressY, 250, 15);
                }
            }
            {// web mei you  add bi xu you
                addressX = urlX;
                addressY = CGRectGetMaxY(_firstLineFrame) + KViewBorderWidth;
                _addressFrame = CGRectMake(startXX, addressY, 250, 15);
            }
        }
        // 计算第二根线的位置
        if (addressLen != 0) {
            _secLineFrame = CGRectMake(0 , CGRectGetMaxY(_addressFrame) + KViewBorderWidth, kWidth, KLineH);
        }else
        {
            if (webLen != 0) {
                _secLineFrame = CGRectMake(0 , CGRectGetMaxY(_webUrlFrame) + KViewBorderWidth, kWidth, KLineH);
            }else{
                _secLineFrame = CGRectMake(0 , CGRectGetMaxY(_telFrame) + KViewBorderWidth, kWidth, KLineH);
            }
        }
        
        mainBusinessY = CGRectGetMaxY(_secLineFrame) + KViewBorderWidth  + KMainFont;
        CGSize mainBusinesssize = [data.mainRun sizeWithFont:[UIFont systemFontOfSize:PxFont(18)] constrainedToSize:CGSizeMake(viewWidth, MAXFLOAT)];
        _mainBusinessFrame = (CGRect){{mainBusinessX,mainBusinessY},mainBusinesssize};
        
        _thirdLineFrame = CGRectMake(0, CGRectGetMaxY(_mainBusinessFrame) + KViewBorderWidth,kWidth,KLineH);
        
        companyIntrudctionY = CGRectGetMaxY(_thirdLineFrame) + KViewBorderWidth  + KMainFont;
        CGFloat companyIntrudctionX = mainBusinessX;
        CGSize companyIntrudctionsize = [data.introduction sizeWithFont:[UIFont systemFontOfSize:PxFont(18)] constrainedToSize:CGSizeMake(viewWidth, MAXFLOAT)];
        _companyIntrudctionFrame = (CGRect){{companyIntrudctionX,companyIntrudctionY},companyIntrudctionsize};
            
            
        _fourthLineFrame = CGRectMake(0, CGRectGetMaxY(_companyIntrudctionFrame) + KViewBorderWidth,kWidth,KLineH);
        
        

        _mainFrame = CGRectMake(imageX, CGRectGetMaxY(_secLineFrame) + KViewBorderWidth, 250, KMainFont);
    }
}

- (CGSize ) iconSizeWithType :(IconType) imgType
{
    CGSize iconSize;
    switch (imgType) {
        case kIconTypeSmall: // 小图标
            iconSize = CGSizeMake(kIconSmallW, kIconSmallH);
            break;
            
        case kIconTypeDefault: // 中图标
            iconSize = CGSizeMake(kIconDefaultW, kIconDefaultH);
            break;
            
        case kIconTypeBig: // 大图标
            iconSize = CGSizeMake(kIconBigW, kIconBigH);
            break;
    }
    CGFloat width = iconSize.width;
    CGFloat height = iconSize.height;
    return CGSizeMake(width, height);
}
@end
