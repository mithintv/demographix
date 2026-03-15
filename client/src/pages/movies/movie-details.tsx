import {
	Box,
	Card,
	Chip,
	CircularProgress,
	Container,
	Fade,
	Typography,
} from "@mui/material";
import { useEffect, useState } from "react";

import { Movie } from "../../shared/types/Movie";

export const MovieDetails = ({
	movie,
	isLoading,
}: {
	movie: Movie | undefined;
	isLoading: boolean;
}) => {
	const [content, setContent] = useState<Movie | undefined>(movie);
	const [show, setShow] = useState(false);

	const compileRuntime = (minutes: number) => {
		const hours = Math.floor(minutes / 60);
		const remainingMinutes = minutes % 60;
		return `${hours}h ${remainingMinutes}m`;
	};

	useEffect(() => {
		setShow(false);
		const delay = setTimeout(() => {
			setContent(movie);

			// Trigger fade-in effect
			setShow(true);
			clearTimeout(delay);
		}, 500);
	}, [movie]);

	return (
		<Card
			sx={{
				mx: 2,
				mb: 2,
				py: 3,
				px: 2,
				width: "100%",
				display: "flex",
				flexDirection: "column",
				justifyContent: content && content.id ? "start" : "center",
				alignItems: content && content.id ? "start" : "center",
				flex: "1 1 auto",
			}}
		>
			{isLoading || !content ? (
				<CircularProgress size={100} thickness={10} />
			) : (
				<Fade in={show}>
					<Container
						disableGutters
						sx={{
							display: "flex",
							flexDirection: "column",
						}}
					>
						<div className="flex flex-col gap-4 xs:flex-row">
							<Box
								sx={{
									display: "flex",
									flexDirection: "column",
									flex: "0 1 auto",
								}}
							>
								<img
									className="min-h-[165px] min-w-[110px] xs:w-[200px]"
									src={`https://www.themoviedb.org/t/p/w600_and_h900_bestv2${content.poster_path}`}
									alt={`Movie poster for ${content.title}`}
								/>
							</Box>
							<div className="flex flex-col gap-2">
								<Typography variant="h4">{content.title}</Typography>
								<div className="flex flex-row gap-2">
									<Typography variant="caption">
										{new Date(content.release_date).getFullYear()}
									</Typography>
									<Typography variant="caption">
										{compileRuntime(content.runtime)}
									</Typography>
								</div>
								<div className="flex flex-row gap-2 py-1">
									{content.genres.map((genre, i) => {
										return <Chip key={i} label={genre} />;
									})}
								</div>
								<Typography variant="subtitle2">{content.overview}</Typography>
							</div>
						</div>
					</Container>
				</Fade>
			)}
		</Card>
	);
};
