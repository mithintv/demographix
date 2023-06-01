const MovieCard = (props) => {
  const { movie } = props;

  return (
    <React.Fragment>
      <Card
        sx={{
          margin: 2,
          py: 3,
          px: 4,
          width: "350px",
          height: "100%",
          display: "flex",
          flexDirection: "column",
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
              <Typography sx={{ paddingRight: 1 }} variant="subtitle1">
                {new Date(movie.release_date).getFullYear()}
              </Typography>
              <Typography variant="subtitle1">
                {compileRuntime(movie.runtime)}
              </Typography>
            </Container>
            <CardMedia
              sx={{ my: 2 }}
              component="img"
              width={275}
              image={`https://www.themoviedb.org/t/p/w600_and_h900_bestv2${movie.poster_path}`}
              alt={`Movie poster for ${movie.title}`}
            />
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
              {movie.genres.map((genre, i) => {
                return (
                  <Typography
                    sx={{ paddingRight: 1 }}
                    key={i}
                    variant="subtitle1"
                  >
                    {genre}
                  </Typography>
                );
              })}
            </Container>
            <Typography sx={{ my: 1 }}>{movie.overview}</Typography>
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
