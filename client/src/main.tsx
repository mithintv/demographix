import { ThemeProvider } from "@mui/material/styles";
import React from "react";
import ReactDOM from "react-dom/client";
import { RouterProvider, createBrowserRouter } from "react-router-dom";
import App from "./App.tsx";
import "./index.css";
import LandingPage from "./pages/Index.tsx";
import MovieDetails from "./pages/Movies.tsx";
import { Visualizer } from "./pages/Visualizer.tsx";
import ErrorPage from "./routes/ErrorPage.tsx";
import { darkTheme } from "./utils/theme.tsx";

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
        element: <MovieDetails />,
      },
    ],
  },
]);

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <ThemeProvider theme={darkTheme}>
      <RouterProvider router={router} />
      {/* <App /> */}
    </ThemeProvider>
  </React.StrictMode>
);
