import { DeviceBean } from './device';
import { NativeModules, Platform } from 'react-native';
import { DeviceDetailResponse } from './home';
import { TuyaError } from './generic';

const tuya = NativeModules.TuyaActivatorModule;
const tuyaBLEActivator = NativeModules.TuyaBLEActivatorModule;
const tuyaBLEScanner = NativeModules.TuyaBLEScannerModule;

export function openNetworkSettings() {
  return tuya.openNetworkSettings({});
}

export enum ActivatorType {
  AP = 'THING_AP',
  EZ = 'THING_EZ',
  AP_4G_GATEWAY = 'THING_4G_GATEWAY',
  QR = 'THING_QR',
}

export type InitActivatorParams = {
  homeId: number;
  ssid: string;
  password: string;
  time: number;
  type: ActivatorType;
};

export function initActivator(
  params: InitActivatorParams
): Promise<DeviceDetailResponse | TuyaError> {
  return tuya.initActivator(params);
}

export function stopConfig() {
  return tuya.stopConfig();
}

export function startBluetoothScan() {
  if (Platform.OS === 'ios') {
    return tuyaBLEScanner.startBluetoothScan();
  }
  return tuya.startBluetoothScan();
}

export function stopLePairing() {
  if (Platform.OS === 'ios') {
    return tuyaBLEActivator.stopLePairing();
  } else {
    console.error('[tuya] stopLePairing is not supported on Android as it is not needed.');
  }
}

export interface InitBluetoothActivatorParams {
  deviceId?: string;
  productId?: string;
  homeId: number;
  ssid: string;
  password: string;
}

export function initBluetoothDualModeActivator(
  params: InitBluetoothActivatorParams
): Promise<DeviceBean | TuyaError> {
  if (Platform.OS === 'ios') {
    return tuyaBLEActivator.initActivator(params);
  }
  return tuya.initBluetoothDualModeActivator(params);
}

export function getCurrentWifi(
  success: (ssid: string) => void,
  error: () => void
) {
  // We need the Allow While Using App location permission to use this.
  return tuya.getCurrentWifi({}, success, error);
}
