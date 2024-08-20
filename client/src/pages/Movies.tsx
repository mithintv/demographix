import {
  Accordion,
  AccordionDetails,
  AccordionSummary,
  Box,
  Container,
  Fade,
  IconButton,
  Typography,
  useMediaQuery,
  useTheme,
} from "@mui/material";
import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import CastCard from "../components/CastCard";
import CastDataCard from "../components/CastDataCard";
import MovieCard from "../components/MovieCard";
import Footer from "../layout/Footer";
import NavBar from "../layout/NavBar";
import { Cast } from "../types/Cast";
import { Movie } from "../types/Movie";
import { backgroundGradient } from "../utils/theme";

export default function Movies() {
  const theme = useTheme();
  const lg = useMediaQuery("(max-width:1200px)");
  const md = useMediaQuery("(max-width:960px)");
  const sm = useMediaQuery("(max-width:600px)");
  const xs = useMediaQuery("(max-width:425px)");
  const { id } = useParams();
  // const { id } = props.match.params;
  const [movieDetails, setMovieDetails] = useState<Movie>({
    id: null,
    title: null,
    genres: [],
    overview: "",
    runtime: "",
    poster_path: "",
    release_date: null,
    budget: "",
    revenue: null,
    cast: [],
  });
  const [castDetails, setCastDetails] = useState<Cast[]>([]);

  useEffect(() => {
    window.scrollTo(0, 0);
  }, []);

  useEffect(() => {
    const fetchData = async () => {
      const response = await fetch(`/api/movies/${id}`);
      const movieData = await response.json();
      console.log(movieData);
      setMovieDetails(movieData);
      setCastDetails(movieData.cast);
    };
    fetchData();
  }, []);

  return (
    <Fade in>
      <Box
        sx={{
          background: backgroundGradient,
          height: "100%",
        }}
      >
        <NavBar />
        <Container
          disableGutters
          sx={{
            pb: 2,
            pt: 10,
            mx: "auto",
            display: "flex",
            flexDirection: "row",
            flexWrap: "wrap",
          }}
        >
          <MovieCard movie={movieDetails} />
          <Accordion
            disableGutters
            sx={{
              width: "100%",
              overflowX: "hidden",
              mb: 2,
            }}
          >
            <AccordionSummary
              sx={{ borderBottom: "3px solid rgba(255, 255, 255, 0.05);" }}
              expandIcon={
                <IconButton
                  size="large"
                  edge="end"
                  color="primary"
                  aria-label="open drawer"
                >
                  <span className="material-symbols-outlined">expand_more</span>
                </IconButton>
              }
              aria-controls="panel1a-content"
              id="panel1a-header"
            >
              <Typography
                sx={{
                  width: "100%",
                }}
                variant="overline"
                color="primary"
              >
                Top Billed Cast
              </Typography>
            </AccordionSummary>
            <AccordionDetails>
              <CastCard cast={castDetails} />
            </AccordionDetails>
          </Accordion>
          <CastDataCard
            cast={castDetails}
            releaseDate={new Date(movieDetails.release_date).getFullYear()}
          />
        </Container>
        <Footer />
      </Box>
    </Fade>
  );
}
