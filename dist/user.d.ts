export declare type RegisterAccountWithEmailParams = {
    countryCode: string;
    email: string;
    validateCode: string;
    password: string;
};
export declare function registerAccountWithEmail(params: RegisterAccountWithEmailParams): Promise<any>;
export declare type GetEmailValidateCodeParams = {
    countryCode: string;
    email: string;
};
export declare function getRegisterEmailValidateCode(params: GetEmailValidateCodeParams): Promise<any>;
export declare type LoginWithEmailParams = {
    email: string;
    password: string;
    countryCode: string;
};
export declare function loginWithEmail(params: LoginWithEmailParams): Promise<any>;
export declare function getEmailValidateCode(params: GetEmailValidateCodeParams): Promise<any>;
export declare type ResetEmailPasswordParams = {
    email: string;
    countryCode: string;
    validateCode: string;
    newPassword: string;
};
export declare function resetEmailPassword(params: ResetEmailPasswordParams): Promise<any>;
export declare function logout(): Promise<string>;
export declare type User = {
    email: string;
    username: string;
    sid: string;
    timezoneId: string;
    uid: string;
    userType: number;
    headPic: string;
    mobile: string;
    nickName: string;
    phoneCode: string;
};
export declare function getCurrentUser(): Promise<User | null>;
export declare function cancelAccount(): Promise<string>;
export declare type GuestAccountLoginParams = {
    countryCode: string;
    nickname: string;
};
export declare function loginWithGuest(params: GuestAccountLoginParams): Promise<any>;
