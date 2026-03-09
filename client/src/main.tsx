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
import { AdminPage } from "./pages/admin/admin-page.tsx";
import { AdminCastPage } from "./pages/admin/admin-cast-page.tsx";
import { AdminNominationsPage } from "./pages/admin/nominations/admin-nominations-page.tsx";

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
