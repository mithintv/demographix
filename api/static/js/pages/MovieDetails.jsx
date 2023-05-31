const MovieDetails = (props) => {
  const [movieDetails, setMovieDetails] = React.useState();
  const [ageData, setAgeData] = React.useState();
  const [raceData, setRaceData] = React.useState();
  const [cobData, setCOBData] = React.useState();

  React.useEffect(() => {
    const fetchData = async () => {
      const response = await fetch(`/api/movies/${props.match.params.id}`);
      const movieData = await response.json();
      setMovieDetails(movieData);

      const listAgeData = parseAges(movieData.cast);
      setAgeData(listAgeData);

      const listRaceData = parseRace(movieData.cast);
      setRaceData(listRaceData);

      const listCOBData = parseCountryOfBirth(movieData.cast);
      setCOBData(listCOBData);
    };
    fetchData();
  }, []);

  return (
    <React.Fragment>
      <div
        style={{
          display: "flex",
        }}
      >
        {ageData && <Histogram data={ageData} />}
        {raceData && <BarChart data={raceData} />}
        {cobData && <PieChart data={cobData} />}
      </div>
      {movieDetails && <CastDetails cast={movieDetails.cast} />}
    </React.Fragment>
  );
};
