const DataCard = React.memo((props) => {
	const lg = useMediaQuery("(max-width:1200px)");
	const md = useMediaQuery("(max-width:960px)");
	const sm = useMediaQuery("(max-width:600px)");
	const xs = useMediaQuery("(max-width:425px)");
	const { cast, releaseDate } = props;
	const [ageData, setAgeData] = React.useState([]);
	const [genderData, setGenderData] = React.useState([]);
	const [raceData, setRaceData] = React.useState([]);
	const [ethnicityData, setEthnicityData] = React.useState([]);
	const [cobData, setCOBData] = React.useState();

	React.useEffect(() => {
		const listAgeData = parseAges(cast, releaseDate);
		setAgeData(listAgeData);

		const listGenderData = parseGenders(cast);
		setGenderData(listGenderData);

		const listRaceData = parseRace(cast);
		setRaceData(listRaceData);

		const listEthnicityData = parseEthnicity(cast);
		setEthnicityData(listEthnicityData);

		const listCOBData = parseCountryOfBirth(cast);
		setCOBData(listCOBData);
	}, [cast, releaseDate]);

	return (
		<Paper
			sx={{
				display: "flex",
				flexDirection: "column",
				mb: 2,
				flex: "3 0 auto",
				// width: (sm && "425px") || (md && "600px") || (lg && "960px") || "960px",
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
					justifyContent: "space-evenly",
					flexWrap: "wrap",
				}}
			>
				<GenderChart data={genderData} />
				<Histogram data={ageData} />
				<RaceChart
					title="ethnicity"
					data={ethnicityData}
					colors={["#FFBB28"]}
				/>
				<RaceChart
					title="race"
					data={raceData}
					colors={[
						"#fff",
						"#B63E76",
						"#0088FE",
						"#00C49F",
						"#FFBB28",
						"#FF8042",
					]}
				/>
			</Box>
		</Paper>
	);
});
