function App() {
  const [topMovies, setTopMovies] = React.useState(false);

  const topMovieHandler = () => {
    setTopMovies(true);
  };

  return (
    <React.Fragment>
      <h1>Welcome!</h1>
      <button onClick={topMovieHandler}>Top 2022 movies</button>
      {topMovies && <TopMovies />}
    </React.Fragment>
  );
}

ReactDOM.render(<App />, document.getElementById("app"));
