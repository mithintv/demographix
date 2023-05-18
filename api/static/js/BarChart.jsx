const BarChart = React.memo((props) => {
  const barChartRef = React.useRef(null);
  const { data } = props;

  console.log("Rendering Bar Chart: ", data);

  React.useEffect(() => {
    const margin = { top: 20, right: 0, bottom: 30, left: 40 };
    const width = 350;
    const height = 300;

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
      .select(barChartRef.current)
      .attr("width", width + margin.left)
      .attr("height", height + margin.bottom + margin.top)
      .attr(
        "transform",
        "translate(" +
          margin.left / 2 +
          "," +
          (margin.top + margin.bottom) / 2 +
          ")"
      );

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
  }, [data]);
  return (
    <div>
      <svg ref={barChartRef}></svg>
    </div>
  );
});
