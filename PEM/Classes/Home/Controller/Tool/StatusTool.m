
#import "StatusTool.h"
#import "HttpTool.h"
#import "Status.h"

@implementation StatusTool
+ (void)statusesWithSuccess:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure
{

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"ios",@"os",@"0",@"lastid", nil];
    [HttpTool postWithPath:@"getIndex" params:dic success:^(id JSON) {
        
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];

        NSMutableArray *statuses =[NSMutableArray array];

        NSDictionary *dict =d[@"response"];
        
        if ([dict isKindOfClass:[NSNull class]])
        {}else{
            Status *s =[[Status alloc] initWithDict:dict];

        [statuses addObject:s];
        
        success(statuses);
        }
    } failure:^(NSError *error) {
        if (failure==nil)return ; {
            failure(error);

        }
    }];
    
   
  
}



@end
