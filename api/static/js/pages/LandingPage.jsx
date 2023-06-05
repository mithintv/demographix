const LandingPage = () => {
  const [showLanding, setShowLanding] = React.useState(true);
  const [award, setAward] = React.useState(new Date().getFullYear());
  const [year, setYear] = React.useState(new Date().getFullYear());

  const handleAward = (event) => {
    setAward(event.target.value);
  };

  const handleYear = (event) => {
    setYear(event.target.value);
  };

  const searchClickHandler = () => {
    setShowLanding(false);
  };
  return (
    <Fade in={showLanding}>
      <Container>
        <Link sx={{ textDecoration: "none" }} component={RouterLink} to="/">
          <Typography align="center" variant="h1">
            Demographix
          </Typography>
        </Link>
        <Typography color="textSecondary" variant="subtitle2" align="center">
          Visualize the diverse tapestry of on-screen talent in blockbuster
          films
        </Typography>
        <SearchBar clicked={searchClickHandler} />

        <Typography
          sx={{ mt: 4, mb: 2 }}
          variant="h4"
          align="center"
          color="primary"
        >
          Awards Summary
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
            <InputLabel id="year">Year</InputLabel>
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
            </Select>
          </FormControl>
        </Box>
        <NomMovies award={award} year={year} />
      </Container>
    </Fade>
  );
};
