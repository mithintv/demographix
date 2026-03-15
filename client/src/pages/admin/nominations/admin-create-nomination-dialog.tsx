import {
	Autocomplete,
	Button,
	Dialog,
	DialogActions,
	DialogContent,
	DialogTitle,
	TextField,
} from "@mui/material";
import { useState } from "react";

import { API_HOSTNAME } from "@/shared/utils/endpoints";

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
	const [creating, setCreating] = useState(false);

	const handleCreate = async () => {
		if (!newName.trim() || !newYear) return;
		setCreating(true);
		const res = await fetch(`${API_HOSTNAME}/admin/nominations`, {
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify({ name: newName.trim(), year: newYear }),
		});
		await res.json();
		setCreating(false);
		setNewName("");
		setNewYear(new Date().getFullYear());
		onClose();
		onCreated();
	};

	const handleClose = () => {
		setNewName("");
		setNewYear(new Date().getFullYear());
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
