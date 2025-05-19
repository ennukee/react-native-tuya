import { DeviceDps } from './device';
import { TuyaError } from './generic';
export declare type QueryRoomListParams = {
    homeId?: number;
};
export declare type QueryRoomListResponse = {
    name: string;
    displayOrder: number;
    id: number;
    roomId: number;
}[] | TuyaError;
export declare function queryRoomList(params: QueryRoomListParams): Promise<QueryRoomListResponse>;
export declare type GetHomeDetailParams = {
    homeId: number;
};
export declare type DeviceDetailResponse = {
    homeId: number;
    isOnline: boolean;
    productId: string;
    devId: string;
    verSw: string;
    name: string;
    dps: DeviceDps;
    homeDisplayOrder: number;
    roomId: number;
} | TuyaError;
export declare type GetHomeDetailResponse = {
    deviceList: DeviceDetailResponse[];
    groupList: any[];
    meshList: any[];
    sharedDeviceList: any[];
    sharedGroupList: any[];
} | TuyaError;
export declare function getHomeDetail(params: GetHomeDetailParams): Promise<GetHomeDetailResponse>;
export declare type UpdateHomeParams = {
    homeId: number;
    name: string;
    geoName: string;
    lon: number;
    lat: number;
};
export declare function updateHome(params: UpdateHomeParams): Promise<string>;
export declare type DismissHomeParams = {
    homeId: number;
};
export declare function dismissHome(params: DismissHomeParams): Promise<string>;
export declare type SortRoomsParams = {
    idList: number[];
    homeId: number;
};
export declare function sortRoom(params: SortRoomsParams): Promise<string>;
