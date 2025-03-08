import { ThemeProvider } from "@mui/material/styles";
import React from "react";
import ReactDOM from "react-dom/client";
import { RouterProvider, createBrowserRouter } from "react-router-dom";
import { App } from "./App.tsx";
import "./index.css";
import { LandingPage } from "./pages/LandingPage.tsx";
import ErrorPage from "./pages/Error.tsx";
import { darkTheme } from "./utils/theme.tsx";
import Movies from "./pages/Movies.tsx";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { Visualizer } from "./pages/Visualizer.tsx";

const router = createBrowserRouter([
	{
		path: "/",
		element: <App />,
		errorElement: <ErrorPage />,
		children: [
			{ index: true, element: <LandingPage /> },
			{
				path: "visualizer/:awardParam/:rangeParam/:yearParam",
				element: <Visualizer />,
			},
			{
				path: "movies/:id",
				element: <Movies />,
			},
		],
	},
]);

ReactDOM.createRoot(document.getElementById("root")!).render(
	<React.StrictMode>
		<ThemeProvider theme={darkTheme}>
			<QueryClientProvider client={new QueryClient()}>
				<RouterProvider router={router} />
			</QueryClientProvider>
		</ThemeProvider>
	</React.StrictMode>
);
