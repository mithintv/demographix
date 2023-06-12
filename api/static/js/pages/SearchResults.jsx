const SearchResults = ({ clicked, keywords }) => {
  const [results, setResults] = React.useState([]);
  const theme = useTheme();

  React.useEffect(() => {
    const fetchSearch = async (query) => {
      try {
        const options = {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            search: query,
          }),
        };
        const response = await fetch("/", options);
        const json = await response.json();
        setResults(json);
      } catch (err) {
        console.log(err);
      }
    };
    let timeout;
    if (keywords.length === 0) {
      fetchSearch(keywords);
    } else {
      timeout = setTimeout(async () => {
        fetchSearch(keywords);
      }, 2000);
    }
    return () => {
      clearTimeout(timeout);
    };
  }, [keywords]);
  return (
    <Box
      sx={{
        boxSizing: "border-box",
        mx: "auto",
        minHeight: 760,
        display: "flex",
        flexDirection: "row",
        flexWrap: "wrap",
        justifyContent: "space-between",
        alignContent: "center",
        zIndex: 3,
      }}
    >
      {results.length > 0 ? (
        results.map((movie, index) => {
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
              onClick={clicked}
            >
              <Card
                sx={{
                  m: 1,
                }}
              >
                <CardMedia
                  sx={{ width: 110 }}
                  component="img"
                  image={imgPath}
                  alt={`Movie poster for ${movie.title}`}
                />
              </Card>
            </Link>
          );
        })
      ) : (
        <CircularProgress size={100} thickness={10} />
      )}
      {/* {showDetails && <MovieDetails movie_id={currMovie} />} */}
    </Box>
  );
};
