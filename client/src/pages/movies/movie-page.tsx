import { Box, Container, Fade } from "@mui/material";
import { useQuery } from "@tanstack/react-query";
import { useEffect } from "react";
import { useParams } from "react-router-dom";

import Footer from "../../shared/layout/footer";
import { Movie } from "../../shared/types/Movie";

import { CastCard } from "@/pages/movies/cast-card";
import { MovieDetails } from "@/pages/movies/movie-details";
import { CardList } from "@/shared/ui/card-list/card-list";
import { CastDataCard } from "@/shared/ui/cast-data-card/cast-data-card";
import { API_HOSTNAME } from "@/shared/api/endpoints";
import { backgroundGradient } from "@/shared/utils/theme";

export const MoviePage = () => {
	// const theme = useTheme();
	// const lg = useMediaQuery("(max-width:1200px)");
	// const md = useMediaQuery("(max-width:960px)");
	// const sm = useMediaQuery("(max-width:600px)");
	// const xs = useMediaQuery("(max-width:425px)");
	const { id } = useParams();
	// const { id } = props.match.params;

	const { data: movieDetails, isFetching } = useQuery({
		queryKey: ["movie", id],
		queryFn: async (): Promise<Movie> => {
			const response = await fetch(`${API_HOSTNAME}/movies/${id}`);
			return await response.json();
		},
		retry: false,
		refetchOnWindowFocus: false,
	});

	useEffect(() => {
		window.scrollTo(0, 0);
	}, []);

	return (
		<Fade in>
			<Box
				sx={{
					background: backgroundGradient,
					height: "100%",
				}}
			>
				<Container
					disableGutters
					sx={{
						pb: 2,
						pt: 12,
						px: 2,
						mx: "auto",
						display: "flex",
						flexDirection: "row",
						flexWrap: "wrap",
					}}
				>
					<MovieDetails movie={movieDetails} isLoading={isFetching} />
					<CardList
						accordion={true}
						heading="Top Billed Cast"
						cardList={movieDetails?.cast.map((cast, index) => {
							return <CastCard cast={cast} key={index} />;
						})}
					/>
					<CastDataCard
						cast={movieDetails?.cast ?? []}
						releaseDate={
							movieDetails?.release_date
								? new Date(movieDetails?.release_date).getFullYear()
								: undefined
						}
					/>
				</Container>
				<Footer />
			</Box>
		</Fade>
	);
};
