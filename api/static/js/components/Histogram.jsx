const CustomTooltip = ({ active, payload, label }) => {
  if (active && payload && payload.length) {
    const ageGroup = payload[0].payload.ageGroup;
    const count = payload[0].value;
    const names = payload[0].payload.names || [];

    return (
      <Paper sx={{ p: 2 }}>
        <Typography variant="overline">{`${ageGroup}: ${count}`}</Typography>
        <p>{`Names: ${names.join(", ")}`}</p>
      </Paper>
    );
  }

  return null;
};

const Histogram = React.memo((props) => {
  const [histogram, setHistogram] = React.useState([]);
  const { data } = props;

  React.useEffect(() => {
    const histogramData = d3.range(0, 10).map((i) => ({
      ageGroup: `${i * 10}-${(i + 1) * 10}`,
      count: 0,
      names: [],
    }));

    data.forEach((item) => {
      const ageGroupIndex = Math.floor(item.amount / 10);
      if (ageGroupIndex >= 0 && ageGroupIndex < histogramData.length) {
        histogramData[ageGroupIndex].count++;
        histogramData[ageGroupIndex].names.push(item.name);
      }
    });
    setHistogram(histogramData);
  }, [data]);

  return (
    <Paper
      elevation={2}
      sx={{
        p: 0,
        m: 2,
        display: "flex",
        flexDirection: "column",
        justifyContent: "space-between",
        alignItems: "center",
        backgroundColor: "background.default",
        flexGrow: 1,
      }}
    >
      <ChartLabel label={"Age Distribution"} />
      <ResponsiveContainer width={550}>
        <BarChart
          width={500}
          height={300}
          data={histogram}
          margin={{
            top: 0,
            right: 0,
            bottom: 25,
            left: -35,
          }}
        >
          <XAxis dataKey="ageGroup" />
          <YAxis dataKey="count" />
          <Tooltip content={<CustomTooltip />} />
          {/* <Legend iconSize={12} /> */}
          <Bar dataKey="count" fill="#8884d8" />
        </BarChart>
      </ResponsiveContainer>
    </Paper>
  );
});
