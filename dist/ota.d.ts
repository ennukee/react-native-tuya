export declare type StartOtaParams = {
    devId: string;
};
export declare function startOta(params: StartOtaParams, onSuccess: (data: any) => void, onFailure: (data: any) => void, onProgress: (data: any) => void): import("react-native").EmitterSubscription;
export declare function getOtaInfo(params: StartOtaParams): Promise<any[]>;
