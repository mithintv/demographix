const RaceTooltip = ({ active, payload, label }) => {
  if (active && payload && payload.length) {
    const name = payload[0].payload.name;
    const count = payload[0].value;

    return (
      <Paper sx={{ p: 2 }}>
        <Typography variant="overline">{`${name}: ${count}`}</Typography>
      </Paper>
    );
  }

  return null;
};

const formatYAxisLabel = (label) => {
  if (label === "Middle Eastern/North African") {
    return "MENA";
  }
  if (label === "Native Hawaiian/Pacific Islander") {
    return "NHPI";
  }
  return label;
};

const RaceChart = React.memo((props) => {
  const theme = useTheme();
  const { data } = props;

  // data.sort((a, b) => d3.descending(a.amount, b.amount));

  const colors = [
    "#fff",
    "#B63E76",
    "#0088FE",
    "#00C49F",
    "#FFBB28",
    "#FF8042",
  ];

  return (
    <Paper
      elevation={2}
      sx={{
        p: 0,
        m: 2,
        mt: 1,
        display: "flex",
        flexDirection: "column",
        justifyContent: "space-between",
        backgroundColor: "background.default",
        flexGrow: 1,
      }}
    >
      <ChartLabel label={"Race"} />
      <Box
        sx={{
          display: "flex",
          flexDirection: "column",
          justifyContent: "center",
          alignItems: "center",
          height: 350,
        }}
      >
        {data.length > 0 ? (
          <ResponsiveContainer width="100%" height={350}>
            <BarChart
              layout="vertical"
              width={550}
              height={350}
              data={data}
              margin={{
                top: 20,
                right: 50,
                left: 100,
                bottom: 30,
              }}
            >
              {/* <CartesianGrid strokeDasharray="3 3" /> */}
              <XAxis
                type="number"
                tickLine={axisLineStyle}
                axisLine={axisLineStyle}
                tick={tickStyle}
              >
                <Label
                  fill={theme.palette.text.secondary}
                  value="Number of Cast Members"
                  offset={-10}
                  position="insideBottom"
                />
              </XAxis>
              <YAxis
                type="category"
                dataKey="name"
                tickLine={axisLineStyle}
                axisLine={axisLineStyle}
                tick={tickStyle}
                tickFormatter={formatYAxisLabel}
              />
              <Tooltip
                viewBox={{ x: 0, y: 0, width: 400, height: 400 }}
                content={<RaceTooltip />}
              />
              <Bar dataKey="amount" label={barChartLabelStyle}>
                {data.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={colors[index]} />
                ))}
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        ) : (
          <CircularProgress size={100} thickness={10} />
        )}
      </Box>
    </Paper>
  );
});
