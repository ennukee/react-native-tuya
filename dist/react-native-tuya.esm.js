import { Platform, NativeModules, NativeEventEmitter } from 'react-native';

var tuya = NativeModules.TuyaActivatorModule;
var tuyaBLEActivator = NativeModules.TuyaBLEActivatorModule;
var tuyaBLEScanner = NativeModules.TuyaBLEScannerModule;
function openNetworkSettings() {
  return tuya.openNetworkSettings({});
}
var ActivatorType;
(function (ActivatorType) {
  ActivatorType["AP"] = "THING_AP";
  ActivatorType["EZ"] = "THING_EZ";
  ActivatorType["AP_4G_GATEWAY"] = "THING_4G_GATEWAY";
  ActivatorType["QR"] = "THING_QR";
})(ActivatorType || (ActivatorType = {}));
function initActivator(params) {
  return tuya.initActivator(params);
}
function stopConfig() {
  return tuya.stopConfig();
}
function startBluetoothScan() {
  if (Platform.OS === 'ios') {
    return tuyaBLEScanner.startBluetoothScan();
  }
  return tuya.startBluetoothScan();
}
function stopLePairing() {
  if (Platform.OS === 'ios') {
    return tuyaBLEActivator.stopLePairing();
  } else {
    console.error('[tuya] stopLePairing is not supported on Android as it is not needed.');
  }
}
function initBluetoothDualModeActivator(params) {
  if (Platform.OS === 'ios') {
    return tuyaBLEActivator.initActivator(params);
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
var eventEmitter = /*#__PURE__*/new NativeEventEmitter(NativeModules.TuyaRNEventEmitter);
function addEvent(eventName, callback) {
  return eventEmitter.addListener(eventName, callback);
}
var bridge = function bridge(key, id) {
  return key + "//" + id;
};

var tuya$1 = NativeModules.TuyaDeviceModule;
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
  if (Platform.OS === 'ios') {
    console.error('[tuya] getDevice is not supported on iOS');
    return Promise.resolve(null);
  }
  return tuya$1.getDevice(params);
}
function getDeviceData(params) {
  if (Platform.OS === 'ios') {
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

var tuya$2 = NativeModules.TuyaHomeModule;
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

var tuya$3 = NativeModules.TuyaHomeDataManagerModule;
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
      if (Platform.OS === 'android') {
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
var tuya$4 = NativeModules.TuyaHomeManagerModule;
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
      if (Platform.OS === 'android') {
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
var tuya$5 = NativeModules.TuyaHomeMemberModule;
function addMember(params) {
  return tuya$5.addMember(params);
}
function removeMember(params) {
  return tuya$5.removeMember(params);
}

var tuya$6 = NativeModules.TuyaDeviceModule;
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
var tuya$7 = NativeModules.TuyaTimerModule;
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
var tuya$8 = NativeModules.TuyaUserModule;
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

export { ActivatorType, DEVLISTENER, GROUPLISTENER, HARDWAREUPGRADELISTENER, HOMECHANGE, HOMESTATUS, SINGLETRANSFER, SUBDEVLISTENER, addEvent, addMember, addTimerWithTask, bridge, cancelAccount, createHome, dismissHome, getAllTimerWithDeviceId, getCurrentUser, getCurrentWifi, getDataPointStat, getDevice, getDeviceData, getEmailValidateCode, getHomeDetail, getOtaInfo, getRegisterEmailValidateCode, getRoomDeviceList, getTimerTaskStatusWithDeviceId, initActivator, initBluetoothDualModeActivator, joinFamily, loginWithEmail, loginWithGuest, logout, openNetworkSettings, queryHomeList, queryMemberList, queryRoomList, registerAccountWithEmail, registerDevListener, removeDevice, removeMember, removeTimerWithTask, renameDevice, resetEmailPassword, send, sortRoom, startBluetoothScan, startOta, stopConfig, stopLePairing, unRegisterAllDevListeners, updateHome, updateTimerStatusWithTask, updateTimerWithTask };
//# sourceMappingURL=react-native-tuya.esm.js.map
