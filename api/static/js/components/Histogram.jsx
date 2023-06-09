const CustomTooltip = ({ active, payload, label }) => {
  if (active && payload && payload.length) {
    const ageGroup = payload[0].payload.ageGroup;
    const count = payload[0].value;
    const cast = payload[0].payload.cast || [];
    return (
      <Paper sx={{ px: 2, py: 2, display: "flex", flexDirection: "column" }}>
        <Typography
          align="center"
          variant="overline"
        >{`${ageGroup} Age Group`}</Typography>
        <Typography
          align="center"
          variant="overline"
        >{`${count} Cast`}</Typography>
        <Box
          sx={{
            maxWidth: "700px",
            width: "100%",
            display: "flex",
            flexDirection: "row",
            justifyContent: "center",
            flexWrap: "wrap",
            flexShrink: 1,
          }}
        >
          {cast.map((el, index) => {
            let imgPath = `https://www.themoviedb.org/t/p/w600_and_h900_bestv2${el.profile_path}`;
            if (el.profile_path == null) {
              imgPath =
                "https://th.bing.com/th/id/OIP.rjbP0DPYm_qmV_cG-S-DUAAAAA?pid=ImgDet&rs=1";
            }
            return (
              <Card
                key={index}
                elevation={2}
                sx={{
                  display: "flex",
                  flexDirection: "column",
                  width: "75px",
                  mx: 1,
                  my: 1,
                  backgroundColor: "background.default",
                  flex: "0 0 auto",
                }}
              >
                <CardMedia
                  sx={{ width: "75px" }}
                  width="75px"
                  height="75px"
                  component="img"
                  image={imgPath}
                  alt={`Image of ${cast.name}`}
                />
                <Container disableGutters sx={{ px: 1, mb: 1 }}>
                  <Typography variant="caption">{el.name}</Typography>
                </Container>
              </Card>
            );
          })}
        </Box>
      </Paper>
    );
  }

  return null;
};

const Histogram = React.memo((props) => {
  const theme = useTheme();
  const [histogram, setHistogram] = React.useState([]);
  let { data } = props;

  React.useEffect(() => {
    const histogramData = d3.range(0, 10).map((i) => ({
      ageGroup: `${i * 10}-${(i + 1) * 10}`,
      count: 0,
      cast: [],
    }));

    data.forEach((item) => {
      const ageGroupIndex = Math.floor(item.amount / 10);
      if (ageGroupIndex >= 0 && ageGroupIndex < histogramData.length) {
        histogramData[ageGroupIndex].count++;
        histogramData[ageGroupIndex].cast.push({
          name: item.name,
          profile_path: item.profile_path,
        });
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
        flex: "1 0 auto",
      }}
    >
      <ChartLabel label={"Age Distribution"} />
      <Box
        sx={{
          display: "flex",
          flexDirection: "column",
          justifyContent: "center",
          alignItems: "center",
          height: "330px",
          flex: "1 0 auto",
        }}
      >
        {data.length > 0 ? (
          <ResponsiveContainer width={550} height={300}>
            <BarChart
              style={{ zIndex: 2 }}
              width={550}
              height={300}
              data={histogram}
              margin={{
                top: 25,
                right: 20,
                bottom: 10,
                left: 25,
              }}
            >
              <XAxis
                dataKey="ageGroup"
                tickLine={axisLineStyle}
                axisLine={axisLineStyle}
                tick={tickStyle}
              />
              <YAxis
                tickLine={axisLineStyle}
                axisLine={axisLineStyle}
                tick={tickStyle}
                dataKey="count"
                // label={{
                //   value: "Number of Cast Members",
                //   angle: -90,
                //   position: "insideLeft",
                //   fill: theme.palette.text.secondary,
                //   offset: 20,
                // }}
              >
                <Label
                  angle={-90}
                  fill={theme.palette.text.secondary}
                  value="Number of Cast Members"
                  position="insideLeft"
                  style={{ textAnchor: "middle" }}
                  offset={2}
                />
              </YAxis>
              <Tooltip
                style={{ zIndex: 9999 }}
                content={<CustomTooltip />}
                cursor={cursorColor}
              />
              <Bar
                dataKey="count"
                fill={theme.palette.primary.main}
                label={histogramLabelStyle}
              ></Bar>
            </BarChart>
          </ResponsiveContainer>
        ) : (
          <CircularProgress size={100} thickness={10} />
        )}
      </Box>
    </Paper>
  );
});
