
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
//占位图片
#define placeHoderImage [UIImage imageNamed:@"load_big.png"]

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


#define backGroundColor    [UIColor colorWithRed:(226.0/ 255.0) green:(226.0 / 255.0) blue:(226.0 / 255.0) alpha:1.0]//背景颜色
#define RGBNAVbackGroundColor             [UIColor colorWithRed:(47.0 / 255.0) green:(138.0 / 255.0) blue:(201.0/ 255.0) alpha:1.0]//导航条的颜色
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

#define kBaseURL @"http://ebingoo.bingoso.com"
#define kURL @"http://192.168.1.155"


// 2.日志输出宏定义
#ifdef DEBUG
// 调试状态
#define NSLog(...) NSLog(__VA_ARGS__)
#else
// 发布状态
#define NSLog(...)
#endif

#define KCompanyMenuItemW   kWidth/3
#define KCompanyMenuItemH   30

// ---------------------公司首页页面
// 图标
#define kIconSmallW 34
#define kIconSmallH 34

#define kIconDefaultW 105
#define kIconDefaultH 74

#define kIconBigW 85
#define kIconBigH 85

#define KViewBorderWidth 10 //距离边界的大小
#define KLineH      16  // 线条图片的高度
#define KBoardWitch  10   // 图片和公司名称的间距
#define KVIPW     18        //vip图片的宽度
#define KVIPH      25       //vip图片的高度

#define KNumberOfText    11  //   一行显示的字数
#define KWordSpace     12     //vip图标和 第二行文字的间隔

#define KEPlatFormW  100  //E平台按钮宽度
#define KEplatFormH  30  //E平台按钮高度
#define KMainFont 40
#define KIconWH 12   //小图标的宽高
