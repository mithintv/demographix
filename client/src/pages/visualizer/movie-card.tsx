import { Link } from "react-router-dom";

import Typography from "@mui/material/Typography";
import { getYear } from "date-fns";

import { IMovieDto } from "@/shared/types/i-movie.dto";
import {
  POSTER_PLACEHOLDER_URL,
  TMDB_POSTER_BASE_URL,
} from "@/shared/utils/constants";

export const MovieCard = ({
  movie,
  width = 125,
  children,
}: {
  movie: IMovieDto;
  width?: number;
  children?: React.ReactNode;
}) => {
  const imgPath = movie.poster_path
    ? `${TMDB_POSTER_BASE_URL}${movie.poster_path}`
    : POSTER_PLACEHOLDER_URL;

  const year = movie.release_date
    ? ` (${new Date(movie.release_date).getFullYear()})`
    : "";

  return (
    <div className="relative group">
      <Link to={`/movies/${movie.id}`}>
        <img
          width={width}
          className="max-w-fit object-contain shadow-xl"
          src={imgPath}
          alt={`Poster image of ${movie.title} (${getYear(movie.release_date)})`}
        />
        <div className="absolute inset-0 bg-black/0 group-hover:bg-black/60 transition-colors flex items-end">
          <Typography
            variant="caption"
            className="opacity-0 group-hover:opacity-100 transition-opacity p-2 text-white!"
          >
            {movie.title}
            {year}
          </Typography>
        </div>
      </Link>
      {children}
    </div>
  );
};
