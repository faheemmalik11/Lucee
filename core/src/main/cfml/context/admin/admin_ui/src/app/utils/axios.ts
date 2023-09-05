import axios, { InternalAxiosRequestConfig } from "axios";
import AppConfig from 'config/config';
import cookie from 'js-cookie'


axios.interceptors.request.use((config: InternalAxiosRequestConfig<string>) => {
    // config.headers.Authorization = `Bearer ${cookie.get("lucee_token")}`;
    config.headers.Authorization = `Bearer ${cookie.get("lucee_token")}`;
    config.headers.apiKey = AppConfig.defaults.api_key;
    return config;
});

const UNAUTHORIZED = 401;

axios.interceptors.request.use(
    (request) => {
        return request;
    },
    // eslint-disable-next-line @typescript-eslint/no-explicit-any, @typescript-eslint/no-unsafe-return
    (error: any) => error
);

axios.interceptors.response.use(
    (response) => response,
    (error) => {
        // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
        const { status } = error.response;
        if (status === UNAUTHORIZED) {
            return (window.location.href = "/");
        } else {
            // console.log("Dispatching api Error")
            // dispatchApiError()
            return Promise.reject(error);
        }
    }
);

export default axios;
