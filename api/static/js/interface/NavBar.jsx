const NavBar = () => {
  const theme = useTheme();
  const [navTransparent, setNavTransparent] = React.useState(true);

  const handleScroll = () => {
    if (window.scrollY > 32) {
      setNavTransparent(false);
    } else {
      setNavTransparent(true);
    }
  };

  React.useEffect(() => {
    window.addEventListener("scroll", handleScroll);
    return () => {
      window.removeEventListener("scroll", handleScroll);
    };
  }, []);

  return (
    <Box sx={{ flexGrow: 1 }}>
      <AppBar
        sx={{
          backgroundColor: navTransparent
            ? "transparent"
            : theme.palette.background.default,
          boxShadow: navTransparent ? "none" : "2px",
          backgroundImage: "none",
          transition: "500ms all",
        }}
        position="fixed"
      >
        <Toolbar
          sx={{
            display: "flex",
            justifyContent: "space-between",
            py: 2,
          }}
        >
          {/* <IconButton
            size="large"
            edge="start"
            color="inherit"
            aria-label="open drawer"
            sx={{ mr: 2 }}
          >
            <span className="material-symbols-outlined">menu</span>
          </IconButton> */}

          <Link sx={{ textDecoration: "none" }} component={RouterLink} to="/">
            <Typography component="div" variant="h6" sx={{ flexGrow: 1 }}>
              Demographix
            </Typography>
          </Link>
          <Box
            sx={{
              display: "flex",
              flexDiection: "row",
              alignItems: "center",
            }}
          >
            <Link
              sx={{ textDecoration: "none", mx: 2 }}
              component={RouterLink}
              to="/noms"
            >
              <Button
                startIcon={
                  <span className="material-symbols-outlined">bar_chart</span>
                }
              >
                Cumulative Data
              </Button>
            </Link>
            <SearchPage nav={true} />
          </Box>
        </Toolbar>
      </AppBar>
    </Box>
  );
};
