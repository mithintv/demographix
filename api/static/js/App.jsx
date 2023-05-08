function App() {
  const [showMovies, setShowMovies] = React.useState(false);
  const [showUsers, setShowUsers] = React.useState(false);

  const movieHandler = () => {
    setShowMovies(true);
  };

  const userHandler = () => {
    setShowUsers(true);
  };

  return (
    <React.Fragment>
      <h1>Welcome!</h1>

      <h2>Navigation</h2>
      <button onClick={movieHandler}>Top 2022 movies</button>
      {showMovies && <MovieList />}
    </React.Fragment>
  );
}

ReactDOM.render(<App />, document.getElementById("app"));
