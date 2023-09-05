import Dashboard from 'components/dashboard';
import Auth from 'components/auth';
import { AuthProvider } from 'app/contexts/authContext';

const DashboardPage = () => {
    return (
        <AuthProvider>
            <Auth>
                <Dashboard />
            </Auth>
        </AuthProvider>
    );
};

export default DashboardPage;