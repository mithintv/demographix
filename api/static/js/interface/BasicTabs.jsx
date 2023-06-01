const TabPanel = (props) => {
  const { children, value, index, ...other } = props;

  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`simple-tabpanel-${index}`}
      aria-labelledby={`simple-tab-${index}`}
      {...other}
    >
      {value === index && <Box sx={{ p: 3 }}>{children}</Box>}
    </div>
  );
};

const a11yProps = (index) => {
  return {
    id: `simple-tab-${index}`,
    "aria-controls": `simple-tabpanel-${index}`,
  };
};

const BasicTabs = (props) => {
  const [value, setValue] = React.useState(0);
  const [ageData, setAgeData] = React.useState();
  const [genderData, setGenderData] = React.useState();
  const [raceData, setRaceData] = React.useState();
  const [cobData, setCOBData] = React.useState();

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  React.useEffect(() => {
    const fetchData = async () => {
      const response = await fetch(`/api/nom/${props.year}`);
      const movieList = await response.json();
      // setMovies(movieList);

      const castList = compileAges(movieList);
      setGenderData(parseGenders(castList));
      setAgeData(parseAges(castList));
      setRaceData(parseRace(castList));
      setCOBData(parseCountryOfBirth(castList));
    };
    fetchData();
  }, []);

  return (
    <Box sx={{ width: "100%" }}>
      <Box sx={{ borderBottom: 1, borderColor: "divider" }}>
        <Tabs
          value={value}
          onChange={handleChange}
          aria-label="basic tabs example"
        >
          <Tab label="Age" {...a11yProps(0)} />
          <Tab label="Gender" {...a11yProps(1)} />
          <Tab label="Race" {...a11yProps(2)} />
          <Tab label="Birth Country" {...a11yProps(3)} />
        </Tabs>
      </Box>
      <TabPanel value={value} index={0}>
        {ageData && <Histogram data={ageData} />}
      </TabPanel>
      <TabPanel value={value} index={1}>
        {genderData && <PieChart data={genderData} />}
      </TabPanel>
      <TabPanel value={value} index={2}>
        {raceData && <BarChart data={raceData} />}
      </TabPanel>
      <TabPanel value={value} index={3}>
        {cobData && <WorldMap data={cobData} />}
      </TabPanel>
    </Box>
  );
};
