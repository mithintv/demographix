const drawGraph = () => {};

const MovieDetails = (props) => {
  const chartRef = React.useRef(null);
  const [movieDetails, setMovieDetails] = React.useState();
  const [data, setData] = React.useState([]);

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
      setData(listData);
    };
    fetchData();
  }, []);

  console.log(movieDetails);
  console.log(data);

  React.useEffect(() => {
    const margin = { top: 20, right: 0, bottom: 30, left: 40 };

    const width = 350;
    const height = 250;

    const x = d3
      .scaleLinear()
      .domain([0, d3.max(data, (d) => d.age)])
      .range([0, width]);

    const y = d3
      .scaleBand()
      .domain(data.map((d) => d.name))
      .rangeRound([0, 20 * data.length])
      .padding(0.1);

    const svg = d3
      .select(chartRef.current)
      .attr("width", width)
      .attr("height", y.range()[1])
      .attr("font-family", "sans-serif")
      .attr("font-size", "10")
      .attr("text-anchor", "end");

    const bar = svg
      .selectAll("g")
      .data(data)
      .join("g")
      .attr("transform", (d, i) => `translate(0,${y(d.name)})`);

    bar
      .append("rect")
      .attr("fill", "steelblue")
      .attr("width", (d) => x(d.age))
      .attr("height", y.bandwidth() - 1);

    bar
      .append("text")
      .attr("fill", "white")
      .attr("x", (d) => x(d.age) - 3)
      .attr("y", (y.bandwidth() - 1) / 2)
      .attr("dy", "0.35em")
      .text((d) => d.age);

    console.log("rendering");
  }, [data]);

  return (
    <React.Fragment>
      <div>
        <svg ref={chartRef}></svg>
      </div>
      {movieDetails &&
        movieDetails.cast.map((cast, index) => {
          let age = "Unknown";
          if (cast.birthday) {
            const birthday = new Date(cast.birthday).getFullYear();
            const currYear = new Date().getFullYear();
            age = currYear - birthday;
          }
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
