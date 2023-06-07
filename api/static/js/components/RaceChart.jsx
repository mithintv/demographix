const RaceChart = React.memo((props) => {
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

      <BarChart
        width={525}
        height={300}
        data={data}
        margin={{
          top: 5,
          right: 50,
          left: 10,
          bottom: 25,
        }}
      >
        {/* <CartesianGrid strokeDasharray="3 3" /> */}
        <XAxis dataKey="name" />
        <YAxis />
        <Tooltip
          viewBox={{ x: 0, y: 0, width: 400, height: 400 }}
          contentStyle={{ backgroundColor: "black" }}
        />
        <Legend iconSize={12} />
        <Bar dataKey="amount" fill="#8884d8" />
      </BarChart>
    </Paper>
  );
});
