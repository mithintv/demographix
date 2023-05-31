const WorldMap = React.memo((props) => {
  const mapRef = React.useRef(null);
  const { data } = props;

  console.log("Rendering Map: ", data);

  React.useEffect(() => {
    const svg = d3.select(mapRef.current),
      margin = { top: 0, right: 100, bottom: 0, left: 100 },
      width = 450,
      height = 350;

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
    ]).then(function (loadData) {
      let topo = loadData[0];

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
        // .attr("fill", "#69b3a2")
        .attr("d", d3.geoPath().projection(projection))
        .style("stroke", "white")
        // .data(data, (d) => (d.name, d.amount))
        .attr("stroke-width", (d) => {
          const element = data.find((el) => d.id === el.name);
          if (element) return 1;
          else return 0;
        })
        .attr("fill", (d) => {
          const element = data.find((el) => d.id === el.name);
          if (element) {
            d.total = element.amount;
            return colorScale(d.total);
          }
        })
        .attr("class", function (d) {
          return "Country";
        })
        .style("opacity", 0.8)
        .on("mouseover", mouseOver)
        .on("mouseleave", mouseLeave);
    });
  }, []);

  return <svg ref={mapRef}></svg>;
});
