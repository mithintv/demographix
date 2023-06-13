const LandingPage = () => {
  React.useEffect(() => {
    window.scrollTo(0, 0);
  }, []);

  return (
    <Fade in>
      <Box
        sx={{
          pb: 10,
          display: "flex",
          height: "100vh",
          flexDirection: "column",
          justifyContent: "space-between",
          background: backgroundGradient,
        }}
      >
        <Box
          sx={{
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
            pt: 40,
          }}
        >
          <Link sx={{ textDecoration: "none" }} component={RouterLink} to="/">
            <Typography align="center" variant="h1">
              Demographix
            </Typography>
          </Link>
          <Typography
            sx={{ mt: 2, mb: 4, width: "950px", lineHeight: 1.25 }}
            color="textSecondary"
            variant="h5"
            align="center"
          >
            Visualize demographics of top billed cast in movies nominated for
            prestigious awards including the Academy Awards, the Golden Globes,
            BAFTA, etc. Demographix also provides demographic breakdowns of cast
            members in individual productions.
          </Typography>
          <Box
            sx={{
              display: "flex",
              flexDirection: "row",
              justifyContent: "space-evenly",
              width: "25%",
            }}
          >
            <Link to="/noms" component={RouterLink}>
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
          </Box>
        </Box>
        <Footer />
      </Box>
    </Fade>
  );
};
