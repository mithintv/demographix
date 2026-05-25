import { useState } from "react";

import {
  Accordion,
  AccordionDetails,
  AccordionSummary,
  Box,
  Button,
  Chip,
  Collapse,
  Container,
  IconButton,
  Tab,
  Tabs,
  Tooltip,
  Typography,
} from "@mui/material";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import axios from "axios";
import {
  AlertTriangle,
  CheckCircle,
  ChevronDown,
  ChevronRight,
  Loader,
  Plus,
  SearchCheck,
  Trash2,
  UserSearch,
} from "lucide-react";

import {
  API_HOSTNAME,
  getMovieCheckEndpoint,
  getNominationEndpoint,
} from "@/shared/api/endpoints";
import { NominationProjectionEnum } from "@/shared/api/nomination-projection.enum";
import { QueryKeyEnum } from "@/shared/api/query-key.enum";
import { ICreditDto } from "@/shared/types/i-credit.dto";
import { IResultsResponse } from "@/shared/types/i-results-response-t";

import { AdminHeader } from "../admin-header";
import { nominationDescription } from "../constants";
import { AdminCreateNominationDialog } from "./admin-create-nomination-dialog";
import { AwardDto } from "./award.dto";

interface NominationMovieDto {
  id: number;
  title: string;
  release_date: string | null;
  credits: ICreditDto[];
}

interface NominationDto {
  id: number;
  year: number;
  award: AwardDto;
  movies: NominationMovieDto[];
}

interface EventDto {
  id: number;
  name: string;
  imdb_event_id: string;
}

const MovieRow = ({
  movie,
  nominationId,
  onRemove,
  onCheck,
  isChecking,
}: {
  movie: NominationMovieDto;
  nominationId: number;
  onRemove: (nominationId: number, movieId: number) => void;
  onCheck: (movieId: number) => void;
  isChecking: boolean;
}) => {
  const movieLabel = movie.release_date
    ? `${movie.title} (${new Date(movie.release_date).getFullYear()})`
    : movie.title;

  return (
    <Box
      sx={{
        display: "flex",
        alignItems: "center",
        gap: 0.5,
        px: 2,
        py: 0.75,
        "&:hover": { bgcolor: "action.hover" },
      }}
    >
      <Tooltip
        title={movie.credits.length > 0 ? "Cast data found" : "No cast data"}
      >
        {movie.credits.length > 0 ? (
          <CheckCircle size={18} color="#4caf50" />
        ) : (
          <AlertTriangle size={18} color="#ff9800" />
        )}
      </Tooltip>
      <Typography variant="body2" sx={{ flex: 1 }}>
        {movieLabel}
      </Typography>
      <IconButton
        size="small"
        color="primary"
        disabled={isChecking}
        onClick={() => onCheck(movie.id)}
      >
        {isChecking ? <Loader size={20} /> : <UserSearch size={20} />}
      </IconButton>
      <Tooltip title="Remove movie from nomination">
        <IconButton
          size="small"
          color="error"
          onClick={() => onRemove(nominationId, movie.id)}
        >
          <Trash2 size={20} />
        </IconButton>
      </Tooltip>
    </Box>
  );
};

export const AdminNominationsPage = () => {
  const queryClient = useQueryClient();
  const [selectedEvent, setSelectedEvent] = useState<EventDto | null>(null);
  const [dialogOpen, setDialogOpen] = useState(false);
  const [checkingId, setCheckingId] = useState<number | null>(null);
  const [expandedNoms, setExpandedNoms] = useState<Set<number>>(new Set());

  const toggleNomExpanded = (nomId: number) => {
    setExpandedNoms((prev) => {
      const next = new Set(prev);
      if (next.has(nomId)) next.delete(nomId);
      else next.add(nomId);
      return next;
    });
  };

  const { data: awardData } = useQuery<IResultsResponse<AwardDto>>({
    queryKey: [QueryKeyEnum.AdminAwards],
    queryFn: async () => {
      const res = await fetch(
        getNominationEndpoint(NominationProjectionEnum.Awards),
      );
      if (res.status === 401) {
        throw new Error("Unauthorized");
      }
      return res.json();
    },
    retry: false,
    refetchOnWindowFocus: false,
  });

  const eventData: EventDto[] = [
    ...new Map(
      awardData?.results.map((x) => [
        x.event.id,
        {
          id: x.event.id,
          name: x.event.name,
          imdb_event_id: x.event.imdb_event_id,
        },
      ]) ?? [],
    ).values(),
  ];
  const activeEvent = selectedEvent ?? eventData[0] ?? null;
  const { data: nominationData, isFetching } = useQuery<
    IResultsResponse<NominationDto>
  >({
    queryKey: [
      QueryKeyEnum.AdminNominations,
      activeEvent?.imdb_event_id ?? null,
    ],
    queryFn: async () => {
      const res = await fetch(
        getNominationEndpoint(
          NominationProjectionEnum.Movies,
          activeEvent?.imdb_event_id,
        ),
      );
      if (res.status === 401) {
        throw new Error("Unauthorized");
      }
      return res.json();
    },
    enabled: !!eventData && !!activeEvent,
    retry: false,
    refetchOnWindowFocus: false,
  });

  const invalidate = () =>
    queryClient.invalidateQueries({
      queryKey: ["admin-nominations", activeEvent?.imdb_event_id ?? null],
    });

  const checkMovieMutation = useMutation({
    mutationFn: async (movieId: number) => {
      await axios.post(getMovieCheckEndpoint(movieId));
    },
    onSuccess: () => invalidate(),
  });

  const handleDeleteNomination = async (nominationId: number) => {
    await fetch(`${API_HOSTNAME}/admin/nominations/${nominationId}`, {
      method: "DELETE",
    });
    invalidate();
  };

  const handleCheckNomination = async (nom: NominationDto) => {
    if (!activeEvent) return;
    setCheckingId(nom.id);
    await fetch(`${API_HOSTNAME}/admin/nominations/check`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        imdb_event_id: activeEvent.imdb_event_id,
        award_id: nom.award.id,
        year: nom.year,
      }),
    });
    setCheckingId(null);
    invalidate();
  };

  const handleRemoveMovie = async (nominationId: number, movieId: number) => {
    await fetch(
      `${API_HOSTNAME}/admin/nominations/${nominationId}/movies/${movieId}`,
      { method: "DELETE" },
    );
    invalidate();
  };

  // Group nominations by award
  const nominationsByAward = new Map<
    number,
    { award: AwardDto; nominations: NominationDto[] }
  >();
  for (const nom of nominationData?.results ?? []) {
    if (!nominationsByAward.has(nom.award.id)) {
      nominationsByAward.set(nom.award.id, {
        award: nom.award,
        nominations: [],
      });
    }
    nominationsByAward.get(nom.award.id)!.nominations.push(nom);
  }
  const awardGroups = [...nominationsByAward.values()].sort((a, b) =>
    a.award.name.localeCompare(b.award.name),
  );

  return (
    <>
      <AdminCreateNominationDialog
        open={dialogOpen}
        onClose={() => setDialogOpen(false)}
        onCreated={invalidate}
        awards={awardData?.results ?? []}
      />
      <Box
        sx={{
          height: "100vh",
          bgcolor: "background.default",
          py: 4,
          display: "flex",
          flexDirection: "column",
        }}
      >
        <Container
          maxWidth="lg"
          sx={{
            display: "flex",
            flexDirection: "column",
            flex: 1,
            overflow: "hidden",
          }}
        >
          <AdminHeader
            subheader={nominationDescription}
            crumbs={[
              { label: "Dashboard", to: "/admin" },
              { label: "Nominations" },
            ]}
            component={
              <Button
                sx={{ height: "2.5rem", display: "flex", alignSelf: "center" }}
                variant="contained"
                startIcon={<Plus size={20} />}
                onClick={() => setDialogOpen(true)}
              >
                Create Nomination
              </Button>
            }
          />
          <Tabs
            textColor="primary"
            indicatorColor="primary"
            TabScrollButtonProps={{ sx: { color: "primary.main" } }}
            value={activeEvent?.id ?? false}
            onChange={(_, val) =>
              setSelectedEvent(eventData?.find((e) => e.id === val) ?? null)
            }
            sx={{ mb: 3, borderBottom: 1, borderColor: "divider" }}
            variant="scrollable"
            scrollButtons="auto"
          >
            {eventData &&
              eventData?.map((event) => (
                <Tab key={event.id} label={event.name} value={event.id} />
              ))}
          </Tabs>

          <Box
            sx={{
              overflowY: "auto",
              display: "flex",
              flexDirection: "column",
              gap: 1,
            }}
          >
            {!isFetching && nominationData?.results.length === 0 && (
              <Typography color="text.secondary">
                No nominations found.
              </Typography>
            )}

            {awardGroups.map(({ award, nominations }) => (
              <Accordion key={award.id} disableGutters>
                <AccordionSummary expandIcon={<ChevronDown size={20} />}>
                  <Box
                    sx={{
                      display: "flex",
                      alignItems: "center",
                      gap: 1.5,
                      width: "100%",
                    }}
                  >
                    <Typography sx={{ flexGrow: 1 }}>{award.name}</Typography>
                    <Chip
                      size="small"
                      label={`${nominations.length} year${nominations.length !== 1 ? "s" : ""}`}
                      sx={{ mr: 1 }}
                    />
                  </Box>
                </AccordionSummary>
                <AccordionDetails sx={{ p: 0 }}>
                  {nominations
                    .slice()
                    .sort((a, b) => b.year - a.year)
                    .map((nom) => {
                      const isExpanded = expandedNoms.has(nom.id);
                      const uncheckedCount = nom.movies.filter(
                        (m) => !m.credits,
                      ).length;

                      return (
                        <Box
                          key={nom.id}
                          sx={{
                            borderTop: 1,
                            borderColor: "divider",
                          }}
                        >
                          {/* Nomination year header row */}
                          <Box
                            sx={{
                              display: "flex",
                              alignItems: "center",
                              gap: 1.5,
                              px: 2,
                              py: 1,
                              cursor: "pointer",
                              "&:hover": { bgcolor: "action.hover" },
                            }}
                            onClick={() => toggleNomExpanded(nom.id)}
                          >
                            <ChevronRight
                              size={18}
                              style={{
                                transition: "transform 0.2s",
                                transform: isExpanded
                                  ? "rotate(90deg)"
                                  : "rotate(0deg)",
                              }}
                            />
                            <Typography
                              variant="body2"
                              color="text.secondary"
                              sx={{
                                minWidth: 40,
                                fontVariantNumeric: "tabular-nums",
                              }}
                            >
                              {nom.year}
                            </Typography>
                            <Box
                              sx={{
                                flex: 1,
                                display: "flex",
                                alignItems: "center",
                                gap: 1,
                              }}
                            >
                              <Chip
                                size="small"
                                label={`${nom.movies.length} movie${nom.movies.length !== 1 ? "s" : ""}`}
                                variant="outlined"
                              />
                              {uncheckedCount > 0 && (
                                <Chip
                                  size="small"
                                  label={`${uncheckedCount} unchecked`}
                                  color="warning"
                                  variant="outlined"
                                />
                              )}
                              {uncheckedCount === 0 &&
                                nom.movies.length > 0 && (
                                  <CheckCircle size={16} color="#4caf50" />
                                )}
                            </Box>
                            <Box
                              sx={{
                                display: "flex",
                                gap: 0.5,
                                flexShrink: 0,
                              }}
                              onClick={(e) => e.stopPropagation()}
                            >
                              <Tooltip title="Fetch nominated movies from IMDB">
                                <IconButton
                                  size="small"
                                  color="primary"
                                  disabled={checkingId === nom.id}
                                  onClick={() => handleCheckNomination(nom)}
                                >
                                  {checkingId === nom.id ? (
                                    <Loader size={20} />
                                  ) : (
                                    <SearchCheck size={20} />
                                  )}
                                </IconButton>
                              </Tooltip>
                              <Tooltip title="Delete nomination and all its movie links">
                                <IconButton
                                  size="small"
                                  color="error"
                                  onClick={() => handleDeleteNomination(nom.id)}
                                >
                                  <Trash2 size={20} />
                                </IconButton>
                              </Tooltip>
                            </Box>
                          </Box>

                          {/* Expandable movie list */}
                          <Collapse in={isExpanded}>
                            <Box
                              sx={{
                                bgcolor: "action.hover",
                                borderTop: 1,
                                borderColor: "divider",
                              }}
                            >
                              {nom.movies.length === 0 ? (
                                <Typography
                                  variant="body2"
                                  color="text.disabled"
                                  sx={{ px: 2, py: 1.5 }}
                                >
                                  No movies linked
                                </Typography>
                              ) : (
                                nom.movies.map((movie) => (
                                  <MovieRow
                                    key={movie.id}
                                    movie={movie}
                                    nominationId={nom.id}
                                    onRemove={handleRemoveMovie}
                                    onCheck={(movieId) =>
                                      checkMovieMutation.mutate(movieId)
                                    }
                                    isChecking={
                                      checkMovieMutation.isPending &&
                                      checkMovieMutation.variables === movie.id
                                    }
                                  />
                                ))
                              )}
                            </Box>
                          </Collapse>
                        </Box>
                      );
                    })}
                </AccordionDetails>
              </Accordion>
            ))}
          </Box>
        </Container>
      </Box>
    </>
  );
};
