const SearchBar = (props) => {
  const [searchMovies, setSearchMovies] = React.useState(false);
  const [searchResults, setSearchResults] = React.useState([]);
  const searchRef = React.useRef(null);
  const [searchInput, setSearchInput] = React.useState("");

  const searchInputHandler = async (e) => {
    setSearchInput(searchRef.current.value);
  };

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

  const clearInputHandler = () => {
    setSearchMovies(false)
    setSearchInput("")
  }

  return (
    <Container maxWidth="md">
      <Paper
        onSubmit={searchHandler}
        component="form"
        sx={{
          m: "1rem 1rem",
          py: "0.25rem",
          display: "flex",
          flexDirection: "column",
          justifyContent: "space-between",
        }}
      >
        <Container sx={{ display: "flex", flexDirection: "row" }}>
          <InputBase
            sx={{ width: "100%" }}
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
        </Container>
        {searchMovies && <SearchResults clicked={clearInputHandler} results={searchResults} />}
      </Paper>
    </Container>
  );
};
