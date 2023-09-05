import React, { useEffect, useState } from "react";
// import AuthContext from "app/contexts/authContext";
// import Employees from "./employees";
import { useNavigate } from "react-router-dom";
// import { useLocation } from 'react-router-dom';
import Header from "components/header/header";
import Footer from "components/footer/footer";
import SideBar from "components/side_bar";

const Dashboard = () => {
    const navigate = useNavigate();
    // const location = useLocation();
    // const { user } = useContext(AuthContext);
    const [welcomeMessege, setWelcomeMessege] = useState<string>('Lucee 6.0.0.531-SNAPSHOT - Overview');
    // const [isAdmin, setIsAdmin] = useState<boolean>(false);
    // const [updateId, setUpdateId] = useState<number>();
    console.log(navigate)
    useEffect(() => {
        // if (user.roles.includes('all')) {
        //     setWelcomeMessege('Welcome super admin')
        //     setIsAdmin(true)
        // }
        // else {
        //     setWelcomeMessege('Welcome user')
        // }
        // if (location.state !== null) {
        //     setUpdateId(location.state.id);
        // }
    })
    // const handleAddEmployee = () => {
    //     navigate('/add_employee')
    // }

    console.log(setWelcomeMessege)
    return <React.Fragment>
        <Header />
        <SideBar />
       
        
        <h1>{welcomeMessege}</h1>


        <Footer />
    
    </React.Fragment>
}

export default Dashboard;