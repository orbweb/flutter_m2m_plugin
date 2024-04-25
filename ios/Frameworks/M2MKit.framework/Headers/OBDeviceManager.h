#import <Foundation/Foundation.h>
//#import "M2MFramework.h"
//#import "CameraInfo.h"
#import "HostCommon.h"

/**
 Device Manager
 */
@interface OBDeviceManager : NSObject


/**
 Callback block

 @param status YES/NO
 @param point rtsp url
 */
typedef void(^GetRTSPBlock)(BOOL status, NSString *point);


/**
 * @discussion init instance
 * @param devInfo Camera Info
 * */
- (id) init:(id)devInfo;
//- (id) init:(CameraInfo *)devInfo;

/**
 @brief init instance
 @param devInfo Camera Info
 @param timeout used timeout
 */
- (id) init:(id)devInfo Timeout:(NSInteger) timeout;
//- (id) init:(CameraInfo *)devInfo Timeout:(NSInteger) timeout;

/**
 * @discussion init instance
 * @param SID Session ID
 * */
- (id) initWithSID:(NSString *)SID;

/**
* @discussion init instance
* @param SID Session ID
 @param account M2M authentication account
 @param password M2M authentication password
* */
- (id) initWithSID:(NSString *)SID Account:(NSString *)account Password:(NSString *)password;
/**
 @brief init instance
 @param SID Session ID
 @param timeout used timeout
*/

- (id) initWithSID:(NSString *)SID Timeout:(NSInteger) timeout;

/**
 @brief init instance
 @param SID Session ID
 @param account M2M authentication account
 @param password M2M authentication password
 @param timeout used timeout
*/

- (id) initWithSID:(NSString *)SID  Account:(NSString *)account Password:(NSString *)password Timeout:(NSInteger) timeout;

/**
 @brief Close connect
 */
- (void) CloseConnect;

/**
 * @discussion release instance
 * */
- (void) Release;


/**
 @brief get session id
 */
- (NSString *)getSID;

/**
@brief get current type
*/
- (NSInteger) getP2PType;

/**
@brief get current error code
*/
- (NSInteger) getErrorCode;

/**
 @discussion Gets client local port be mapped to device service port by "orbweb connect".
 @param DeviceServicePort : the application service port used in the device
 @return the app client local port. If the value is -1, please check DeviceServicePort
 */
- (NSInteger) getLocalPort:(NSInteger)DeviceServicePort;

/**
 Gets the client local port that be mapped to device application service port by "Orbweb connect" assign "Orbweb connect" type.

 @param DeviceServicePort the application service port used in the device.
 @param type "Orbweb connect" type  1.lan, 2.tcp, 4.udp, 8.relay
 @return the app client local port. If the value is -1, please check DeviceServicePort and "Orbweb connect" type is correct.
 */
- (NSInteger) getLocalPort:(NSInteger)DeviceServicePort ConnectType:(NSInteger)type;

/**
 @discussion get rtsp url point
 @param block callback function point implement by yorself
 */
- (void) getRTSPPoint:(GetRTSPBlock) block;

/**
 @discussion get rtsp url
 @return rtsp url string
 */
- (NSString *) getRTSPPoint;

- (NSString *) getServerID;

/**
 @discussion Restart m2m connect
 */
- (void) RestartConnect;

/**
 * @discussion this is funtion using for change the network status variable
 * @param type the type
 */

- (void) onNetworkChange:(M2MNetworkStatus)type;
/**
 * @discussion this is static funtion using for change the network status variable
 * @param type the type
 */
+ (void) setNetworkType:(M2MNetworkStatus)type;

+ (void) ReleaseAll;

//+ (void) DisableReconnect;


+ (BOOL) isReady;

/**
 @brief Initialize SDK
 */
+ (BOOL) initializeSDK;

/**
 @brief Initialize SDK with China 
 */

+ (BOOL) initializeSDKWithChina;

/**
 * <pre>
 * Initialize SDK with path
 * @param hostname RDZ domain name
 *</pre>
 * */

+ (BOOL) initializeSDKRDZ:(NSString *) hostname;

/**
 * <pre>
 * Uninitialize SDK 
 *</pre>
 * */

+ (void) uninitializeSDK;

/**
 * get M2MFramework version
 * */
+ (NSString *) getVersion;

/**
 * get orbweb connect sdk version
 * */

+ (NSString *) getOrbwebM2MVersion;

/**
 @discussion Start connect by LAN mode
 @param SID Session ID
 */
+ (void)startHostByLanWithSID:(NSString*) SID;

/**
@discussion Start connect by LAN mode
@param SIDs Session ID array
*/

+ (void)startClientByLanWithSID:(NSArray*) SIDs success:(void(^)(NSDictionary *result, NSError *error))successBlock;

/**
  @discussion Stop connect by LAN mode
 */
+ (void)stopHostByLan;

/**
 @discussion Used URL
 @param value enable/disable
* */

+ (void)setUsedDomainName:(BOOL)value;

/**
 @discussion show/hide log output Session ID
 @param value TRUE is HIDE
 */
+ (void)hideSessionID:(BOOL)value;

/**
@discussion show/hide debug log output
@param value FALSE is HIDE
*/

+ (void)setupLog:(BOOL)value;

@end
