import { Box, Chip, Tooltip } from "@mui/material";

import { IEthnicity } from "@/shared/types/i-ethnicity";

export const EthnicityChipList = ({
	ethnicities,
}: {
	ethnicities: IEthnicity[];
}) => {
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
};
