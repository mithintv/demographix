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
      .scaleBand()
      .domain(data.map((d) => d.name[0]))
      .rangeRound([margin.left, width - margin.right])
      .padding(0.1);

    const y = d3
      .scaleLinear()
      .domain([0, d3.max(data, (d) => d.age)])
      .range([height - margin.bottom, margin.top]);

    const yTitle = (g) =>
      g
        .append("text")
        .attr("font-family", "sans-serif")
        .attr("font-size", 10)
        .attr("y", 10)
        .text("Age");

    const xAxis = (g) =>
      g
        .attr("transform", `translate(0,${height - margin.bottom})`)
        .call(d3.axisBottom(x).tickSizeOuter(0));

    const yAxis = (g) =>
      g
        .attr("transform", `translate(${margin.left},0)`)
        .call(d3.axisLeft(y))
        .call((g) => g.select(".domain").remove());

    const svg = d3
      .select(chartRef.current)
      .attr("viewBox", [0, 0, width, height]);

    svg
      .append("g")
      .attr("fill", "steelblue")
      .selectAll("rect")
      .data(data)
      .join("rect")
      .attr("x", (d) => x(d.name[0]))
      .attr("y", (d) => y(d.age))
      .attr("height", (d) => y(0) - y(d.age))
      .attr("width", x.bandwidth());

    svg.append("g").call(xAxis);

    svg.append("g").call(yAxis);

    svg.call(yTitle);

    console.log("rendering");
  }, [data]);

  return (
    <React.Fragment>
      <div style={{ width: "350px" }}>
        <svg ref={chartRef}></svg>
      </div>
      <div>
        <PieChart />
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
              <img
                style={{ borderRadius: "25px" }}
                src={`https://www.themoviedb.org/t/p/w600_and_h900_bestv2${cast.profile_path}`}
                width={100}
              />
              <span>Name: {cast.name} </span>
              <span>Gender: {cast.gender} </span>
              <span>Age: {age} </span>
              <div>
                Race:
                {cast.race.map((race, j) => {
                  return <span key={j}>{race}, </span>;
                })}
              </div>
              <div>
                Ethnicity:{" "}
                {cast.ethnicity.map((ethnicity, k) => {
                  return <span key={k}>{ethnicity}, </span>;
                })}
              </div>
              <span>Country of Birth: {cast.country_of_birth} </span>
              <hr />
            </div>
          );
        })}
    </React.Fragment>
  );
};
