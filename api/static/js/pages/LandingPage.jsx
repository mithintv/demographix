const LandingPage = () => {
  const [range, setRange] = React.useState("yearly");
  const [award, setAward] = React.useState("academy awards");
  const [summary, setSummary] = React.useState("last 3");
  const [year, setYear] = React.useState(new Date().getFullYear());

  const handleAward = (event) => {
    setAward(event.target.value);
  };

  const handleRange = (event) => {
    setRange(event.target.value);
  };

  const handleSummary = (event) => {
    setSummary(event.target.value);
    setYear(event.target.value);
  };

  const handleYear = (event) => {
    setYear(event.target.value);
  };

  React.useEffect(() => {
    if (range === "summary") {
      setYear(summary);
    } else setYear(new Date().getFullYear());
  }, [range]);

  return (
    <Fade in>
      <Container
        disableGutters
        sx={{
          my: 5,
          display: "flex",
          height: "100vh",
          flexDirection: "column",
        }}
      >
        <Box
          sx={{
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
          }}
        >
          <Link sx={{ textDecoration: "none" }} component={RouterLink} to="/">
            <Typography align="center" variant="h1">
              Demographix
            </Typography>
          </Link>
          <Typography
            sx={{ mb: 2 }}
            color="textSecondary"
            variant="subtitle2"
            align="center"
          >
            Visualize the diverse tapestry of on-screen talent in highly
            acclaimed blockbuster films
          </Typography>
          <SearchBar />
        </Box>
        <Box
          sx={{
            pl: 1,
            mt: 4,
            display: "flex",
            flexDirection: "row",
            alignItems: "center",
            justifyContent: "space-between",
          }}
        >
          <Typography align="center" color="primary" variant="h3">
            Overview
          </Typography>
          <Box
            sx={{
              display: "flex",
              flexDirection: "row",
              justifyContent: "end",
            }}
          >
            <FormControl
              sx={{
                m: 1,
              }}
            >
              <InputLabel id="award">Award</InputLabel>
              <Select
                labelId="award"
                id="award"
                value={award}
                label="Award"
                onChange={handleAward}
              >
                <MenuItem value={award}>Academy Awards</MenuItem>
              </Select>
            </FormControl>
            <FormControl
              sx={{
                m: 1,
              }}
            >
              <InputLabel id="range">Range</InputLabel>
              <Select
                labelId="range"
                id="range"
                value={range}
                label="range"
                onChange={handleRange}
              >
                <MenuItem value={"summary"}>Cumulative</MenuItem>
                <MenuItem value={"yearly"}>Yearly</MenuItem>
              </Select>
            </FormControl>
            {range === "summary" ? (
              <FormControl
                sx={{
                  m: 1,
                  width: "150px",
                }}
              >
                <InputLabel id={"summary"}>Summary</InputLabel>
                <Select
                  labelId="summary"
                  id="summary"
                  value={summary}
                  label="summary"
                  onChange={handleSummary}
                >
                  <MenuItem value={"last 3"}>Last 3 Years</MenuItem>
                  <MenuItem value={"last 5"}>Last 5 Years</MenuItem>
                  <MenuItem value={"last 10"}>Last 10 Years</MenuItem>
                </Select>
              </FormControl>
            ) : (
              <FormControl
                sx={{
                  m: 1,
                  width: "100px",
                }}
              >
                <InputLabel id={"year"}>Year</InputLabel>
                <Select
                  labelId="year"
                  id="year"
                  value={year}
                  label="Year"
                  onChange={handleYear}
                >
                  <MenuItem value={2023}>2023</MenuItem>
                  <MenuItem value={2022}>2022</MenuItem>
                  <MenuItem value={2021}>2021</MenuItem>
                  <MenuItem value={2022}>2020</MenuItem>
                  <MenuItem value={2021}>2019</MenuItem>
                </Select>
              </FormControl>
            )}
          </Box>
        </Box>
        <NomMovies award={award} year={year} />
      </Container>
    </Fade>
  );
};
