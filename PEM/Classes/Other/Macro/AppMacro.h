
#ifndef MoneyMaker_AppMacro_h
#define MoneyMaker_AppMacro_h

//首次启动
#define First_Launched @"firstLaunch"

//系统版本
#define IsIos7 [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0 ? YES : NO
#define isRetina [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960),[[UIScreen mainScreen] currentMode].size) : NO

#define iPhone5 [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO

#define _iPhone4 ([UIScreen mainScreen].bounds.size.height == 480)
#define _iPhone5 ([UIScreen mainScreen].bounds.size.height == 568)
#define _iPhone6 ([UIScreen mainScreen].bounds.size.height == 667)

#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif

//加载图片
//#define LOADIMAGE(file,type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:type]]
//#define LOADPNGIMAGE(file) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:@"png"]]
#define LOADPNGIMAGE(file) [UIImage imageNamed:file]
#define Rect(x,y,width,height) CGRectMake(x, y, width, height)
//可拉伸的图片

#define ResizableImage(name,top,left,bottom,right) [[UIImage imageNamed:name] resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right)]
#define ResizableImageWithMode(name,top,left,bottom,right,mode) [[UIImage imageNamed:name] resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right) resizingMode:mode]

//App
#define kApp ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define kNav ((AppDelegate *)[UIApplication sharedApplication].delegate.navigationController)

//color
#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]//十六进制转换

#define linColor   [UIColor colorWithRed:(45.0/ 255.0) green:(129.0 / 255.0) blue:(229.0 / 255.0) alpha:1.0]//线条颜色
#define titleColor
#define backGroundColor    [UIColor colorWithRed:(226.0/ 255.0) green:(226.0 / 255.0) blue:(226.0 / 255.0) alpha:1.0]//背景颜色
#define TextRGBColor     [UIColor colorWithRed:(48.0 / 255.0) green:(136.0 / 255.0) blue:(213.0 / 255.0) alpha:1.0]//蓝色字体颜色
#define RGBNAVbackGroundColor             [UIColor colorWithRed:(47.0 / 255.0) green:(138.0 / 255.0) blue:(201.0/ 255.0) alpha:1.0]//导航条的颜色
#define RGBAlpha(r, g, b, a)     [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define PxFont(px) (((float) px/96)*72)//字体大小转换

//设备屏幕尺寸
#define kHeight   [UIScreen mainScreen].bounds.size.height
#define kWidth    [UIScreen mainScreen].bounds.size.width

//拨打电话
#define canTel                 [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel:"]
#define tel(phoneNumber)      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]]]
#define telprompt(phoneNumber) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",phoneNumber]]]

//打开URL
#define canOpenURL(appScheme) [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appScheme]]
#define openURL(appScheme) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appScheme]]
#endif



//判断字典dic中键key对应的值是否为空
#define isNull(dic,key) [[dic objectForKey:key] isKindOfClass:[NSNull class]]?YES:NO




#define SUPPLY_DATA  @"supplyData"
#define PURCHASE_DATA @"purchaseData"

//从哪里进入的登录界面
#define SETTING_TYPE @"companySetting"
#define DIRECT_TYPE @"loginBtn"
#define MENU_TYPE @"nemu"

//进入注册界面的类型
#define UPDATE_TYPE @"update"   //特权页面进入注册界面
#define PUBLISH_TYPE @"publish" //发布页面进入注册页面


//进入企业设置界面的类型
#define DERECT_SET_TYPE @"derectSet"      //企业设置直接进入
#define NONDERECT_SET_TYPE @"otherSet"    //其他界面进入




#define kBaseURL @"http://218.244.149.129"
#define kURL @"http://192.168.1.155"

