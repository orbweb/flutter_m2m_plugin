//
//  APIResponse.h
//  M2MFramework
//
//  Created by William on 2019/6/19.
//  Copyright © 2019 William. All rights reserved.
//

#ifndef APIResponse_h
#define APIResponse_h

/// ==========================
/// @name ORBM2MErrorCode
/// ==========================
/** ORBM2M Error Domain description */

typedef NS_ENUM(NSUInteger, ORBM2MErrorCode) {
    
    /// M2M connect success
    CONN_ERROR_NONE = 0,
    /// Rendezvous server received unknown data format.
    CONN_SERVER_POST_UNKNOWDATA = 1001,
    /// Rendezvous server cannot identify device role(client/host).
    CONN_SERVER_UNKNOWNROLE = 1002,
    /// Client/host registered with invalid SID
    CONN_SERVER_INVALID_SID = 1003,
    /// Rendezvous server cannot find TaT Server.
    CONN_SERVER_NO_VALID_TAT = 1004,
    /// Host not registered
    CONN_SERVER_HOST_NOT_EXIST = 1005,
    /// Rendezvous server response unknown info
    CONN_SERVER_UNKNOWNINFO_ERROR = 1006,
    
    CONN_HOST_NOT_NETWORK = 1101,
    /// Rendezvous server error
    CONN_HOST_RENDEZVOUS_SERVER_ERROR = 2000,
    /// Host register to TaT server timeout
    CONN_HOST_REGISTER_TAT_SERVER_TIMEOUT,
    /// Host register to TaT server fail
    CONN_HOST_REGISTER_TAT_SERVER_FAIL,
    /// Session ID is not registered.
    CONN_HOST_SESSION_ID_NOT_REGISTERED,
    /// Session ID is already registered.
    CONN_HOST_SESSION_ID_ALREADY_REGISTERED,
    /// tunnel is not ready.
    CONN_HOST_TUNNEL_NOT_EXIST,
    /// Host local port is already used
    CONN_HOST_LOCAL_PORT_ALREADY_USED,
    /// Host local port is not in port mapping
    CONN_HOST_LOCAL_PORT_NOT_MAPPED,
    /// Host local port is not under listening.
    CONN_HOST_LOCAL_PORT_NOT_LISTENED,
    /// Missing host configuration file.
    CONN_HOST_MISSING_CONFIGURATION,
    /// Host has no memory
    CONN_HOST_NOMEMORY,
    
    /// Rendezvous server error
    CONN_CLIENT_RENDEZVOUS_SERVER_ERROR = 3000,
    /// Client connect host timeout.
    CONN_CLIENT_CONNECT_HOST_TIMEOUT,
    /// Client connect host fail.
    CONN_CLIENT_CONNECT_HOST_FAIL,
    /// Session ID is not registered.
    CONN_CLIENT_SESSION_ID_NOT_REGISTERED,
    /// Session ID is already registered.
    CONN_CLIENT_SESSION_ID_ALREADY_REGISTERED,
    /// Tunnel is not ready.
    CONN_CLIENT_TUNNEL_NOT_EXIST,
    /// Host local port is already used
    CONN_CLIENT_LOCAL_PORT_ALREADY_USED,
    /// Host local port is not in port mapping
    CONN_CLIENT_LOCAL_PORT_NOT_MAPPED,
    /// Host local port is not under listening.
    CONN_CLIENT_LOCAL_PORT_NOT_LISTENED,
    /// Missing client configuration file.
    CONN_CLIENT_MISSING_CONFIGURATION,
    /// Client has no memory.
    CONN_CLIENT_NOMEMORY,
    // client connect tat fail.
    CONN_CLIENT_CONNECT_TAT_FAIL,
    // clinet register nic fail.
    CONN_CLIENT_REG_NIC_FAIL_RSP,
    
    CONN_CLIENT_DOMAIN_ERROR = 3100,
    
    CONN_CLIENT_CLOSE_CONNECT = 3101,
};

#endif /* APIResponse_h */
