import { TuyaError } from './generic';
export declare type DeviceBean = {
    productId: string;
    devId: string;
    verSw: string;
    name: string;
    dps: DeviceDps;
    uuid: string;
    communicationId: string;
    connectionStatus: number;
    bluetooth: boolean;
    cloudOnline: boolean;
    isOnline: boolean;
    mac: string;
    address: string;
    deviceType: number;
    meta?: {
        wifiEnable?: boolean;
    };
};
export declare type DevListenerParams = {
    devId: string;
};
export declare type DevListenerType = 'onDpUpdate' | 'onRemoved' | 'onStatusChanged' | 'onNetworkStatusChanged' | 'onDevInfoUpdate' | 'onFirmwareUpgradeSuccess' | 'onFirmwareUpgradeFailure' | 'onFirmwareUpgradeProgress';
export declare function registerDevListener(params: DevListenerParams, type: DevListenerType, callback: (data: any) => void): void;
export declare function unRegisterAllDevListeners(): void;
export declare type GetDeviceParams = {
    devId: string;
};
export declare function getDevice(params: GetDeviceParams): Promise<any>;
export declare function getDeviceData(params: GetDeviceParams): Promise<any>;
export declare type DeviceDpValue = boolean | number | string;
export declare type DeviceDps = {
    [dpId: string]: DeviceDpValue;
};
export declare type SendParams = {
    devId: string;
} & DeviceDps;
export declare function send(params: object): any;
export declare type RemoveDeviceParams = {
    devId: string;
};
export declare function removeDevice(params: RemoveDeviceParams): Promise<string | TuyaError>;
export declare type RenameDeviceParams = {
    devId: string;
    name: string;
};
export declare function renameDevice(params: RenameDeviceParams): Promise<string | TuyaError>;
export declare type GetDataPointStatsParams = {
    devId: string;
    DataPointTypeEnum: 'DAY' | 'WEEK' | 'MONTH';
    number: number;
    dpId: string;
    startTime: number;
};
export declare function getDataPointStat(params: GetDataPointStatsParams): Promise<any>;
