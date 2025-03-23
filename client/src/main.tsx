import { ThemeProvider } from "@mui/material/styles";
import React from "react";
import ReactDOM from "react-dom/client";
import { Outlet, RouterProvider, createBrowserRouter } from "react-router-dom";
import "./index.css";
import { LandingPage } from "./pages/landing-page.tsx";
import { ErrorPage } from "./pages/error-page.tsx";
import { darkTheme } from "@/shared/utils/theme.tsx";
import { MoviePage } from "./pages/movie/movie-page.tsx";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { VisualizerPage } from "./pages/visualizer/visualizer-page.tsx";
import NavBar from "./components/layout/NavBar.tsx";

const router = createBrowserRouter([
	{
		path: "/",
		element: (
			<>
				<NavBar />
				<Outlet />
			</>
		),
		errorElement: <ErrorPage />,
		children: [
			{ index: true, element: <LandingPage /> },
			{
				path: "visualizer/:awardParam/:rangeParam/:yearParam",
				element: <VisualizerPage />,
			},
			{
				path: "movie/:id",
				element: <MoviePage />,
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
