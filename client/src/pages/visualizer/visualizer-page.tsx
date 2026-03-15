import {
	Box,
	Button,
	Dialog,
	DialogContent,
	DialogTitle,
	Fade,
	FormControl,
	InputLabel,
	MenuItem,
	Select,
	SelectChangeEvent,
	Typography,
	useMediaQuery,
} from "@mui/material";
import { useQuery } from "@tanstack/react-query";
import { useEffect, useState } from "react";
import { useSearchParams } from "react-router-dom";

import { MovieCard } from "./movie-card";

import Footer from "@/shared/layout/footer";
import { Cast } from "@/shared/types/Cast";
import { Movie } from "@/shared/types/Movie";
import { CardList } from "@/shared/ui/card-list/card-list";
import { CastDataCard } from "@/shared/ui/cast-data-card/cast-data-card";
import { getDemographicsEndpoint } from "@/shared/utils/constants";
import { backgroundGradient } from "@/shared/utils/theme";

const getSelectableYears = () => {
	const currYear = new Date().getFullYear();
	const allYears = [];
	for (let i = currYear; i >= 1950; i--) {
		allYears.push(i);
	}
	return allYears;
};

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
	const md = useMediaQuery("(max-width:960px)");
	// const sm = useMediaQuery("(max-width:600px)");
	// const xs = useMediaQuery("(max-width:425px)");
	const [searchParams, setSearchParams] = useSearchParams();

	const [event, setEvent] = useState(
		searchParams.get("event") ?? "academy-awards",
	);
	const [range, setRange] = useState(searchParams.get("range") ?? "yearly");
	const [year, setYear] = useState(
		searchParams.get("year") ?? new Date().getFullYear().toString(),
	);
	const [cumYears, setCumYears] = useState("");
	const [open, setOpen] = useState(false);

	useEffect(() => {
		window.scrollTo(0, 0);
		setSearchParams({ event, range, year });
	}, [setSearchParams, event, range, year]);

	useEffect(() => {
		if (range === "cumulative" && year !== undefined) {
			const years = year.toString().split("-");
			const splitYear = Number.parseInt(years[1]);
			const current_year = new Date().getFullYear();
			const string = `${current_year - splitYear + 1} - ${current_year}`;
			setCumYears(string);
		}
	}, [year, range]);

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

	const handleEvent = (e: SelectChangeEvent) => {
		const selectedEvent = e.target.value;
		setEvent(selectedEvent);
		setSearchParams({ event: selectedEvent });
	};

	const handleRange = (e: SelectChangeEvent) => {
		const selectedRange = e.target.value;
		setRange(selectedRange);
		let selectedYear = "last-3";
		if (selectedRange === "cumulative") {
			setYear(selectedYear);
		} else {
			selectedYear = new Date().getFullYear().toString();
			setYear(selectedYear);
		}
		setSearchParams({
			range: selectedRange,
		});
	};

	const handleYear = (e: SelectChangeEvent) => {
		const selectedYear = e.target.value;
		setYear(selectedYear);
		setSearchParams({ year: selectedYear });
	};

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
					<Box
						sx={{
							mt: 4,
							display: "flex",
							flexDirection: "row",
							alignItems: "center",
							justifyContent: "space-between",
							px: 2,
						}}
					>
						<Box
							sx={{
								display: "flex",
								flexDirection: "column",
								justifyContent: "end",
							}}
						>
							<Typography
								sx={{ lineHeight: 0.75, mt: 1 }}
								color="primary"
								variant="subtitle1"
							>
								Top Billed Cast
							</Typography>
							<Typography color="primary" variant="overline">
								Academy Award Nominated Titles (
								{range === "yearly" ? year : cumYears})
							</Typography>
						</Box>

						{md ? (
							<Box
								sx={{
									display: "flex",
									flexDirection: "row",
									justifyContent: "end",
								}}
							>
								<Button
									sx={{ my: 1.86 }}
									size={"large"}
									variant="outlined"
									onClick={() => setOpen(true)}
								>
									Filters
								</Button>
								<Dialog open={open} onClose={() => setOpen(false)}>
									<DialogTitle>Filters</DialogTitle>
									<DialogContent sx={{ px: 2 }}>
										<FormControl
											sx={{
												ml: 1,
												my: 1,
											}}
										>
											<InputLabel id="event">Event</InputLabel>
											<Select
												labelId="event"
												id="event"
												value={event}
												label="Event"
												onChange={handleEvent}
											>
												<MenuItem value={"golden-globes"}>
													Golden Globes
												</MenuItem>
												<MenuItem value={"bafta"}>BAFTA</MenuItem>
												<MenuItem value={"academy-awards"}>
													Academy Awards
												</MenuItem>
											</Select>
										</FormControl>
										<FormControl
											sx={{
												ml: 1,
												my: 1,
											}}
										>
											<InputLabel id="range">Range</InputLabel>
											<Select
												labelId="range"
												id="range"
												value={range}
												label="range"
												onChange={handleRange}
											>
												<MenuItem value={"cumulative"}>Cumulative</MenuItem>
												<MenuItem value={"yearly"}>Yearly</MenuItem>
											</Select>
										</FormControl>
										{range === "cumulative" ? (
											<FormControl
												sx={{
													ml: 1,
													my: 1,
													width: "150px",
												}}
											>
												<InputLabel id={"cumulative"}>Cumulative</InputLabel>
												<Select
													labelId="cumulative"
													id="cumulative"
													value={year}
													label="cumulative"
													onChange={handleYear}
												>
													<MenuItem value={"last-3"}>Last 3 Years</MenuItem>
													<MenuItem value={"last-5"}>Last 5 Years</MenuItem>
													<MenuItem value={"last-10"}>Last 10 Years</MenuItem>
												</Select>
											</FormControl>
										) : (
											<FormControl
												sx={{
													m: 1,
													width: "100px",
												}}
											>
												<InputLabel id={"year"}>Year</InputLabel>
												<Select
													labelId="year"
													id="year"
													value={year}
													label="Year"
													onChange={handleYear}
												>
													{getSelectableYears().map((x, i) => {
														return (
															<MenuItem key={i} value={x}>
																{x}
															</MenuItem>
														);
													})}
												</Select>
											</FormControl>
										)}
									</DialogContent>
								</Dialog>
							</Box>
						) : (
							<Box
								sx={{
									display: "flex",
									flexDirection: "row",
									justifyContent: "end",
								}}
							>
								<FormControl
									sx={{
										ml: 1,
										my: 1,
										width: 200,
									}}
								>
									<InputLabel id="event">Event</InputLabel>
									<Select
										labelId="event"
										id="event"
										value={event}
										label="Event"
										onChange={handleEvent}
									>
										<MenuItem value={"golden-globes"}>Golden Globes</MenuItem>
										<MenuItem value={"bafta"}>BAFTA</MenuItem>
										<MenuItem value={"academy-awards"}>Academy Awards</MenuItem>
									</Select>
								</FormControl>
								<FormControl
									sx={{
										ml: 1,
										my: 1,
										width: 150,
									}}
								>
									<InputLabel id="range">Range</InputLabel>
									<Select
										labelId="range"
										id="range"
										value={range}
										label="range"
										onChange={handleRange}
									>
										<MenuItem value={"cumulative"}>Cumulative</MenuItem>
										<MenuItem value={"yearly"}>Yearly</MenuItem>
									</Select>
								</FormControl>
								<FormControl
									sx={{
										ml: 1,
										my: 1,
										width: 150,
									}}
								>
									{range === "cumulative" ? (
										<>
											<InputLabel id={"cumulative"}>Cumulative</InputLabel>
											<Select
												labelId="cumulative"
												id="cumulative"
												value={year}
												label="cumulative"
												onChange={handleYear}
											>
												<MenuItem value={"last-3"}>Last 3 Years</MenuItem>
												<MenuItem value={"last-5"}>Last 5 Years</MenuItem>
												<MenuItem value={"last-10"}>Last 10 Years</MenuItem>
											</Select>
										</>
									) : (
										<>
											<InputLabel id={"year"}>Year</InputLabel>
											<Select
												labelId="year"
												id="year"
												value={year}
												label="Year"
												onChange={handleYear}
											>
												{getSelectableYears().map((x, i) => {
													return (
														<MenuItem key={i} value={x}>
															{x}
														</MenuItem>
													);
												})}
											</Select>
										</>
									)}
								</FormControl>
							</Box>
						)}
					</Box>

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
