const NomMovies = (props) => {
  const { award, year } = props;
  const [movies, setMovies] = React.useState([]);
  const [currMovie, setCurrMovie] = React.useState(null);
  const [showDetails, setShowDetails] = React.useState(false);
  const [castData, setCastData] = React.useState([]);

  React.useEffect(() => {
    const fetchData = async () => {
      const response = await fetch(`/api/nom/${year}`);
      const movieList = await response.json();
      setMovies(movieList);

      const castList = compileAges(movieList);
      setCastData(castList);
    };
    fetchData();
  }, [award, year]);

  const setMovieHandler = (movie_id) => {
    setShowDetails(true);
    setCurrMovie(movie_id);
  };

  return (
    <React.Fragment>
      <Paper
        elevation={2}
        sx={{
          mb: 2,
          px: 1,
          py: 2,
          display: "flex",
          flexDirection: "row",
          width: "100%",
          overflowX: "auto",
        }}
      >
        {!showDetails &&
          movies.map((movie, index) => {
            const releaseDate = new Date(movie.release_date);
            return (
              <Card
                key={index}
                elevation={2}
                sx={{
                  width: 125,
                  mx: 1,
                  backgroundColor: "background.default",
                  flex: "0 0 auto",
                }}
              >
                <Link
                  sx={{ mb: 1 }}
                  onClick={setMovieHandler.bind(this, movie.id)}
                >
                  <CardMedia
                    width={100}
                    component="img"
                    image={`https://www.themoviedb.org/t/p/w600_and_h900_bestv2${movie.poster_path}`}
                    alt={`Poster image of ${movie.title} (${releaseDate})`}
                  />
                </Link>
              </Card>
            );
          })}
      </Paper>
      <DataCard cast={castData} />
    </React.Fragment>
  );
};
