const PieChart = React.memo((props) => {
  const pieChartRef = React.useRef(null);
  const { data } = props;
  console.log("Rendering Pie Chart: ", data);

  React.useEffect(() => {
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

    // // Create dummy data
    // const data = { a: 9, b: 20, c: 30, d: 8, e: 12, f: 11 };

    // set the color scale
    const color = d3
      .scaleOrdinal()
      .domain(Object.keys(data))
      .range(d3.schemeDark2);

    // Compute the position of each group on the pie:
    const pie = d3.pie().value((d) => d.value);
    const data_ready = pie(
      Object.entries(data).map(([key, value]) => ({ key, value }))
    );

    // The arc generator
    const arc = d3
      .arc()
      .innerRadius(radius * 0.4) // This is the size of the donut hole
      .outerRadius(radius * 0.8);

    // Another arc that won't be drawn. Just for labels positioning
    const outerArc = d3
      .arc()
      .innerRadius(radius * 0.9)
      .outerRadius(radius * 0.9);

    // Build the pie chart: Basically, each part of the pie is a path that we build using the arc function.
    svg
      .selectAll("allSlices")
      .data(data_ready)
      .enter()
      .append("path")
      .attr("d", arc)
      .attr("fill", (d) => color(d.data))
      .attr("stroke", "white")
      .style("stroke-width", "2px")
      .style("opacity", 0.7);

    svg
      .selectAll("allPolylines")
      .data(data_ready)
      .join("polyline")
      .attr("stroke", "white")
      .style("fill", "none")
      .attr("stroke-width", 1)
      .attr("points", function (d, i) {
        const centroid = outerArc.centroid(d);
        const posA = arc.centroid(d); // line insertion in the slice
        const posB = [centroid[0], centroid[1]]; // line break: we use the other arc generator that has been built only for that
        const posC = [centroid[0], centroid[1]]; // Label position = almost the same as posB
        const midangle = d.startAngle + (d.endAngle - d.startAngle) / 2; // we need the angle to see if the X position will be at the extreme right or extreme left
        posC[0] = radius * 0.95 * (midangle < Math.PI ? 1 : -1); // multiply by 1 or -1 to put it on the right or on the left
        return [posA, posB, posC];
      });

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
        const label = d.data.key;
        if (label.includes("/")) {
          return label.split("/")[0] + "/";
        }
        if (label.includes(" ")) {
          return label.split(" ")[0];
        } else return label;
      })
      .append("tspan")
      .text((d) => {
        const label = d.data.key;
        if (label.includes("/")) {
          return label.split("/")[1];
        }
        if (label.includes(" ")) {
          return label.split(" ")[1];
        }
      })
      .attr("x", 0)
      .attr("dy", "1em");
  }, []);

  return (
    <div
      style={{
        display: "flex",
        justifyContent: "center",
      }}
      ref={pieChartRef}
    ></div>
  );
});
