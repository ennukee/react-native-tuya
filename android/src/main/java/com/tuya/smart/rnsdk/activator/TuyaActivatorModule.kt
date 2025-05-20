package com.tuya.smart.rnsdk.activator

import android.content.Intent
import android.provider.Settings
import com.facebook.react.bridge.*
import com.thingclips.smart.android.ble.api.ScanType
import com.thingclips.smart.android.common.utils.WiFiUtil
import com.thingclips.smart.home.sdk.ThingHomeSdk
import com.thingclips.smart.home.sdk.builder.ActivatorBuilder
import com.thingclips.smart.home.sdk.builder.ThingGwSubDevActivatorBuilder
import com.thingclips.smart.sdk.api.IMultiModeActivatorListener
import com.thingclips.smart.sdk.api.IThingActivator
import com.thingclips.smart.sdk.api.IThingActivatorGetToken
import com.thingclips.smart.sdk.api.IThingSmartActivatorListener
import com.thingclips.smart.sdk.bean.DeviceBean
import com.thingclips.smart.sdk.bean.MultiModeActivatorBean
import com.thingclips.smart.sdk.enums.ActivatorModelEnum
import com.tuya.smart.rnsdk.utils.*
import com.tuya.smart.rnsdk.utils.Constant.HOMEID
import com.tuya.smart.rnsdk.utils.Constant.PASSWORD
import com.tuya.smart.rnsdk.utils.Constant.SSID
import com.tuya.smart.rnsdk.utils.Constant.TIME
import com.tuya.smart.rnsdk.utils.Constant.DEVID
import com.tuya.smart.rnsdk.utils.Constant.TYPE
import android.util.Log


class TuyaActivatorModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

  var mITuyaActivator: IThingActivator? = null
  var mTuyaGWActivator: IThingActivator? = null
  override fun getName(): String {
    return "TuyaActivatorModule"
  }

  @ReactMethod
  fun startBluetoothScan(promise: Promise) {
    ThingHomeSdk.getBleOperator().startLeScan(60000, ScanType.SINGLE
    ) { bean -> promise.resolve(TuyaReactUtils.parseToWritableMap(bean)) };
  }

  @ReactMethod
  fun stopBluetoothScan() {
    ThingHomeSdk.getBleOperator().stopLeScan();
  }


  @ReactMethod
  fun initBluetoothDualModeActivator(params: ReadableMap, promise: Promise) {
    Log.d("TuyaActivatorModule", "[tuya] initBluetoothDualModeActivator called with params: $params")
    if (ReactParamsCheck.checkParams(arrayOf(HOMEID, SSID, PASSWORD), params)) {
      ThingHomeSdk.getBleOperator().startLeScan(60000, ScanType.SINGLE
      ) { bean ->
        params.getDouble(HOMEID).toLong().let {
          Log.d("TuyaActivatorModule", "[tuya] bluetooth found device")
          ThingHomeSdk.getActivatorInstance()
            .getActivatorToken(it, object : IThingActivatorGetToken {
              override fun onSuccess(token: String) {
                val multiModeActivatorBean = MultiModeActivatorBean();
                multiModeActivatorBean.ssid = params.getString(SSID);
                multiModeActivatorBean.pwd = params.getString(PASSWORD);

                multiModeActivatorBean.uuid = bean.getUuid();
                multiModeActivatorBean.deviceType = bean.getDeviceType();
                multiModeActivatorBean.mac = bean.getMac();
                multiModeActivatorBean.address = bean.getAddress();


                multiModeActivatorBean.homeId = params.getDouble(HOMEID).toLong();
                multiModeActivatorBean.token = token;
                multiModeActivatorBean.timeout = 180000;
                multiModeActivatorBean.phase1Timeout = 60000;

                ThingHomeSdk.getActivator().newMultiModeActivator()
                  .startActivator(multiModeActivatorBean, object : IMultiModeActivatorListener {
                    override fun onSuccess(bean: DeviceBean) {
                      promise.resolve(TuyaReactUtils.parseToWritableMap(bean));
                    }

                    override fun onFailure(code: Int, msg: String?, handle: Any?) {
                      Log.d("TuyaActivatorModule", "[tuya] activator listener failed: $code, $msg")
                      val errorObj = object {
                        val error = true
                        val code = code
                        val msg = msg
                      }
                      promise.resolve(TuyaReactUtils.parseToWritableMap(errorObj))
                    }
                  });
              }

              override fun onFailure(s: String, s1: String) {
                promise.reject(s, s1);
              }
            })
        }
      };
    } else {
      Log.d("TuyaActivatorModule", "[tuya] initActivator failed: params did not match expected keys")
    }
  }


  @ReactMethod
  fun getCurrentWifi(params: ReadableMap, successCallback: Callback,
                     errorCallback: Callback) {
    successCallback.invoke(WiFiUtil.getCurrentSSID(reactApplicationContext.applicationContext));
  }

  @ReactMethod
  fun openNetworkSettings(params: ReadableMap) {
    val currentActivity = currentActivity
    if (currentActivity == null) {
      return
    }
    try {
      currentActivity.startActivity(Intent(Settings.ACTION_SETTINGS))
    } catch (e: Exception) {
    }

  }

  /**
   * Maps string value to ActivatorModelEnum
   * Returns null on unknown case
   */
  private fun getActivatorModelEnumByString(value: String): ActivatorModelEnum? {
    return when (value) {
      "THING_AP" -> ActivatorModelEnum.THING_AP
      "THING_EZ" -> ActivatorModelEnum.THING_EZ
      "THING_4G_GATEWAY" -> ActivatorModelEnum.THING_4G_GATEWAY
      "THING_QR" -> ActivatorModelEnum.THING_QR
      else -> null
    }
  }

  @ReactMethod
  fun initActivator(params: ReadableMap, promise: Promise) {
    Log.d("TuyaActivatorModule", "[tuya] initActivator called with params: $params")
    if (ReactParamsCheck.checkParams(arrayOf(HOMEID, SSID, PASSWORD, TIME, TYPE), params)) {
      ThingHomeSdk.getActivatorInstance().getActivatorToken(params.getDouble(HOMEID).toLong(), object : IThingActivatorGetToken {
        override fun onSuccess(token: String) {
          val modeValue = params.getString(TYPE) as String
          val mode = getActivatorModelEnumByString(modeValue) ?: ActivatorModelEnum.THING_EZ
          mITuyaActivator = ThingHomeSdk.getActivatorInstance().newActivator(
            ActivatorBuilder()
            .setSsid(params.getString(SSID))
            .setContext(reactApplicationContext.applicationContext)
            .setPassword(params.getString(PASSWORD))
            .setActivatorModel(mode)
            .setTimeOut(params.getInt(TIME).toLong())
            .setToken(token).setListener(getITuyaSmartActivatorListener(promise)))
          mITuyaActivator?.start()
        }


        override fun onFailure(s: String, s1: String) {
          Log.d("TuyaActivatorModule", "[tuya] initActive failed to get token: $s, $s1")
          promise.reject(s, s1)
        }
      })
    } else {
      Log.d("TuyaActivatorModule", "[tuya] initActivator failed: params did not match expected keys")
    }

  }

  /**
   * ZigBee子设备配网需要ZigBee网关设备云在线的情况下才能发起,且子设备处于配网状态。
   */
  @ReactMethod
  fun newGwSubDevActivator(params: ReadableMap, promise: Promise) {
    if (ReactParamsCheck.checkParams(arrayOf(DEVID, TIME), params)) {
      val builder = ThingGwSubDevActivatorBuilder()
        //设置网关ID
        .setDevId(params.getString(DEVID))
        //设置配网超时时间
        .setTimeOut(params.getInt(TIME).toLong())
        .setListener(object : IThingSmartActivatorListener {
          override fun onError(var1: String, var2: String) {
            promise.reject(var1, var2)
          }

          /**
           * 设备配网成功,且设备上线（手机可以直接控制），可以通过
           */
          override fun onActiveSuccess(var1: DeviceBean) {
            promise.resolve(TuyaReactUtils.parseToWritableMap(var1))
          }

          /**
           * device_find 发现设备
          device_bind_success 设备绑定成功，但还未上线，此时设备处于离线状态，无法控制设备。
           */
          override fun onStep(var1: String, var2: Any) {
            // promise.reject(var1,"")
          }
        })

      mTuyaGWActivator = ThingHomeSdk.getActivatorInstance().newGwSubDevActivator(builder)
    }
  }

  @ReactMethod
  fun stopConfig() {
    mITuyaActivator?.stop()
    mTuyaGWActivator?.stop()
  }

  @ReactMethod
  fun onDestory() {
    mITuyaActivator?.onDestroy()
    mTuyaGWActivator?.onDestroy()
  }

  fun getITuyaSmartActivatorListener(promise: Promise): IThingSmartActivatorListener {
    return object : IThingSmartActivatorListener {
      /**
       * 1001        网络错误
      1002        配网设备激活接口调用失败，接口调用不成功
      1003        配网设备激活失败，设备找不到。
      1004        token 获取失败
      1005        设备没有上线
      1006        配网超时
       */
      override fun onError(var1: String, var2: String) {
        Log.d("TuyaActivatorModule", "[tuya] activator listener failed: $var1, $var2")
        val errorObj = object {
          val error = true
          val code = var1
          val msg = var2
        }
        promise.resolve(TuyaReactUtils.parseToWritableMap(errorObj))
      }

      /**
       * 设备配网成功,且设备上线（手机可以直接控制），可以通过
       */
      override fun onActiveSuccess(var1: DeviceBean) {
        Log.d("TuyaActivatorModule", "[tuya] activator listener success: $var1")
        promise.resolve(TuyaReactUtils.parseToWritableMap(var1))
      }

      /**
       * device_find 发现设备
      device_bind_success 设备绑定成功，但还未上线，此时设备处于离线状态，无法控制设备。
       */
      override fun onStep(var1: String, var2: Any) {
        // IOS 没有onStep保持一致
        Log.d("TuyaActivatorModule", "[tuya] activator listener stepped: $var1, $var2")
        //promise.reject(var1,"")
      }
    }
  }
}
