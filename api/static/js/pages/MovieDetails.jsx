const MovieDetails = (props) => {
	const lg = useMediaQuery("(max-width:1200px)");
	const md = useMediaQuery("(max-width:960px)");
	const sm = useMediaQuery("(max-width:600px)");
	const xs = useMediaQuery("(max-width:425px)");
	const { id } = props.match.params;
	const [movieDetails, setMovieDetails] = React.useState({
		"id": null,
		"title": null,
		"genres": [],
		"overview": "",
		"runtime": "",
		"poster_path": "",
		"release_date": null,
		"budget": "",
		"revenue": null,
		"cast": [],
	});
	const [castDetails, setCastDetails] = React.useState([]);

	React.useEffect(() => {
		window.scrollTo(0, 0);
	}, []);

	React.useEffect(() => {
		const fetchData = async () => {
			const response = await fetch(`/api/movies/${id}`);
			const movieData = await response.json();
			setMovieDetails(movieData);
			setCastDetails(movieData.cast);
		};
		fetchData();
	}, [id]);

	return (
		<Fade in>
			<Box
				sx={{
					background: backgroundGradient,
					height: "100%",
				}}
			>
				<NavBar />
				<Container
					disableGutters
					maxWidth="xl"
					sx={{
						pb: 2,
						pt: 10,
						mx: "auto",
						display: "flex",
						flexDirection: "column",
						flex: "1 1",
					}}
				>
					<Container
						disableGutters
						maxWidth="xl"
						sx={{
							display: "flex",
							flexDirection: "row",
							pt: 1,
						}}
					>
						<MovieCard movie={movieDetails} />
						<DataCard
							cast={castDetails}
							releaseDate={new Date(movieDetails.release_date).getFullYear()}
						/>
					</Container>
					<CastCard cast={castDetails} />
				</Container>
				<Footer />
			</Box>
		</Fade>
	);
};
