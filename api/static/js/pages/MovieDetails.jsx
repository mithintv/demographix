const MovieDetails = (props) => {
  const { id } = props.match.params;
  const [movieDetails, setMovieDetails] = React.useState({
    "id": null,
    "title": null,
    "genres": [],
    "overview": "",
    "runtime": "",
    "poster_path": "",
    "release_date": null,
    "budget": "",
    "revenue": null,
    "cast": [],
  });
  const [castDetails, setCastDetails] = React.useState([]);

  React.useEffect(() => {
    // Set scroll position when the component mounts
    window.scrollTo(0, 0);

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
      <Box
        sx={{
          background: backgroundGradient,
        }}
      >
        <NavBar />
        <Container
          disableGutters
          maxWidth="xl"
          sx={{
            pb: 2,
            pt: 10,
            mx: "auto",
            display: "flex",
            flexDirection: "column",
            flex: "1 1",
          }}
        >
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
            <DataCard
              cast={castDetails}
              releaseDate={new Date(movieDetails.release_date).getFullYear()}
            />
          </Container>
          <CastCard cast={castDetails} />
        </Container>
      </Box>
    </Fade>
  );
};
