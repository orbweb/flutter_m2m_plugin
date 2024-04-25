//
//  Common.h
//  M2MFramework
//
//  Created by William on 2020/1/7.
//  Copyright © 2020 William. All rights reserved.
//

#ifndef HOSTCommon_h
#define HOSTCommon_h

//Instance register receive the notification for p2p status change
#define NOTIFICATION_P2P_STATUS_CHANGE @"NOTIFICATION_P2P_STATUS_CHANGE"
/**
 * @brief message data
 * @param KEY_SID : SID
 * @param KEY_TYPE : "Orbweb connect" type
 * @param KEY_ERROR_CODE : "Orbweb connect" error code
 * */
#define NOTIFICATION_KEY_SID @"KEY_SID"
#define NOTIFICATION_KEY_TYPE @"KEY_TYPE"
#define NOTIFICATION_KEY_ERROR_CODE @"KEY_ERROR_CODE"
#define NOTIFICATION_KEY_ERROR_MSG @"KEY_ERROR_MSG"

//William 20181220
#define NOTIFICATION_KEY_PINGTIME @"KEY_PINGTIME"
#define NOTIFICATION_KEY_CONNECTION_TIME @"KEY_CONNECTION_TIME"

/**
 * m2m instance intent ACTION for speed test report
 */
#define NOTIFICATION_P2P_SPEED_TIME @"NOTIFICATION_P2P_SPEED_TIME"
#define NOTIFICATION_KEY_SPEED_TIME @"KEY_SPEED_TIME"

#define NOTIFICATION_KEY_SPEED_RECEIVE @"KEY_SPEED_RECEIVE"
#define NOTIFICATION_KEY_SPEED_SEND @"KEY_SPEED_SEND"
#define NOTIFICATION_KEY_SPEED_MIN @"KEY_SPEED_MIN"
#define NOTIFICATION_KEY_SPEED_MAX @"KEY_SPEED_MAX"

//Host notification
#define NOTIFICATION_HOST_STATUS @"NOTIFICATION_HOST_STATUS"
#define NOTIFICATION_HOST_STATUS_TYPE @"NOTIFICATION_HOST_STATUS_TYPE"
#define NOTIFICATION_HOST_ERROR_CODE @"NOTIFICATION_HOST_ERROR_CODE"

#define NOTIFICATION_HOST_CLIENT_STATUS_CHANGE @"NOTIFICATION_HOST_CLIENT_STATUS_CHANGE"
#define NOTIFICATION_HOST_CLIENT_SERVER_ID @"NOTIFICATION_HOST_CLIENT_SERVER_ID"
#define NOTIFICATION_HOST_CLIENT_P2P_TYPE @"NOTIFICATION_HOST_CLIENT_P2P_TYPE"
#define NOTIFICATION_HOST_CLIENT_ERROR_CODE @"NOTIFICATION_HOST_CLIENT_ERROR_CODE"


typedef NS_ENUM(NSInteger, M2MNetworkStatus) {
    NetworkStatusInit             = -2,
    NetworkStatusUnknown          = -1,
    NetworkStatusNotReachable     = 0,
    NetworkStatusReachableViaWWAN = 1,
    NetworkStatusReachableViaWiFi = 2,
};

#endif /* Common_h */
