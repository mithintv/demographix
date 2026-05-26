import { useRef, useState } from "react";

import {
  Box,
  Chip,
  CircularProgress,
  Container,
  IconButton,
  InputAdornment,
  Pagination,
  Paper,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  TextField,
  Typography,
} from "@mui/material";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import axios from "axios";
import { SearchCheck } from "lucide-react";

import {
  getCastMemberCheckEndpoint,
  getCastMemberEndpoint,
} from "@/shared/api/endpoints";
import { QueryKeyEnum } from "@/shared/api/query-key.enum";
import type { ICastMember } from "@/shared/types/i-cast-member";
import type { IResultsResponse } from "@/shared/types/i-results-response-t";

import { AdminHeader } from "../admin-header";
import { castMemberDescription } from "../constants";
import { EthnicityChipList } from "./ethnicity-chip-list";

export const AdminCastPage = () => {
  const queryClient = useQueryClient();

  const [page, setPage] = useState(1);
  const [search, setSearch] = useState("");
  const [searchInput, setSearchInput] = useState("");
  const searchTimeout = useRef<ReturnType<typeof setTimeout> | null>(null);

  const checkMutation = useMutation({
    mutationFn: async (castMemberId: number) => {
      await axios.post(getCastMemberCheckEndpoint(castMemberId));
    },
    onSuccess: () => {
      queryClient.invalidateQueries({
        queryKey: [QueryKeyEnum.AdminCastMembers],
      });
    },
  });

  const { data, isFetching } = useQuery({
    queryKey: [QueryKeyEnum.AdminCastMembers, page, search],
    queryFn: async () => {
      const res = await axios.get<IResultsResponse<ICastMember>>(
        getCastMemberEndpoint(page, search),
      );
      if (res.status === 401) {
        throw new Error("Unauthorized");
      }
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
          subheader={castMemberDescription}
          crumbs={[
            { label: "Dashboard", to: "/admin" },
            { label: "Cast Members" },
          ]}
        />

        <div className="flex flex-row justify-between">
          <Box sx={{ display: "flex", alignItems: "center", gap: 2, mb: 2 }}>
            <TextField
              size="small"
              label="Search by name"
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
                {data.meta.total_items} cast members
              </Typography>
            )}
          </Box>
        </div>

        <TableContainer component={Paper}>
          <Table size="small">
            <TableHead>
              <TableRow>
                <TableCell>ID</TableCell>
                <TableCell>Name</TableCell>
                <TableCell>Gender</TableCell>
                <TableCell>Country of Birth</TableCell>
                <TableCell>Ethnicities</TableCell>
                <TableCell>Races</TableCell>
                <TableCell>Actions</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {data &&
                data.results.map((cm) => {
                  const missingData =
                    cm.ethnicities.length === 0 && cm.races.length === 0;
                  const hasSources = cm.ethnicities.some(
                    (e) => e.sources.length > 0,
                  );
                  return (
                    <TableRow
                      key={cm.id}
                      sx={{
                        bgcolor: missingData
                          ? "error.dark"
                          : cm.ethnicities.length > 0 && !hasSources
                            ? "warning.dark"
                            : undefined,
                        opacity:
                          missingData ||
                          (cm.ethnicities.length > 0 && !hasSources)
                            ? 0.85
                            : 1,
                      }}
                    >
                      <TableCell>
                        <Typography variant="caption" color="text.secondary">
                          {cm.id}
                        </Typography>
                      </TableCell>
                      <TableCell>
                        <Typography variant="body2">{cm.name}</Typography>
                      </TableCell>
                      <TableCell>
                        <Typography variant="body2" color="text.secondary">
                          {cm.gender ?? "—"}
                        </Typography>
                      </TableCell>
                      <TableCell>
                        <Typography variant="body2" color="text.secondary">
                          {cm.country_of_birth ?? "—"}
                        </Typography>
                      </TableCell>
                      <TableCell>
                        {cm.ethnicities.length > 0 ? (
                          <EthnicityChipList ethnicities={cm.ethnicities} />
                        ) : (
                          <Typography variant="caption" color="text.secondary">
                            —
                          </Typography>
                        )}
                      </TableCell>
                      <TableCell>
                        <Box
                          sx={{ display: "flex", flexWrap: "wrap", gap: 0.5 }}
                        >
                          {cm.races.length > 0 ? (
                            cm.races.map((r) => (
                              <Chip key={r} size="small" label={r} />
                            ))
                          ) : (
                            <Typography
                              variant="caption"
                              color="text.secondary"
                            >
                              —
                            </Typography>
                          )}
                        </Box>
                      </TableCell>
                      <TableCell>
                        <IconButton
                          size="small"
                          onClick={() => checkMutation.mutate(cm.id)}
                          disabled={checkMutation.isPending}
                        >
                          {checkMutation.isPending &&
                          checkMutation.variables === cm.id ? (
                            <CircularProgress size={20} />
                          ) : (
                            <SearchCheck size={20} className="text-gold-500" />
                          )}
                        </IconButton>
                      </TableCell>
                    </TableRow>
                  );
                })}
              {isFetching && !data && (
                <TableRow>
                  <TableCell colSpan={7} align="center">
                    <CircularProgress size={24} sx={{ my: 2 }} />
                  </TableCell>
                </TableRow>
              )}
            </TableBody>
          </Table>
        </TableContainer>

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
