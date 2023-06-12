const LandingPage = () => {
  React.useEffect(() => {
    window.scrollTo(0, 0);
  }, []);

  return (
    <Fade in>
      <Container
        disableGutters
        sx={{
          pb: 20,
          display: "flex",
          height: "100vh",
          flexDirection: "column",
          justifyContent: "center",
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
            sx={{ my: 2, width: "700px" }}
            color="textSecondary"
            variant="body"
            align="justify"
          >
            Demographix is a visualization of demographic information of top
            billed cast in movies nominated for prestigious awards such as the
            Academy Awards, the Golden Globes, BAFTA, etc. You can also search
            for demographic breakdowns of cast members in individual
            productions.
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
              <Button variant="outlined">Visualize Data</Button>
            </Link>
            <SearchPage nav={false} />
          </Box>
        </Box>
      </Container>
    </Fade>
  );
};
