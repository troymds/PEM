//
//  phoneView.m
//  PEM
//
//  Created by YY on 14-9-18.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "phoneView.h"
#define kCallSetupTime      3.0

@interface phoneView ()
@property (nonatomic, strong) NSDate *callStartTime;

@property (nonatomic, copy) ACETelCallBlock callBlock;
@property (nonatomic, copy) ACETelCancelBlock cancelBlock;
@property (nonatomic, copy) ACETelBackBlock backBlock;
@end

@implementation phoneView
+ (instancetype)sharedInstance
{
    static phoneView *_instance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

+ (BOOL)callPhoneNumber:(NSString *)phoneNumber
                   call:(ACETelCallBlock)callBlock
                 cancel:(ACETelCancelBlock)cancelBlock finish:(ACETelBackBlock)backBlock
{
    if ([self validPhone:phoneNumber]) {
        
        phoneView *telPrompt = [phoneView sharedInstance];
        
        // observe the app notifications
        [telPrompt setNotifications];
        
        // set the blocks
        telPrompt.callBlock = callBlock;
        telPrompt.cancelBlock = cancelBlock;
        telPrompt.backBlock = backBlock;
        
        // clean the phone number
        NSString *simplePhoneNumber =
        [[phoneNumber componentsSeparatedByCharactersInSet:
          [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        
        // call the phone number using the telprompt scheme
        NSString *stringURL = [@"telprompt://" stringByAppendingString:simplePhoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringURL]];
        
        return YES;
    }
    return NO;
}

+ (BOOL)validPhone:(NSString*) phoneString
{
    NSTextCheckingType type = [[NSTextCheckingResult phoneNumberCheckingResultWithRange:NSMakeRange(0, phoneString.length)
                                                                            phoneNumber:phoneString] resultType];
    return type == NSTextCheckingTypePhoneNumber;
}


#pragma mark - Notifications

- (void)setNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
}


#pragma mark - Events

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    // save the time of the call
    self.callStartTime = [NSDate date];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    // now it's time to remove the observers
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.callStartTime != nil) {
        
        
        // I'm coming back after a call
        if (self.callBlock != nil) {
            self.callBlock(-([self.callStartTime timeIntervalSinceNow]) - kCallSetupTime);
        }
        if (self.backBlock !=nil) {
            self.backBlock();
        }
        // reset the start timer
        self.callStartTime = nil;
        
    } else if (self.cancelBlock != nil) {
        
        // user didn't start the call
        self.cancelBlock();
    }
}

@end
