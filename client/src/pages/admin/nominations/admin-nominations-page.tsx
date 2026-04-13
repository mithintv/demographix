import {
	Accordion,
	AccordionDetails,
	AccordionSummary,
	Box,
	Button,
	Chip,
	Container,
	IconButton,
	Tab,
	Tabs,
	Tooltip,
	Typography,
} from "@mui/material";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { useState } from "react";

import { AdminHeader } from "../admin-header";
import { nominationDescription } from "../constants";

import { AdminCreateNominationDialog } from "./admin-create-nomination-dialog";

import { API_HOSTNAME, getNominationsEndpoint } from "@/shared/api/endpoints";
import { NominationProjectionEnum } from "@/shared/api/nomination-projection.enum";
import { AwardDto } from "./award.dto";
import { QueryKeysEnum } from "@/shared/types/enums/query-key.enum";
import { ResultsResponse } from "@/shared/types/results-response-t";

interface NominationMovieDto {
	id: number;
	title: string;
	release_date: string | null;
	has_cast: boolean;
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

export const AdminNominationsPage = () => {
	const queryClient = useQueryClient();
	const [selectedEvent, setSelectedEvent] = useState<EventDto | null>(null);
	const [dialogOpen, setDialogOpen] = useState(false);
	const [checkingId, setCheckingId] = useState<number | null>(null);

	const { data: awardData } = useQuery<ResultsResponse<AwardDto>>({
		queryKey: [QueryKeysEnum.AdminAwards],
		queryFn: async () => {
			const res = await fetch(
				getNominationsEndpoint(NominationProjectionEnum.Awards),
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
		ResultsResponse<NominationDto>
	>({
		queryKey: [
			QueryKeysEnum.AdminNominations,
			activeEvent?.imdb_event_id ?? null,
		],
		queryFn: async () => {
			const res = await fetch(
				getNominationsEndpoint(
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
								startIcon={
									<span className="material-symbols-outlined">add</span>
								}
								onClick={() => setDialogOpen(true)}
							>
								New Nomination
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
								<AccordionSummary
									expandIcon={
										<span className="material-symbols-outlined">
											expand_more
										</span>
									}
								>
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
										.map((nom) => (
											<Box
												key={nom.id}
												sx={{
													display: "flex",
													alignItems: "center",
													gap: 1.5,
													px: 2,
													py: 1,
													borderTop: 1,
													borderColor: "divider",
													"&:hover": { bgcolor: "action.hover" },
												}}
											>
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
														display: "flex",
														flexWrap: "wrap",
														gap: 0.5,
														flex: 1,
														minHeight: 52,
														alignContent: "center",
													}}
												>
													{nom.movies.length === 0 ? (
														<Typography variant="body2" color="text.disabled">
															No movies linked
														</Typography>
													) : (
														nom.movies.map((movie) => (
															<Chip
																key={movie.id}
																size="small"
																label={
																	movie.release_date
																		? `${movie.title} (${new Date(movie.release_date).getFullYear()})`
																		: movie.title
																}
																onDelete={() =>
																	handleRemoveMovie(nom.id, movie.id)
																}
																deleteIcon={
																	<span
																		className="material-symbols-outlined"
																		style={{ fontSize: 14 }}
																	>
																		close
																	</span>
																}
																variant={movie.has_cast ? "filled" : "outlined"}
															/>
														))
													)}
												</Box>
												<Box sx={{ display: "flex", gap: 0.5, flexShrink: 0 }}>
													<Tooltip title="Run nomination check">
														<IconButton
															size="small"
															color="primary"
															disabled={checkingId === nom.id}
															onClick={() => handleCheckNomination(nom)}
														>
															<span className="material-symbols-outlined">
																{checkingId === nom.id
																	? "hourglass_empty"
																	: "search_check"}
															</span>
														</IconButton>
													</Tooltip>
													<Tooltip title="Delete nomination and all its movie links">
														<IconButton
															size="small"
															color="error"
															onClick={() => handleDeleteNomination(nom.id)}
														>
															<span className="material-symbols-outlined">
																delete
															</span>
														</IconButton>
													</Tooltip>
												</Box>
											</Box>
										))}
								</AccordionDetails>
							</Accordion>
						))}
					</Box>
				</Container>
			</Box>
		</>
	);
};
