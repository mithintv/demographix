import {
	Autocomplete,
	Button,
	CircularProgress,
	Dialog,
	DialogActions,
	DialogContent,
	DialogTitle,
	TextField,
} from "@mui/material";
import { useState } from "react";

import { API_HOSTNAME } from "@/shared/utils/constants";

interface MovieOption {
	id: number;
	title: string;
	release_date: string | null;
}

export const AdminCreateNominationDialog = ({
	open,
	onClose,
	onCreated,
	awardNames,
}: {
	open: boolean;
	onClose: () => void;
	onCreated: () => void;
	awardNames: string[];
}) => {
	const [newName, setNewName] = useState("");
	const [newYear, setNewYear] = useState<number | "">(new Date().getFullYear());
	const [selectedMovies, setSelectedMovies] = useState<MovieOption[]>([]);
	const [movieSearch, setMovieSearch] = useState("");
	const [movieOptions, setMovieOptions] = useState<MovieOption[]>([]);
	const [movieLoading, setMovieLoading] = useState(false);
	const [creating, setCreating] = useState(false);

	const handleMovieSearch = async (search: string) => {
		setMovieSearch(search);
		if (!search.trim()) {
			setMovieOptions([]);
			return;
		}
		setMovieLoading(true);
		const res = await fetch(
			`${API_HOSTNAME}/admin/movies?search=${encodeURIComponent(search)}`,
		);
		const movies: MovieOption[] = await res.json();
		setMovieOptions(movies);
		setMovieLoading(false);
	};

	const handleCreate = async () => {
		if (!newName.trim() || !newYear) return;
		setCreating(true);
		const res = await fetch(`${API_HOSTNAME}/admin/nominations`, {
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify({ name: newName.trim(), year: newYear }),
		});
		const nom = await res.json();
		for (const movie of selectedMovies) {
			await fetch(`${API_HOSTNAME}/admin/nominations/${nom.id}/movies`, {
				method: "POST",
				headers: { "Content-Type": "application/json" },
				body: JSON.stringify({ movie_id: movie.id }),
			});
		}
		setCreating(false);
		setNewName("");
		setNewYear(new Date().getFullYear());
		setSelectedMovies([]);
		setMovieOptions([]);
		onClose();
		onCreated();
	};

	const handleClose = () => {
		setNewName("");
		setNewYear(new Date().getFullYear());
		setSelectedMovies([]);
		setMovieOptions([]);
		onClose();
	};

	return (
		<Dialog open={open} onClose={handleClose} maxWidth="sm" fullWidth>
			<DialogTitle>Create Nomination</DialogTitle>
			<DialogContent
				sx={{
					display: "flex",
					flexDirection: "column",
					gap: 2,
					pt: "16px !important",
				}}
			>
				<Autocomplete
					freeSolo
					options={awardNames}
					value={newName}
					onInputChange={(_, val) => setNewName(val)}
					renderInput={(params) => (
						<TextField {...params} label="Award Name" required />
					)}
				/>
				<TextField
					label="Year"
					type="number"
					required
					value={newYear}
					onChange={(e) =>
						setNewYear(e.target.value ? parseInt(e.target.value) : "")
					}
					inputProps={{ min: 1900, max: 2100 }}
				/>
				<Autocomplete
					multiple
					options={movieOptions}
					value={selectedMovies}
					onChange={(_, val) => setSelectedMovies(val)}
					inputValue={movieSearch}
					onInputChange={(_, val) => handleMovieSearch(val)}
					getOptionLabel={(opt) =>
						opt.release_date
							? `${opt.title} (${new Date(opt.release_date).getFullYear()})`
							: opt.title
					}
					isOptionEqualToValue={(opt, val) => opt.id === val.id}
					loading={movieLoading}
					filterOptions={(x) => x}
					renderInput={(params) => (
						<TextField
							{...params}
							label="Movies"
							placeholder="Search movies..."
							InputProps={{
								...params.InputProps,
								endAdornment: (
									<>
										{movieLoading && <CircularProgress size={16} />}
										{params.InputProps.endAdornment}
									</>
								),
							}}
						/>
					)}
				/>
			</DialogContent>
			<DialogActions>
				<Button onClick={handleClose}>Cancel</Button>
				<Button
					variant="contained"
					onClick={handleCreate}
					disabled={!newName.trim() || !newYear || creating}
				>
					{creating ? "Creating..." : "Create"}
				</Button>
			</DialogActions>
		</Dialog>
	);
};
