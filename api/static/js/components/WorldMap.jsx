const WorldMap = React.memo((props) => {
  const mapRef = React.useRef(null);
  const { data } = props;

  console.log("Rendering Map: ", data);

  React.useEffect(() => {
    const svg = d3.select(mapRef.current).append("svg"),
      margin = { top: 0, right: 10, bottom: 0, left: 10 },
      width = 400,
      height = 320;

    // Map and projection
    const projection = d3
      .geoMercator()
      .scale(65)
      .center([0, 20])
      .translate([width / 2, height / 2]);

    svg
      .attr("width", width + margin.right + margin.left)
      .attr("height", height);

    const colorScale = d3
      .scaleThreshold()
      .domain([1, 3, 5, 10, 20, 40])
      .range(d3.schemeBlues[7]);

    // Load external data and boot
    Promise.all([
      d3.json(
        "https://raw.githubusercontent.com/holtzy/D3-graph-gallery/master/DATA/world.geojson"
      ),
    ]).then((loadData) => {
      let topo = loadData[0];
      data.forEach((country) => {
        const found = topo.features.find((el) => el.id === country.name);
        found.amount = country.amount;
      });

      let mouseOver = function (d) {
        d3.selectAll(".Country")
          .transition()
          .duration(200)
          .style("opacity", 0.5);

        d3.select(this).transition().duration(200).style("opacity", 1);
      };

      let mouseLeave = function (d) {
        d3.selectAll(".Country")
          .transition()
          .duration(200)
          .style("opacity", 0.8);
        d3.select(this).transition().duration(200);
      };

      // Draw the map
      svg
        .append("g")
        .selectAll("path")
        .data(topo.features)
        .join("path")
        .attr("d", d3.geoPath().projection(projection))
        .style("stroke", "white")
        .attr("stroke-width", (d) => (d.amount ? 1 : 0))
        .attr("fill", (d) => colorScale(d.amount))
        .attr("class", function (d) {
          return "Country";
        })
        .style("opacity", 0.8)
        .on("mouseover", mouseOver)
        .on("mouseleave", mouseLeave);
    });
    return () => {
      // Remove the SVG element from the DOM
      d3.select(mapRef.current).selectAll("svg").remove();
    };
  }, [data]);

  return (
    <Paper
      elevation={2}
      sx={{
        p: 0,
        m: 2,
        display: "flex",
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
        ref={mapRef}
      ></Box>
      {/* <svg ref={mapRef}></svg> */}
    </Paper>
  );
});
