import { Card, Typography } from "@mui/material";

import { Cast } from "@/shared/types/Cast";
import { TMDB_POSTER_BASE_URL } from "@/shared/utils/constants";

import noPhoto from "/no-photo.svg";

export const CastCard = ({ cast }: { cast: Cast }) => {
  return (
    <Card
      elevation={2}
      sx={{
        width: 125,
        height: 275,
        my: 1,
        backgroundColor: "background.default",
        flex: "0 0 auto",
      }}
    >
      <img
        width={125}
        className="max-w-fit object-contain shadow-xl"
        src={
          cast.profile_path
            ? `${TMDB_POSTER_BASE_URL}${cast.profile_path}`
            : noPhoto
        }
        alt={`Poster image of ${cast.name}`}
      />
      <div className="flex flex-col px-2 pt-2">
        <Typography variant="caption">{cast.name}</Typography>
        <Typography variant="caption" color="textSecondary">
          {cast.character}
        </Typography>
      </div>
    </Card>
  );
};
