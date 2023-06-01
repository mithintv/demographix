const SearchResults = (props) => {
  const [currMovie, setCurrMovie] = React.useState(null);
  const [showDetails, setShowDetails] = React.useState(false);

  const setMovieHandler = (movie_id) => {
    props.clicked();
    setShowDetails(true);
    setCurrMovie(movie_id);
  };

  return (
    <React.Fragment>
      <Box
        sx={{
          boxSizing: "border-box",
          width: props.results.length * 132,
          mx: "auto",
          minHeight: 182,
          px: 2,
          py: 2,
          display: "flex",
          flexDirection: "row",
          justifyContent: "space-between",
          alignContent: "center",
        }}
      >
        {props.results.length > 0 ? (
          props.results.map((movie, index) => {
            const releaseDate = new Date(movie.release_date);

            let imgPath = `https://www.themoviedb.org/t/p/w600_and_h900_bestv2${movie.poster_path}`;
            if (movie.poster_path == null) {
              imgPath =
                "https://incakoala.github.io/top9movie/film-poster-placeholder.png";
            }

            return (
              <Card key={index}>
                <Link
                  component={RouterLink}
                  onClick={setMovieHandler.bind(this, movie.id)}
                  to={`/movies/${movie.id}`}
                >
                  <CardMedia
                    sx={{ width: 100 }}
                    component="img"
                    image={imgPath}
                    alt={`Movie poster for ${movie.title}`}
                  />
                </Link>
              </Card>
            );
          })
        ) : (
          <CircularProgress sx={{ margin: "auto" }} />
        )}
        {/* {showDetails && <MovieDetails movie_id={currMovie} />} */}
      </Box>
    </React.Fragment>
  );
};
