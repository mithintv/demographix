const CustomTooltip = ({ active, payload, label }) => {
  if (active && payload && payload.length) {
    const ageGroup = payload[0].payload.ageGroup;
    const count = payload[0].value;
    const cast = payload[0].payload.cast || [];
    console.log(payload);
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

const formatYAxisTick = (tick) => {
  return Math.floor(tick);
};

const Histogram = React.memo((props) => {
  const theme = useTheme();
  const [histogram, setHistogram] = React.useState([]);
  const { data } = props;

  console.log(data);

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
        flexGrow: 1,
      }}
    >
      <ChartLabel label={"Age Distribution"} />
      <ResponsiveContainer width={550}>
        <BarChart
          style={{ zIndex: 2 }}
          width={500}
          height={300}
          data={histogram}
          margin={{
            top: 25,
            right: 25,
            bottom: 10,
            left: 5,
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
            // domain={[0, 10]}
            // interval={1}
          />
          <Tooltip
            style={{ zIndex: 9999 }}
            content={<CustomTooltip />}
            cursor={cursorColor}
          />
          <Bar dataKey="count" fill={theme.palette.primary.main} />
        </BarChart>
      </ResponsiveContainer>
    </Paper>
  );
});
