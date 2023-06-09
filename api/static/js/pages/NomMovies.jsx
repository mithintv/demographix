const NomMovies = (props) => {
  const { award, year } = props;
  const [movies, setMovies] = React.useState([]);
  const [showDetails, setShowDetails] = React.useState(false);
  const [castData, setCastData] = React.useState([]);

  const data = castData.sort((a, b) => a.id - b.id);
  console.log(data);

  React.useEffect(() => {
    const fetchData = async () => {
      const response = await fetch(`/api/nom/${year}`);
      const movieList = await response.json();
      setMovies(movieList);

      const castList = compileCast(movieList);
      setCastData(castList);
    };
    fetchData();
  }, [award, year]);

  return (
    <Box
      sx={{
        mb: 2,
      }}
    >
      <DataCard cast={castData} />
      <Paper
        sx={{
          display: "flex",
          flexDirection: "column",
          mb: 2,
        }}
      >
        <Typography
          sx={{
            mt: 1,
            pl: 2,
            width: "100%",
            borderBottom: "3px solid rgba(255, 255, 255, 0.05);",
          }}
          variant="overline"
          color="primary"
        >
          Nominations
        </Typography>
        <Container
          disableGutters
          sx={{
            px: 1,
            py: 2,
            display: "flex",
            flexDirection: "row",
            width: "100%",
            overflowX: "scroll",
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
                    cursor: "pointer",
                  }}
                >
                  <Link component={RouterLink} to={`/movies/${movie.id}`}>
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
        </Container>
      </Paper>
    </Box>
  );
};
