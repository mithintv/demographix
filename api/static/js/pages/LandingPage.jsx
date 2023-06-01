const LandingPage = () => {
  const [showLanding, setShowLanding] = React.useState(true);
  const searchClickHandler = () => {
    setShowLanding(false);
  };
  return (
    <Fade in={showLanding}>
      <Container>
        <Link sx={{ textDecoration: "none" }} component={RouterLink} to="/">
          <Typography align="center" variant="h1">
            Demographix
          </Typography>
        </Link>
        <Typography color="textSecondary" variant="subtitle2" align="center">
          Visualize the diverse tapestry of on-screen talent in blockbuster
          films
        </Typography>
        <SearchBar clicked={searchClickHandler} />
      </Container>
    </Fade>
  );
};
