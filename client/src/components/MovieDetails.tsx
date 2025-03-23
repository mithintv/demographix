import {
	Box,
	Card,
	CardMedia,
	Chip,
	CircularProgress,
	Container,
	Fade,
	Stack,
	Typography,
	useMediaQuery,
} from "@mui/material";
import { useEffect, useState } from "react";
import { Movie } from "../shared/types/Movie";

export default function MovieDetails({
	movie,
	isLoading,
}: {
	movie: Movie | undefined;
	isLoading: boolean;
}) {
	// const theme = useTheme();
	// const lg = useMediaQuery("(max-width:1200px)");
	// const md = useMediaQuery("(max-width:960px)");
	// const sm = useMediaQuery("(max-width:600px)");
	const xs = useMediaQuery("(max-width:426px)");
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
						<Box sx={{ display: "flex", flexDirection: xs ? "column" : "row" }}>
							<Box
								sx={{
									display: "flex",
									flexDirection: "column",
									flex: "0 1 auto",
								}}
							>
								<CardMedia
									sx={{
										width: xs ? "300px" : "200px",
										px: xs ? 2 : 0,
										mb: xs ? 2 : 0,
									}}
									component="img"
									image={`https://www.themoviedb.org/t/p/w600_and_h900_bestv2${content.poster_path}`}
									alt={`Movie poster for ${content.title}`}
								/>
							</Box>
							<Box
								sx={{
									display: "flex",
									flexDirection: "column",
									flex: "1 1 auto",
								}}
							>
								<Typography
									variant="h4"
									sx={{
										mx: 2,
									}}
								>
									{content.title}
								</Typography>
								<Container
									disableGutters
									sx={{
										px: 2,
										marginLeft: 0,
										marginRight: "auto",
										display: "flex",
										flexDirection: "row",
									}}
								>
									<Typography sx={{ paddingRight: 1 }} variant="caption">
										{new Date(content.release_date).getFullYear()}
									</Typography>
									<Typography variant="caption">
										{compileRuntime(content.runtime)}
									</Typography>
								</Container>
								<Stack
									sx={{ mt: 1, ml: 2 }}
									direction="row"
									spacing={1}
									useFlexGap
									flexWrap="wrap"
								>
									{content.genres.map((genre, i) => {
										return <Chip key={i} label={genre} />;
									})}
								</Stack>
								<Typography variant="subtitle2" sx={{ mt: 1, mx: 2 }}>
									{content.overview}
								</Typography>
							</Box>
						</Box>
					</Container>
				</Fade>
			)}
		</Card>
	);
}
