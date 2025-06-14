package com.tuya.smart.rnsdk.user

import com.facebook.react.bridge.*
import com.thingclips.smart.android.user.api.IBooleanCallback
import com.thingclips.smart.android.user.api.ILoginCallback
import com.thingclips.smart.android.user.api.ILogoutCallback
import com.thingclips.smart.android.user.api.IRegisterCallback
import com.thingclips.smart.android.user.api.IResetPasswordCallback
import com.thingclips.smart.android.user.api.IValidateCallback
import com.thingclips.smart.android.user.bean.User
import com.thingclips.smart.home.sdk.ThingHomeSdk
import com.thingclips.smart.sdk.enums.TempUnitEnum
import com.tuya.smart.rnsdk.utils.Constant
import com.tuya.smart.rnsdk.utils.Constant.ACCESSTOKEN
import com.tuya.smart.rnsdk.utils.Constant.CODE
import com.tuya.smart.rnsdk.utils.Constant.COUNTRYCODE
import com.tuya.smart.rnsdk.utils.Constant.EMAIL
import com.tuya.smart.rnsdk.utils.Constant.FILEPATH
import com.tuya.smart.rnsdk.utils.Constant.KEY
import com.tuya.smart.rnsdk.utils.Constant.NEWPASSWORD
import com.tuya.smart.rnsdk.utils.Constant.PASSWORD
import com.tuya.smart.rnsdk.utils.Constant.PHONENUMBER
import com.tuya.smart.rnsdk.utils.Constant.SECRET
import com.tuya.smart.rnsdk.utils.Constant.TEMPUNITENUM
import com.tuya.smart.rnsdk.utils.Constant.TOKEN
import com.tuya.smart.rnsdk.utils.Constant.UID
import com.tuya.smart.rnsdk.utils.Constant.USERID
import com.tuya.smart.rnsdk.utils.Constant.NICKNAME
import com.tuya.smart.rnsdk.utils.Constant.VALIDATECODE
import com.tuya.smart.rnsdk.utils.Constant.getIResultCallback
import com.tuya.smart.rnsdk.utils.ReactParamsCheck
import com.tuya.smart.rnsdk.utils.TuyaReactUtils
import java.io.File
import android.util.Log

class TuyaUserModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    override fun getName(): String {
        return "TuyaUserModule"
    }

    /* 检测是否要升级用户数据 */
    @ReactMethod
    fun checkVersionUpgrade(promise: Promise) {
        promise.resolve(ThingHomeSdk.getUserInstance().checkVersionUpgrade())
    }

    /* 升级账号 */
    @ReactMethod
    fun upgradeVersion(promise: Promise) {
        ThingHomeSdk.getUserInstance().upgradeVersion(getIResultCallback(promise))
    }

    /* 获取手机验证码 */
    @ReactMethod
    fun getValidateCode(params: ReadableMap, promise: Promise) {
        if (ReactParamsCheck.checkParams(arrayOf(COUNTRYCODE, PHONENUMBER), params)) {
            ThingHomeSdk.getUserInstance().getValidateCode(
                    params.getString(COUNTRYCODE),
                    params.getString(PHONENUMBER),
                    getValidateCodeCallback(promise)
            )
        }
    }

    /* Log in with a guest account */
    @ReactMethod
    fun loginWithTouristUser(params: ReadableMap, promise: Promise) {
        Log.d("TuyaUserModule", "[tuya] loginWithTouristUser called with params: $params")
        if (ReactParamsCheck.checkParams(arrayOf(COUNTRYCODE, NICKNAME), params)) {
            Log.d("TuyaUserModule", "[tuya] loginWithTouristUser type check passed, registering...")
            ThingHomeSdk.getUserInstance().touristRegisterAndLogin(
                    params.getString(COUNTRYCODE),
                    params.getString(NICKNAME),
                    getRegisterCallback(promise))
        } else {
            Log.d("TuyaUserModule", "[tuya] loginWithTouristUser failed: params did not match expected keys")
        }
    }

    /* 手机验证码登录 */
    @ReactMethod
    fun loginWithValidateCode(params: ReadableMap, promise: Promise) {
        if (ReactParamsCheck.checkParams(arrayOf(COUNTRYCODE, PHONENUMBER, VALIDATECODE), params)) {
            ThingHomeSdk.getUserInstance().loginWithPhone(
                    params.getString(COUNTRYCODE),
                    params.getString(PHONENUMBER),
                    params.getString(VALIDATECODE),
                    getLoginCallback(promise))
        }
    }

    /* 注册手机密码账户*/
    @ReactMethod
    fun registerAccountWithPhone(params: ReadableMap, promise: Promise) {
        if (ReactParamsCheck.checkParams(arrayOf(COUNTRYCODE, PHONENUMBER, PASSWORD, VALIDATECODE), params)) {
            ThingHomeSdk.getUserInstance().registerAccountWithPhone(
                    params.getString(COUNTRYCODE),
                    params.getString(PHONENUMBER),
                    params.getString(PASSWORD),
                    params.getString(VALIDATECODE),
                    getRegisterCallback(promise))
        }
    }


    /* 手机密码登录 */
    @ReactMethod
    fun loginWithPhonePassword(params: ReadableMap, promise: Promise) {
        if (ReactParamsCheck.checkParams(arrayOf(COUNTRYCODE, PHONENUMBER, PASSWORD), params)) {
            ThingHomeSdk.getUserInstance().loginWithPhonePassword(
                    params.getString(COUNTRYCODE),
                    params.getString(PHONENUMBER),
                    params.getString(PASSWORD),
                    getLoginCallback(promise))
        }
    }

    /* 手机密码重置 */
    @ReactMethod
    fun resetPhonePassword(params: ReadableMap, promise: Promise) {
        if (ReactParamsCheck.checkParams(arrayOf(COUNTRYCODE, PHONENUMBER, CODE, NEWPASSWORD), params)) {
            ThingHomeSdk.getUserInstance().resetPhonePassword(
                    params.getString(COUNTRYCODE),
                    params.getString(PHONENUMBER),
                    params.getString(CODE),
                    params.getString(NEWPASSWORD),
                    getResetPasswdCallback(promise))
        }
    }

    /*注册获取邮箱验证码。*/
    @ReactMethod
    fun getRegisterEmailValidateCode(params: ReadableMap, promise: Promise) {
        if (ReactParamsCheck.checkParams(arrayOf(COUNTRYCODE, EMAIL), params)) {
            ThingHomeSdk.getUserInstance().getRegisterEmailValidateCode(
                    params.getString(COUNTRYCODE),
                    params.getString(EMAIL),
                    getIResultCallback(promise)
            )
        }
    }


    /* 邮箱密码注册 */
    @ReactMethod
    fun registerAccountWithEmail(params: ReadableMap, promise: Promise) {
        if (ReactParamsCheck.checkParams(arrayOf(COUNTRYCODE, EMAIL, PASSWORD, VALIDATECODE), params)) {
            ThingHomeSdk.getUserInstance().registerAccountWithEmail(
                    params.getString(COUNTRYCODE),
                    params.getString(EMAIL),
                    params.getString(PASSWORD),
                    params.getString(VALIDATECODE),
                    getRegisterCallback(promise)
            )
        }
    }

    /* 邮箱密码登陆 */
    @ReactMethod
    fun loginWithEmail(params: ReadableMap, promise: Promise) {
        if (ReactParamsCheck.checkParams(arrayOf(COUNTRYCODE, EMAIL, PASSWORD), params)) {
            ThingHomeSdk.getUserInstance().loginWithEmail(
                    params.getString(COUNTRYCODE),
                    params.getString(EMAIL),
                    params.getString(PASSWORD),
                    getLoginCallback(promise)
            )
        }
    }

    /* 邮箱获取验证码 找密码 */
    @ReactMethod
    fun getEmailValidateCode(params: ReadableMap, promise: Promise) {
        if (ReactParamsCheck.checkParams(arrayOf(COUNTRYCODE, EMAIL), params)) {
            ThingHomeSdk.getUserInstance().getEmailValidateCode(
                    params.getString(COUNTRYCODE),
                    params.getString(EMAIL),
                    getValidateCodeCallback(promise)
            )
        }
    }

    /* 邮箱重置密码 */
    @ReactMethod
    fun resetEmailPassword(params: ReadableMap, promise: Promise) {
        Log.d("TuyaUserModule", "[tuya] resetEmailPassword called with params: $params")
        if (ReactParamsCheck.checkParams(arrayOf(COUNTRYCODE, EMAIL, VALIDATECODE, NEWPASSWORD), params)) {
            ThingHomeSdk.getUserInstance().resetEmailPassword(
                    params.getString(COUNTRYCODE),
                    params.getString(EMAIL),
                    params.getString(VALIDATECODE),
                    params.getString(NEWPASSWORD),
                    getResetPasswdCallback(promise)
            )
        } else {
            Log.d("TuyaUserModule", "[tuya] resetEmailPassword failed: params did not match expected keys")
        }
    }

    /* logout */
    @ReactMethod
    fun logout(promise: Promise) {
        ThingHomeSdk.getUserInstance().logout(object : ILogoutCallback {
            override fun onSuccess() {
                promise.resolve(Constant.SUCCESS)
            }

            override fun onError(code: String?, error: String?) {
                promise.reject(code ?: "UNKNOWN_ERROR", error)
            }

        })
    }

    /* 注销账户 */
    @ReactMethod
    fun cancelAccount(promise: Promise) {
        ThingHomeSdk.getUserInstance().cancelAccount(getIResultCallback(promise))
    }

    /* 用户uid注册*/
    @ReactMethod
    fun registerAccountWithUid(params: ReadableMap, promise: Promise) {
        if (ReactParamsCheck.checkParams(arrayOf(COUNTRYCODE, UID, PASSWORD), params)) {
            ThingHomeSdk.getUserInstance().registerAccountWithUid(
                    params.getString(COUNTRYCODE),
                    params.getString(UID),
                    params.getString(PASSWORD),
                    getRegisterCallback(promise))
        }
    }

    /* uid 登陆*/
    @ReactMethod
    fun loginWithUid(params: ReadableMap, promise: Promise) {
        if (ReactParamsCheck.checkParams(arrayOf(COUNTRYCODE, UID, PASSWORD), params)) {
            ThingHomeSdk.getUserInstance().loginWithUid(
                    params.getString(COUNTRYCODE),
                    params.getString(UID),
                    params.getString(PASSWORD),
                    getLoginCallback(promise))
        }
    }

    /* uid 登陆和注册合并一个接口*/
    @ReactMethod
    fun loginOrRegisterWithUid(params: ReadableMap, promise: Promise) {
        if (ReactParamsCheck.checkParams(arrayOf(COUNTRYCODE, UID, PASSWORD), params)) {
            ThingHomeSdk.getUserInstance().loginOrRegisterWithUid(
                    params.getString(COUNTRYCODE),
                    params.getString(UID),
                    params.getString(PASSWORD),
                    getLoginCallback(promise))
        }
    }


    /* Twitter登陆*/
    @ReactMethod
    fun loginByTwitter(params: ReadableMap, promise: Promise) {
        if (ReactParamsCheck.checkParams(arrayOf(COUNTRYCODE, KEY, SECRET), params)) {
            ThingHomeSdk.getUserInstance().loginByTwitter(
                    params.getString(COUNTRYCODE),
                    params.getString(KEY),
                    params.getString(SECRET),
                    getLoginCallback(promise))
        }
    }


    /* QQ登陆*/
    @ReactMethod
    fun loginByQQ(params: ReadableMap, promise: Promise) {
        if (ReactParamsCheck.checkParams(arrayOf(COUNTRYCODE, USERID, ACCESSTOKEN), params)) {
            ThingHomeSdk.getUserInstance().loginByQQ(
                    params.getString(COUNTRYCODE),
                    params.getString(USERID),
                    params.getString(ACCESSTOKEN),
                    getLoginCallback(promise))
        }
    }

    /* 微信登陆*/
    @ReactMethod
    fun loginByWechat(params: ReadableMap, promise: Promise) {
        if (ReactParamsCheck.checkParams(arrayOf(COUNTRYCODE, CODE), params)) {
            ThingHomeSdk.getUserInstance().loginByWechat(
                    params.getString(COUNTRYCODE),
                    params.getString(CODE),
                    getLoginCallback(promise))
        }
    }

    /* Facebook登陆*/
    @ReactMethod
    fun loginByFacebook(params: ReadableMap, promise: Promise) {
        if (ReactParamsCheck.checkParams(arrayOf(COUNTRYCODE, TOKEN), params)) {
            ThingHomeSdk.getUserInstance().loginByFacebook(
                    params.getString(COUNTRYCODE),
                    params.getString(TOKEN),
                    getLoginCallback(promise))
        }
    }

    @ReactMethod
    fun getCurrentUser(promise: Promise) {
        if (ThingHomeSdk.getUserInstance().user != null) {
            promise.resolve(TuyaReactUtils.parseToWritableMap(ThingHomeSdk.getUserInstance().user))
        } else {
            promise.resolve(null)
        }
    }


    /* 上传用户头像*/
    @ReactMethod
    fun uploadUserAvatar(params: ReadableMap, promise: Promise) {
        if (ReactParamsCheck.checkParams(arrayOf(FILEPATH), params)) {
            ThingHomeSdk.getUserInstance().uploadUserAvatar(
                    File(params.getString(FILEPATH)), getIBooleanCallback(promise))
        }
    }

    /* 设置温度单位*/
    @ReactMethod
    fun setTempUnit(params: ReadableMap, promise: Promise) {
        if (ReactParamsCheck.checkParams(arrayOf(TEMPUNITENUM), params)) {
            ThingHomeSdk.getUserInstance().setTempUnit(TempUnitEnum.valueOf(params.getString(TEMPUNITENUM) as String), getIResultCallback(promise))
        }
    }


    fun getLoginCallback(promise: Promise): ILoginCallback? {
        val callback = object : ILoginCallback {
            override fun onSuccess(user: User?) {
                promise.resolve(TuyaReactUtils.parseToWritableMap(user))
            }

            override fun onError(code: String?, error: String?) {
                Log.d("TuyaUserModule", "[tuya] getLoginCallback onError called with code: $code, error: $error")
                val errorObj = object {
                    val error = true
                    val code = code
                    val msg = error
                }
                promise.resolve(TuyaReactUtils.parseToWritableMap(errorObj))
            }

        }
        return callback
    }

    fun getRegisterCallback(promise: Promise): IRegisterCallback? {
        return object : IRegisterCallback {
            override fun onSuccess(user: User?) {
                Log.d("TuyaUserModule", "[tuya] getRegisterCallback onSuccess called with user: $user")
                promise.resolve(TuyaReactUtils.parseToWritableMap(user))
            }

            override fun onError(code: String?, error: String?) {
                Log.d("TuyaUserModule", "[tuya] getRegisterCallback onError called with code: $code, error: $error")
                val errorObj = object {
                    val error = true
                    val code = code
                    val msg = error
                }
                promise.resolve(TuyaReactUtils.parseToWritableMap(errorObj))
            }

        }
    }

    fun getResetPasswdCallback(promise: Promise): IResetPasswordCallback? {
        return object : IResetPasswordCallback {
            override fun onSuccess() {
                promise.resolve(Constant.SUCCESS)
            }

            override fun onError(code: String?, error: String?) {
                Log.d("TuyaUserModule", "[tuya] getResetPasswdCallback onError called with code: $code, error: $error")
                val errorObj = object {
                    val error = true
                    val code = code
                    val msg = error
                }
                promise.resolve(TuyaReactUtils.parseToWritableMap(errorObj))
            }

        }
    }

    fun getValidateCodeCallback(promise: Promise): IValidateCallback {
        return object : IValidateCallback {
            override fun onSuccess() {
                promise.resolve(Constant.SUCCESS)
            }

            override fun onError(code: String?, error: String?) {
                Log.d("TuyaUserModule", "[tuya] getValidateCodeCallback onError called with code: $code, error: $error")
                val errorObj = object {
                    val error = true
                    val code = code
                    val msg = error
                }
                promise.resolve(TuyaReactUtils.parseToWritableMap(errorObj))
            }
        }
    }


    fun getIBooleanCallback(promise: Promise): IBooleanCallback? {
        return object : IBooleanCallback {
            override fun onSuccess() {
                promise.resolve(Constant.SUCCESS)
            }

            override fun onError(code: String?, error: String?) {
                promise.reject(code ?: "UNKNOWN_ERROR", error)
            }
        }
    }
}
