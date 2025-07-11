import { NativeModules } from 'react-native';
import { DeviceDps } from './device';
import { TuyaError } from './generic';

const tuya = NativeModules.TuyaHomeModule;

export type QueryRoomListParams = {
  homeId?: number;
};
export type QueryRoomListResponse = {
  name: string;
  displayOrder: number;
  id: number;
  roomId: number;
}[];

export function queryRoomList(
  params: QueryRoomListParams
): Promise<QueryRoomListResponse | TuyaError> {
  return tuya.queryRoomList(params);
}

export type GetHomeDetailParams = {
  homeId: number;
};
export type DeviceDetailResponse = {
  homeId: number;
  isOnline: boolean;
  cloudOnline: boolean;
  productId: string;
  devId: string;
  verSw: string;
  name: string;
  dps: DeviceDps;
  homeDisplayOrder: number;
  roomId: number;
  uuid: string;
  communicationId: string;
};
export type GetHomeDetailResponse = {
  deviceList: DeviceDetailResponse[];
  groupList: any[];
  meshList: any[];
  sharedDeviceList: any[];
  sharedGroupList: any[];
};

export function getHomeDetail(
  params: GetHomeDetailParams
): Promise<GetHomeDetailResponse | TuyaError> {
  return tuya.getHomeDetail(params);
}

export type UpdateHomeParams = {
  homeId: number;
  name: string;
  geoName: string;
  lon: number;
  lat: number;
};

export function updateHome(params: UpdateHomeParams): Promise<string | TuyaError> {
  return tuya.updateHome(params);
}

export type DismissHomeParams = {
  homeId: number;
};

export function dismissHome(params: DismissHomeParams): Promise<string | TuyaError> {
  return tuya.dismissHome(params);
}

export type SortRoomsParams = {
  idList: number[];
  homeId: number;
};

export function sortRoom(params: SortRoomsParams): Promise<string | TuyaError> {
  return tuya.sortRoom(params);
}
