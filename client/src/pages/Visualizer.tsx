import {
	Box,
	Button,
	Card,
	CardMedia,
	Container,
	Dialog,
	DialogContent,
	DialogTitle,
	Fade,
	FormControl,
	InputLabel,
	MenuItem,
	Paper,
	Select,
	SelectChangeEvent,
	Typography,
	useMediaQuery,
} from "@mui/material";
import { useEffect, useState } from "react";
import { Link, useNavigate, useParams } from "react-router-dom";
import CastDataCard from "../components/CastDataCard";
import Footer from "../components/layout/Footer";
import NavBar from "../components/layout/NavBar";
import { Cast } from "../types/Cast";
import { Movie } from "../types/Movie";
import { backgroundGradient } from "../utils/theme";

const compileCast = (movies: Movie[]) => {
	const allMoviesCast: Cast[] = [];
	movies.forEach((movie) => {
		allMoviesCast.push(...movie.cast);
	});
	return allMoviesCast;
};

export const Visualizer = () => {
	const md = useMediaQuery("(max-width:960px)");
	// const sm = useMediaQuery("(max-width:600px)");
	const xs = useMediaQuery("(max-width:425px)");
	const { awardParam, rangeParam, yearParam } = useParams();

	const [movies, setMovies] = useState<Movie[]>([]);
	const [castData, setCastData] = useState<Cast[]>([]);

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
	useEffect(() => {
		const fetchData = async () => {
			const response = await fetch(`/api/nom/${year}`);
			const movieList = await response.json();
			console.log(movieList);
			setMovies(movieList);

			const castList = compileCast(movieList);
			setCastData(castList);
		};
		fetchData();
	}, [award, year]);

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
		let selectedYear = "last 3";
		if (selectedRange === "cumulative") {
			setYear(selectedYear);
		} else {
			selectedYear = new Date().getFullYear().toString();
			setYear(selectedYear);
		}
		navigate(`/visualizer/${award}/${selectedRange}/${selectedYear}`);
	};

	const handleYear = (event: SelectChangeEvent) => {
		setMovies([]);
		setCastData([]);
		const selectedYear = event.target.value;
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
				<NavBar />
				<Container
					disableGutters
					sx={{
						pb: 2,
						pt: 8,
						px: 2,
						display: "flex",
						flexDirection: "column",
					}}
				>
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
													<MenuItem value={"last 3"}>Last 3 Years</MenuItem>
													<MenuItem value={"last 5"}>Last 5 Years</MenuItem>
													<MenuItem value={"last 10"}>Last 10 Years</MenuItem>
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
													<MenuItem value={2023}>2023</MenuItem>
													<MenuItem value={2022}>2022</MenuItem>
													<MenuItem value={2021}>2021</MenuItem>
													<MenuItem value={2020}>2020</MenuItem>
													<MenuItem value={2019}>2019</MenuItem>
													<MenuItem value={2018}>2018</MenuItem>
													<MenuItem value={2017}>2017</MenuItem>
													<MenuItem value={2016}>2016</MenuItem>
													<MenuItem value={2015}>2015</MenuItem>
													<MenuItem value={2014}>2014</MenuItem>
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
											<MenuItem value={"last 3"}>Last 3 Years</MenuItem>
											<MenuItem value={"last 5"}>Last 5 Years</MenuItem>
											<MenuItem value={"last 10"}>Last 10 Years</MenuItem>
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
											<MenuItem value={2023}>2023</MenuItem>
											<MenuItem value={2022}>2022</MenuItem>
											<MenuItem value={2021}>2021</MenuItem>
											<MenuItem value={2020}>2020</MenuItem>
											<MenuItem value={2019}>2019</MenuItem>
											<MenuItem value={2018}>2018</MenuItem>
											<MenuItem value={2017}>2017</MenuItem>
											<MenuItem value={2016}>2016</MenuItem>
											<MenuItem value={2015}>2015</MenuItem>
											<MenuItem value={2014}>2014</MenuItem>
										</Select>
									</FormControl>
								)}
							</Box>
						)}
					</Box>
					<CastDataCard cast={castData} />
					<Paper
						sx={{
							display: "flex",
							flexDirection: "column",
							mb: 2,
						}}
					>
						<Typography
							sx={{
								mt: 1,
								pl: 2,
								width: "100%",
								borderBottom: "3px solid rgba(255, 255, 255, 0.05);",
							}}
							variant="overline"
							color="primary"
						>
							Nominations
						</Typography>
						<Container
							disableGutters
							sx={{
								px: 1,
								py: 2,
								display: "flex",
								flexDirection: "row",
								width: "100%",
								overflowX: "scroll",
								height: 225.9,
							}}
						>
							{movies.map((movie, index) => {
								const releaseDate = new Date(movie.release_date);
								return (
									<Fade in timeout={500} key={index}>
										<Card
											elevation={2}
											sx={{
												width: 125,
												mx: 1,
												backgroundColor: "background.default",
												flex: "0 0 auto",
												cursor: "pointer",
											}}
										>
											<Link to={`/movies/${movie.id}`}>
												<CardMedia
													width={100}
													component="img"
													image={`https://www.themoviedb.org/t/p/w600_and_h900_bestv2${movie.poster_path}`}
													alt={`Poster image of ${movie.title} (${releaseDate})`}
												/>
											</Link>
										</Card>
									</Fade>
								);
							})}
						</Container>
					</Paper>
				</Container>
				<Footer />
			</Box>
		</Fade>
	);
};
