import { useRef, useState } from "react";

import {
  Box,
  CircularProgress,
  Container,
  IconButton,
  InputAdornment,
  Pagination,
  TextField,
  Tooltip,
  Typography,
} from "@mui/material";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import axios from "axios";
import { SearchCheck } from "lucide-react";

import { MovieCard } from "@/pages/visualizer/movie-card";
import {
  getMovieCheckEndpoint,
  getMoviesEndpoint,
} from "@/shared/api/endpoints";
import { QueryKeyEnum } from "@/shared/api/query-key.enum";
import type { IMovieDto } from "@/shared/types/i-movie.dto";
import type { IResultsResponse } from "@/shared/types/i-results-response-t";

import { AdminHeader } from "../admin-header";
import { movieDescription } from "../constants";

export const AdminMoviesPage = () => {
  const queryClient = useQueryClient();

  const [page, setPage] = useState(1);
  const [search, setSearch] = useState("");
  const [searchInput, setSearchInput] = useState("");
  const searchTimeout = useRef<ReturnType<typeof setTimeout> | null>(null);

  const checkMutation = useMutation({
    mutationFn: async (movieId: number) => {
      await axios.post(getMovieCheckEndpoint(movieId));
    },
    onSuccess: () => {
      queryClient.invalidateQueries({
        queryKey: [QueryKeyEnum.AdminMovies],
      });
    },
  });

  const { data, isFetching } = useQuery({
    queryKey: [QueryKeyEnum.AdminMovies, page, search],
    queryFn: async () => {
      const res = await axios.get<IResultsResponse<IMovieDto>>(
        getMoviesEndpoint(search, page),
      );
      return res.data;
    },
    retry: false,
    refetchOnWindowFocus: false,
  });

  const handleSearchChange = (value: string) => {
    setSearchInput(value);
    if (searchTimeout.current) clearTimeout(searchTimeout.current);
    searchTimeout.current = setTimeout(() => {
      setSearch(value);
      setPage(1);
    }, 400);
  };

  return (
    <Box sx={{ minHeight: "100vh", bgcolor: "background.default", py: 4 }}>
      <Container maxWidth="lg">
        <AdminHeader
          subheader={movieDescription}
          crumbs={[{ label: "Dashboard", to: "/admin" }, { label: "Movies" }]}
        />

        <div className="flex flex-row justify-between">
          <Box sx={{ display: "flex", alignItems: "center", gap: 2, mb: 2 }}>
            <TextField
              size="small"
              label="Search by title"
              value={searchInput}
              onChange={(e) => handleSearchChange(e.target.value)}
              InputProps={{
                endAdornment: isFetching ? (
                  <InputAdornment position="end">
                    <CircularProgress size={16} />
                  </InputAdornment>
                ) : null,
              }}
              sx={{ width: 300 }}
            />
            {data && (
              <Typography variant="body2" color="text.secondary">
                {data.meta.total_items} movies
              </Typography>
            )}
          </Box>
        </div>

        {isFetching && !data && (
          <Box sx={{ display: "flex", justifyContent: "center", py: 4 }}>
            <CircularProgress size={48} />
          </Box>
        )}

        <div className="flex flex-row flex-wrap gap-4">
          {data?.results.map((movie) => (
            <MovieCard key={movie.id} movie={movie}>
              <div className="absolute top-1 right-1 opacity-0 group-hover:opacity-100 transition-opacity">
                <Tooltip title={`Check cast demographics`} arrow>
                  <IconButton
                    size="small"
                    className="bg-black/60! hover:bg-black!"
                    onClick={(e) => {
                      e.preventDefault();
                      checkMutation.mutate(Number(movie.id));
                    }}
                    disabled={checkMutation.isPending}
                  >
                    {checkMutation.isPending &&
                    checkMutation.variables === Number(movie.id) ? (
                      <CircularProgress size={18} />
                    ) : (
                      <SearchCheck size={18} className="text-gold-500" />
                    )}
                  </IconButton>
                </Tooltip>
              </div>
            </MovieCard>
          ))}
        </div>

        {data && data.meta.total_pages > 1 && (
          <Box sx={{ display: "flex", justifyContent: "center", mt: 3 }}>
            <Pagination
              count={data.meta.total_pages}
              page={page}
              onChange={(_, p) => setPage(p)}
              color="primary"
            />
          </Box>
        )}
      </Container>
    </Box>
  );
};
