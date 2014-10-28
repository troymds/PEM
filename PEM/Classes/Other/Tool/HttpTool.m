
#import "HttpTool.h"
#import "AFHTTPClient.h"
#import <objc/message.h>
#import "AHReach.h"
#import "RemindView.h"

@implementation HttpTool
+ (void)requestWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure method:(NSString *)method
{
    // 1.创建post请求
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:kURL]];

    NSMutableDictionary *allParams = [NSMutableDictionary dictionary];
//    // 拼接传进来的参数
    if (params) {
        [allParams setDictionary:params];
    }
    NSString *time =[DateManeger getCurrentTimeStamps];
    NSString *uuid = [SystemConfig sharedInstance].uuidStr;
    NSString *md5 = [NSString stringWithFormat:@"%@%@%@",uuid,time,@"hdy782634j23487sdfkjw3486"];
    md5 = [md5 md5Encrypt];
        
    [allParams setObject:time forKey:@"time"];
    [allParams setObject:uuid forKey:@"uuid"];
    [allParams setObject:md5 forKey:@"secret"];
    NSString *pathStr = [NSString stringWithFormat:@"ebingoo/index.php?s=/Home/Api/%@",path];
   
     [client postPath:pathStr parameters:allParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        failure(error);
       
    }];
    
    
//    
//    struct sockaddr_in addr;
//	memset(&addr, 0, sizeof(struct sockaddr_in));
//	addr.sin_len = sizeof(struct sockaddr_in);
//	addr.sin_family = AF_INET;
//	addr.sin_port = htons(80);
//	inet_aton("218.244.149.129", &addr.sin_addr);
//    
//    
    AHReach *defaultHostReach = [AHReach reachForDefaultHost];
	[defaultHostReach startUpdatingWithBlock:^(AHReach *reach) {
		[self updateAvailabilityFieldWithReach:reach];
	}];
	[self updateAvailabilityFieldWithReach:defaultHostReach];
    
//	AHReach *addressReach = [AHReach reachForAddress:&addr];
//	[addressReach startUpdatingWithBlock:^(AHReach *reach) {
//		[self updateAvailabilityFieldWithReach:reach];
//	}];
//	[self updateAvailabilityFieldWithReach:addressReach];
//    
}

+ (void)updateAvailabilityFieldWithReach:(AHReach *)reach
{
    if([reach isReachableViaWWAN])
    {
        //[RemindView showViewWithTitle:@"已连接上网络！" location:BELLOW];
    }else if([reach isReachableViaWiFi])
    {
        //[RemindView showViewWithTitle:@"已经连接WiFi" location:BELLOW];
    }else
    {
        [RemindView showViewWithTitle:@"网络断开，请检测网络！" location:BELLOW];
    }
}




+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    [self requestWithPath:path params:params success:success failure:failure method:@"POST"];
}

+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{

    [self requestWithPath:path params:params success:success failure:failure method:@"GET"];
}
+ (void)downloadImage:(NSString *)url place:(UIImage *)place imageView:(UIImageView *)imageView
{
    [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:place options:SDWebImageLowPriority | SDWebImageRetryFailed];
}
@end
