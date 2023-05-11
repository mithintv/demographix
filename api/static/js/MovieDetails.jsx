const MovieDetails = (props) => {
  const [movieDetails, setMovieDetails] = React.useState([]);

  React.useEffect(() => {
    const fetchData = async () => {
      const response = await fetch(`/movies/${props.movie_id}`);
      const movieCastDetails = await response.json();
      setMovieDetails(movieCastDetails);
    };
    fetchData();
    console.log(movieDetails);
  }, []);

  return (
    <React.Fragment>
      {movieDetails.map((cast, index) => {
        return (
          <div key={index}>
            <p>{cast.name}</p>
          </div>
        );
      })}
    </React.Fragment>
  );
};
