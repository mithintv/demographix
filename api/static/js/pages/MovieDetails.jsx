const MovieDetails = (props) => {
  const [movieDetails, setMovieDetails] = React.useState();
  const [ageData, setAgeData] = React.useState();
  const [raceData, setRaceData] = React.useState();
  const [birthCountryData, setBCData] = React.useState();

  React.useEffect(() => {
    const fetchData = async () => {
      const response = await fetch(`/api/movies/${props.match.params.id}`);
      const movieData = await response.json();
      setMovieDetails(movieData);

      const listAgeData = [];
      const filteredBdays = movieData.cast.filter(
        (cast) => cast.birthday !== null
      );
      filteredBdays.forEach((cast) => {
        const birthday = new Date(cast.birthday).getFullYear();
        const currYear = new Date().getFullYear();
        const age = currYear - birthday;
        listAgeData.push({
          name: cast.name,
          age,
        });
      });
      setAgeData(listAgeData);

      const listRaceData = {};
      movieData.cast.forEach((cast) => {
        if (cast.race.length === 0) {
          listRaceData["Unknown"] = listRaceData["Unknown"]
            ? (listRaceData["Unknown"] += 1)
            : 1;
        }
        cast.race.forEach((race) => {
          listRaceData[race] = listRaceData[race]
            ? (listRaceData[race] += 1)
            : 1;
        });
      });
      setRaceData(listRaceData);

      const listBCData = {};
      movieData.cast.forEach((cast) => {
        if (cast.country_of_birth === null) {
          listBCData["Unknown"] = listBCData["Unknown"]
            ? (listBCData["Unknown"] += 1)
            : 1;
        } else {
          listBCData[cast.country_of_birth] = listBCData[cast.country_of_birth]
            ? (listBCData[cast.country_of_birth] += 1)
            : 1;
        }
      });
      setBCData(listBCData);
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
        {ageData && <BarChart data={ageData} />}
        {raceData && <PieChart data={raceData} />}
        {birthCountryData && <PieChart data={birthCountryData} />}
      </div>
      {movieDetails && <CastDetails cast={movieDetails.cast} />}
    </React.Fragment>
  );
};
