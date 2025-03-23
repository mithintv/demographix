import {
	Box,
	Card,
	CardMedia,
	CircularProgress,
	Fade,
	Link,
	useMediaQuery,
} from "@mui/material";
import { Link as RouterLink } from "react-router-dom";
import { Movie } from "@/shared/types/Movie";
import { API_HOSTNAME } from "@/shared/utils/constants";
import { useQuery } from "@tanstack/react-query";

export const SearchResults = ({
	setOpen,
	searchText,
}: {
	setOpen: React.Dispatch<React.SetStateAction<boolean>>;
	searchText: string;
}) => {
	// const lg = useMediaQuery("(max-width:1200px)");
	// const md = useMediaQuery("(max-width:960px)");
	const sm = useMediaQuery("(max-width:600px)");
	// const xs = useMediaQuery("(max-width:485px)");
	// const theme = useTheme();

	const { data: results, isFetching } = useQuery({
		queryKey: ["search-movies", searchText],
		queryFn: async (): Promise<Movie[]> => {
			const response = await fetch(`${API_HOSTNAME}`, {
				method: "POST",
				headers: {
					"Content-Type": "application/json",
				},
				body: JSON.stringify({
					search: searchText,
				}),
			});
			return await response.json();
		},
		retry: false,
		refetchOnWindowFocus: false,
	});

	return (
		<Box
			sx={{
				mx: 4,
				mb: 4,
				display: "flex",
				flexDirection: "row",
				flexWrap: "wrap",
				justifyContent: "center",
				alignContent:
					results && results.length > 0 ? "space-between" : "center",
				zIndex: 3,
				height: "77.5vh",
				overflowY: "auto",
			}}
		>
			{!isFetching ? (
				results?.map((movie, index) => {
					let imgPath = `https://www.themoviedb.org/t/p/w600_and_h900_bestv2${movie.poster_path}`;
					if (movie.poster_path == null) {
						imgPath =
							"https://incakoala.github.io/top9movie/film-poster-placeholder.png";
					}

					return (
						<Fade key={index} in timeout={index * 50}>
							<Link
								sx={{
									mx: 1,
									mb: 2,
								}}
								component={RouterLink}
								to={`/movie/${movie.id}`}
								onClick={() => setOpen(false)}
							>
								<Card>
									<CardMedia
										sx={{ width: (sm && 180) || 110 }}
										component="img"
										image={imgPath}
										alt={`Movie poster for ${movie.title}`}
									/>
								</Card>
							</Link>
						</Fade>
					);
				})
			) : (
				<CircularProgress size={100} thickness={10} />
			)}
		</Box>
	);
};
