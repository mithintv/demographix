const LandingPage = () => {
  const [range, setRange] = React.useState("yearly");
  const [award, setAward] = React.useState("academy awards");
  const [cumulative, setCumulative] = React.useState("last 3");
  const [cumYears, setCumYears] = React.useState("");
  const [year, setYear] = React.useState(new Date().getFullYear());
  const [title, setTitle] = React.useState("");

  React.useEffect(() => {
    window.scrollTo(0, 0);
  }, []);

  React.useEffect(() => {
    if (range === "cumulative") {
      setYear(cumulative);
    } else setYear(new Date().getFullYear());
  }, [range]);

  React.useEffect(() => {
    if (range === "cumulative") {
      const years = year.toString().split(" ");
      console.log(year);
      const current_year = new Date().getFullYear();
      const string = `${current_year - years[1] + 1} - ${current_year}`;
      setCumYears(string);
    }
  }, [year, range]);

  const handleAward = (event) => {
    setAward(event.target.value);
  };

  const handleRange = (event) => {
    setRange(event.target.value);
  };

  const handleCumulative = (event) => {
    setCumulative(event.target.value);
    setYear(event.target.value);
  };

  const handleYear = (event) => {
    setYear(event.target.value);
  };

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
            sx={{ my: 2, width: "700px" }}
            color="textSecondary"
            variant="body"
            align="justify"
          >
            Visualize the diverse tapestry of on-screen talent in highly
            acclaimed blockbuster films. Demographix is a visualization of
            demographic information of top billed cast in movies nominated for
            prestigious awards such as the Academy Awards, the Golden Globes,
            BAFTA, etc. You can also search for demographic breakdowns of cast
            members in individual productions.
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
          <Box
            sx={{
              display: "flex",
              flexDirection: "column",
              justifyContent: "end",
            }}
          >
            <Typography
              sx={{ lineHeight: 0.75 }}
              color="primary"
              variant="overline2"
            >
              Top Billed Cast
            </Typography>
            <Typography color="primary" variant="overline">
              Academy Award Nominated Titles (
              {range === "yearly" ? year : cumYears})
            </Typography>
          </Box>

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
                <MenuItem value={"cumulative"}>Cumulative</MenuItem>
                <MenuItem value={"yearly"}>Yearly</MenuItem>
              </Select>
            </FormControl>
            {range === "cumulative" ? (
              <FormControl
                sx={{
                  m: 1,
                  width: "150px",
                }}
              >
                <InputLabel id={"cumulative"}>Cumulative</InputLabel>
                <Select
                  labelId="cumulative"
                  id="cumulative"
                  value={cumulative}
                  label="cumulative"
                  onChange={handleCumulative}
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
