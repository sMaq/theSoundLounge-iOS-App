//
//  AppSettings.m
//  Virtual Reception
//
//  Created by Muhammad Ubaid on 2/12/14.
//  Copyright (c) 2014 Muhammad Ubaid. All rights reserved.
//

#import "AppSettings.h"
#import "AppDelegate.h"
static AppSettings *appSettings;

@implementation AppSettings
@synthesize isCallInProgressForData, isCallInProgressForLanguage;

+ (AppSettings*)sharedAppSettings
{
    if (!appSettings) {
        appSettings = [[AppSettings alloc] init];
    }
    return appSettings;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.isCallInProgressForLanguage = NO;
        self.isCallInProgressForData = NO;
    }
    return self;
}
-(void)setUserPassword:(NSString *)password{
    [[NSUserDefaults standardUserDefaults] setValue:password forKey:@"user_password"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
-(NSString*)getUserPassword{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userPass = [userDefaults objectForKey:@"user_password"];
    if (!userPass) {
        userPass=@"";
    }
    return userPass;
}

-(NSString*)getUserDeviceToken{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults objectForKey:@"devicetoken"];
    if (!string) {
        string=@"";
    }
    return string;
}
-(void)setUserDeviceToken:(NSString *)string{
    [[NSUserDefaults standardUserDefaults] setValue:string forKey:@"devicetoken"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
-(NSString*)getRecieverUserName{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults objectForKey:@"recieverusername"];
    if (!string) {
        string=@"";
    }
    return string;
}
-(void)setRecieverUserName:(NSString *)string{
    [[NSUserDefaults standardUserDefaults] setValue:string forKey:@"recieverusername"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
-(NSString*)getRecieverUserTime{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults objectForKey:@"recievertime"];
    if (!string) {
        string=@"";
    }
    return string;
}
-(void)setRecieverUserTime:(NSString *)string{
    [[NSUserDefaults standardUserDefaults] setValue:string forKey:@"recievertime"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
-(NSString*)getUserFirstname{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults objectForKey:@"firstname"];
    if (!string) {
        string=@"";
    }
    return string;
}
-(void)setUserFirstname:(NSString *)string{
    [[NSUserDefaults standardUserDefaults] setValue:string forKey:@"firstname"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
-(NSString*)getUserLongitude{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults objectForKey:@"longitude"];
    if (!string) {
        string=@"";
    }
    return string;
}
-(void)setUserLongitude:(NSString *)string{
    [[NSUserDefaults standardUserDefaults] setValue:string forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
-(NSString*)getUserlatitude{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults objectForKey:@"latitude"];
    if (!string) {
        string=@"";
    }
    return string;
}
-(void)setUserlatitude:(NSString *)string{
    [[NSUserDefaults standardUserDefaults] setValue:string forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
-(NSString*)getUserCategory{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults objectForKey:@"category"];
    if (!string) {
        string=@"";
    }
    return string;
}
-(void)setUserCategory:(NSString *)string{
    [[NSUserDefaults standardUserDefaults] setValue:string forKey:@"category"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
-(NSString*)getUserType{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults objectForKey:@"type"];
    if (!string) {
        string=@"";
    }
    return string;
}
-(void)setUserType:(NSString *)string{
    [[NSUserDefaults standardUserDefaults] setValue:string forKey:@"type"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
-(NSString*)getUserPhase{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults objectForKey:@"phase"];
    if (!string) {
        string=@"";
    }
    return string;
}
-(void)setUserPhase:(NSString *)string{
    [[NSUserDefaults standardUserDefaults] setValue:string forKey:@"phase"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
-(NSString*)getUserPhone{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults objectForKey:@"phone"];
    if (!string) {
        string=@"";
    }
    return string;
}
-(void)setUserPhone:(NSString *)string{
    [[NSUserDefaults standardUserDefaults] setValue:string forKey:@"phone"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
-(NSString*)getUserTitle{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults objectForKey:@"title"];
    if (!string) {
        string=@"";
    }
    return string;
}
-(void)setUserTitle:(NSString *)string{
    [[NSUserDefaults standardUserDefaults] setValue:string forKey:@"title"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
-(NSString*)getUserDefaultlanguage{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults objectForKey:@"defaultlanguage"];
    if (!string) {
        string=@"";
    }
    return string;
}
-(void)setUserDefaultlanguage:(NSString *)string{
    [[NSUserDefaults standardUserDefaults] setValue:string forKey:@"defaultlanguage"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
-(BOOL)getUserVerified{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL varified = [userDefaults boolForKey:@"verified"];
    return varified;
}
-(void)setUserVerified:(BOOL )varified{
    [[NSUserDefaults standardUserDefaults] setBool:varified forKey:@"verified"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}


-(NSString*)getUserVerificationGUID{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults objectForKey:@"verificationGUID"];
    if (!string) {
        string=@"";
    }
    return string;
}
-(void)setUserVerificationGUID:(NSString *)string{
    [[NSUserDefaults standardUserDefaults] setValue:string forKey:@"verificationGUID"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
-(NSString*)getUserPhotoUrl{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults objectForKey:@"photourl"];
    if (!string) {
        string=@"";
    }
    return string;
}
-(void)setUserPhotoUrl:(NSString *)string{
    [[NSUserDefaults standardUserDefaults] setValue:string forKey:@"photourl"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
-(NSString*)getUserSignatureUrl{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults objectForKey:@"signatureurl"];
    if (!string) {
        string=@"";
    }
    return string;
}
-(void)setUserSignatureUrl:(NSString *)string{
    [[NSUserDefaults standardUserDefaults] setValue:string forKey:@"signatureurl"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
-(NSString*)getUserInvitationGUID{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults objectForKey:@"invitationGUID"];
    if (!string) {
        string=@"";
    }
    return string;
}

-(void)setUserInvitationGUID:(NSString *)string{
    [[NSUserDefaults standardUserDefaults] setValue:string forKey:@"invitationGUID"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

-(NSString*)getUserMailGUID{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults objectForKey:@"mailGUID"];
    if (!string) {
        string=@"";
    }
    return string;
}
-(void)setUserMailGUID:(NSString *)string{
    [[NSUserDefaults standardUserDefaults] setValue:string forKey:@"mailGUID"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}



- (void)saveUserSignature:(NSData *)imgData{
    [[NSUserDefaults standardUserDefaults]setObject:imgData forKey:@"signatureImg"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (NSData*)getUserSignature{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"signatureImg"];
    
}
- (void)setDataUpdateStartTime:(NSDate*)time
{
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"data_Update_Start_Time"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDate*)getDataUpdateStartTime
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *time = [userDefaults objectForKey:@"data_Update_Start_Time"];
    
    return time;
}
- (void)setAccessToken:(NSString*)arg
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:arg forKey:@"AccessToken"];
    
    [userDefaults synchronize];
}

- (NSString*)getAccessToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *resp = [userDefaults objectForKey:@"AccessToken"];
    
    return resp;
}
-(void)setUserLoggedIn:(BOOL)isLoggedIn{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isLoggedIn forKey:@"userLoggedIn"];
    [userDefaults synchronize];
}
-(BOOL)isUserLoggedIn{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL resp = [userDefaults boolForKey:@"userLoggedIn"];
    
    return resp;
}
//- (void)setContentsUpdateTime:(NSInteger)timeInMin
//{
//    [[NSUserDefaults standardUserDefaults] setInteger:timeInMin forKey:@"ContentsUpdateTime"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//- (NSInteger)getContentsUpdateTime
//{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSInteger timeInMin = [userDefaults integerForKey:@"ContentsUpdateTime"];
//
//    return timeInMin;
//}

- (void)setUserName:(NSString*)userName
{
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"UserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)getUserName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults objectForKey:@"UserName"];
    if(!userName)
        userName = @"";
    return userName;
}

- (void)setRememberCredentials:(BOOL) pState
{
    [[NSUserDefaults standardUserDefaults] setBool:pState forKey:@"RememberCredentials"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)getRememberCredentials
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL state = [userDefaults boolForKey:@"RememberCredentials"];
    return state;
}






//
//- (void)setUserInitial:(NSString*)userName
//{
//    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"UserInitial"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//- (NSString*)getUserInitial
//{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *userName = [userDefaults objectForKey:@"UserInitial"];
//    if(!userName)
//        userName = @"";
//    return userName;
//}

//- (void)setUserMail:(NSString*)mail
//{
//    [[NSUserDefaults standardUserDefaults] setObject:mail forKey:@"UserMail"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

//- (NSString*)getUserMail
//{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *userMail = [userDefaults objectForKey:@"UserMail"];
//    if(!userMail)
//        userMail = @"";
//    return userMail;
//}

//- (void)setUserPhone:(NSString*)phone
//{
//    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:@"UserPhone"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//- (NSString*)getUserPhone
//{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *userPhone = [userDefaults objectForKey:@"UserPhone"];
//    if(!userPhone)
//        userPhone = @"";
//    return userPhone;
//}

//- (void)setPassword:(NSString*)password
//{
//    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"Password"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

//- (NSString*)getPassword
//{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *password = [userDefaults objectForKey:@"Password"];
//    if(!password)
//        password = @"";
//    return password;
//}
//-(void) setCountryID:(NSString *)countryID{
//    [[NSUserDefaults standardUserDefaults] setObject:countryID forKey:@"CountryID"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//-(NSString*)getCountryID{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *countryID = [userDefaults objectForKey:@"CountryID"];
//    if(!countryID)
//        countryID = @"";
//    return countryID;
//}


//-(void) setOfferValue:(NSString *)offerValue{
//    [[NSUserDefaults standardUserDefaults] setObject:offerValue forKey:@"offerValue"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//-(NSString*)getOfferValue{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *offerValue = [userDefaults objectForKey:@"offerValue"];
//    if(!offerValue)
//        offerValue = @"";
//    return offerValue;
//}

- (void)setTokenExpireTime:(NSString*)time
{
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"cache_expired_time"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)getCacheExpireTime
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *time = [userDefaults objectForKey:@"cache_expired_time"];
    if(!time)
        time = @"";
    return time;
}

//- (void)setLoginState:(BOOL)state
//{
////    if (!state) {
////        [(AppDelegate*)[[UIApplication sharedApplication] delegate] appLoggedOut];
////    }
//    
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:state] forKey:@"UserLoginState"];
////    [[NSUserDefaults standardUserDefaults] setBool:state forKey:@"UserLoginState"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//- (BOOL)loginState
//{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSNumber *state = [userDefaults objectForKey:@"UserLoginState"];
//
//    if (!state) {
//        return NO;
//    }
//    return [state boolValue];
//}

//- (void)setSuggestionEditState:(BOOL)state
//{
//    [[NSUserDefaults standardUserDefaults] setBool:state forKey:@"SuggestionEditState"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

//- (BOOL)suggestionEditState
//{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    BOOL state = [userDefaults boolForKey:@"SuggestionEditState"];
//    
//    return state;
//}
//
//- (void)setAutoLoginState:(BOOL)state
//{
//    [[NSUserDefaults standardUserDefaults] setBool:state forKey:@"AutoLoginState"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//- (BOOL)autoLoginState
//{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    BOOL state = [userDefaults boolForKey:@"AutoLoginState"];
//
//    return state;
//}


-(void) logoutUser{
    [self setUserLoggedIn:NO];
    BOOL state = [[AppSettings sharedAppSettings] getRememberCredentials];
    if (state == NO) {
      [self setUserPassword:nil];
    }
  
    [self setUserDeviceToken:nil];
    [self setUserFirstname:nil];
    [self setUserLastname:nil];
    [self setUserPhase:nil];
    [self setUserPhone:nil];
    [self setUserTitle:nil];
    [self setUserDefaultlanguage:nil];
    [self setUserVerified:nil];
    [self setUserVerificationGUID:nil];
    [self setUserPhotoUrl:nil];
    [self setUserSignatureUrl:nil];
    [self setUserInvitationGUID:nil];
    [self setUserMailGUID:nil];
    [self saveUserSignature:nil];
    [self setDataUpdateStartTime:nil];
    [self setAccessToken:nil];

//    [self setUserName:nil];
    
}

//-(void) populateWithUserDic:(NSDictionary*) userInfoDic{
//    [self setUserName:([userInfoDic objectForKey:@"username"]!= [NSNull null])?[userInfoDic objectForKey:@"username"]:@""];
////    [self setUserPassword:([userInfoDic objectForKey:@"password"]!= [NSNull null])?[userInfoDic objectForKey:@"password"]:@""];
//    [self setUserDeviceToken:([userInfoDic objectForKey:@"companyname"]!= [NSNull null])?[userInfoDic objectForKey:@"companyname"]:@""];
//    [self setUserFirstname:([userInfoDic objectForKey:@"firstname"]!= [NSNull null])?[userInfoDic objectForKey:@"firstname"]:@""];
//    [self setUserLastname:([userInfoDic objectForKey:@"lastname"]!= [NSNull null])?[userInfoDic objectForKey:@"lastname"]:@""];
//    [self setUserPhase:([userInfoDic objectForKey:@"phase"]!= [NSNull null])?[userInfoDic objectForKey:@"phase"]:@""];
//    [self setUserPhone:([userInfoDic objectForKey:@"phone"]!= [NSNull null])?[userInfoDic objectForKey:@"phone"]:@""];
//    [self setUserTitle:([userInfoDic objectForKey:@"title"]!= [NSNull null])?[userInfoDic objectForKey:@"title"]:@""];
//    [self setUserDefaultlanguage:([userInfoDic objectForKey:@"defaultlanguage"]!= [NSNull null])?[userInfoDic objectForKey:@"defaultlanguage"]:@""];
//    [self setUserVerified:([userInfoDic objectForKey:@"verified"]!= [NSNull null])?[[userInfoDic objectForKey:@"verified"] boolValue]:NO];
//    [self setUserVerificationGUID:([userInfoDic objectForKey:@"verificationGUID"]!= [NSNull null])?[userInfoDic objectForKey:@"verificationGUID"]:@""];
//    NSString* photoName = ([userInfoDic objectForKey:@"photourl"]!= [NSNull null])?[userInfoDic objectForKey:@"photourl"]:@"";
//    NSString* photoUrlStr = [NSString stringWithFormat:@"%@%@/%@/%@",URL_WS3_Amazone,[self getUserCompanyname],[self getUserName],photoName];
//    [self setUserPhotoUrl:photoUrlStr];
//    
//    NSString* sigFileName = ([userInfoDic objectForKey:@"signatureurl"]!= [NSNull null])?[userInfoDic objectForKey:@"signatureurl"]:@"";
//    NSString* sigUrlStr = [NSString stringWithFormat:@"%@%@/%@/%@",URL_WS3_Amazone,[self getUserCompanyname],[self getUserName],sigFileName];
//  [self setUserSignatureUrl:sigUrlStr];
//    
//    [self setUserMailGUID:([userInfoDic objectForKey:@"mailGUID"]!= [NSNull null])?[userInfoDic objectForKey:@"mailGUID"]:@""];
//    [self setUserInvitationGUID:([userInfoDic objectForKey:@"invitationGUID"]!= [NSNull null])?[userInfoDic objectForKey:@"invitationGUID"]:@""];
//}


@end
