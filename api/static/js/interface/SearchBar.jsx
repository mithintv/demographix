const SearchBar = (props) => {
  const [searchMovies, setSearchMovies] = React.useState(false);
  const [results, setResults] = React.useState([]);
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
      setResults(json);

      console.log(json);
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
          setResults(json);
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
    setSearchMovies(false);
    setSearchInput("");
  };

  return (
    <Box sx={{ width: "33%" }}>
      <Paper
        onSubmit={searchHandler}
        component="form"
        sx={{
          py: "0.25rem",
          display: "flex",
          flexDirection: "column",
          justifyContent: "space-between",
        }}
      >
        <Box sx={{ display: "flex", flexDirection: "row", pl: 2, pr: 1 }}>
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
        </Box>
        {searchMovies && (
          <SearchResults clicked={clearInputHandler} results={results} />
        )}
      </Paper>
    </Box>
  );
};
