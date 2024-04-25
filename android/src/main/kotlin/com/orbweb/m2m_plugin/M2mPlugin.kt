package com.orbweb.m2m_plugin

import android.annotation.SuppressLint
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import com.orbweb.libm2m.common.M2Mintent
import com.orbweb.libm2m.manager.M2MDeviceManager
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject


/** M2mPlugin */
class M2mPlugin: FlutterPlugin, MethodCallHandler , EventChannel.StreamHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity

  private lateinit var channel : MethodChannel

  private lateinit var context: Context
  private var eventSink: EventSink? = null

  private var mP2PList : HashMap<String, M2MDeviceManager> = HashMap()

  private var mM2MStatusReceiver : M2MStatusReceiver? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.orbweb.m2m_plugin")
    channel.setMethodCallHandler(this)

    EventChannel(flutterPluginBinding.binaryMessenger, "com.orbweb.demo/event").setStreamHandler(this)

    this.context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(call: MethodCall, result: Result) {

    if (call.method == "getPlatformVersion") {
      //result.success("Android ${android.os.Build.VERSION.RELEASE}")
      result.success(M2MDeviceManager.getVersion())
    }
    else if (call.method == "isReady") {
      result.success(M2MDeviceManager.isReady())
    }
    else if (call.method == "initializeSDK") {
      result.success(M2MDeviceManager.initializeSDK())
    }
    else if (call.method == "initializeWithChina") {
      result.success(M2MDeviceManager.initializeSDKWithChina())
    }
    else if (call.method == "initializeWithRDZ") {
      val rdz: String = call.argument("rdz")!!
      result.success(M2MDeviceManager.initializeSDKRDZ(rdz))
    }
    else if (call.method == "uninitializedSDK") {
      M2MDeviceManager.uninitializeSDK()
      result.success(true)
    }
    else if (call.method == "setupLog") {
      val value: Boolean = call.argument("value")!!
      M2MDeviceManager.setupLog(value)
      result.success(null)
    }
    else if (call.method == "setUsedDomainName") {
      val value: Boolean = call.argument("value")!!
      M2MDeviceManager.setUsedDomainName(value)
      result.success(null)
    }
    else if (call.method == "create") {
      val sid: String = call.argument("sid")!!
      val account : String = call.argument("account")!!
      val password : String = call.argument("password")!!
      val timeout : Long = call.argument("timeout")!!

      result.success(create(sid,account, password, timeout))
    }
    else if (call.method == "reconnect") {
      val sid: String = call.argument("sid")!!
      reConnect(sid)
      result.success(null)
    }
    else if (call.method == "close") {
      val sid: String = call.argument("sid")!!
      result.success(close(sid))
    }
    else if (call.method == "closeAll") {
      result.success(closeAll())
    }
    else if (call.method == "getPort") {
      val sid: String = call.argument("sid")!!
      val from :Int = call.argument("from")!!
      result.success(getPort(sid, from))
    }
    else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun getManager(sid: String) : M2MDeviceManager? {
    if (mP2PList.containsKey(sid)) {
      return mP2PList[sid]!!
    }

    return null
  }

  private fun create(sid : String, account : String?, password : String?, timeout :Long) : Boolean {
    var manager : M2MDeviceManager? = getManager(sid)

    if (manager == null) {
      if (account != null && password != null && account.length>0 && password.length>0) {
        manager = M2MDeviceManager(this.context, sid, account, password, timeout)
      } else {
        manager = M2MDeviceManager(this.context, sid, timeout)
      }


      mP2PList[sid] = manager
    }

    if (manager.p2PType < 0) {
      manager.onNetworkChange(0)
    }

    return (manager.p2PType > 0)
  }

  private fun reConnect(sid : String) {
    var manager : M2MDeviceManager? = getManager(sid)
    if (manager != null) {
      if (manager.p2PType < 0) {
        manager.RestartConnect();
      }
    }
  }

  private fun close(sid: String) : Boolean {
    var find : Boolean  = false
    val manager : M2MDeviceManager? = getManager(sid)
    if (manager != null) {
      manager.release()
      mP2PList.remove(sid)
      find = true
    }
    return find;
  }

  private fun closeAll() : Boolean {
    var find : Boolean  = false
    mP2PList.forEach { (_, manager) ->
      manager.release()
      //mP2PList.remove(sid)
      find = true
    }

    mP2PList.clear();
    
    return find;
    
  }

  private fun getPort(sid:String, from: Int) : Int {
    val manager : M2MDeviceManager? = getManager(sid)
    if (manager != null) {
      return manager.getLocalPort(from)
    }
    return -1
  }

  @SuppressLint("UnspecifiedRegisterReceiverFlag")
  override fun onListen(arguments: Any?, events: EventSink?) {
    eventSink = events;

    val filter = IntentFilter()
    filter.addAction(M2Mintent.BROADCAST_P2P_STATUS_CHANGE_ACTION)

    mM2MStatusReceiver = M2MStatusReceiver(eventSink)

    if (Build.VERSION.SDK_INT > Build.VERSION_CODES.S_V2) {
      context.registerReceiver(mM2MStatusReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
    } else {
      val permission = context.packageName+".permission.SEND_M2M"
      context.registerReceiver(mM2MStatusReceiver, filter, permission, null)
    }

  }

  override fun onCancel(arguments: Any?) {
    eventSink = null
    context.unregisterReceiver(mM2MStatusReceiver)
    mM2MStatusReceiver = null
  }
}


class M2MStatusReceiver(private var event : EventSink?) : BroadcastReceiver() {

  override fun onReceive(context: Context?, intent: Intent?) {
    val action = intent?.action;
    if (action == M2Mintent.BROADCAST_P2P_STATUS_CHANGE_ACTION) {
      val bundle = intent.getBundleExtra(M2Mintent.BROADCAST_P2P_STATUS_CHANGE_KET)
      val sid = bundle?.getString(M2Mintent.BROADCAST_KEY_SID)
      val p2pType : Int? = bundle?.getInt(M2Mintent.BROADCAST_KEY_TYPE, -1)
      val errorCode = bundle?.getInt(M2Mintent.BROADCAST_KEY_ERROR_CODE, 0)

      val json = JSONObject()
      json.put("sid", sid)
      json.put("p2pType", p2pType.toString())
      json.put("errorCode", errorCode.toString())

      this.event?.success(json.toString())
    }
  }

}
