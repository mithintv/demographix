const { BrowserRouter, Route, Link: RouterLink } = ReactRouterDOM;
const {
  Box,
  Card,
  CardContent,
  CardMedia,
  CircularProgress,
  colors,
  createTheme,
  CssBaseline,
  Container,
  Link,
  IconButton,
  InputBase,
  Paper,
  Tab,
  Tabs,
  TextField,
  ThemeProvider,
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
  },
});

const App = () => {
  const nomMovieHandler = () => {
    setNomMovies(true);
  };

  return (
    <BrowserRouter>
      <Container
        maxWidth="lg"
        sx={{
          mt: 10,
          display: "flex",
          height: "100vh",
          flexDirection: "column",
        }}
      >
        <Link sx={{ textDecoration: "none" }} component={RouterLink} to="/">
          <Typography align="center" variant="h1">
            Demographix
          </Typography>
        </Link>
        <Typography color="textSecondary" variant="subtitle2" align="center">
          Visualize the diverse tapestry of on-screen talent in blockbuster
          films
        </Typography>
        <SearchBar />
        <Route path="/movies/:id" component={MovieDetails} exact></Route>
        {/* <BasicTabs year={new Date().getFullYear()} /> */}
      </Container>
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
