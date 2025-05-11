export declare type QueryMemberListParams = {
    homeId: number;
};
export declare type MemberListItem = {
    admin: boolean;
    username: string;
    id: number;
    dealStatus: number;
};
export declare type QueryMemberListResponse = MemberListItem[];
export declare function queryMemberList(params: QueryMemberListParams): Promise<QueryMemberListResponse>;
export declare type AddMemberParams = {
    homeId: number;
    userAccount: string;
    countryCode: string;
    name: string;
    admin: boolean;
};
export declare function addMember(params: AddMemberParams): Promise<any>;
export declare type RemoveMemberParams = {
    memberId: number;
};
export declare function removeMember(params: RemoveMemberParams): Promise<any>;
