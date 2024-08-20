import {
  Box,
  Button,
  Container,
  Fade,
  Grid,
  Link,
  Typography,
  useMediaQuery,
  useTheme,
} from "@mui/material";
import { useEffect } from "react";
import { Link as RouterLink } from "react-router-dom";
import SearchPage from "../components/SearchPage";
import Footer from "../components/layout/Footer";

export default function Index() {
  const theme = useTheme();
  // const md = useMediaQuery("(max-width:960px)");
  const sm = useMediaQuery("(max-width:600px)");
  // const xs = useMediaQuery("(max-width:425px)");

  useEffect(() => {
    window.scrollTo(0, 0);
  }, []);

  return (
    <Fade in>
      <Box
        // container
        sx={{
          display: "flex",
          flexDirection: "column",
          justifyContent: "center",
          background: theme.palette.background.default,
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
            xs={10}
            sx={{
              display: "flex",
              flexDirection: sm ? "column" : "row",
              justifyContent: sm ? "center" : "space-evenly",
              alignItems: "center",
              width: "75%",
            }}
          >
            <Link
              sx={{ textDecoration: "none" }}
              to={`visualizer/academy awards/yearly/${2023}`}
              component={RouterLink}
            >
              <Button
                sx={{ my: 1 }}
                size={sm ? "medium" : "large"}
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
}
