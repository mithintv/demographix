const SearchResults = ({ clicked, keywords }) => {
	const lg = useMediaQuery("(max-width:1200px)");
	const md = useMediaQuery("(max-width:960px)");
	const sm = useMediaQuery("(max-width:600px)");
	const xs = useMediaQuery("(max-width:485px)");
	const [results, setResults] = React.useState([]);
	const theme = useTheme();

	React.useEffect(() => {
		const fetchSearch = async (query) => {
			try {
				const options = {
					method: "POST",
					headers: {
						"Content-Type": "application/json",
					},
					body: JSON.stringify({
						search: query,
					}),
				};
				const response = await fetch("/", options);
				const json = await response.json();
				setResults(json);
			} catch (err) {
				console.log(err);
			}
		};
		let timeout;
		if (keywords.length === 0) {
			fetchSearch(keywords);
		} else {
			timeout = setTimeout(async () => {
				fetchSearch(keywords);
			}, 1000);
		}
		return () => {
			clearTimeout(timeout);
		};
	}, [keywords]);
	return (
		<Box
			sx={{
				mx: 4,
				mb: 4,
				display: "flex",
				flexDirection: "row",
				flexWrap: "wrap",
				justifyContent: "center",
				alignContent: results.length > 0 ? "space-between" : "center",
				zIndex: 3,
				height: "77.5vh",
				overflowY: "auto",
			}}
		>
			{results.length > 0 ? (
				results.map((movie, index) => {
					const releaseDate = new Date(movie.release_date);

					let imgPath = `https://www.themoviedb.org/t/p/w600_and_h900_bestv2${movie.poster_path}`;
					if (movie.poster_path == null) {
						imgPath =
							"https://incakoala.github.io/top9movie/film-poster-placeholder.png";
					}

					return (
						<Fade key={index} in timeout={index * 50}>
							<Link
								sx={{
									mx: 1,
									mb: 2,
								}}
								component={RouterLink}
								to={`/movies/${movie.id}`}
								onClick={clicked}
							>
								<Card>
									<CardMedia
										sx={{ width: (sm && 180) || 110 }}
										component="img"
										image={imgPath}
										alt={`Movie poster for ${movie.title}`}
									/>
								</Card>
								{/* <Box
                sx={{
                  display: "flex",
                  flexDirection: "column",
                }}
              >
                <Typography variant="overline">
                  {new Date(movie.release_date).getFullYear()}
                </Typography>
                <Typography variant="caption">{movie.title}</Typography>
              </Box> */}
							</Link>
						</Fade>
					);
				})
			) : (
				<CircularProgress size={100} thickness={10} />
			)}
			{/* {showDetails && <MovieDetails movie_id={currMovie} />} */}
		</Box>
	);
};
