//
//  AppSettings.h
//  Virtual Reception
//
//  Created by Muhammad Ubaid on 2/12/14.
//  Copyright (c) 2014 Muhammad Ubaid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSettings : NSObject

@property (nonatomic, assign) BOOL isCallInProgressForLanguage;
@property (nonatomic, assign) BOOL isCallInProgressForData;

+ (AppSettings*)sharedAppSettings;
- (void)setUserPassword:(NSString *)password;
- (NSString*)getUserPassword;
- (NSString*)getUserDeviceToken;
- (void)setUserDeviceToken:(NSString *)string;
- (NSString*)getRecieverUserName;
- (void)setRecieverUserName:(NSString *)string;
- (NSString*)getRecieverUserTime;
- (void)setRecieverUserTime:(NSString *)string;


- (NSString*)getUserFirstname;
- (void)setUserlatitude:(NSString *)string;
- (NSString *)getUserlatitude;
- (void)setUserLongitude:(NSString *)string;
- (NSString*)getUserLongitude;
-(void)setUserType:(NSString *)string;
- (NSString*)getUserType;
-(void)setUserCategory:(NSString *)string;
- (NSString*)getUserCategory;

- (void)setUserLastname:(NSString *)string;
- (NSString*)getUserPhase;
- (void)setUserPhase:(NSString *)string;
- (NSString*)getUserPhone;
- (void)setUserPhone:(NSString *)string;
- (NSString*)getUserTitle;
- (void)setUserTitle:(NSString *)string;
- (NSString*)getUserDefaultlanguage;
- (void)setUserDefaultlanguage:(NSString *)string;
- (BOOL)getUserVerified;
- (void)setUserVerified:(BOOL )varified;
- (NSString*)getUserVerificationGUID;
- (void)setUserVerificationGUID:(NSString *)string;
- (NSString*)getUserPhotoUrl;
- (void)setUserPhotoUrl:(NSString *)string;
- (NSString*)getUserSignatureUrl;
-(void)setUserSignatureUrl:(NSString *)string;

- (NSString*)getUserInvitationGUID;
- (void)setUserInvitationGUID:(NSString *)string;
- (NSString*)getUserMailGUID;
- (void)setUserMailGUID:(NSString *)string;
- (void)saveUserSignature:(NSData *)imgData;
- (NSData*)getUserSignature;
- (void)setDataUpdateStartTime:(NSDate*)time;
- (NSDate*)getDataUpdateStartTime;
- (void)setAccessToken:(NSString*)arg;
- (NSString*)getAccessToken;
- (void)setUserLoggedIn:(BOOL)isLoggedIn;
- (BOOL)isUserLoggedIn;
//- (void)setContentsUpdateTime:(NSInteger)timeInMin;
//- (NSInteger)getContentsUpdateTime;
- (void)setUserName:(NSString*)userName;
- (NSString*)getUserName;
//- (void)setUserInitial:(NSString*)userName;
//- (NSString*)getUserInitial;
//- (void)setUserMail:(NSString*)mail;
//- (NSString*)getUserMail;
//- (void) setCountryID:(NSString *)countryID;
//- (NSString*)getCountryID;
//- (void) setOfferValue:(NSString *)offerValue;
//- (NSString*)getOfferValue;
//- (void)setTokenExpireTime:(NSString*)time;
//- (NSString*)getCacheExpireTime;
//- (void)setLoginState:(BOOL)state;
//- (BOOL)loginState;
//- (void)setSuggestionEditState:(BOOL)state;
//- (BOOL)suggestionEditState;
//- (void)setAutoLoginState:(BOOL)state;
//- (BOOL)autoLoginState;
- (void) logoutUser;
- (void)setRememberCredentials:(BOOL) pState;
- (BOOL)getRememberCredentials;
- (void) populateWithUserDic:(NSDictionary*) userInfoDic;

@end
