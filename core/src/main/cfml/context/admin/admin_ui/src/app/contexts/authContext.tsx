import { createContext, useReducer } from 'react';
import cookie from "js-cookie"

import { IAuth } from 'app/interfaces/auth';
import IProvider from "app/interfaces/provider";
import { AuthActions, AuthReducer } from '../contexts/reducers/auth';


const AuthContext = createContext <IAuth> (null!);
export default AuthContext;

const lucee_token = cookie.get("lucee_token");
const system_user = cookie.get("system_user");

export const AuthInitState: IAuth = {
    token: lucee_token ? lucee_token : '',
    setToken: () => {},
    user: system_user ? JSON.parse(system_user) : {
        id: null!,
        status: null!,

        name: '',
        slug: '',
        email: '',
        website: '',
        address: '',
        phone: '',
        created_at: '',
        updated_at: '',

        roles: [],
    },
    isLoggedIn: false,
    
    setUser: () => {},
    setIsLoggedIn: () => {},

    logout: () => {},
};

export const AuthProvider = (props: IProvider) => {
    const [{ token, user, isLoggedIn }, dispatch] = useReducer(AuthReducer, AuthInitState);

    const setToken = (token: string) => {
        dispatch({
            type: AuthActions.SET_TOKEN,
            payload: token,
        });
    };

    const setIsLoggedIn = (success: boolean) => {
        dispatch({
            type: AuthActions.SET_LOGGED_IN,
            payload: success
        });
    }

    const setUser = (user: any) => {
        console.log('user: ', user);
        dispatch({
            type: AuthActions.SET_USER,
            payload: user
        });
    }

    const removeAuthCookies = () => {
        cookie.remove('lucee_token');
        cookie.remove('system_user');
    };

    const logout = () => {
        console.log('logout dispatched');
        
        dispatch({
            type: AuthActions.LOGOUT,
            payload: {}
        });

        removeAuthCookies();
        return true;
    }
    
    return (
        <>
            <AuthContext.Provider 
                value={{
                    token,
                    isLoggedIn,
                    setToken,
                    user,
                    setUser,
                    setIsLoggedIn,
                    logout,
                }}
            >
                {props.children}
            </AuthContext.Provider>
        </>
    );
};