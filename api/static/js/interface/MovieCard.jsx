const MovieCard = (props) => {
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
				width: "350px",
				display: "flex",
				flexDirection: "column",
				justifyContent: content && content.id ? "start" : "center",
				alignItems: content && content.id ? "start" : "center",
				flex: "1 0 auto",
			}}
		>
			{content.id ? (
				<Fade in={show}>
					<Container disableGutters>
						<Typography variant="h5">{content.title}</Typography>
						<Container
							disableGutters
							sx={{
								p: 0,
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
						<CardMedia
							sx={{ my: 2 }}
							component="img"
							width={200}
							image={`https://www.themoviedb.org/t/p/w600_and_h900_bestv2${content.poster_path}`}
							alt={`Movie poster for ${content.title}`}
						/>

						<Stack direction="row" spacing={1} useFlexGap flexWrap="wrap">
							{content.genres.map((genre, i) => {
								return <Chip key={i} label={genre} />;
							})}
						</Stack>
						<Typography variant="subtitle2" sx={{ my: 1 }}>
							{content.overview}
						</Typography>
					</Container>
				</Fade>
			) : (
				<CircularProgress size={100} thickness={10} />
			)}
		</Card>
	);
};
