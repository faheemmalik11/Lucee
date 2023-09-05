// Plugins Import
import { FC } from "react";
import { BrowserRouter, Route, Routes } from "react-router-dom";
// Components Import
import routes from "config/routes";
// Extra Importsconfig/routes
import "./App.css";
const App: FC = () => {
  
  return (
      // <Test />
    <BrowserRouter>
      <Routes>
        {routes.map((route, index) => {
          return (
            <Route
              key={index}
              path={route.path}
              element={
                <route.component
                  {...route.props}
                  name={route.name}
                />}
            />
          );
        })}
      </Routes>
    </BrowserRouter>
  );
};
export default App;