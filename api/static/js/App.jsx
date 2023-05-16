function App() {
  const [topMovies, setTopMovies] = React.useState(false);
  const [searchMovies, setSearchMovies] = React.useState(false);
  const searchRef = React.useRef(null);

  const topMovieHandler = () => {
    setTopMovies(true);
  };

  const searchHandler = async (e) => {
    e.preventDefault();
    const keyword = searchRef.current.value;
    console.log(keyword);

    const data = {
      search: keyword,
    };
    try {
      const response = await fetch("/", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(data),
      });
      const json = await response.json();
      console.log(json);
    } catch (err) {
      console.log(err);
    }
  };

  return (
    <React.Fragment>
      <h1>Welcome!</h1>
      <form onSubmit={searchHandler}>
        <label htmlFor="search">
          <input ref={searchRef} type="text" name="search" />
        </label>
        <button type="submit">Search</button>
      </form>
      {searchResults && <SearchResults />}
      {!topMovies && <button onClick={topMovieHandler}>Top 2022 movies</button>}
      {topMovies && <TopMovies />}
    </React.Fragment>
  );
}

ReactDOM.render(<App />, document.getElementById("app"));
