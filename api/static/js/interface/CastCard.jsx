const CastCard = React.memo((props) => {
	const theme = useTheme();
	const { cast } = props;
	const [content, setContent] = React.useState(cast);
	const [show, setShow] = React.useState(false);
	const location = useLocation();

	React.useEffect(() => {
		setShow(false);
		const delay = setTimeout(() => {
			setContent(cast);
			// Trigger fade-in effect
			setShow(true);
			clearTimeout(delay);
		}, 500);
	}, [cast]);

	return (
		<Box
			elevation={2}
			sx={{
				display: "flex",
				flexDirection: "column",
				width: "100%",
				backgroundColor: "transparent",
				mt: 1,
			}}
		>
			<Box
				sx={{
					position: "relative",
					display: "flex",
					flexDirection: "row",
					overflowX: "auto",
				}}
			>
				{content ? (
					content.map((cast, index) => {
						let age = "Unknown";
						if (cast.birthday) {
							const birthday = new Date(cast.birthday).getFullYear();
							const currYear = new Date().getFullYear();
							age = currYear - birthday;
						}

						let imgPath = `https://www.themoviedb.org/t/p/w600_and_h900_bestv2${cast.profile_path}`;
						if (cast.profile_path == null) {
							imgPath =
								"https://th.bing.com/th/id/OIP.rjbP0DPYm_qmV_cG-S-DUAAAAA?pid=ImgDet&rs=1";
						}
						return (
							<Fade in={show} key={index} timeout={500}>
								<Card
									elevation={2}
									sx={{
										width: 125,
										height: 300,
										mr: 2,
										mb: 2,
										backgroundColor: "background.default",
										flex: "0 0 auto",
									}}
								>
									<CardMedia
										sx={{ mb: 1 }}
										width={150}
										height={187.5}
										component="img"
										image={imgPath}
										alt={`Image of ${cast.name}`}
									/>
									<Container disableGutters sx={{ px: 1, mb: 1 }}>
										<Typography variant="caption">{cast.name}</Typography>
										<br />
										<Typography variant="caption" color="textSecondary">
											{cast.character}
										</Typography>
									</Container>
								</Card>
							</Fade>
						);
					})
				) : (
					<CircularProgress size={100} thickness={10} />
				)}
				{/* <Box
          sx={{
            content: "''",
            position: "absolute",
            width: "60px",
            top: "0",
            right: "0",
            bottom: "0",
            backgroundImage:
              "linear-gradient(to right, rgba(255,255,255,0) 0%, #151036 100%)",
          }}
        /> */}
			</Box>
		</Box>
	);
});
