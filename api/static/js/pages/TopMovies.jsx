const TopMovies = () => {
  const [movies, setMovies] = React.useState([]);
  const [currMovie, setCurrMovie] = React.useState(null);
  const [showDetails, setShowDetails] = React.useState(false);

  React.useEffect(() => {
    const fetchData = async () => {
      const response = await fetch("/top");
      const movieList = await response.json();
      setMovies(movieList);
    };
    fetchData();
  }, []);

  const setMovieHandler = (movie_id) => {
    setShowDetails(true);
    setCurrMovie(movie_id);
  };

  console.log(currMovie);

  return (
    <React.Fragment>
      {showDetails && <MovieDetails movie_id={currMovie} />}
      {!showDetails &&
        movies.map((movie, index) => {
          const releaseDate = new Date(movie.release_date);
          return (
            <div key={index}>
              <img
                src={`https://www.themoviedb.org/t/p/w600_and_h900_bestv2${movie.poster_path}`}
                width={250}
              />
              <a onClick={setMovieHandler.bind(this, movie.id)}>
                <p>
                  {movie.title} <span>({releaseDate.getFullYear()})</span>
                </p>
              </a>
            </div>
          );
        })}
    </React.Fragment>
  );
};
