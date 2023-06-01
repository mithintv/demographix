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
});

const App = () => {
  const [searchMovies, setSearchMovies] = React.useState(false);
  const [searchResults, setSearchResults] = React.useState([]);
  const searchRef = React.useRef(null);
  const [searchInput, setSearchInput] = React.useState("");

  const nomMovieHandler = () => {
    setNomMovies(true);
  };

  const searchInputHandler = async (e) => {
    setSearchInput(searchRef.current.value);
  };

  React.useEffect(() => {
    let timeout;
    if (searchInput.length > 0) {
      setSearchMovies(true);
      timeout = setTimeout(async () => {
        try {
          const options = {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify({
              search: searchInput,
            }),
          };
          const response = await fetch("/", options);
          const json = await response.json();
          setSearchResults(json);
        } catch (err) {
          console.log(err);
        }
      }, 200);
    } else {
      setSearchMovies(false);
    }
    return () => {
      clearTimeout(timeout);
    };
  }, [searchInput]);

  const searchHandler = async (e) => {
    e.preventDefault();
    setSearchMovies(true);
    const keyword = searchRef.current.value;
    console.log(keyword);

    try {
      const options = {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          search: keyword,
        }),
      };
      const response = await fetch("/search", options);
      const json = await response.json();
      setSearchResults(json);

      console.log(searchResults);
    } catch (err) {
      console.log(err);
    }
  };

  return (
    <BrowserRouter>
      <Container
        maxWidth="lg"
        sx={{
          display: "flex",
          flexDirection: "column",
          justifyContent: "center",
        }}
      >
        <Paper
          onSubmit={searchHandler}
          component="form"
          sx={{
            m: "1rem 1rem",
            p: "0.25rem 1rem",
            display: "flex",
            justifyContent: "space-between",
          }}
        >
          <InputBase
            inputRef={searchRef}
            value={searchInput}
            id="outlined-basic"
            name="search"
            label=""
            placeholder="Search Movies"
            variant="outlined"
            onChange={searchInputHandler}
          />
          <IconButton type="submit" sx={{ p: "10px" }} aria-label="search">
            <span className="material-symbols-outlined">search</span>
          </IconButton>
        </Paper>
        <Link sx={{ textDecoration: "none" }} component={RouterLink} to="/">
          <Typography align="center" variant="h1">
            Demographix
          </Typography>
        </Link>
        <Typography color="textSecondary" variant="subtitle2" align="center">
          Visualize the diverse tapestry of on-screen talent in blockbusterfilms
        </Typography>

        <Route path="/movies/:id" component={MovieDetails} exact></Route>
        <BasicTabs year={new Date().getFullYear()} />
        {searchMovies && <SearchResults results={searchResults} />}
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
