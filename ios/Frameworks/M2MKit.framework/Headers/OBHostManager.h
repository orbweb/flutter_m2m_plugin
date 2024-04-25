//
//  OBHostManager.h
//  M2MFramework
//
//  Created by William on 2019/12/11.
//  Copyright © 2019 William. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HostCommon.h"

NS_ASSUME_NONNULL_BEGIN

@interface OBHostManager : NSObject

/**
Access the shared OBHostManager instance
@return Returns the shared OBHostManager instance
*/

+ (id) getInstance;

/**
* @discussion Used URL
* @param value enable/disable
* */

+ (void)setUsedDomainame:(BOOL)value;

/**
  @discussion Setup Host M2M account and password
 */
- (void) setAccount:(NSString * _Nullable)account
           Password:(NSString *_Nullable )password;

/**
 @discussion Start Host service
 @param sid Host Session ID
 */
- (void) startHostWithSID:(NSString *)sid;

/**
 @discussion Start Host service with authenticate
 @param sid Host Session ID
 @param account the account
 @param password the password
 */
/*
- (void) startHostWithSID:(NSString *)sid
                  Account:(NSString * _Nullable)account
                 Password:(NSString * _Nullable)password;
 */
/**
 @discussion Stop Host service
*/
- (void) stopHostService;

/**
 @discussion check Host service
 @return Returns service status (ONLINE/OFFLINE)
*/
- (BOOL) checkStatus;
/**
 * @discussion this is funtion using for change the network status variable
 * @param type the type
 */

- (void) onNetworkChange:(M2MNetworkStatus)type;

@end

NS_ASSUME_NONNULL_END
