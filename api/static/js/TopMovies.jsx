function TopMovies() {
  const [movies, setMovies] = React.useState([]);

  React.useEffect(() => {
    (async function fetchData() {
      const response = await fetch("/top");
      const parsed = await response.json();
      setMovies(parsed);
    })();
  });

  return (
    <React.Fragment>
      {movies.map((movie, index) => {
        const releaseDate = new Date(movie.release_date);
        return (
          <div key={index}>
            <img
              src={`https://www.themoviedb.org/t/p/w600_and_h900_bestv2${movie.poster_path}`}
              width={250}
            />
            <a href={`/movies/${movie.id}`}>
              <p>
                {movie.title} <span>({releaseDate.getFullYear()})</span>
              </p>
            </a>
          </div>
        );
      })}
    </React.Fragment>
  );
}
