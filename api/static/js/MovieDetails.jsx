const MovieDetails = (props) => {
  const [movieDetails, setMovieDetails] = React.useState();
  const [ageData, setAgeData] = React.useState();

  React.useEffect(() => {
    const fetchData = async () => {
      const response = await fetch(`/movies/${props.movie_id}`);
      const movieData = await response.json();
      setMovieDetails(movieData);

      const listData = [];
      const filteredBdays = movieData.cast.filter(
        (cast) => cast.birthday !== null
      );
      filteredBdays.forEach((cast) => {
        const birthday = new Date(cast.birthday).getFullYear();
        const currYear = new Date().getFullYear();
        const age = currYear - birthday;
        listData.push({
          name: cast.name,
          age,
        });
      });
      setAgeData(listData);
    };
    fetchData();
  }, []);

  return (
    <React.Fragment>
      {ageData && <BarChart data={ageData} />}
      <PieChart />
      {movieDetails && <CastDetails cast={movieDetails.cast} />}
    </React.Fragment>
  );
};
