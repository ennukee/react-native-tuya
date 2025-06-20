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
}[];
export declare function queryRoomList(params: QueryRoomListParams): Promise<QueryRoomListResponse | TuyaError>;
export declare type GetHomeDetailParams = {
    homeId: number;
};
export declare type DeviceDetailResponse = {
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
export declare type GetHomeDetailResponse = {
    deviceList: DeviceDetailResponse[];
    groupList: any[];
    meshList: any[];
    sharedDeviceList: any[];
    sharedGroupList: any[];
};
export declare function getHomeDetail(params: GetHomeDetailParams): Promise<GetHomeDetailResponse | TuyaError>;
export declare type UpdateHomeParams = {
    homeId: number;
    name: string;
    geoName: string;
    lon: number;
    lat: number;
};
export declare function updateHome(params: UpdateHomeParams): Promise<string | TuyaError>;
export declare type DismissHomeParams = {
    homeId: number;
};
export declare function dismissHome(params: DismissHomeParams): Promise<string | TuyaError>;
export declare type SortRoomsParams = {
    idList: number[];
    homeId: number;
};
export declare function sortRoom(params: SortRoomsParams): Promise<string | TuyaError>;
