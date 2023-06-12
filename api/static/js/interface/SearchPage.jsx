const SearchPage = () => {
  const [open, setOpen] = React.useState(false);
  const handleOpen = () => setOpen(true);
  const handleClose = () => {
    clearInputHandler();
    setOpen(false);
  };
  const searchRef = React.useRef(null);
  const [searchInput, setSearchInput] = React.useState("");

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

  const clearInputHandler = () => {
    setSearchInput("");
  };

  return (
    <React.Fragment>
      <Button variant="contained" onClick={handleOpen}>
        Search
      </Button>
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
            position: "absolute",
            top: "50%",
            left: "50%",
            transform: "translate(-50%, -50%)",
            width: "50%",
            bgcolor: "background.default",
            border: "2px solid #000",
            boxShadow: 24,
            p: 4,
          }}
        >
          <Paper
            onSubmit={searchHandler}
            component="form"
            sx={{
              py: "0.25rem",
              display: "flex",
              flexDirection: "column",
              justifyContent: "space-between",
            }}
          >
            <Box sx={{ display: "flex", flexDirection: "row", pl: 2, pr: 1 }}>
              <IconButton type="submit" sx={{ p: "10px" }} aria-label="search">
                <span className="material-symbols-outlined">search</span>
              </IconButton>
              <InputBase
                sx={{ width: "100%" }}
                inputRef={searchRef}
                value={searchInput}
                id="outlined-basic"
                name="search"
                label=""
                placeholder="Search Movies"
                variant="outlined"
                onChange={searchInputHandler}
              />
            </Box>
          </Paper>
          <SearchResults clicked={clearInputHandler} keywords={searchInput} />
        </Paper>
      </Modal>
    </React.Fragment>
  );
};
