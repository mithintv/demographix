const NomMovies = (props) => {
  const [movies, setMovies] = React.useState([]);
  const [currMovie, setCurrMovie] = React.useState(null);
  const [showDetails, setShowDetails] = React.useState(false);
  const [ageData, setAgeData] = React.useState();
  const [raceData, setRaceData] = React.useState();
  const [cobData, setCOBData] = React.useState();

  React.useEffect(() => {
    const fetchData = async () => {
      const response = await fetch(`/api/nom/${props.year}`);
      const movieList = await response.json();
      setMovies(movieList);

      const castList = compileAges(movieList);
      setAgeData(parseAges(castList));
      setRaceData(parseRace(castList));
      setCOBData(parseCountryOfBirth(castList));
    };
    fetchData();
  }, []);

  const setMovieHandler = (movie_id) => {
    setShowDetails(true);
    setCurrMovie(movie_id);
  };

  return (
    <React.Fragment>
      {ageData && <Histogram data={ageData} />}
      {raceData && <BarChart data={raceData} />}
      {cobData && <WorldMap data={cobData} />}
      {!showDetails &&
        movies.map((movie, index) => {
          const releaseDate = new Date(movie.release_date);
          return (
            <div key={index}>
              {/* <img
                src={`https://www.themoviedb.org/t/p/w600_and_h900_bestv2${movie.poster_path}`}
                width={100}
              /> */}
              <a onClick={setMovieHandler.bind(this, movie.id)}>
                <p>
                  {movie.title} <span>({releaseDate.getFullYear()})</span>
                </p>
              </a>
            </div>
          );
        })}
    </React.Fragment>
  );
};
