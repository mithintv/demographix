const LandingPage = () => {
	React.useEffect(() => {
		window.scrollTo(0, 0);
	}, []);

	return (
		<Fade in>
			<Box
				container
				sx={{
					display: "flex",
					flexDirection: "column",
					justifyContent: "center",
					background: backgroundGradient,
					height: "100vh",
					flexGrow: 1,
				}}
			>
				<Container
					maxWidth="lg"
					sx={{
						display: "flex",
						flexDirection: "column",
						alignItems: "center",
						justifyContent: "end",
						flexGrow: 1,
					}}
				>
					<Link
						sx={{ mt: "auto", textDecoration: "none" }}
						component={RouterLink}
						to="/"
					>
						<Typography align="center" variant="h1">
							Demographix
						</Typography>
					</Link>
					<Container>
						<Typography
							sx={{ mt: 2, mb: 4, lineHeight: 1.25 }}
							color="textSecondary"
							variant="h5"
							align="center"
						>
							Visualize demographics of top billed cast in movies nominated for
							prestigious awards including the Academy Awards, the Golden
							Globes, BAFTA, etc. Demographix also provides demographic
							breakdowns of cast members in individual productions.
						</Typography>
					</Container>
					<Grid
						item
						sx={{
							display: "flex",
							flexDirection: "row",
							justifyContent: "space-evenly",
						}}
					>
						<Link
							to={`/noms/academy awards/yearly/${new Date().getFullYear()}`}
							component={RouterLink}
						>
							<Button
								size="large"
								startIcon={
									<span className="material-symbols-outlined">bar_chart</span>
								}
								variant="outlined"
							>
								Visualize Data
							</Button>
						</Link>
						<SearchPage nav={false} />
					</Grid>
				</Container>
				<Container
					sx={{
						display: "flex",
						flexDirection: "column",
						alignItems: "center",
						justifyContent: "end",
						flexGrow: 1,
					}}
				>
					<Footer />
				</Container>
			</Box>
		</Fade>
	);
};
