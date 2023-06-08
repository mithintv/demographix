const RaceChart = React.memo((props) => {
  const theme = useTheme();
  const { data } = props;

  console.log("Rendering Race Chart: ", data);

  return (
    <Paper
      elevation={2}
      sx={{
        p: 0,
        m: 2,
        display: "flex",
        flexDirection: "column",
        justifyContent: "space-between",
        backgroundColor: "background.default",
      }}
    >
      <ChartLabel label={"Race"} />
      <ResponsiveContainer width={550}>
        <BarChart
          layout="vertical"
          width={550}
          height={300}
          data={data}
          margin={{
            top: 20,
            right: 25,
            left: 100,
            bottom: 10,
          }}
        >
          {/* <CartesianGrid strokeDasharray="3 3" /> */}
          <XAxis
            type="number"
            tickLine={axisLineStyle}
            axisLine={axisLineStyle}
            tick={tickStyle}
          />
          <YAxis
            type="category"
            dataKey="name"
            tickLine={axisLineStyle}
            axisLine={axisLineStyle}
            tick={tickStyle}
          />
          <Tooltip
            viewBox={{ x: 0, y: 0, width: 400, height: 400 }}
            contentStyle={{ backgroundColor: "black" }}
          />
          <Bar dataKey="amount" fill={theme.palette.primary.main} />
        </BarChart>
      </ResponsiveContainer>
    </Paper>
  );
});
