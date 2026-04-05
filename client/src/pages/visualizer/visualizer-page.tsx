import { Box, Fade } from "@mui/material";
import { useQuery } from "@tanstack/react-query";
import { useSearchParams } from "react-router-dom";

import { MovieCard } from "./movie-card";

import Footer from "@/shared/layout/footer";
import { Cast } from "@/shared/types/Cast";
import { Movie } from "@/shared/types/Movie";
import { CardList } from "@/shared/ui/card-list/card-list";
import { CastDataCard } from "@/shared/ui/cast-data-card/cast-data-card";
import { getDemographicsEndpoint } from "@/shared/api/endpoints";
import { backgroundGradient } from "@/shared/utils/theme";
import { VisualizerHeader } from "./visualizer-header";
import { YearSelectorTypeEnum } from "./year-selector";

const compileCast = (movies: Movie[] | undefined) => {
	if (!movies) {
		return undefined;
	}
	const allMoviesCast: Cast[] = [];
	movies.forEach((movie) => {
		allMoviesCast.push(...movie.cast);
	});
	return allMoviesCast;
};

export const VisualizerPage = () => {
	const [searchParams] = useSearchParams();
	const event = searchParams.get("event") ?? "1";
	const range = searchParams.get("range") ?? YearSelectorTypeEnum.Yearly;
	const year = searchParams.get("year") ?? new Date().getFullYear().toString();

	// fetch call for data retrieval
	const { data: movies, error } = useQuery({
		queryKey: ["visualizer", event, range, year],
		queryFn: async (): Promise<Movie[]> => {
			const url = getDemographicsEndpoint(event, range, year);
			const response = await fetch(url);
			return await response.json();
		},
		retry: false,
		refetchOnWindowFocus: false,
	});
	if (error) console.error(error);

	return (
		<Fade in>
			<Box
				sx={{
					width: "100%",
					height: "100%",
					background: backgroundGradient,
				}}
			>
				<div className="flex flex-col max-w-7xl ml-auto mr-auto pb-2 pt-20 px-2">
					<VisualizerHeader />
					<CastDataCard cast={compileCast(movies)} />
					<CardList
						accordion={false}
						heading="Nominations"
						cardList={movies?.map((movie, index) => {
							return <MovieCard movie={movie} key={index} />;
						})}
					/>
				</div>
				<Footer />
			</Box>
		</Fade>
	);
};
