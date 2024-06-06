import {
  AppBar,
  Box,
  Button,
  Drawer,
  IconButton,
  Link,
  Toolbar,
  Typography,
  useMediaQuery,
  useTheme,
} from "@mui/material";
import { useEffect, useState } from "react";
import { Link as RouterLink } from "react-router-dom";
import SearchPage from "../components/SearchPage";

export default function NavBar() {
  const sm = useMediaQuery("(max-width:600px)");
  const theme = useTheme();
  const [open, setOpen] = useState(false);
  const [navTransparent, setNavTransparent] = useState(true);

  const handleScroll = () => {
    if (window.scrollY > 32) {
      setNavTransparent(false);
    } else {
      setNavTransparent(true);
    }
  };

  useEffect(() => {
    window.addEventListener("scroll", handleScroll);
    return () => {
      window.removeEventListener("scroll", handleScroll);
    };
  }, []);

  const handleDrawer = () => {
    setOpen(true);
  };

  return (
    <Box>
      <AppBar
        sx={{
          backgroundColor: navTransparent
            ? "transparent"
            : theme.palette.background.default,
          boxShadow: navTransparent ? "none" : "2px",
          backgroundImage: "none",
          transition: "background-color 500ms",
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
          <Link sx={{ textDecoration: "none" }} component={RouterLink} to="/">
            <Typography component="div" variant="h6" sx={{ flexGrow: 1 }}>
              Demographix
            </Typography>
          </Link>
          {sm ? (
            <Box
              sx={{
                display: "flex",
                flexDiection: "row",
                alignItems: "center",
              }}
            >
              <Drawer anchor={"top"} open={open} onClose={() => setOpen(false)}>
                <Link
                  sx={{
                    textDecoration: "none",
                    mt: 2,
                    mx: 2,
                    textAlign: "center",
                  }}
                  component={RouterLink}
                  to="/noms/academy awards/yearly/2023"
                >
                  <Button
                    startIcon={
                      <span className="material-symbols-outlined">
                        bar_chart
                      </span>
                    }
                  >
                    Cumulative Data
                  </Button>
                </Link>
                <SearchPage nav={true} />
              </Drawer>
              <IconButton
                onClick={handleDrawer}
                size="large"
                edge="end"
                color="primary"
                aria-label="open drawer"
              >
                <span className="material-symbols-outlined">menu</span>
              </IconButton>
            </Box>
          ) : (
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
                to="/noms/academy awards/yearly/2023"
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
          )}
        </Toolbar>
      </AppBar>
    </Box>
  );
}
