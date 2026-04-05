import {
	Box,
	Button,
	Chip,
	CircularProgress,
	Container,
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
	ToggleButton,
	ToggleButtonGroup,
	Tooltip,
	Typography,
} from "@mui/material";
import { useQuery } from "@tanstack/react-query";
import { useRef, useState } from "react";

import { AdminHeader } from "./admin-header";
import { castMemberDescription } from "./constants";

import { API_HOSTNAME } from "@/shared/api/endpoints";

interface SourceLink {
	id: number;
	link: string;
	source_id: number;
}

interface Ethnicity {
	name: string;
	sources: SourceLink[];
}

interface CastMember {
	id: number;
	name: string;
	gender: string | null;
	country_of_birth: string | null;
	ethnicities: Ethnicity[];
	races: string[];
}

interface CastListResponse {
	cast: CastMember[];
	total: number;
	page: number;
	per_page: number;
}

function EthnicityChips({ ethnicities }: { ethnicities: Ethnicity[] }) {
	return (
		<Box sx={{ display: "flex", flexWrap: "wrap", gap: 0.5 }}>
			{ethnicities.map((e) => (
				<Tooltip
					key={e.name}
					title={
						e.sources.length === 0
							? "No sources — may be inaccurate"
							: `${e.sources.length} source(s)`
					}
				>
					<Chip
						size="small"
						label={e.name}
						color={e.sources.length === 0 ? "warning" : "default"}
					/>
				</Tooltip>
			))}
		</Box>
	);
}

export const AdminCastPage = () => {
	const [page, setPage] = useState(1);
	const [search, setSearch] = useState("");
	const [searchInput, setSearchInput] = useState("");
	const [flag, setFlag] = useState<string | null>(null);
	const searchTimeout = useRef<ReturnType<typeof setTimeout> | null>(null);

	const { data, isFetching } = useQuery<CastListResponse>({
		queryKey: ["admin-cast", page, search, flag],
		queryFn: async () => {
			const params = new URLSearchParams({
				page: String(page),
				per_page: "50",
				...(search ? { search } : {}),
				...(flag ? { flag } : {}),
			});
			const res = await fetch(`${API_HOSTNAME}/admin/cast?${params}`, {});
			if (res.status === 401) {
				throw new Error("Unauthorized");
			}
			return res.json();
		},
		retry: false,
		refetchOnWindowFocus: false,
	});

	const handleSearchChange = (value: string) => {
		setSearchInput(value);
		if (searchTimeout.current) clearTimeout(searchTimeout.current);
		searchTimeout.current = setTimeout(() => {
			setSearch(value);
			setFlag(null);
			setPage(1);
		}, 400);
	};

	const totalPages = data ? Math.ceil(data.total / data.per_page) : 1;

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
							{data.total} cast members
						</Typography>
					)}
				</Box>

				<Box sx={{ display: "flex", alignItems: "center", gap: 2, mb: 2 }}>
					<ToggleButtonGroup
						size="small"
						exclusive
						value={flag}
						onChange={(_, val) => {
							setFlag(val);
							setPage(1);
						}}
					>
						<ToggleButton
							value="no_sources"
							sx={{
								borderColor: "warning.main",
								color: "warning.main",
								"&.Mui-selected": { bgcolor: "warning.dark", color: "white" },
							}}
						>
							No sources
						</ToggleButton>
						<ToggleButton
							value="missing_data"
							sx={{
								borderColor: "error.main",
								color: "error.main",
								"&.Mui-selected": { bgcolor: "error.dark", color: "white" },
							}}
						>
							Missing data
						</ToggleButton>
					</ToggleButtonGroup>
					{flag && (
						<Button
							size="small"
							onClick={() => {
								setFlag(null);
								setPage(1);
							}}
						>
							Clear filter
						</Button>
					)}
				</Box>

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
							</TableRow>
						</TableHead>
						<TableBody>
							{data?.cast.map((cm) => {
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
												<EthnicityChips ethnicities={cm.ethnicities} />
											) : (
												<Typography variant="caption" color="error">
													None
												</Typography>
											)}
										</TableCell>
										<TableCell>
											<Box sx={{ display: "flex", flexWrap: "wrap", gap: 0.5 }}>
												{cm.races.length > 0 ? (
													cm.races.map((r) => (
														<Chip key={r} size="small" label={r} />
													))
												) : (
													<Typography variant="caption" color="text.secondary">
														—
													</Typography>
												)}
											</Box>
										</TableCell>
									</TableRow>
								);
							})}
							{isFetching && !data && (
								<TableRow>
									<TableCell colSpan={6} align="center">
										<CircularProgress size={24} sx={{ my: 2 }} />
									</TableCell>
								</TableRow>
							)}
						</TableBody>
					</Table>
				</TableContainer>

				{totalPages > 1 && (
					<Box sx={{ display: "flex", justifyContent: "center", mt: 3 }}>
						<Pagination
							count={totalPages}
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
