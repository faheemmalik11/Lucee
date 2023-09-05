import { FC } from 'react'
import IPage from "app/interfaces/page";
import Login from 'components/login';
import { AuthProvider } from 'app/contexts/authContext';

const LoginPage: FC<IPage> = () => {
    return <AuthProvider><Login /></AuthProvider>
}

export default  LoginPage