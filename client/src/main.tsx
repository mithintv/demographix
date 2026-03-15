import { ThemeProvider } from "@mui/material/styles";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import React from "react";
import ReactDOM from "react-dom/client";
import { Outlet, RouterProvider, createBrowserRouter } from "react-router-dom";

import "./index.css";
import { AdminCastPage } from "./pages/admin/admin-cast-page.tsx";
import { AdminPage } from "./pages/admin/admin-page.tsx";
import { AdminNominationsPage } from "./pages/admin/nominations/admin-nominations-page.tsx";
import { ErrorPage } from "./pages/error-page.tsx";
import { LandingPage } from "./pages/landing-page.tsx";
import { MoviePage } from "./pages/movies/movie-page.tsx";
import { VisualizerPage } from "./pages/visualizer/visualizer-page.tsx";
import { NavBar } from "./shared/layout/nav-bar.tsx";

import { darkTheme } from "@/shared/utils/theme.tsx";

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
				path: "visualizer",
				element: <VisualizerPage />,
			},
			{
				path: "movies/:id",
				element: <MoviePage />,
			},
		],
	},
	...(import.meta.env.DEV
		? [
				{
					path: "/admin",
					element: <Outlet />,
					children: [
						{ index: true, element: <AdminPage /> },
						{ path: "cast", element: <AdminCastPage /> },
						{ path: "nominations", element: <AdminNominationsPage /> },
					],
				},
			]
		: []),
]);

ReactDOM.createRoot(document.getElementById("root")!).render(
	<React.StrictMode>
		<ThemeProvider theme={darkTheme}>
			<QueryClientProvider client={new QueryClient()}>
				<RouterProvider router={router} />
			</QueryClientProvider>
		</ThemeProvider>
	</React.StrictMode>,
);
