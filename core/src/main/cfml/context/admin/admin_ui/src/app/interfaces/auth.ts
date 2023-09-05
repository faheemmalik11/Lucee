export interface IAuth {
    token: string;
    setToken: Function;
    user: IUser;
    setUser: Function;
    isLoggedIn: Boolean;
    setIsLoggedIn: Function;
    logout: Function;
}


export interface IUser {
    id: number,
    status: number,

    name: string,
    slug: string,
    email: string,
    website: string,
    address: string,
    phone: string,
    created_at: string,
    updated_at: string,

    roles: string[]
}