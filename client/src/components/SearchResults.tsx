import {
	Box,
	Card,
	CardMedia,
	CircularProgress,
	Fade,
	Link,
	useMediaQuery,
} from "@mui/material";
import { useEffect } from "react";
import { Link as RouterLink } from "react-router-dom";
import { Movie } from "../types/Movie";
import { API_HOSTNAME } from "@/utils/constants";
import { useQuery } from "@tanstack/react-query";

export default function SearchResults({
	setOpen,
	searchText,
}: {
	setOpen: React.Dispatch<React.SetStateAction<boolean>>;
	searchText: string;
}) {
	// const lg = useMediaQuery("(max-width:1200px)");
	// const md = useMediaQuery("(max-width:960px)");
	const sm = useMediaQuery("(max-width:600px)");
	// const xs = useMediaQuery("(max-width:485px)");
	// const theme = useTheme();

	const {
		data: results,
		refetch,
		isFetching,
	} = useQuery({
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

	useEffect(() => {
		let timeout: NodeJS.Timeout;
		if (searchText.length === 0) {
			refetch();
		} else {
			timeout = setTimeout(async () => {
				refetch();
			}, 1000);
		}
		return () => {
			clearTimeout(timeout);
		};
	}, [refetch, searchText]);

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
				results.map((movie, index) => {
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
								to={`/movies/${movie.id}`}
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
}
