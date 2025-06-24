import { DeviceBean } from 'device';
import { TuyaError } from './generic';
import { NativeModules, Platform } from 'react-native';

const tuya = NativeModules.TuyaHomeManagerModule;

export type CreateHomeParams = {
  name: string;
  geoName: string;
  lon: number;
  lat: number;
  rooms: string[];
};

export type HomeDetailsResponse = {
  name: string;
  admin: boolean;
  background: string;
  dealStatus?: 1 | 2; // 1 = unaccepted 2 = accepted
  deviceList: DeviceBean[];
  displayOrder: number;
  geoName: string;
  gid: number;
  homeId: number;
  lat: number;
  lon: number;
};

export function createHome(params: CreateHomeParams): Promise<HomeDetailsResponse | TuyaError> {
  return tuya.createHome(params);
}

export type QueryHomeListResponse = HomeDetailsResponse[];

export async function queryHomeList(): Promise<QueryHomeListResponse | TuyaError> {
  let homes = await tuya.queryHomeList();
  // Tuya's Android SDK uses different property names than the iOS SDK...
  if (Platform.OS === 'android') {
    homes = homes.map((m: any) => ({
      ...m,
      dealStatus: m.homeStatus,
    }));
  }
  return homes;
}

export type JoinFamilyParams = {
  homeId: number;
  action: boolean;
};

export function joinFamily(params: JoinFamilyParams) {
  return tuya.joinFamily(params);
}
