const CustomLabel = (props) => {
  const RADIAN = Math.PI / 180;
  const {
    cx,
    cy,
    midAngle,
    innerRadius,
    outerRadius,
    startAngle,
    endAngle,
    fill,
    payload,
    percent,
    value,
  } = props;
  const sin = Math.sin(-RADIAN * midAngle);
  const cos = Math.cos(-RADIAN * midAngle);
  const textRadius = outerRadius + 10;
  const textX = cx + textRadius * cos;
  const textY = cy + textRadius * sin;
  const lineStartX = cx + outerRadius * cos;
  const lineStartY = cy + outerRadius * sin;
  const lineEndX = cx + (outerRadius + 30) * cos;
  const lineEndY = cy + (outerRadius + 30) * sin;
  const labelX = lineEndX + (cos >= 0 ? 1 : -1) * 5;
  const labelY = lineEndY;
  const textAnchor = cos >= 0 ? "start" : "end";

  return (
    <Fade in>
      <g>
        <Sector
          cx={cx}
          cy={cy}
          innerRadius={innerRadius}
          outerRadius={outerRadius}
          startAngle={startAngle}
          endAngle={endAngle}
          fill={fill}
        />
        {/* <Sector
        cx={cx}
        cy={cy}
        startAngle={startAngle}
        endAngle={endAngle}
        innerRadius={outerRadius + 6}
        outerRadius={outerRadius + 10}
        fill={fill}
      /> */}
        <path
          d={`M${lineStartX},${lineStartY}L${lineEndX},${lineEndY}`}
          stroke={fill}
          fill="none"
        />
        {/* <circle cx={lineEndX} cy={lineEndY} r={2} fill={fill} stroke="none" /> */}
        <text x={labelX} y={labelY} dy={10} textAnchor={textAnchor} fill="#fff">
          {`${payload.name} (${(percent * 100).toFixed(2)}%)`}
        </text>
      </g>
    </Fade>
  );
};

const GenderChart = React.memo((props) => {
  const { data } = props;

  const COLORS = ["#369EC8", "#B63E76", "#FFBB28", "#FF8042"];

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
      <ChartLabel label={"Gender Ratio"} />
      <PieChart width={500} height={350}>
        <Pie
          data={data}
          cx="45%"
          cy="50%"
          width={500}
          height={350}
          innerRadius={55}
          outerRadius={100}
          stroke="none"
          fill="#8884d8"
          paddingAngle={5}
          nameKey="name"
          dataKey="amount"
          label={<CustomLabel />}
        >
          {data.map((entry, index) => (
            <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
          ))}
        </Pie>
      </PieChart>
    </Paper>
  );
});
