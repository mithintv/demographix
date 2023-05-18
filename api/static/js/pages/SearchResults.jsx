const SearchResults = (props) => {
  const [currMovie, setCurrMovie] = React.useState(null);
  const [showDetails, setShowDetails] = React.useState(false);

  const setMovieHandler = (movie_id) => {
    setShowDetails(true);
    setCurrMovie(movie_id);
  };

  return (
    <React.Fragment>
      {/* {showDetails && <MovieDetails movie_id={currMovie} />} */}
      {props.results.map((movie, index) => {
        const releaseDate = new Date(movie.release_date);

        let imgPath = `https://www.themoviedb.org/t/p/w600_and_h900_bestv2${movie.poster_path}`;
        if (movie.poster_path == null) {
          imgPath =
            "https://incakoala.github.io/top9movie/film-poster-placeholder.png";
        }

        return (
          <div key={index}>
            <img src={imgPath} width={100} />
            <Link
              onClick={setMovieHandler.bind(this, movie.id)}
              to={`/movies/${movie.id}`}
            >
              <p>
                {movie.title} <span>({releaseDate.getFullYear()})</span>
              </p>
            </Link>
          </div>
        );
      })}
    </React.Fragment>
  );
};
