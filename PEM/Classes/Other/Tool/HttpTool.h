

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "NSString+MD5.h"
#import "SystemConfig.h"
#import "DateManeger.h"
#import "UIImageView+WebCache.h"
#import "AHReach.h"

typedef void (^HttpSuccessBlock)(id JSON);
typedef void (^HttpFailureBlock)(NSError *error);

@interface HttpTool : NSObject


+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;
+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;
+ (void)downloadImage:(NSString *)url place:(UIImage *)place imageView:(UIImageView *)imageView;


+ (void)updateAvailabilityFieldWithReach:(AHReach *)reach;
@end