import { useEffect, useContext } from "react";
import AuthContext from "app/contexts/authContext";
import { useNavigate } from "react-router-dom";
import cookie from 'js-cookie'

const Auth = (props: any) => {
    const {isLoggedIn, token} = useContext(AuthContext);
    const lucee_token = cookie.get("lucee_token");

    const navigate = useNavigate();

    useEffect(() => {
        console.log('isLoggedIn: ', isLoggedIn)
        console.log('token: ', token)
        !lucee_token && navigate('/login');
    },[isLoggedIn]);


    return <>
        {
            !!lucee_token && <>
                {props.children}
            </>
        }
    </>
}

export default Auth;