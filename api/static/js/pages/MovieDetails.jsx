const MovieDetails = (props) => {
  const { id } = props.match.params;
  const [movieDetails, setMovieDetails] = React.useState();
  const [castDetails, setCastDetails] = React.useState([]);

  React.useEffect(() => {
    const fetchData = async () => {
      const response = await fetch(`/api/movies/${id}`);
      const movieData = await response.json();
      setMovieDetails(movieData);
      setCastDetails(movieData.cast);
    };
    fetchData();
  }, [id]);

  return (
    <Fade in>
      <Container
        disableGutters
        maxWidth="xl"
        sx={{
          my: 0,
          mx: "auto",
          display: "flex",
          flexDirection: "column",
          flex: "1 1",
        }}
      >
        <NavBar />
        <Container
          disableGutters
          maxWidth="xl"
          sx={{
            display: "flex",
            flexDirection: "row",
            pt: 1,
          }}
        >
          <MovieCard movie={movieDetails} />
          <DataCard cast={castDetails} />
        </Container>
        <CastCard cast={castDetails} />
      </Container>
    </Fade>
  );
};
