const MovieCard = (props) => {
	const theme = useTheme();
	const lg = useMediaQuery("(max-width:1200px)");
	const md = useMediaQuery("(max-width:960px)");
	const sm = useMediaQuery("(max-width:600px)");
	const xs = useMediaQuery("(max-width:425px)");
	const { movie } = props;
	const [content, setContent] = React.useState(movie);
	const [show, setShow] = React.useState(false);

	React.useEffect(() => {
		setShow(false);
		const delay = setTimeout(() => {
			setContent(movie);

			// Trigger fade-in effect
			setShow(true);
			clearTimeout(delay);
		}, 500);
	}, [movie]);

	return (
		<Card
			sx={{
				mr: 2,
				mb: 2,
				py: 3,
				px: 3,
				width: "100%",
				display: "flex",
				flexDirection: "column",
				justifyContent: content && content.id ? "start" : "center",
				alignItems: content && content.id ? "start" : "center",
				flex: "0 0 auto",
			}}
		>
			{content.id ? (
				<Fade in={show}>
					<Container
						disableGutters
						sx={{
							display: "flex",
							flexDirection: "column",
						}}
					>
						<Box sx={{ display: "flex", flexDirection: "row", mb: 2 }}>
							<Box
								sx={{
									display: "flex",
									flexDirection: "column",
								}}
							>
								<CardMedia
									component="img"
									width={"100%"}
									image={`https://www.themoviedb.org/t/p/w600_and_h900_bestv2${content.poster_path}`}
									alt={`Movie poster for ${content.title}`}
								/>
							</Box>
							<Box
								sx={{
									display: "flex",
									flexDirection: "column",
								}}
							>
								<Typography
									variant="h5"
									sx={{
										mx: 2,
									}}
								>
									{content.title}
								</Typography>
								<Container
									disableGutters
									sx={{
										px: 2,
										marginLeft: 0,
										marginRight: "auto",
										display: "flex",
										flexDirection: "row",
									}}
								>
									<Typography sx={{ paddingRight: 1 }} variant="caption">
										{new Date(content.release_date).getFullYear()}
									</Typography>
									<Typography variant="caption">
										{compileRuntime(content.runtime)}
									</Typography>
								</Container>
								<Stack
									sx={{ mt: 2, ml: 2 }}
									direction="row"
									spacing={1}
									useFlexGap
									flexWrap="wrap"
								>
									{content.genres.map((genre, i) => {
										return <Chip key={i} label={genre} />;
									})}
								</Stack>
								<Typography variant="subtitle2" sx={{ m: 2 }}>
									{content.overview}
								</Typography>
							</Box>
						</Box>
					</Container>
				</Fade>
			) : (
				<CircularProgress size={100} thickness={10} />
			)}
		</Card>
	);
};
