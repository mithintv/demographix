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

const CustomizedLabel = (props) => {
  const { x, width, y, height, value, index, total } = props;
  console.log(total);
  if ((index % 2 === 0 && total > 10) || total < 10) {
    return (
      <g>
        <text
          x={x + 5 + width}
          y={total < 10 ? y + 4 + height / 2 : y + 3 + height / 2}
          style={total < 10 ? barChartLabelStyle : barChartLabelStyle2}
        >
          {value}
        </text>
      </g>
    );
  }
  return null;
};

const RaceChart = React.memo(({ data, title, colors }) => {
  const theme = useTheme();

  // data.sort((a, b) => d3.descending(a.amount, b.amount));

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
      <ChartLabel label={title} />
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
          <ResponsiveContainer width={550} height={350}>
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
              <Bar
                dataKey="amount"
                label={<CustomizedLabel total={data.length} />}
              >
                {data.map((entry, index) => {
                  if (colors.length === 1) {
                    return <Cell key={`cell-${index}`} fill={colors[0]} />;
                  }
                  return <Cell key={`cell-${index}`} fill={colors[index]} />;
                })}
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
