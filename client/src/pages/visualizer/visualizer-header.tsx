import { useEffect, useState } from "react";

import { useSearchParams } from "react-router-dom";
import {
	Typography,
	Box,
	Button,
	Dialog,
	DialogTitle,
	DialogContent,
	FormControl,
	InputLabel,
	Select,
	MenuItem,
	SelectChangeEvent,
	useMediaQuery,
} from "@mui/material";
import { useQuery } from "@tanstack/react-query";

import { getNominationsEndpoint } from "@/shared/api/endpoints";
import { QueryKeyEnum } from "@/shared/api/query-key.enum";
import { YearSelector, YearSelectorTypeEnum } from "./year-selector";
import { NominationProjectionEnum } from "@/shared/api/nomination-projection.enum";
import { ResultsResponse } from "@/shared/types/results-response-t";
import { EventDto } from "@/shared/types/event.dto";

export const VisualizerHeader = () => {
	const md = useMediaQuery("(max-width:960px)");
	const [searchParams, setSearchParams] = useSearchParams();
	const [event, setEvent] = useState(searchParams.get("event") ?? "1");
	const [range, setRange] = useState(
		(searchParams.get("range") as YearSelectorTypeEnum) ??
			YearSelectorTypeEnum.Yearly,
	);
	const [year, setYear] = useState(
		searchParams.get("year") ?? new Date().getFullYear().toString(),
	);
	const [cumYears, setCumYears] = useState("");
	const [open, setOpen] = useState(false);

	const { data: events } = useQuery({
		queryKey: [QueryKeyEnum.NominationEvents, event],
		queryFn: async (): Promise<ResultsResponse<EventDto>> => {
			const response = await fetch(
				getNominationsEndpoint(NominationProjectionEnum.Events),
			);
			return await response.json();
		},
		retry: false,
		refetchOnWindowFocus: false,
	});
	const { data: years } = useQuery({
		queryKey: [QueryKeyEnum.NominationYears],
		queryFn: async (): Promise<ResultsResponse<YearDto>> => {
			const response = await fetch(
				getNominationsEndpoint(NominationProjectionEnum.Years),
			);
			return await response.json();
		},
		retry: false,
		refetchOnWindowFocus: false,
	});

	useEffect(() => {
		if (range === YearSelectorTypeEnum.Cumulative && year !== undefined) {
			const years = year.toString().split("-");
			const splitYear = Number.parseInt(years[1]);
			const current_year = new Date().getFullYear();
			const string = `${current_year - splitYear + 1} - ${current_year}`;
			setCumYears(string);
		}
	}, [year, range]);

	const handleEvent = (e: SelectChangeEvent) => {
		const selectedEvent = e.target.value;
		setEvent(selectedEvent);
		setSearchParams({ event: selectedEvent, range, year });
	};

	const handleRange = (e: SelectChangeEvent) => {
		const selectedRange = e.target.value as YearSelectorTypeEnum;
		setRange(selectedRange);
		let selectedYear = "last-3";
		if (selectedRange === YearSelectorTypeEnum.Cumulative) {
			setYear(selectedYear);
		} else {
			selectedYear = new Date().getFullYear().toString();
			setYear(selectedYear);
		}
		setSearchParams({ event, range: selectedRange, year });
	};

	const handleYear = (e: SelectChangeEvent) => {
		const selectedYear = e.target.value;
		setYear(selectedYear);
		setSearchParams({ event, range, year: selectedYear });
	};

	return (
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
					Academy Award Nominated Titles ({range === "yearly" ? year : cumYears}
					)
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
									{events &&
										events.results.map((e) => {
											return (
												<MenuItem key={e.id} value={e.id}>
													{e.name}
												</MenuItem>
											);
										})}
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
							<YearSelector
								type={range}
								data={years?.results}
								value={year}
								onChange={handleYear}
							/>
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
							{events &&
								events.results.map((e) => {
									return (
										<MenuItem key={e.id} value={e.id}>
											{e.name}
										</MenuItem>
									);
								})}
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
						<YearSelector
							type={range}
							data={years?.results}
							value={year}
							onChange={handleYear}
						/>
					</FormControl>
				</Box>
			)}
		</Box>
	);
};
