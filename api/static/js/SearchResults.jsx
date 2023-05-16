const SearchResults = (props) => {
  return (
    <React.Fragment>
      {props.results.map((movie, index) => {
        const releaseDate = new Date(movie.release_date);
        return (
          <div key={index}>
            <img
              src={`https://www.themoviedb.org/t/p/w600_and_h900_bestv2${movie.poster_path}`}
              width={100}
            />
            <a>
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
