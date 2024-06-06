import { ThemeProvider, createTheme } from "@mui/material/styles";
import React from "react";
import ReactDOM from "react-dom/client";
import { RouterProvider, createBrowserRouter } from "react-router-dom";
import App from "./App.tsx";
import "./index.css";
import LandingPage from "./pages/LandingPage.tsx";
import MovieDetails from "./pages/MovieDetails.tsx";
import { NomMovies } from "./pages/NomMovies.tsx";
import ErrorPage from "./routes/ErrorPage.tsx";

// Create a theme instance.
const darkTheme = createTheme({
  palette: {
    mode: "dark",
    primary: {
      main: "#fdbd25",
    },
    secondary: {
      main: "#e64788",
    },
    background: {
      default: "#151036",
      paper: "#2c274f",
    },
    text: {
      primary: "#fefffe",
      secondary: "rgba(255, 255, 255, 0.7)",
    },
    warning: {
      main: "#ed6c02",
    },
    success: {
      main: "#2e7d32",
    },
  },
  typography: {
    h1: {
      fontWeight: 700,
      "@media (max-width:960px)": {
        fontSize: "4rem", // for small screens and above
      },
      "@media (max-width:600px)": {
        fontSize: "3.5rem", // for small screens and above
      },
      "@media (max-width:425px)": {
        fontSize: "3rem", // for small screens and above
      },
    },
    h2: {
      fontWeight: 500,
    },
    h3: {
      fontWeight: 500,
    },
    h4: {
      fontWeight: 500,
      "@media (max-width:960px)": {
        fontSize: "1.75rem", // for small screens and above
      },
      "@media (max-width:600px)": {
        fontSize: "1.65rem", // for small screens and above
      },
      "@media (max-width:425px)": {
        fontSize: "1.5rem", // for small screens and above
      },
    },
    h5: {
      fontWeight: 500,
      "@media (max-width:960px)": {
        fontSize: "1rem", // for small screens and above
      },
      "@media (max-width:600px)": {
        fontSize: "0.925rem", // for small screens and above
      },
      "@media (max-width:425px)": {
        fontSize: "0.85rem", // for small screens and above
      },
    },
    subtitle2: {
      fontWeight: 400,
    },
    overline: {
      fontWeight: 500,
      "@media (max-width:960px)": {
        fontSize: "0.7rem", // for small screens and above
      },
      "@media (max-width:600px)": {
        fontSize: "0.65rem", // for small screens and above
      },
      "@media (max-width:425px)": {
        fontSize: "0.50rem", // for small screens and above
      },
      "@media (max-width:375px)": {
        fontSize: "0.45rem", // for small screens and above
      },
    },
    // overline2: {
    // 	fontSize: "2rem",
    // 	fontWeight: 700,
    // 	textTransform: "uppercase",
    // 	"@media (max-width:960px)": {
    // 		fontSize: "1.75rem", // for small screens and above
    // 	},
    // 	"@media (max-width:600px)": {
    // 		fontSize: "1.50rem", // for small screens and above
    // 	},
    // 	"@media (max-width:425px)": {
    // 		fontSize: "1.45rem", // for small screens and above
    // 	},
    // },
  },
});


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
