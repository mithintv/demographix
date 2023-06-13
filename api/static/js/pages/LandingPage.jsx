const LandingPage = () => {
  React.useEffect(() => {
    window.scrollTo(0, 0);
  }, []);

  return (
    <Fade in>
      <Box
        disableGutters
        sx={{
          pb: 20,
          display: "flex",
          height: "100vh",
          flexDirection: "column",
          justifyContent: "center",
          background:
            "radial-gradient(ellipse at center, #151036 50%, #000 100%)",
        }}
      >
        <Box
          sx={{
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
          }}
        >
          <Link sx={{ textDecoration: "none" }} component={RouterLink} to="/">
            <Typography align="center" variant="h1">
              Demographix
            </Typography>
          </Link>
          <Typography
            sx={{ mt: 2, mb: 4, width: "800px" }}
            color="textSecondary"
            variant="body"
            align="center"
          >
            Visualize demographic information of top billed cast in movies
            nominated for prestigious awards such as the Academy Awards, the
            Golden Globes, BAFTA, etc. You can also search for demographic
            breakdowns of cast members in individual productions.
          </Typography>
          <Box
            sx={{
              display: "flex",
              flexDirection: "row",
              justifyContent: "space-evenly",
              width: "20%",
            }}
          >
            <Link to="/noms" component={RouterLink}>
              <Button
                startIcon={
                  <span className="material-symbols-outlined">bar_chart</span>
                }
                variant="outlined"
              >
                Visualize Data
              </Button>
            </Link>
            <SearchPage nav={false} />
          </Box>
        </Box>
      </Box>
    </Fade>
  );
};
