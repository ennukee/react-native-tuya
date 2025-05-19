import { DeviceDps } from './device';
import { TuyaError } from './generic';
export declare type AddTimerWithTaskDpsParams = {
    devId: number;
    taskName: string;
    loops: string;
    time: string;
    dps: DeviceDps;
};
export declare function addTimerWithTask(params: AddTimerWithTaskDpsParams): Promise<any>;
export declare type UpdateTimerWithTaskParams = AddTimerWithTaskDpsParams & {
    timerId: string;
    isOpen: boolean;
};
export declare function updateTimerWithTask(params: UpdateTimerWithTaskParams): Promise<any>;
export declare type GetTimerTaskStatusWithDeviceIdParams = {
    devId: number;
};
export declare function getTimerTaskStatusWithDeviceId(params: GetTimerTaskStatusWithDeviceIdParams): Promise<any>;
export declare type GetAllTimerWithDeviceIdParams = {
    devId: number;
};
export declare type TimerTask = {
    timerList: {
        timerId: string;
        loops: string;
        time: string;
        status: number;
    }[];
    timerTaskStatus: {
        open: boolean;
        timerName: string;
    };
};
export declare type GetAllTimerWithDeviceIdResponse = TimerTask[];
export declare function getAllTimerWithDeviceId(params: GetAllTimerWithDeviceIdParams): Promise<GetAllTimerWithDeviceIdResponse | TuyaError>;
export declare type RemoveTimerWithTaskParams = {
    devId: number;
    taskName: string;
    timerId: string;
};
export declare function removeTimerWithTask(params: RemoveTimerWithTaskParams): Promise<any>;
export declare type UpdateTimerStatusWithTaskParams = {
    devId: number;
    taskName: string;
    timerId: string;
    isOpen: boolean;
};
export declare function updateTimerStatusWithTask(params: UpdateTimerStatusWithTaskParams): Promise<any>;
