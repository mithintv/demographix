const SearchPage = ({ nav }) => {
	const sm = useMediaQuery("(max-width:600px)");
	const [open, setOpen] = React.useState(false);
	const searchRef = React.useRef(null);
	const [searchInput, setSearchInput] = React.useState("");

	const handleOpen = () => setOpen(true);
	const handleClose = () => {
		setSearchInput("");
		setOpen(false);
	};

	const searchInputHandler = async (e) => {
		setSearchInput(searchRef.current.value);
	};

	const searchHandler = async (e) => {
		e.preventDefault();
		setSearchMovies(true);
		const keyword = searchRef.current.value;
		console.log(keyword);

		try {
			const options = {
				method: "POST",
				headers: {
					"Content-Type": "application/json",
				},
				body: JSON.stringify({
					search: keyword,
				}),
			};
			const response = await fetch("/search", options);
			const json = await response.json();
			setResults(json);

			console.log(json);
		} catch (err) {
			console.log(err);
		}
	};

	return (
		<React.Fragment>
			<Button
				sx={{ my: 1 }}
				size={sm ? "medium" : "large"}
				startIcon={<span className="material-symbols-outlined">search</span>}
				variant={nav ? "text" : "contained"}
				onClick={handleOpen}
			>
				Search Movies
			</Button>
			{/* {nav && (
        <IconButton
          onClick={handleOpen}
          sx={{ p: "10px" }}
          aria-label="search"
          color="primary"
          variant="outlined"
        >
          <span className="material-symbols-outlined">search</span>
        </IconButton>
      )} */}
			<Modal
				sx={{
					position: "fixed",
				}}
				open={open}
				onClose={handleClose}
				aria-labelledby="search-modal"
				aria-describedby="search modal for movies and other productions"
				slotProps={{
					backdrop: {
						timeout: 500,
					},
				}}
			>
				<Paper
					sx={{
						mt: 5,
						mx: "auto",
						// transform: "translate(-50%, -50%)",
						width: sm ? "85%" : "50%",
						bgcolor: "background.default",
						border: "2px solid #000",
						boxShadow: 24,
						py: 4,
						px: sm ? 2 : 4,
					}}
				>
					<Box
						onSubmit={searchHandler}
						component="form"
						sx={{
							py: "0.25rem",
							display: "flex",
							flexDirection: "column",
							justifyContent: "space-between",
							mx: 1,
						}}
					>
						<TextField
							sx={{ width: "100%", mb: 2 }}
							inputRef={searchRef}
							value={searchInput}
							name="search"
							InputProps={{
								startAdornment: (
									<InputAdornment position="start">
										<span className="material-symbols-outlined">search</span>
									</InputAdornment>
								),
							}}
							placeholder="Search Movies"
							onChange={searchInputHandler}
							variant="standard"
						/>
					</Box>
					<SearchResults clicked={handleClose} keywords={searchInput} />
				</Paper>
			</Modal>
		</React.Fragment>
	);
};
