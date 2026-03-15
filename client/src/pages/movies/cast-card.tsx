import { Card, Typography } from "@mui/material";

import { Cast } from "@/shared/types/Cast";

export const CastCard = ({ cast }: { cast: Cast }) => {
	return (
		<Card
			elevation={2}
			sx={{
				width: 125,
				height: 275,
				my: 1,
				backgroundColor: "background.default",
				flex: "0 0 auto",
			}}
		>
			<img
				width={125}
				className="max-w-fit object-contain shadow-xl"
				src={`https://www.themoviedb.org/t/p/w600_and_h900_bestv2${cast.profile_path}`}
				alt={`Poster image of ${cast.name}`}
			/>
			<div className="flex flex-col px-2 pt-2">
				<Typography variant="caption">{cast.name}</Typography>
				<Typography variant="caption" color="textSecondary">
					{cast.character}
				</Typography>
			</div>
		</Card>
	);
};
