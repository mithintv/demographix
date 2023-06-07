const PieChart = React.memo((props) => {
  const pieChartRef = React.useRef(null);
  const { data } = props;

  console.log("Rendering Pie Chart: ", data);

  React.useEffect(() => {
    let total = 0;
    data.forEach((el) => {
      total += el.amount;
    });

    const colorScheme = {
      "Male": "#369EC8",
      "Female": "#B63E76",
      "Non-Binary": "#18bd9b",
    };

    const width = 350;
    const height = 300;
    const margin = {
      top: 0,
      left: width * 0.1,
      right: width * 0.1,
      bottom: height * 0.1,
    };

    // The radius of the pieplot is half the width or half the height (smallest one). I subtract a bit of margin.
    const radius = Math.min(width, height) / 2 - margin.right;

    // append the svg object to the pieChart ref
    const svg = d3
      .select(pieChartRef.current)
      .append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr(
        "transform",
        "translate(" +
          (width + margin.left + margin.right) / 2 +
          "," +
          (height + margin.top + margin.bottom) / 2 +
          ")"
      );

    // Create a color scale using the custom color scheme
    const color = d3
      .scaleOrdinal()
      .domain(Object.keys(colorScheme))
      .range(Object.values(colorScheme));

    // Compute the position of each group on the pie:
    const pie = d3
      .pie()
      .value((d) => d.amount)
      .padAngle(0.05);

    // The arc generator
    const arc = d3
      .arc()
      .innerRadius(radius * 0.4) // This is the size of the donut hole
      .outerRadius(radius * 0.8);

    // Another arc that won't be drawn. Just for labels positioning
    const midArc = d3
      .arc()
      .innerRadius(radius * 0.55)
      .outerRadius(radius * 0.8);

    // Another arc that won't be drawn. Just for labels positioning
    const outerArc = d3
      .arc()
      .innerRadius(radius * 0.9)
      .outerRadius(radius * 0.9);

    const updateChart = (newData) => {
      const data_ready = pie(newData);
      const slices = svg.selectAll("allSlices").data(data_ready);

      slices
        .enter()
        .append("path")
        .attr("d", arc)
        .attr("fill", (d) => color(d.data))
        .style("stroke-width", "1px")
        .transition()
        .duration(1000);

      svg
        .selectAll("allPolylines")
        .data(data_ready)
        .join("polyline")
        .attr("stroke", "white")
        .style("fill", "none")
        .attr("stroke-width", 1)
        .attr("points", function (d, i) {
          const centroid = outerArc.centroid(d);
          const posA = midArc.centroid(d); // line insertion in the slice
          const posB = [centroid[0], centroid[1]]; // line break: we use the other arc generator that has been built only for that
          const posC = [centroid[0], centroid[1]]; // Label position = almost the same as posB
          const midangle = d.startAngle + (d.endAngle - d.startAngle) / 2; // we need the angle to see if the X position will be at the extreme right or extreme left
          posC[0] = radius * 0.95 * (midangle < Math.PI ? 1 : -1); // multiply by 1 or -1 to put it on the right or on the left

          return [posA, posB, posC];
        })
        .transition()
        .duration(1000);

      // Add the polylines between chart and labels:
      svg
        .selectAll("allLabels")
        .data(data_ready)
        .join("text")
        .attr("transform", function (d) {
          const pos = outerArc.centroid(d);
          const midangle = d.startAngle + (d.endAngle - d.startAngle) / 2;
          pos[0] = radius * 1 * (midangle < Math.PI ? 1 : -1);
          pos[1] += 2.5;
          return `translate(${pos})`;
        })
        .style("fill", "white")
        .style("text-anchor", function (d) {
          const midangle = d.startAngle + (d.endAngle - d.startAngle) / 2;
          return midangle < Math.PI ? "start" : "end";
        })
        .append("tspan")
        .text((d) => {
          const label = d.data.name;
          if (label.includes("/")) {
            return label.split("/")[0] + "/";
          }
          if (label.includes(" ")) {
            return label.split(" ")[0];
          }
          if (label.includes("-")) {
            return label.split("-")[0] + "-";
          } else
            return `${label} (${Math.round((d.data.amount / total) * 100)}%)`;
        })
        .append("tspan")
        .text((d) => {
          const label = d.data.name;
          if (label.includes("/")) {
            return `${label.split("/")[1]} (${Math.round(
              (d.data.amount / total) * 100
            )}%)`;
          }
          if (label.includes(" ")) {
            return `${label.split(" ")[1]} (${Math.round(
              (d.data.amount / total) * 100
            )}%)`;
          }
          if (label.includes("-")) {
            return `${label.split("-")[1]} (${Math.round(
              (d.data.amount / total) * 100
            )}%)`;
          }
        })
        .attr("x", 0)
        .attr("dy", "1em")
        .transition()
        .duration(2000);
    };
    updateChart(data);

    return () => {
      // Remove the SVG element from the DOM
      d3.select(pieChartRef.current).selectAll("svg").remove();
    };
  }, [data]);

  return (
    <Paper
      elevation={2}
      sx={{
        p: 0,
        m: 2,
        display: "flex",
        flexDirection: "column",
        justifyContent: "start",
        backgroundColor: "background.default",
        flexGrow: 1,
      }}
    >
      <ChartLabel label={"Gender Ratio"} />
      <Box
        sx={{
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
          height: "330px",
        }}
        ref={pieChartRef}
      ></Box>
    </Paper>
  );
});
