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
import { useMemo, useState } from "react";

import { AdminHeader } from "../admin-header";
import { nominationDescription } from "../constants";

import { AdminCreateNominationDialog } from "./admin-create-nomination-dialog";

import { API_HOSTNAME } from "@/shared/utils/endpoints";

interface NominationMovie {
	id: number;
	title: string;
	release_date: string | null;
	has_cast: boolean;
}

interface Nomination {
	id: number;
	name: string;
	year: number;
	movies: NominationMovie[];
}

interface NominationsResponse {
	nominations: Nomination[];
	total: number;
}

export const AdminNominationsPage = () => {
	const [selectedAward, setSelectedAward] = useState<string | null>(null);
	const [dialogOpen, setDialogOpen] = useState(false);
	const [checkingId, setCheckingId] = useState<number | null>(null);
	const queryClient = useQueryClient();

	const { data, isFetching } = useQuery<NominationsResponse>({
		queryKey: ["admin-nominations"],
		queryFn: async () => {
			const res = await fetch(`${API_HOSTNAME}/admin/nominations`, {});
			if (res.status === 401) {
				throw new Error("Unauthorized");
			}
			return res.json();
		},
		retry: false,
		refetchOnWindowFocus: false,
	});

	const awardNames = useMemo(() => {
		if (!data) return [];
		return [...new Set(data.nominations.map((n) => n.name))].sort();
	}, [data]);

	const activeAward = selectedAward ?? awardNames[0] ?? null;

	const filtered = useMemo(
		() => data?.nominations.filter((n) => n.name === activeAward) ?? [],
		[data, activeAward],
	);

	const invalidate = () =>
		queryClient.invalidateQueries({ queryKey: ["admin-nominations"] });

	const handleDeleteNomination = async (nominationId: number) => {
		await fetch(`${API_HOSTNAME}/admin/nominations/${nominationId}`, {
			method: "DELETE",
		});
		invalidate();
	};

	const handleCheckNomination = async (nom: Nomination) => {
		setCheckingId(nom.id);
		await fetch(`${API_HOSTNAME}/admin/nominations/check`, {
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify({ name: nom.name.toLowerCase(), year: nom.year }),
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

	return (
		<>
			<AdminCreateNominationDialog
				open={dialogOpen}
				onClose={() => setDialogOpen(false)}
				onCreated={invalidate}
				awardNames={awardNames}
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
						value={activeAward}
						onChange={(_, val) => setSelectedAward(val)}
						sx={{ mb: 3, borderBottom: 1, borderColor: "divider" }}
						variant="scrollable"
						scrollButtons="auto"
					>
						{awardNames.length > 0 &&
							awardNames.map((name) => (
								<Tab key={name} label={name} value={name} />
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
						{!isFetching && data && filtered.length === 0 && (
							<Typography color="text.secondary">
								No nominations found.
							</Typography>
						)}

						{filtered.map((nom, index) => (
							<Box key={index} sx={{ pr: 2 }}>
								<Accordion key={nom.id} disableGutters>
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
												width: "100%",
												gap: 2,
											}}
										>
											<Typography sx={{ flexGrow: 1 }}>{nom.year}</Typography>
											<Chip
												size="small"
												label={`${nom.movies.length} movie${nom.movies.length !== 1 ? "s" : ""}`}
											/>
											<Tooltip title="Run nomination check">
												<IconButton
													size="small"
													color="primary"
													disabled={checkingId === nom.id}
													onClick={(e) => {
														e.stopPropagation();
														handleCheckNomination(nom);
													}}
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
													onClick={(e) => {
														e.stopPropagation();
														handleDeleteNomination(nom.id);
													}}
												>
													<span className="material-symbols-outlined">
														delete
													</span>
												</IconButton>
											</Tooltip>
										</Box>
									</AccordionSummary>
									<AccordionDetails>
										{nom.movies.length === 0 ? (
											<Typography variant="body2" color="text.secondary">
												No movies linked.
											</Typography>
										) : (
											<Box
												sx={{
													display: "flex",
													flexDirection: "column",
													gap: 1,
												}}
											>
												{nom.movies.map((movie) => (
													<Box
														key={movie.id}
														sx={{
															display: "flex",
															alignItems: "center",
															gap: 1,
														}}
													>
														<Typography variant="body2" sx={{ flexGrow: 1 }}>
															{movie.title}
															{movie.release_date && (
																<Typography
																	component="span"
																	variant="caption"
																	color="text.secondary"
																	sx={{ ml: 1 }}
																>
																	({new Date(movie.release_date).getFullYear()})
																</Typography>
															)}
														</Typography>
														<Tooltip title="Remove from nomination">
															<IconButton
																size="small"
																onClick={() =>
																	handleRemoveMovie(nom.id, movie.id)
																}
															>
																<span className="material-symbols-outlined">
																	close
																</span>
															</IconButton>
														</Tooltip>
													</Box>
												))}
											</Box>
										)}
									</AccordionDetails>
								</Accordion>
							</Box>
						))}
					</Box>
				</Container>
			</Box>
		</>
	);
};
