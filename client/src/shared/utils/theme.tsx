import { createTheme } from "@mui/material";
import { CSSProperties } from "react";
import { ImplicitLabelType } from "recharts/types/component/Label";

// Create a theme instance.
export const darkTheme = createTheme({
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
    subtitle1: {
      fontSize: "2rem",
      fontWeight: 700,
      textTransform: "uppercase",
      "@media (max-width:960px)": {
        fontSize: "1.75rem", // for small screens and above
      },
      "@media (max-width:600px)": {
        fontSize: "1.50rem", // for small screens and above
      },
      "@media (max-width:425px)": {
        fontSize: "1.45rem", // for small screens and above
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
  },
});

export const backgroundGradient =
  "radial-gradient(ellipse at center, #151036 50%, #100b2a 100%)";

export const axisLineStyle = {
  stroke: darkTheme.palette.text.secondary,
};
export const tickStyle = {
  fill: darkTheme.palette.text.secondary,
  y: -10,
};
export const cursorColor = {
  fill: darkTheme.palette.text.disabled,
};
export const histogramLabelStyle: ImplicitLabelType = {
  fill: darkTheme.palette.text.secondary,
  position: "top",
};
export const barChartLabelStyle: CSSProperties = {
  fill: darkTheme.palette.text.secondary,
  // position: "righ",
  fontSize: "0.75em",
};
export const barChartLabelStyle2: CSSProperties = {
  fill: darkTheme.palette.text.secondary,
  // position: "right",
  fontSize: "0",
};
