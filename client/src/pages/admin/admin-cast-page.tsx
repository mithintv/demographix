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
import { useRef, useState } from "react";
import { useQuery, useQueryClient } from "@tanstack/react-query";

import { API_HOSTNAME } from "@/shared/utils/constants";
import { AdminHeader } from "./admin-header";
import { castMemberDescription } from "./constants";

interface Ethnicity {
	cast_ethnicity_id: number;
	ethnicity_id: number;
	ethnicity_name: string | null;
	source_count: number;
}

interface CastMember {
	id: number;
	name: string;
	gender: string | null;
	gender_id: number;
	country_of_birth: string | null;
	country_of_birth_id: string | null;
	ethnicities: Ethnicity[];
	races: string[];
	has_sources: boolean;
	missing_data: boolean;
}

interface CastListResponse {
	cast: CastMember[];
	total: number;
	page: number;
	per_page: number;
}

function EthnicityChips({
	ethnicities,
	castId,
	onDeleted,
}: {
	ethnicities: Ethnicity[];
	castId: number;
	onDeleted: () => void;
}) {
	const handleDelete = async (castEthnicityId: number) => {
		await fetch(
			`${API_HOSTNAME}/admin/cast/${castId}/ethnicities/${castEthnicityId}`,
			{ method: "DELETE" },
		);
		onDeleted();
	};

	return (
		<Box sx={{ display: "flex", flexWrap: "wrap", gap: 0.5 }}>
			{ethnicities.map((e) => (
				<Tooltip
					key={e.cast_ethnicity_id}
					title={
						e.source_count === 0
							? "No sources — may be inaccurate"
							: `${e.source_count} source(s)`
					}
				>
					<Chip
						size="small"
						label={e.ethnicity_name ?? "Unknown"}
						color={e.source_count === 0 ? "warning" : "default"}
						onDelete={() => handleDelete(e.cast_ethnicity_id)}
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
	const queryClient = useQueryClient();

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

	const invalidateList = () =>
		queryClient.invalidateQueries({ queryKey: ["admin-cast"] });

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
							{data?.cast.map((cm) => (
								<TableRow
									key={cm.id}
									sx={{
										bgcolor: cm.missing_data
											? "error.dark"
											: !cm.has_sources
												? "warning.dark"
												: undefined,
										opacity: cm.missing_data || !cm.has_sources ? 0.85 : 1,
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
											<EthnicityChips
												ethnicities={cm.ethnicities}
												castId={cm.id}
												onDeleted={invalidateList}
											/>
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
							))}
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
