const DataCard = React.memo((props) => {
  const { cast } = props;
  const [ageData, setAgeData] = React.useState();
  const [genderData, setGenderData] = React.useState();
  const [raceData, setRaceData] = React.useState();
  const [cobData, setCOBData] = React.useState();

  React.useEffect(() => {
    const listAgeData = parseAges(cast);
    setAgeData(listAgeData);

    const listGenderData = parseGenders(cast);
    setGenderData(listGenderData);

    const listRaceData = parseRace(cast);
    setRaceData(listRaceData);

    const listCOBData = parseCountryOfBirth(cast);
    setCOBData(listCOBData);
  }, [cast]);

  return (
    <Paper
      sx={{
        display: "flex",
        flexDirection: "column",
        mb: 2,
        flex: "3 3",
      }}
    >
      <Typography
        sx={{
          mt: 1,
          pl: 2,
          width: "100%",
          borderBottom: "3px solid rgba(255, 255, 255, 0.05);",
        }}
        variant="overline"
        color="primary"
      >
        Demographics
      </Typography>
      <Box
        sx={{
          display: "flex",
          flexDirection: "row",
        }}
      >
        {genderData && <PieChart data={genderData} />}
        {ageData && <Histogram data={ageData} />}
      </Box>
      <Box
        sx={{
          display: "flex",
          flexDirection: "row",
        }}
      >
        {raceData && <BarChart data={raceData} />}
        {cobData && <WorldMap data={cobData} />}
      </Box>
    </Paper>
  );
});
