// import { Formik, Field, Form, ErrorMessage } from 'formik';
// import * as Yup from 'yup';
// import { login, loginUser } from 'services/auth';
import { useContext, useEffect } from 'react';
import AuthContext from 'app/contexts/authContext';
import { useNavigate } from 'react-router-dom';
import { useState } from 'react';
import { login } from 'app/services/auth';

const initialFormObj =  {
    password: '',
    language: 'en',
    remember: 's',
}

const languageOptions = [
    {
        value: 'de',
        label: 'Deutsch'
    },
    {
        value: 'en',
        label: 'English'
    },
    {
        value: 'es',
        label: 'Español'
    }
];

const rememberOptions = [
    {
        value: 's',
        label: 'this Session'
    },
    {
        value: 'd',
        label: 'one Day'
    },
    {
        value: 'ww',
        label: 'one Week'
    },
    {
        value: 'm',
        label: 'one Month'
    },
    {
        value: 'yyyy',
        label: 'one Year'
    }    
];


const Login = () => {
    const { setIsLoggedIn, isLoggedIn } = useContext(AuthContext);
    const navigate = useNavigate();

    const [form, setForm] = useState<any>(initialFormObj);    

    const formSubmitHandler = async (e: any) => {
        e.preventDefault();
        console.log('formSubmitHandler: ', form);
        const response = await login(form);
        setIsLoggedIn(response?.data?.success);
        console.log('response: ', response)
    }
    
    useEffect(() => {       
        console.log('isLoggedIn in login: ', isLoggedIn)
        isLoggedIn && navigate('/dashboard');
    }, [isLoggedIn]);

    return (
        <>
            <section className="vh-100 login">
                <div className="login-background"></div>
                <div className="login-container h-100">
                    <div className="row login__content">
                        <div className="col-sm-12 col-md-9 col-lg-7 col-xl-6 login__content-column p-0">
                            <div className="card login__card">
                                <div className="login__card-header">
                                    <div className="flex-column flex-sm-row flex-md-row d-flex justify-content-between">
                                        <div className="login__card-text">
                                            <p>Lucee Login</p>
                                        </div>
                                    </div>
                                </div>
                                <div className="card-body login__card-body text-center">
                                    <form onSubmit={formSubmitHandler} method="POST">
                                        <div className="login__card-inputs">

                                            <div>
                                                <label>Password</label>
                                                <input
                                                    type="text"
                                                    value={form.password}
                                                    onChange={(e: any) => {
                                                        setForm((prev: any) => {
                                                            return {
                                                                ...prev,
                                                                password: e.target.value
                                                            }
                                                        })
                                                    }}
                                                />
                                            </div>

                                            <div>
                                                <label>Language</label>
                                                <select
                                                    name="language" 
                                                    onChange={(e: any) => {
                                                        setForm((prev: any) => {
                                                            return {
                                                                ...prev,
                                                                language: e.target.value
                                                            }
                                                        })
                                                    }}
                                                >
                                                    
                                                    {languageOptions.map((option) => {
                                                        return <option value={option.value} defaultValue={form.language} key={option.value} >
                                                            {option.label}
                                                        </option>
                                                    })}
                                                </select>
                                            </div>

                                            <div>
                                                <label>Remember Me for</label>
                                                <select 
                                                    name="rememberMe" 
                                                    className="medium"
                                                    onChange={(e: any) => {
                                                        setForm((prev: any) => {
                                                            return {
                                                                ...prev,
                                                                remember: e.target.value
                                                            }
                                                        })
                                                    }}
                                                >

                                                    {rememberOptions.map((option) => {
                                                        return <option value={option.value} defaultValue={form.remember} key={option.value} >
                                                            {option.label}
                                                        </option>
                                                    })}

                                                </select>
                                            </div>

                                            <div>
                                                <button
                                                    type='submit'
                                                    style={{
                                                        backgroundColor: "#BF4F36",
                                                    }}
                                                >
                                                    Submit
                                                </button>
                                             </div>

                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </>
    );
};

export default Login;
