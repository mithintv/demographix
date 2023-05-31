const { BrowserRouter, Route, Link: RouterLink } = ReactRouterDOM;
const {
  Box,
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
  },
  components: {
    MuiLink: {
      styleOverrides: {
        root: {
          textDecoration: "none",
        },
      },
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
        maxWidth="sm"
        sx={{
          display: "flex",
          flexDirection: "column",
          justifyContent: "center",
        }}
      >
        <Link component={RouterLink} to="/">
          <Typography
            variant="h1"
            sx={{
              textDecoration: "none",
            }}
          >
            Demographix
          </Typography>
        </Link>
        <Paper
          onSubmit={searchHandler}
          component="form"
          sx={{
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
        <Route path="/movies/:id" component={MovieDetails} exact></Route>
        <BasicTabs />
        {searchMovies && <SearchResults results={searchResults} />}
        <NomMovies year={new Date().getFullYear()} />
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
