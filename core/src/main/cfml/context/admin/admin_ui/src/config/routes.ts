import IRoute from "app/interfaces/route";
import HomePage from "pages/Home";
import DashboardPage from "pages/Dashboard";
import LoginPage from "pages/Login"

const routes: IRoute[] = [
    {
        path: '/',
        name: 'Home',
        component: HomePage,

    }, 
    {
        path: '/home',
        name: 'Home',
        component: HomePage
    }, 
    {
        path: '/dashboard',
        name: 'Dashboard',
        component: DashboardPage
    }, 
    {
        path: '/login',
        name: 'Login',
        component: LoginPage
    }
];

export default routes;