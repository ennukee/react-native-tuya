import { TuyaError } from './generic';
import { NativeModules } from 'react-native';

const tuya = NativeModules.TuyaHomeDataManagerModule;

export type GetRoomDeviceListParams = {
  homeId?: number;
  roomId: number;
};

export type GetRoomDeviceListResponse = {
  deviceList: {}[];
  groupList: {}[];
};

export function getRoomDeviceList(
  params: GetRoomDeviceListParams
): Promise<GetRoomDeviceListResponse | TuyaError> {
  return tuya.getRoomDeviceList(params);
}
