
#import "HttpTool.h"
#import "AFHTTPClient.h"
#import <objc/message.h>

@implementation HttpTool
+ (void)requestWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure method:(NSString *)method
{
    // 1.创建post请求
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:kBaseURL]];

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
    NSString *pathStr = [NSString stringWithFormat:@"eb/index.php?s=/Home/Api/%@",path];
   
     [client postPath:pathStr parameters:allParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
       
      
        
      
        failure(error);
        
       
    }];
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
