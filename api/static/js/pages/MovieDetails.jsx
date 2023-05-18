const MovieDetails = (props) => {
  const [movieDetails, setMovieDetails] = React.useState();
  const [ageData, setAgeData] = React.useState();
  const [raceData, setRaceData] = React.useState();

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
    };
    fetchData();
  }, []);

  return (
    <React.Fragment>
      {ageData && <BarChart data={ageData} />}
      {raceData && <PieChart data={raceData} />}
      {movieDetails && <CastDetails cast={movieDetails.cast} />}
    </React.Fragment>
  );
};
