const PieChart = () => {
  const pieChartRef = React.useRef(null);

  React.useEffect(() => {
    var width = 300;
    var height = 300;
    var margin = 40;

    // The radius of the pieplot is half the width or half the height (smallest one). I subtract a bit of margin.
    var radius = Math.min(width, height) / 2 - margin;

    // append the svg object to the div called 'my_dataviz'
    var svg = d3
      .select(pieChartRef.current)
      .append("svg")
      .attr("width", width + margin + margin)
      .attr("height", height + margin + margin)
      .append("g")
      .attr(
        "transform",
        "translate(" +
          (width + margin + margin) / 2 +
          "," +
          (height + margin + margin) / 2 +
          ")"
      );

    // Create dummy data
    var data = { a: 9, b: 20, c: 30, d: 8, e: 12 };

    // set the color scale
    var color = d3
      .scaleOrdinal()
      .domain(Object.keys(data))
      .range(["#98abc5", "#8a89a6", "#7b6888", "#6b486b", "#a05d56"]);

    // Compute the position of each group on the pie:
    var pie = d3.pie().value(function (d) {
      return d.value;
    });
    var data_ready = pie(
      Object.entries(data).map(([key, value]) => ({ key, value }))
    );

    // Build the pie chart: Basically, each part of the pie is a path that we build using the arc function.
    svg
      .selectAll("whatever")
      .data(data_ready)
      .enter()
      .append("path")
      .attr(
        "d",
        d3
          .arc()
          .innerRadius(width / 8) // This is the size of the donut hole
          .outerRadius(radius)
      )
      .attr("fill", function (d) {
        return color(d.data.key);
      })
      .attr("stroke", "black")
      .style("stroke-width", "2px")
      .style("opacity", 0.7);
  }, []);

  return <div ref={pieChartRef}></div>;
};
