const SearchResults = (props) => {
  const theme = useTheme();
  return (
    <Paper
      sx={{
        position: "absolute",
        boxSizing: "border-box",
        transform: "translate(-10%, 25%)",
        width: props.results.length * 132,
        mx: "auto",
        minHeight: 182,
        px: 2,
        py: 2,
        display: "flex",
        flexDirection: "row",
        justifyContent: "space-between",
        alignContent: "center",
        zIndex: 3,
        backgroundColor: theme.palette.background.paper,
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
            <Link
              key={index}
              component={RouterLink}
              to={`/movies/${movie.id}`}
              onClick={props.clicked}
            >
              <Card>
                <CardMedia
                  sx={{ width: 100 }}
                  component="img"
                  image={imgPath}
                  alt={`Movie poster for ${movie.title}`}
                />
              </Card>
            </Link>
          );
        })
      ) : (
        <CircularProgress sx={{ margin: "auto" }} />
      )}
      {/* {showDetails && <MovieDetails movie_id={currMovie} />} */}
    </Paper>
  );
};
