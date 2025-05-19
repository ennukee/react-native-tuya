import { TuyaError } from './generic';
export declare type GetRoomDeviceListParams = {
    homeId?: number;
    roomId: number;
};
export declare type GetRoomDeviceListResponse = {
    deviceList: {}[];
    groupList: {}[];
};
export declare function getRoomDeviceList(params: GetRoomDeviceListParams): Promise<GetRoomDeviceListResponse | TuyaError>;
