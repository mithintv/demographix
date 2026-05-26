import {
  Box,
  Card,
  Chip,
  CircularProgress,
  Container,
  Fade,
  Typography,
} from "@mui/material";

import { IMovieDto } from "@/shared/types/i-movie.dto";
import { TMDB_POSTER_BASE_URL } from "@/shared/utils/constants";

export const MovieDetails = ({
  movie,
  isLoading,
}: {
  movie: IMovieDto | undefined;
  isLoading: boolean;
}) => {
  const compileRuntime = (minutes: number) => {
    const hours = Math.floor(minutes / 60);
    const remainingMinutes = minutes % 60;
    return `${hours}h ${remainingMinutes}m`;
  };

  return (
    <Card
      sx={{
        mx: 2,
        mb: 2,
        py: 3,
        px: 2,
        width: "100%",
        minHeight: 235.59,
        display: "flex",
        flexDirection: "column",
        justifyContent: movie && movie.id ? "start" : "center",
        alignItems: movie && movie.id ? "start" : "center",
        flex: "1 1 auto",
      }}
    >
      {isLoading && (
        <div className="flex flex-row w-full h-[187.6px] justify-center items-center">
          <CircularProgress size={100} thickness={10} />
        </div>
      )}
      {!isLoading && !movie && (
        <Typography variant="overline" color="text.secondary">
          Movie not found
        </Typography>
      )}
      {!isLoading && movie && (
        <Fade in={true}>
          <Container
            disableGutters
            sx={{
              display: "flex",
              flexDirection: "column",
            }}
          >
            <div className="flex flex-col gap-4 xs:flex-row">
              <Box
                sx={{
                  display: "flex",
                  flexDirection: "column",
                  flex: "0 1 auto",
                }}
              >
                <img
                  className="min-h-41.25 min-w-27.5 xs:w-50"
                  src={`${TMDB_POSTER_BASE_URL}${movie.poster_path}`}
                  alt={`Movie poster for ${movie.title}`}
                />
              </Box>
              <div className="flex flex-col gap-2">
                <Typography variant="h4">{movie.title}</Typography>
                <div className="flex flex-row gap-2">
                  <Typography variant="caption">
                    {new Date(movie.release_date).getFullYear()}
                  </Typography>
                  <Typography variant="caption">
                    {compileRuntime(movie.runtime)}
                  </Typography>
                </div>
                <div className="flex flex-row gap-2 py-1">
                  {movie.genres.map((genre, i) => {
                    return <Chip key={i} label={genre} />;
                  })}
                </div>
                <Typography variant="subtitle2">{movie.overview}</Typography>
              </div>
            </div>
          </Container>
        </Fade>
      )}
    </Card>
  );
};
