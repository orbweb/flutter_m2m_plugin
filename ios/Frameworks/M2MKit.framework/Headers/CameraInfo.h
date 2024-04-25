
#import <Foundation/Foundation.h>

#define P2P_TYPE_OFFLINE -1
#define P2P_TYPE_CONNECT 0
#define P2P_TYPE_LAN 1
#define P2P_TYPE_TCP 2
#define P2P_TYPE_UDP 4
#define P2P_TYPE_RELAY 8


/**
 Camera Info
 */
@interface CameraInfo : NSObject

/**
 * name : Device name
 * sid : "orbweb connect" SID used in device
 * Ports : Application services ports in ip camera
 * p2pType : "orbweb connect" type
 * account, password : check account/password  for "orbweb connect" in camera
 * */


@property NSString *name;
@property NSString *sid;
@property NSString *deviceID;
@property NSArray *ports;
@property NSInteger p2pType;

@property NSString *account;
@property NSString *password;

@property NSInteger errorCode;
//@property BOOL usedAuth;
@property NSInteger RTSP_PORT;
@property NSString *RTSP_POINT;

@property NSInteger HTTP_PORT;

//William 20181220
@property NSInteger CMD_PORT;
@property NSInteger audioCodec;
@property UInt64 audioSampleRate;
@property UInt32 audioFormat;
@property UInt32 audioChannel;

@property NSString *userID;
@property NSString *userToken;

@property NSString *rtsp_user;
@property NSString *rtsp_password;

@property NSString *record_type;
@property BOOL usedCmdService;
@property NSString *local_ip;

- (id) initWithSessionID:(NSString *)SessinID;

- (id) initWithSessionID:(NSString *)SessinID Account:(NSString *)acc Password:(NSString *)pwd;

/**
 @brief check is p2p
 */
- (BOOL)isP2P;
/**
 @brief check is online
 */
- (BOOL)isOnline;

/**
 @brief set RTSP Account/Password
 @param user RTSP Account
 @param password RTSP password
 */

- (void) setRTSPUser:(NSString *)user Password:(NSString *)password;

/**
 @brief set RTSP Auth
 @param b enable auth
 @param user User
 @param password Password
 @deprecated is deprecated new api setRTSPUser
 
 */

- (void) setUsedAuth:(BOOL) b User:(NSString *)user Password:(NSString *)password __deprecated;


/**
 @brief set M2M connect auth
 @param ID m2m account
 @param PWD m2m Password
 */

- (void) setIDPassword:(NSString *)ID Password:(NSString *)PWD;

/**
 @brief set Push to talk
 @param codec set audio codec
    AUDIO_CODEC_PCM
    AUDIO_CODEC_ALAW
    AUDIO_CODEC_ULAW
    AUDIO_CODEC_AAC
 @param format set audio format
    AUDIO_FORMAT_8BIT
 AUDIO_FORMAT_16BIT
 @param rate set audio sample rate
    8000.0f
    16000.0f
 @param channel set audio channel
    AUDIO_CHANNEL_MONO
    AUDIO_CHANNEL_STEREO
 */

- (void) setPushAudioCodec:(NSInteger)codec
                    Format:(UInt32)format
                SampleRate:(UInt64)rate
                   Channel:(UInt32)channel;


/**
 @brief set Push to talk
 @param codec set audio codec
 AUDIO_CODEC_PCM
 AUDIO_CODEC_ALAW
 AUDIO_CODEC_ULAW
 AUDIO_CODEC_AAC
 @param rate set audio sample rate
 8000.0f
 16000.0f
 */
- (void) setPushAudioCodec:(NSInteger)codec
                SampleRate:(UInt64)rate;


@end
