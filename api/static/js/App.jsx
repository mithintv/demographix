const { BrowserRouter, Route, Link: RouterLink } = ReactRouterDOM;
const {
  AppBar,
  Box,
  Card,
  CardContent,
  CardMedia,
  CircularProgress,
  colors,
  createTheme,
  CssBaseline,
  Container,
  Fade,
  FormControl,
  GlobalStyles,
  InputLabel,
  Link,
  MenuItem,
  IconButton,
  InputBase,
  Paper,
  Select,
  Tab,
  Tabs,
  TextField,
  ThemeProvider,
  Toolbar,
  Typography,
} = MaterialUI;

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
    },
    h2: {
      fontWeight: 500,
    },
    h3: {
      fontWeight: 500,
    },
    overline: {
      fontWeight: 500,
    },
  },
});

const globalStyles = (
  <GlobalStyles
    styles={{
      "*::-webkit-scrollbar-track": {
        padding: 1,
        backgroundColor: "#2c274f",
      },
      "*::-webkit-scrollbar": {
        m: 2,
        height: "0.4rem",
        width: "0.5em",
      },
      "*::-webkit-scrollbar-thumb": {
        backgroundColor: "#545995",
        borderRadius: "2.5px",
      },
    }}
  />
);

const App = (props) => {
  const nomMovieHandler = () => {
    setNomMovies(true);
  };

  console.log(props.match);

  return (
    <BrowserRouter>
      {globalStyles}
      <Route path="/" component={LandingPage} exact></Route>
      <Route path="/movies/:id" component={MovieDetails} exact></Route>
      {/* <BasicTabs year={new Date().getFullYear()} /> */}
    </BrowserRouter>
  );
};

ReactDOM.render(
  <ThemeProvider theme={darkTheme}>
    <CssBaseline />
    <App />
  </ThemeProvider>,
  document.getElementById("app")
);
