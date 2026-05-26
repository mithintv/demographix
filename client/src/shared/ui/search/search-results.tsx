import { Box, CircularProgress, Fade } from "@mui/material";
import { useQuery } from "@tanstack/react-query";
import axios from "axios";

import { MovieCard } from "@/pages/visualizer/movie-card";
import { getMoviesEndpoint } from "@/shared/api/endpoints";
import { QueryKeyEnum } from "@/shared/api/query-key.enum";
import { IMovieDto } from "@/shared/types/i-movie.dto";

export const SearchResults = ({
  setOpen,
  searchText,
}: {
  setOpen: React.Dispatch<React.SetStateAction<boolean>>;
  searchText: string;
}) => {
  const { data: results, isFetching } = useQuery({
    queryKey: [QueryKeyEnum.Movies, searchText],
    queryFn: async (): Promise<IMovieDto[]> => {
      const { data } = await axios.get(getMoviesEndpoint(searchText));
      return data.results;
    },
    enabled: true,
    retry: false,
    refetchOnWindowFocus: false,
  });

  return (
    <Box
      sx={{
        mx: 4,
        my: 4,
        display: "flex",
        flexDirection: "row",
        flexWrap: "wrap",
        justifyContent: "center",
        alignContent:
          results && results.length > 0 ? "space-between" : "center",
        zIndex: 3,
        height: "66vh",
        overflowY: "auto",
      }}
    >
      {isFetching ? (
        <CircularProgress size={100} thickness={10} />
      ) : (
        results?.map((movie, index) => (
          <Fade key={index} in timeout={index * 50}>
            <div className="mx-1 mb-2" onClick={() => setOpen(false)}>
              <MovieCard movie={movie} width={119} />
            </div>
          </Fade>
        ))
      )}
    </Box>
  );
};
