

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "NSString+MD5.h"
#import "SystemConfig.h"
#import "DateManeger.h"
#import "UIImageView+WebCache.h"
//#import "AFHTTPRequestOperationManager.h"
@protocol HttpDownloadDelegate;

typedef void (^HttpSuccessBlock)(id JSON);
typedef void (^HttpFailureBlock)(NSError *error);

@interface HttpTool : NSObject
@property (nonatomic,strong) NSError * error;

@property (nonatomic,weak) __weak id<HttpDownloadDelegate>delegate;

+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;
+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;
+ (void)downloadImage:(NSString *)url place:(UIImage *)place imageView:(UIImageView *)imageView;
@end