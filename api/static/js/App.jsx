function App() {
  const [topMovies, setTopMovies] = React.useState(false);
  const [searchMovies, setSearchMovies] = React.useState(false);
  const [searchResults, setSearchResults] = React.useState([]);
  const searchRef = React.useRef(null);
  const [searchInput, setSearchInput] = React.useState("");

  const topMovieHandler = () => {
    setTopMovies(true);
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

          console.log(searchResults);
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
    <React.Fragment>
      <h1>Welcome!</h1>
      <form onSubmit={searchHandler}>
        <label htmlFor="search">
          <input
            value={searchInput}
            ref={searchRef}
            onChange={searchInputHandler}
            type="text"
            name="search"
          />
        </label>
        <button type="submit">Search</button>
      </form>
      {searchMovies && <SearchResults results={searchResults} />}
      {/* {!topMovies && <button onClick={topMovieHandler}>Top 2022 movies</button>}
      {topMovies && <TopMovies />} */}
    </React.Fragment>
  );
}

ReactDOM.render(<App />, document.getElementById("app"));
