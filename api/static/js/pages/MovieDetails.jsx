const MovieDetails = (props) => {
  const [movieDetails, setMovieDetails] = React.useState();
  const [castDetails, setCastDetails] = React.useState([]);
  const [ageData, setAgeData] = React.useState();
  const [genderData, setGenderData] = React.useState();
  const [raceData, setRaceData] = React.useState();
  const [cobData, setCOBData] = React.useState();

  React.useEffect(() => {
    const fetchData = async () => {
      const response = await fetch(`/api/movies/${props.match.params.id}`);
      const movieData = await response.json();
      setMovieDetails(movieData);
      setCastDetails(movieData.cast);

      const listAgeData = parseAges(movieData.cast);
      setAgeData(listAgeData);

      const listGenderData = parseGenders(movieData.cast);
      setGenderData(listGenderData);

      const listRaceData = parseRace(movieData.cast);
      setRaceData(listRaceData);

      const listCOBData = parseCountryOfBirth(movieData.cast);
      setCOBData(listCOBData);
    };
    fetchData();
  }, []);

  return (
    <Fade in>
      <Container>
        <Container
          disableGutters
          sx={{
            display: "flex",
            flexDirection: "column",
          }}
        >
          <MovieCard movie={movieDetails} />
          <CastCard cast={castDetails} />
          <Card>
            <CardContent>{ageData && <Histogram data={ageData} />}</CardContent>
          </Card>
          {genderData && <PieChart data={genderData} />}
          {raceData && <BarChart data={raceData} />}
          {cobData && <WorldMap data={cobData} />}
        </Container>
      </Container>
    </Fade>
  );
};
