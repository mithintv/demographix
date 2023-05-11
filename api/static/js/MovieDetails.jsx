const MovieDetails = (props) => {
  const chartRef = React.useRef(null);
  const [movieDetails, setMovieDetails] = React.useState();
  const [ageData, setAgeData] = React.useState([]);

  React.useEffect(() => {
    const fetchData = async () => {
      const response = await fetch(`/movies/${props.movie_id}`);
      const movieData = await response.json();
      setMovieDetails(movieData);

      const data = [];
      movieData.cast.forEach((cast) => {
        const birthday = new Date(cast.birthday).getFullYear();
        const currYear = new Date().getFullYear();
        const age = currYear - birthday;
        data.push(age);
      });
      setAgeData(data);
    };
    fetchData();
  }, []);

  console.log(movieDetails);

  React.useEffect(() => {
    const svg = d3
      .select(chartRef.current)
      .attr("width", 500)
      .attr("height", 500);

    const bars = svg
      .selectAll("rect")
      .data(ageData)
      .enter()
      .append("rect")
      .attr("x", function (d, i) {
        return i * (500 / ageData.length);
      })
      .attr("y", function (d) {
        return 500 - d * 10;
      })
      .attr("width", 500 / ageData.length - 1)
      .attr("height", function (d) {
        return d * 10;
      })
      .attr("fill", "steelblue");

    console.log("rendering");
  }, [ageData]);

  return (
    <React.Fragment>
      <div>
        <svg ref={chartRef}></svg>
      </div>
      {movieDetails &&
        movieDetails.cast.map((cast, index) => {
          const birthday = new Date(cast.birthday).getFullYear();
          const currYear = new Date().getFullYear();
          const age = currYear - birthday;
          return (
            <div key={index}>
              <p>
                Name: {cast.name} <span>Age: {age}</span>
              </p>
            </div>
          );
        })}
    </React.Fragment>
  );
};
