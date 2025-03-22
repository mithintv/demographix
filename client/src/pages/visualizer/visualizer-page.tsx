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
import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import CastDataCard from "../../components/CastDataCard";
import Footer from "../../components/layout/Footer";
import { Cast } from "../../types/Cast";
import { Movie } from "../../types/Movie";
import { backgroundGradient } from "../../utils/theme";
import { API_HOSTNAME } from "@/utils/constants";
import { useQuery } from "@tanstack/react-query";
import { MovieCard } from "./movie-card";
import { CardList } from "@/components/ui/card-list/card-list";

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
		return [];
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
	const xs = useMediaQuery("(max-width:425px)");
	const { awardParam, rangeParam, yearParam } = useParams();

	const [range, setRange] = useState(rangeParam);
	const [award, setAward] = useState(awardParam);
	const [cumYears, setCumYears] = useState("");
	const [year, setYear] = useState(yearParam);

	const [open, setOpen] = useState(false);

	const navigate = useNavigate();

	useEffect(() => {
		window.scrollTo(0, 0);
	}, []);

	// fetch call for data retrieval
	const { data: movies } = useQuery({
		queryKey: ["visualizer", year],
		queryFn: async (): Promise<Movie[]> => {
			const response = await fetch(
				`${API_HOSTNAME}/nom/query?award=${award}&range=${range}&year=${year}`
			);
			return await response.json();
		},
		retry: false,
		refetchOnWindowFocus: false,
	});

	// useEffect for displaying title with cumulative years above data card
	useEffect(() => {
		if (range === "cumulative" && year !== undefined) {
			const years = year.toString().split(" ");
			const splitYear = Number.parseInt(years[1]);
			const current_year = new Date().getFullYear();
			const string = `${current_year - splitYear + 1} - ${current_year}`;
			setCumYears(string);
		}
	}, [year, range]);

	// functions that handle filter onChange events
	const handleAward = (event: SelectChangeEvent) => {
		const selectedAward = event.target.value;
		setAward(selectedAward);
		navigate(`/visualizer/${selectedAward}/${range}/${year}`);
	};

	const handleRange = (event: SelectChangeEvent) => {
		const selectedRange = event.target.value;
		setRange(selectedRange);
		let selectedYear = "last-3";
		if (selectedRange === "cumulative") {
			setYear(selectedYear);
		} else {
			selectedYear = new Date().getFullYear().toString();
			setYear(selectedYear);
		}
		navigate(`/visualizer/${award}/${selectedRange}/${selectedYear}`);
	};

	const handleYear = (event: SelectChangeEvent) => {
		const selectedYear = event.target.value;
		console.log(selectedYear);
		setYear(selectedYear);
		navigate(`/visualizer/${award}/${range}/${selectedYear}`);
	};

	const handleClickOpen = () => {
		setOpen(true);
	};

	const handleClose = () => {
		setOpen(false);
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
									size={xs ? "small" : "large"}
									variant="outlined"
									onClick={handleClickOpen}
								>
									Filters
								</Button>
								<Dialog open={open} onClose={handleClose}>
									<DialogTitle>Filters</DialogTitle>
									<DialogContent sx={{ px: 2 }}>
										<FormControl
											sx={{
												ml: 1,
												my: 1,
											}}
										>
											<InputLabel id="award">Award</InputLabel>
											<Select
												labelId="award"
												id="award"
												value={award}
												label="Award"
												onChange={handleAward}
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
									}}
								>
									<InputLabel id="award">Award</InputLabel>
									<Select
										labelId="award"
										id="award"
										value={award}
										label="Award"
										onChange={handleAward}
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
											ml: 1,
											my: 1,
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
							</Box>
						)}
					</Box>

					<CastDataCard cast={compileCast(movies)} />
					<CardList
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
