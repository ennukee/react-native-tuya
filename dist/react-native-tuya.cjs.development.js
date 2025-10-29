'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var reactNative = require('react-native');

var tuya = reactNative.NativeModules.TuyaActivatorModule;
var tuyaBLEActivator = reactNative.NativeModules.TuyaBLEActivatorModule;
var tuyaBLEScanner = reactNative.NativeModules.TuyaBLEScannerModule;
function openNetworkSettings() {
  return tuya.openNetworkSettings({});
}
(function (ActivatorType) {
  ActivatorType["AP"] = "THING_AP";
  ActivatorType["EZ"] = "THING_EZ";
  ActivatorType["AP_4G_GATEWAY"] = "THING_4G_GATEWAY";
  ActivatorType["QR"] = "THING_QR";
})(exports.ActivatorType || (exports.ActivatorType = {}));
function initActivator(params) {
  return tuya.initActivator(params);
}
function stopConfig() {
  return tuya.stopConfig();
}
function startBluetoothScan() {
  if (reactNative.Platform.OS === 'ios') {
    return tuyaBLEScanner.startBluetoothScan();
  }
  return tuya.startBluetoothScan();
}
function stopLePairing() {
  if (reactNative.Platform.OS === 'ios') {
    return tuyaBLEActivator.stopLePairing();
  } else {
    console.error('[tuya] stopLePairing is not supported on Android as it is not needed.');
  }
}
function getActivatorToken(params) {
  if (reactNative.Platform.OS === 'ios') {
    console.error('[tuya] getActivatorToken is not supported on iOS.');
    return Promise.reject('Not supported on iOS');
  }
  return tuya.getActivatorToken(params);
}
function startAndroidBLEActivator(params) {
  if (reactNative.Platform.OS === 'ios') {
    console.error('[tuya] startAndroidBLEActivator is not supported on iOS.');
    return Promise.reject('Not supported on iOS');
  }
  return tuya.startBLEActivator(params);
}
function startLateWifiActivation(params) {
  if (reactNative.Platform.OS === 'ios') {
    console.error('[tuya] startLateWifiActivation is not supported on iOS.');
    return Promise.reject('Not supported on iOS');
  }
  return tuya.startLateWifiActivation(params);
}
function initBluetoothDualModeActivator(params) {
  if (reactNative.Platform.OS === 'ios') {
    return tuyaBLEActivator.initActivator(params);
  }
  return tuya.initBluetoothDualModeActivator(params);
}
function initBluetoothFlowAndroid(params) {
  if (reactNative.Platform.OS === 'ios') {
    console.error('[tuya] initBluetoothFlowAndroid is not supported on iOS.');
    return Promise.reject('Not supported on iOS');
  }
  return tuya.initBluetoothDualModeActivator(params);
}
function getCurrentWifi(success, error) {
  // We need the Allow While Using App location permission to use this.
  return tuya.getCurrentWifi({}, success, error);
}

var GROUPLISTENER = 'groupListener';
var HARDWAREUPGRADELISTENER = 'hardwareUpgradeListener';
var DEVLISTENER = 'devListener';
var SUBDEVLISTENER = 'subDevListener';
var HOMESTATUS = 'homeStatus';
var HOMECHANGE = 'homeChange';
var SINGLETRANSFER = 'SingleTransfer';
var eventEmitter = /*#__PURE__*/new reactNative.NativeEventEmitter(reactNative.NativeModules.TuyaRNEventEmitter);
function addEvent(eventName, callback) {
  return eventEmitter.addListener(eventName, callback);
}
var bridge = function bridge(key, id) {
  return key + "//" + id;
};

var tuya$1 = reactNative.NativeModules.TuyaDeviceModule;
var devListenerSubs = {};
function registerDevListener(params, type, callback) {
  tuya$1.registerDevListener(params);
  var sub = addEvent(bridge(DEVLISTENER, params.devId), function (data) {
    if (data.type === type) {
      callback(data);
    }
  });
  devListenerSubs[params.devId] = sub;
}
function unRegisterAllDevListeners() {
  for (var devId in devListenerSubs) {
    var sub = devListenerSubs[devId];
    sub.remove();
    tuya$1.unRegisterDevListener({
      devId: devId
    });
  }
  devListenerSubs = {};
}
function getDevice(params) {
  if (reactNative.Platform.OS === 'ios') {
    console.error('[tuya] getDevice is not supported on iOS');
    return Promise.resolve(null);
  }
  return tuya$1.getDevice(params);
}
function getDeviceData(params) {
  if (reactNative.Platform.OS === 'ios') {
    console.error('[tuya] getDevice is not supported on iOS');
    return Promise.resolve(null);
  }
  return tuya$1.getDeviceData(params);
}
function send(params) {
  return tuya$1.send(params);
}
function removeDevice(params) {
  return tuya$1.removeDevice(params);
}
function renameDevice(params) {
  return tuya$1.renameDevice(params);
}
function getDataPointStat(params) {
  return tuya$1.getDataPointStat(params);
}

var tuya$2 = reactNative.NativeModules.TuyaHomeModule;
function queryRoomList(params) {
  return tuya$2.queryRoomList(params);
}
function getHomeDetail(params) {
  return tuya$2.getHomeDetail(params);
}
function updateHome(params) {
  return tuya$2.updateHome(params);
}
function dismissHome(params) {
  return tuya$2.dismissHome(params);
}
function sortRoom(params) {
  return tuya$2.sortRoom(params);
}

var tuya$3 = reactNative.NativeModules.TuyaHomeDataManagerModule;
function getRoomDeviceList(params) {
  return tuya$3.getRoomDeviceList(params);
}

function _extends() {
  return _extends = Object.assign ? Object.assign.bind() : function (n) {
    for (var e = 1; e < arguments.length; e++) {
      var t = arguments[e];
      for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]);
    }
    return n;
  }, _extends.apply(null, arguments);
}

var queryHomeList = function queryHomeList() {
  try {
    return Promise.resolve(tuya$4.queryHomeList()).then(function (homes) {
      // Tuya's Android SDK uses different property names than the iOS SDK...
      if (reactNative.Platform.OS === 'android') {
        homes = homes.map(function (m) {
          return _extends({}, m, {
            dealStatus: m.homeStatus
          });
        });
      }
      return homes;
    });
  } catch (e) {
    return Promise.reject(e);
  }
};
var tuya$4 = reactNative.NativeModules.TuyaHomeManagerModule;
function createHome(params) {
  return tuya$4.createHome(params);
}
function joinFamily(params) {
  return tuya$4.joinFamily(params);
}

var queryMemberList = function queryMemberList(params) {
  try {
    return Promise.resolve(tuya$5.queryMemberList(params)).then(function (members) {
      // Tuya's Android SDK uses different property names than the iOS SDK...
      if (reactNative.Platform.OS === 'android') {
        members = members.map(function (m) {
          return {
            admin: m.admin,
            username: m.account,
            id: m.memberId,
            dealStatus: m.memberStatus
          };
        });
      }
      return members;
    });
  } catch (e) {
    return Promise.reject(e);
  }
};
var tuya$5 = reactNative.NativeModules.TuyaHomeMemberModule;
function addMember(params) {
  return tuya$5.addMember(params);
}
function removeMember(params) {
  return tuya$5.removeMember(params);
}

var tuya$6 = reactNative.NativeModules.TuyaDeviceModule;
function startOta(params, onSuccess, onFailure, onProgress) {
  tuya$6.startOta(params);
  return addEvent(bridge(HARDWAREUPGRADELISTENER, params.devId), function (data) {
    if (data.type === 'onSuccess') {
      onSuccess(data);
    } else if (data.type === 'onFailure') {
      onFailure(data);
    } else if (data.type === 'onProgress') {
      onProgress(data);
    }
  });
}
function getOtaInfo(params) {
  return tuya$6.getOtaInfo(params);
}

var getAllTimerWithDeviceId = function getAllTimerWithDeviceId(params) {
  try {
    return Promise.resolve(tuya$7.getAllTimerWithDeviceId(params)).then(function (timers) {
      timers.forEach(function (t) {
        t.timerTaskStatus.open = !!t.timerTaskStatus.open;
      });
      return timers;
    });
  } catch (e) {
    return Promise.reject(e);
  }
};
var tuya$7 = reactNative.NativeModules.TuyaTimerModule;
function addTimerWithTask(params) {
  return tuya$7.addTimerWithTask(params);
}
function updateTimerWithTask(params) {
  return tuya$7.updateTimerWithTask(params);
}
function getTimerTaskStatusWithDeviceId(params) {
  return tuya$7.getTimerTaskStatusWithDeviceId(params);
}
function removeTimerWithTask(params) {
  return tuya$7.removeTimerWithTask(params);
}
function updateTimerStatusWithTask(params) {
  return tuya$7.updateTimerStatusWithTask(params);
}

var getCurrentUser = function getCurrentUser() {
  try {
    return Promise.resolve(tuya$8.getCurrentUser()).then(function (user) {
      // The iOS SDK returns an empty user model but the Android one doesn't.
      // Need to check for username over email, as guest accounts do not have an email.
      return user && user.username ? user : null;
    });
  } catch (e) {
    return Promise.reject(e);
  }
};
var tuya$8 = reactNative.NativeModules.TuyaUserModule;
function registerAccountWithEmail(params) {
  return tuya$8.registerAccountWithEmail(params);
}
function getRegisterEmailValidateCode(params) {
  return tuya$8.getRegisterEmailValidateCode(params);
}
function loginWithEmail(params) {
  return tuya$8.loginWithEmail(params);
}
function getEmailValidateCode(params) {
  return tuya$8.getEmailValidateCode(params);
}
function resetEmailPassword(params) {
  return tuya$8.resetEmailPassword(params);
}
function logout() {
  return tuya$8.logout();
}
function cancelAccount() {
  return tuya$8.cancelAccount();
}
function loginWithGuest(params) {
  return tuya$8.loginWithTouristUser(params);
}

exports.DEVLISTENER = DEVLISTENER;
exports.GROUPLISTENER = GROUPLISTENER;
exports.HARDWAREUPGRADELISTENER = HARDWAREUPGRADELISTENER;
exports.HOMECHANGE = HOMECHANGE;
exports.HOMESTATUS = HOMESTATUS;
exports.SINGLETRANSFER = SINGLETRANSFER;
exports.SUBDEVLISTENER = SUBDEVLISTENER;
exports.addEvent = addEvent;
exports.addMember = addMember;
exports.addTimerWithTask = addTimerWithTask;
exports.bridge = bridge;
exports.cancelAccount = cancelAccount;
exports.createHome = createHome;
exports.dismissHome = dismissHome;
exports.getActivatorToken = getActivatorToken;
exports.getAllTimerWithDeviceId = getAllTimerWithDeviceId;
exports.getCurrentUser = getCurrentUser;
exports.getCurrentWifi = getCurrentWifi;
exports.getDataPointStat = getDataPointStat;
exports.getDevice = getDevice;
exports.getDeviceData = getDeviceData;
exports.getEmailValidateCode = getEmailValidateCode;
exports.getHomeDetail = getHomeDetail;
exports.getOtaInfo = getOtaInfo;
exports.getRegisterEmailValidateCode = getRegisterEmailValidateCode;
exports.getRoomDeviceList = getRoomDeviceList;
exports.getTimerTaskStatusWithDeviceId = getTimerTaskStatusWithDeviceId;
exports.initActivator = initActivator;
exports.initBluetoothDualModeActivator = initBluetoothDualModeActivator;
exports.initBluetoothFlowAndroid = initBluetoothFlowAndroid;
exports.joinFamily = joinFamily;
exports.loginWithEmail = loginWithEmail;
exports.loginWithGuest = loginWithGuest;
exports.logout = logout;
exports.openNetworkSettings = openNetworkSettings;
exports.queryHomeList = queryHomeList;
exports.queryMemberList = queryMemberList;
exports.queryRoomList = queryRoomList;
exports.registerAccountWithEmail = registerAccountWithEmail;
exports.registerDevListener = registerDevListener;
exports.removeDevice = removeDevice;
exports.removeMember = removeMember;
exports.removeTimerWithTask = removeTimerWithTask;
exports.renameDevice = renameDevice;
exports.resetEmailPassword = resetEmailPassword;
exports.send = send;
exports.sortRoom = sortRoom;
exports.startAndroidBLEActivator = startAndroidBLEActivator;
exports.startBluetoothScan = startBluetoothScan;
exports.startLateWifiActivation = startLateWifiActivation;
exports.startOta = startOta;
exports.stopConfig = stopConfig;
exports.stopLePairing = stopLePairing;
exports.unRegisterAllDevListeners = unRegisterAllDevListeners;
exports.updateHome = updateHome;
exports.updateTimerStatusWithTask = updateTimerStatusWithTask;
exports.updateTimerWithTask = updateTimerWithTask;
//# sourceMappingURL=react-native-tuya.cjs.development.js.map
