const NavBar = () => {
  return (
    <Box sx={{ flexGrow: 1 }}>
      <AppBar position="static">
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
          <SearchBar />
        </Toolbar>
      </AppBar>
    </Box>
  );
};
