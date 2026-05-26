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

import { API_HOSTNAME } from "@/shared/api/endpoints";
import { AwardDto } from "./award.dto";

export const AdminCreateNominationDialog = ({
	open,
	onClose,
	onCreated,
	awards,
}: {
	open: boolean;
	onClose: () => void;
	onCreated: () => void;
	awards: AwardDto[];
}) => {
	const [selectedAward, setSelectedAward] = useState<AwardDto | null>(null);
	const [newYear, setNewYear] = useState<number | "">(new Date().getFullYear());
	const [creating, setCreating] = useState(false);

	const handleCreate = async () => {
		if (!selectedAward || !newYear) return;
		setCreating(true);
		const res = await fetch(`${API_HOSTNAME}/admin/nominations`, {
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify({ award_id: selectedAward.id, year: newYear }),
		});
		await res.json();
		setCreating(false);
		setSelectedAward(null);
		setNewYear(new Date().getFullYear());
		onClose();
		onCreated();
	};

	const handleClose = () => {
		setSelectedAward(null);
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
					options={awards}
					value={selectedAward}
					onChange={(_, val) => setSelectedAward(val)}
					getOptionLabel={(o) => `${o.event.name} - ${o.name}`}
					isOptionEqualToValue={(o, v) => o.id === v.id}
					renderInput={(params) => (
						<TextField {...params} label="Award" required />
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
			<DialogActions sx={{ px: 3, pb: 2 }}>
				<Button onClick={handleClose}>Cancel</Button>
				<Button
					variant="contained"
					onClick={handleCreate}
					disabled={!selectedAward || !newYear || creating}
				>
					{creating ? "Creating..." : "Create"}
				</Button>
			</DialogActions>
		</Dialog>
	);
};
