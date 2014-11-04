//
//  CompanyHomeView.m
//  PEM
//  公司首页view
//  Created by promo on 14-10-23.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "CompanyHomeView.h"
#import "CompangHomeHeadFrame.h"
#import "comHomeModel.h"
#import "supplyRecentlyView.h"
#import "comPanyModel.h"

@interface CompanyHomeView ()
{
    CompangHomeHeadFrame * _headFrame;
    
    UIScrollView *_scroll;
    UIImageView * _image;
    UILabel *_companyName;
    UIImageView * _vipImg;
    UIButton *_company_E;
    UILabel*  _telphoneLabel;
    UILabel * _urlLabel;
    UILabel*  _addessLabel;
    UILabel * _mainBusinessLabel;
    UILabel* _companyIntrudctionLabel;
    
    supplyViewClickedBlocl _clickBlock;
    NSInteger cont;
    
}
@property (nonatomic, strong) NSArray *comPanyArray;
@end

@implementation CompanyHomeView


- (id)initWithBlock:(supplyViewClickedBlocl)block
{
    self = [super init];
    if (self) {
        _clickBlock = block;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = HexRGB(0xffffff);
        
        _scroll = [[UIScrollView alloc] init];
        _scroll.showsHorizontalScrollIndicator = NO;
        _scroll.showsVerticalScrollIndicator = NO;
        _scroll.pagingEnabled = NO;
        _scroll.bounces = NO;
        _scroll.scrollEnabled = YES;
        _scroll.userInteractionEnabled = YES;
        [self addSubview:_scroll];
        //大图片
        _image = [[UIImageView alloc] init];
        [_scroll addSubview:_image];
        
        //公司名称
        _companyName = [[UILabel alloc] init];
        _companyName.backgroundColor = [UIColor clearColor];
        _companyName.font =[UIFont systemFontOfSize:PxFont(20)];
        _companyName.numberOfLines = 0;
        [_scroll addSubview:_companyName];
        
        //3 vip image
        _vipImg = [[UIImageView alloc] init];
        [_scroll addSubview:_vipImg];
        
        //4 ePlatform
        
        _company_E =[UIButton buttonWithType:UIButtonTypeCustom];
        
        [_scroll addSubview:_company_E];
        [_company_E addTarget:self action:@selector(ebingooE) forControlEvents:UIControlEventTouchUpInside];
        
        _telphoneLabel = [[UILabel alloc] init];
        
        _telphoneLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        _telphoneLabel.textColor=HexRGB(0x5e5e5e);
        _telphoneLabel.backgroundColor =[UIColor clearColor];
        [_scroll addSubview:_telphoneLabel];
        
        _urlLabel = [[UILabel alloc] init];
        _urlLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        _urlLabel.backgroundColor =[UIColor clearColor];
        _urlLabel.textColor=HexRGB(0x5e5e5e);
        
        [_scroll addSubview:_urlLabel];
        
        _addessLabel = [[UILabel alloc] init];
        _addessLabel.textColor=HexRGB(0x5e5e5e);
        _addessLabel.backgroundColor =[UIColor clearColor];
        _addessLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        [_scroll addSubview:_addessLabel];
        
        _mainBusinessLabel =[[UILabel alloc]init];
        _mainBusinessLabel.numberOfLines = 0;
        _mainBusinessLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        _mainBusinessLabel.textColor = HexRGB(0x666666);
        [_scroll addSubview:_mainBusinessLabel];
        
        _companyIntrudctionLabel =[[UILabel alloc]init];
        _companyIntrudctionLabel.numberOfLines = 0;
        _companyIntrudctionLabel.textColor = HexRGB(0x666666);
        _companyIntrudctionLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        [_scroll addSubview:_companyIntrudctionLabel];
    }
    return self;
}

#pragma mark -设置数据
- (void)setData:(comHomeModel *)data
{
    _data = data;
      //  先计算各个控件的frame
    _headFrame = [[CompangHomeHeadFrame alloc] init];
    _headFrame.data = _data;
    

    // 1 图片
    _image.frame = _headFrame.imageFrame;
    [_image setImageWithURL:[NSURL URLWithString:_data.image] placeholderImage:[UIImage imageNamed:@"loading.png"] options:(SDWebImageLowPriority||SDWebImageRetryFailed)];
    
    // 2 公司名称
    _companyName.frame = _headFrame.companyNameFrame;
    _companyName.text = data.name;
    
    //3 vip
    _vipImg.frame = _headFrame.vipIconFrame;
    NSString *imgName = nil;
    switch ([data.viptype intValue]) {
        case -1:
        {
            imgName = @"Vip6.png";
        }
            break;
        case 0:
        {
            imgName = @"Vip5.png";
        }
            break;
        case 1:
        {
            imgName = @"Vip4.png";
        }
            break;
        case 2:
        {
            imgName = @"Vip3.png";
            
        }
            break;
        case 3:
        {
            imgName = @"Vip2.png";
            
        }
            break;
        case 4:
        {
            imgName = @"Vip1.png";
            
        }
            break;
            
        default:
            break;
    }
    _vipImg.image = [UIImage imageNamed:imgName];
    
    //4 ePlatformFrame
    _company_E.frame = _headFrame.ePlatformFrame;
    if ([data.e_url isKindOfClass:[NSNull class]]) {
        [_company_E setImage:[UIImage imageNamed:@"company_e_pre.png"] forState:UIControlStateNormal];
//        _company_E.enabled = NO;
    }else{
        [_company_E setImage:[UIImage imageNamed:@"company_E_btn.png"] forState:UIControlStateNormal];
//        _company_E.enabled = YES;
    }
    [_company_E addTarget:self action:@selector(ebingooE) forControlEvents:UIControlEventTouchDragOutside];
    //第一段分割线

    UIImageView *linView =[[UIImageView alloc]init];
    linView.image =[UIImage imageNamed:@"bg_homeCodition.png"];
    linView.frame = _headFrame.firstLineFrame;
    [_scroll addSubview:linView];
    
    CGFloat startX = _headFrame.imageFrame.origin.x + KBoardWitch;
 
    //    电话
    
    if (data.tel.length != 0) {
        UIImageView *_phoneImage =[[UIImageView alloc]initWithFrame:CGRectMake(startX, _headFrame.telFrame.origin.y, KIconWH, KIconWH )];
        _phoneImage.image =[UIImage imageNamed:@"phone_pany.png"];
        [_scroll addSubview:_phoneImage];
        
        
        _telphoneLabel.frame = _headFrame.telFrame;
        _telphoneLabel.text =[NSString stringWithFormat:@"电话:%@",data.tel];
        //地址
    }
    
    //    网址
    if (data.website.length != 0) {
        UIImageView *_urlImage =[[UIImageView alloc]initWithFrame:CGRectMake(startX, _headFrame.webUrlFrame.origin.y, KIconWH, KIconWH )];
        _urlImage.image =[UIImage imageNamed:@"website_url.png"];
        [_scroll addSubview:_urlImage];
        
        
        _urlLabel.frame = _headFrame.webUrlFrame;
        _urlLabel.text =[NSString stringWithFormat:@"网址:%@",data.website];
        //地址
    }
 
    if (data.addr.length != 0) {
        UIImageView *_addrImage =[[UIImageView alloc]initWithFrame:CGRectMake(startX, _headFrame.addressFrame.origin.y, KIconWH, KIconWH )];
        _addrImage.image =[UIImage imageNamed:@"place_company.png"];
        [_scroll addSubview:_addrImage];
        
        
        _addessLabel.frame = _headFrame.addressFrame;
        _addessLabel.text =[NSString stringWithFormat:@"地址:%@",data.addr];
        //地址
    }

    //第二段分割线
    UIImageView *linView2 =[[UIImageView alloc]init];
    linView2.image =[UIImage imageNamed:@"bg_homeCodition.png"];
    linView2.frame = _headFrame.secLineFrame;
    [_scroll addSubview:linView2];
    
    // mainBusiness
    
    UILabel * business = [[UILabel alloc ] init];
    business.text = @"【主营范围】";
    business.backgroundColor =[UIColor clearColor];
    business.textColor = HexRGB(0x3a3a3a);
    business.font =[UIFont systemFontOfSize:PxFont(20)];
    business.frame = _headFrame.mainFrame;
    [_scroll addSubview:business];
    
    _mainBusinessLabel.text =data.mainRun;
    _mainBusinessLabel.frame = _headFrame.mainBusinessFrame;
    
    //第三段分割线
    UIImageView *linView3 =[[UIImageView alloc]init];
    linView3.image =[UIImage imageNamed:@"bg_homeCodition.png"];
    linView3.frame = _headFrame.thirdLineFrame;
    [_scroll addSubview:linView3];
    
    
    UILabel * companyI = [[UILabel alloc ] init];
    companyI.text = @"【公司简介】";
    companyI.backgroundColor =[UIColor clearColor];
    companyI.textColor = HexRGB(0x3a3a3a);
    companyI.font =[UIFont systemFontOfSize:PxFont(20)];
    companyI.frame = CGRectMake(_headFrame.imageFrame.origin.x, CGRectGetMaxY(linView3.frame) + KViewBorderWidth, 200, KMainFont);
    [_scroll addSubview:companyI];
    
    _companyIntrudctionLabel.text =data.introduction;
    _companyIntrudctionLabel.frame = _headFrame.companyIntrudctionFrame;
    
    //第四段分割线
    UIImageView *linView4 =[[UIImageView alloc]init];
    linView4.image =[UIImage imageNamed:@"bg_homeCodition.png"];
    linView4.frame = _headFrame.fourthLineFrame;
    [_scroll addSubview:linView4];
    
    

    //判断是否有具体公司信息
    UILabel *noCompanginfo = [[UILabel alloc] init];
    UILabel *companyinfo = [[UILabel alloc] init];
    UILabel *noCompang = [[UILabel alloc] init];

    if ([data.infoarray isKindOfClass:[NSNull class]]) {

        noCompang.text = @"【近期供求】";
        noCompang.backgroundColor =[UIColor clearColor];
        noCompang.textColor = HexRGB(0x3a3a3a);
        noCompang.font =[UIFont systemFontOfSize:PxFont(20)];
        noCompang.frame = CGRectMake(_headFrame.imageFrame.origin.x, CGRectGetMaxY(linView4.frame) + KViewBorderWidth, 200, KMainFont);
        [_scroll addSubview:noCompang];
        
        noCompanginfo.text = @"暂无近期供求！";
        noCompanginfo.textColor =HexRGB(0x666666);
        noCompanginfo.font = [UIFont systemFontOfSize:PxFont(17)];
        noCompanginfo.hidden = NO;
        
        companyinfo.hidden = YES;
        noCompanginfo.frame = CGRectMake(_headFrame.imageFrame.origin.x+120, 20+CGRectGetMaxY(linView4.frame) + KViewBorderWidth, 200, KMainFont);
        _scroll.contentSize = CGSizeMake(kWidth, CGRectGetMaxY(noCompanginfo.frame) ) ;
        [_scroll addSubview:noCompanginfo];

   }else{
       

    NSInteger count = data.infoarray.count;
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:count];
    for (NSDictionary *dict in data.infoarray)
    {
        comPanyModel *hotModel = [[comPanyModel alloc]initWithDictionaryForComapnyBtn:dict];
        [array addObject:hotModel];
    }
    _comPanyArray = array;
       
       
       
       companyinfo.text = @"【近期供求】";
       companyinfo.backgroundColor =[UIColor clearColor];
       companyinfo.textColor = HexRGB(0x3a3a3a);
       companyinfo.font =[UIFont systemFontOfSize:PxFont(20)];
       companyinfo.frame = CGRectMake(_headFrame.imageFrame.origin.x, CGRectGetMaxY(linView4.frame) + KViewBorderWidth, 200, KMainFont);
       [_scroll addSubview:companyinfo];
        noCompanginfo.hidden = YES;
        companyinfo.hidden = NO;
       noCompang.hidden = YES;

       
        
        CGFloat supplyStartY = CGRectGetMaxY(companyinfo.frame) + KViewBorderWidth;
        for (int i = 0; i < count; i++) {
            supplyRecentlyView * recent = [[supplyRecentlyView alloc] initWithFrame:CGRectMake(0, supplyStartY + i*30, kWidth, 30)];
            recent.data = [_comPanyArray objectAtIndex:i];
            recent.tag = i;
            [_scroll addSubview:recent];
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
            [recent addGestureRecognizer:tap];
        }
        _scroll.contentSize = CGSizeMake(kWidth, supplyStartY+ (30 *count )) ;
    }
}
#pragma mark 点击供应视图
- (void)tapGesture :(UITapGestureRecognizer *) myView
{
    supplyRecentlyView *view = (supplyRecentlyView*)myView.view;
    comPanyModel *data =  view.data;
    _clickBlock(data);
}


- (void)setFrame:(CGRect)frame
{

    _scroll.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [super setFrame:frame];
}

- (void)ebingooE
{
    if ([_delegate respondsToSelector:@selector(CompanyHomeView:)]) {
        [_delegate CompanyHomeView:self];
    }
}



@end
