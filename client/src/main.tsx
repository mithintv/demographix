import { ThemeProvider } from "@mui/material/styles";
import React from "react";
import ReactDOM from "react-dom/client";
import { RouterProvider, createBrowserRouter } from "react-router-dom";
import App from "./App.tsx";
import "./index.css";
import LandingPage from "./pages/LandingPage.tsx";
import MovieDetails from "./pages/MovieDetails.tsx";
import { NomMovies } from "./pages/NomMovies.tsx";
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
        path: "noms/",
        element: <NomMovies />,
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
