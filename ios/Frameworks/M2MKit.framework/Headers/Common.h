//
//  Common.h
//  iFacecall
//
//  Created by William on 2018/8/1.
//  Copyright © 2018年 William. All rights reserved.
//

#ifndef Common_h
#define Common_h
//#define LOCAL_HOST_SID @"LOCAL_HOST_SID"
#define LOCAL_VIDEO_PORT @"LOCAL_VIDEO_PORT"
#define LOCAL_AUDIO_PORT @"LOCAL_AUDIO_PORT"

#define InComing 1
#define CallOut 2
#define KEY_TYPE @"CALL_TYPE"
#define KEY_VIDEO_PORT @"VIDEO_PORT"
#define KEY_AUDIO_PORT @"AUDIO_PORT"
#define KEY_CALL_ID @"CALL_ID"
#define HOST_CONNECT_STATUS_CHANGE @"HOST_CONNECT_STATUS_CHANGE"
#define HOST_STATUS_CODE @"HOST_STATUS_CODE"
#define HOST_STATUS_MSG @"HOST_STATUS_MSG"
#define HOST_STATUS_ERRORCODE @"HOST_STATUS_ERRORCODE"
#define HOST_STATUS_P2PTYPE @"HOST_STATUS_P2PTYPE"


typedef NS_ENUM(NSInteger, HostConnectStatus) {
    CONNECT_NONE = 0,  //offline
    CONNECT_CONNECT,
    CONNECT_READY,      //host connect to server
    CONNECT_CONNECTED, //Client connect
    CONNECT_DISCONNECT, //Client disconnect
    //CONNECT_REFUSED
};

typedef NS_ENUM(NSInteger, HostAuthType) {
    AuthNotConnected = 0,
    AuthConnected,
    AuthConnecting,
    AuthFail
};

#if 0
#define STATUS_NONE 0
#define STATUS_IN 1
#define STATUS_IN_START 2

#define STATUS_OUT 10
#define STATUS_OUT_START 11
#define STATUS_OUT_WAIT 12

#define STATUS_CLOSE 20
#define STATUS_REFUSED 21
#endif
#endif /* Common_h */
