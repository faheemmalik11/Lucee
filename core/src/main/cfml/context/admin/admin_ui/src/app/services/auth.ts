import config from 'config/config'
import axios from "app/utils/axios";
import cookie from "js-cookie"

interface ILogin {

    password: string | undefined,
    language: string | undefined,
    remember: string | undefined,
}

export const login = async (body: ILogin) => {
    let response: any
    try {
        response = await axios.post(
            `${config.defaults.api_url}/login.json`,
            body
        );

        console.log('response: ', response);
        console.log('response data: ', response.data);

        // if (response.data.user && response.data.token) {
        //     generateAuthCookies(response.data.user, response.data.token);
        // }

        if (response.data.success && response.data.token) {
            generateAuthCookies(response.data.token);
        }

        return response;
    } catch (error) {
        console.log("Error in [getSupportTickets] : ", error);
        return response;
    }
};

export const loginUser = async (body: ILogin) => {
    let response: any
    try {
        response = await axios.post(
            `${config.defaults.api_url}/login`,
            body
        );

        console.log('response: ', response);
        console.log('response data: ', response.data);

        if (response.data.user && response.data.token) {
            generateAuthCookies(response.data.token);
        }

        return response;
    } catch (error) {
        console.log("Error in [getSupportTickets] : ", error);
        return response;
    }
};

export const logout = async () => {
    resetAuthCookies();
    //     try {
    //     const  response: any = await axios.post(
    //         `${config.defaults.api_url}/logout`
    //     );

    //     console.log('data in logout: ', response);

    //     // if(data.user && data.token) {
    //     //     generateAuthCookies(data.user, data.token);
    //     // }

    //     return response;
    // } catch (error) {
    //     console.log("Error in [getSupportTickets] : ", error);
    //     return null;
    // }
}

// export const loginUser = async (body: ILogin) => {
//     try {
//         const  {data}: any = await axios.post(
//             `${config.defaults.api_url}/login`,
//             body
//         );

//         console.log('data: ', data);

//         if(data.user && data.token) {
//             generateAuthCookies(data.user, data.token);
//         }

//         return data;
//     } catch (error) {
//         console.log("Error in [getSupportTickets] : ", error);
//         return null;
//     }
// };

const generateAuthCookies = (token: string) => {
    const expire = new Date;
    expire.setHours(expire.getHours() + 4);
    console.log('cookie')
    cookie.set('lucee_token', token, { expires: expire });
    console.log('cookie', cookie)
};
const resetAuthCookies = () => {

    cookie.remove('lucee_token');
    console.log('cookie', cookie);
};