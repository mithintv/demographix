const Histogram = React.memo((props) => {
  const histogramRef = React.useRef(null);
  const { data } = props;

  console.log("Rendering Histogram: ", data);

  React.useEffect(() => {
    // set the dimensions and margins of the graph
    const margin = { top: 10, right: 30, bottom: 30, left: 40 },
      width = 450 - margin.left - margin.right,
      height = 300 - margin.top - margin.bottom;

    // append the svg object to the body of the page
    const svg = d3
      .select(histogramRef.current)
      .append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", `translate(${margin.left},${margin.top})`);

    // d3.csv(
    //   "https://raw.githubusercontent.com/holtzy/data_to_viz/master/Example_dataset/1_OneNum.csv"
    // ).then((data) => {

    // X axis: scale and draw:
    const x = d3
      .scaleLinear()
      .domain([0, 100]) // can use this instead of 1000 to have the max of data: d3.max(data, function(d) { return +d.price })
      .range([0, width]);

    svg
      .append("g")
      .attr("transform", `translate(0, ${height})`)
      .call(d3.axisBottom(x));

    // set the parameters for the histogram
    const histogram = d3
      .histogram()
      .value((d) => d.amount) // I need to give the vector of value
      .domain(x.domain()) // then the domain of the graphic
      .thresholds(x.ticks(30)); // then the numbers of bins

    // And apply this function to data to get the bins
    const bins = histogram(data);

    // Y axis: scale and draw:
    const y = d3.scaleLinear().range([height, 0]);
    y.domain([
      0,
      d3.max(bins, function (d) {
        return d.length;
      }),
    ]); // d3.hist has to be called before the Y axis obviously
    svg.append("g").call(d3.axisLeft(y));

    // append the bar rectangles to the svg element
    svg
      .selectAll("rect")
      .data(bins)
      .join("rect")
      .attr("x", 1)
      .attr("transform", (d) => `translate(${x(d.x0)} , ${y(d.length)})`)
      .attr("width", (d) => x(d.x1) - x(d.x0))
      .attr("height", (d) => height - y(d.length))
      .attr("stroke", "white")
      .style("fill", "#69b3a2");
    // });
    return () => {
      // Remove the SVG element from the DOM
      d3.select(histogramRef.current).selectAll("svg").remove();
    };
  }, [data]);

  return (
    <Paper
      elevation={2}
      sx={{
        p: 0,
        m: 2,
        display: "flex",
        justifyContent: "center",
        height: "330px",
        backgroundColor: "background.default",
        flexGrow: 1,
      }}
    >
      <Box
        sx={{
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
          height: "330px",
          width: "100%",
        }}
        ref={histogramRef}
      ></Box>
    </Paper>
  );
});
