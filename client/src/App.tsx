import { Outlet } from "react-router-dom";
import NavBar from "./components/layout/NavBar";

export const App = () => {
	return (
		<>
			<NavBar />
			<Outlet />
		</>
	);
};
