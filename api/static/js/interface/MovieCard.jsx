const MovieCard = (props) => {
  const { movie } = props;

  return (
    <React.Fragment>
      <Card
        sx={{
          mr: 2,
          mb: 2,
          py: 3,
          px: 4,
          width: "350px",
          display: "flex",
          flexDirection: "column",
          flex: "1 1",
        }}
      >
        {movie ? (
          <Container disableGutters>
            <Typography variant="h5">{movie.title}</Typography>
            <Container
              disableGutters
              sx={{
                p: 0,
                marginLeft: 0,
                marginRight: "auto",
                display: "flex",
                flexDirection: "row",
              }}
            >
              <Typography sx={{ paddingRight: 1 }} variant="caption">
                {new Date(movie.release_date).getFullYear()}
              </Typography>
              <Typography variant="caption">
                {compileRuntime(movie.runtime)}
              </Typography>
            </Container>
            <CardMedia
              sx={{ mt: 2, mb: 1 }}
              component="img"
              width={275}
              image={`https://www.themoviedb.org/t/p/w600_and_h900_bestv2${movie.poster_path}`}
              alt={`Movie poster for ${movie.title}`}
            />

            <Stack direction="row" spacing={1}>
              {movie.genres.map((genre, i) => {
                return <Chip key={i} label={genre} />;
              })}
            </Stack>
            <Typography variant="subtitle2" sx={{ my: 1 }}>
              {movie.overview}
            </Typography>
          </Container>
        ) : (
          <Container
            sx={{
              display: "flex",
              flexDirection: "column",
              justifyContent: "center",
              alignItems: "center",
            }}
          >
            <CircularProgress />
          </Container>
        )}
      </Card>
    </React.Fragment>
  );
};
