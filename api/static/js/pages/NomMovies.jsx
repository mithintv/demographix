const NomMovies = (props) => {
	const { rangeParam, yearParam } = props.match.params;
	const [movies, setMovies] = React.useState([]);
	const [castData, setCastData] = React.useState([]);

	const [range, setRange] = React.useState(rangeParam);
	const [award, setAward] = React.useState("academy awards");
	const [cumYears, setCumYears] = React.useState("");
	const [year, setYear] = React.useState(yearParam);

	const history = useHistory();
	const location = useLocation();

	const data = castData.sort((a, b) => a.id - b.id);

	React.useEffect(() => {
		const fetchData = async () => {
			const response = await fetch(`/api/nom/${year}`);
			const movieList = await response.json();
			setMovies(movieList);

			const castList = compileCast(movieList);
			setCastData(castList);
		};
		fetchData();
	}, [award, year]);

	React.useEffect(() => {
		if (range === "cumulative") {
			setYear(yearParam);
		} else {
			setYear(yearParam);
		}
	}, [range, yearParam, rangeParam]);

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
		const selectedRange = event.target.value;
		setRange(selectedRange);
		let selectedYear = "last 3";
		if (selectedRange === "cumulative") {
			setYear("last 3");
		} else {
			selectedYear = new Date().getFullYear();
			setYear(selectedYear);
		}
		location.pathname = `/noms/${selectedRange}/${selectedYear}`;
		history.push(location.pathname);
	};

	const handleCumulative = (event) => {
		const selectedYear = event.target.value;
		console.log(selectedYear);
		setYear(selectedYear);
		location.pathname = `/noms/${range}/${selectedYear}`;
		history.push(location.pathname);
	};

	const handleYear = (event) => {
		const selectedYear = event.target.value;
		setYear(selectedYear);
		location.pathname = `/noms/${range}/${selectedYear}`;
		history.push(location.pathname);
	};

	return (
		<Fade in>
			<Box
				sx={{
					width: "100%",
					height: "100%",
					background: backgroundGradient,
				}}
			>
				<NavBar />
				<Container
					disableGutters
					sx={{
						pb: 2,
						pt: 8,
						display: "flex",
						flexDirection: "column",
					}}
				>
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
									<MenuItem value={"golden globes"}>Golden Globes</MenuItem>
									<MenuItem value={"bafta"}>BAFTA</MenuItem>
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
										value={year}
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
										<MenuItem value={2020}>2020</MenuItem>
										<MenuItem value={2019}>2019</MenuItem>
										<MenuItem value={2018}>2018</MenuItem>
										<MenuItem value={2017}>2017</MenuItem>
										<MenuItem value={2016}>2016</MenuItem>
										<MenuItem value={2015}>2015</MenuItem>
										<MenuItem value={2014}>2014</MenuItem>
									</Select>
								</FormControl>
							)}
						</Box>
					</Box>
					<DataCard cast={castData} releaseDate={null} />
					<Paper
						sx={{
							display: "flex",
							flexDirection: "column",
							mb: 2,
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
							Nominations
						</Typography>
						<Container
							disableGutters
							sx={{
								px: 1,
								py: 2,
								display: "flex",
								flexDirection: "row",
								width: "100%",
								overflowX: "scroll",
							}}
						>
							{movies.map((movie, index) => {
								const releaseDate = new Date(movie.release_date);
								return (
									<Card
										key={index}
										elevation={2}
										sx={{
											width: 125,
											mx: 1,
											backgroundColor: "background.default",
											flex: "0 0 auto",
											cursor: "pointer",
										}}
									>
										<Link component={RouterLink} to={`/movies/${movie.id}`}>
											<CardMedia
												width={100}
												component="img"
												image={`https://www.themoviedb.org/t/p/w600_and_h900_bestv2${movie.poster_path}`}
												alt={`Poster image of ${movie.title} (${releaseDate})`}
											/>
										</Link>
									</Card>
								);
							})}
						</Container>
					</Paper>
				</Container>
				<Footer />
			</Box>
		</Fade>
	);
};
