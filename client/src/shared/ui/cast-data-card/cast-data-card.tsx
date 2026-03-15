import { Box, Paper, Typography } from "@mui/material";
import { memo, useEffect, useState } from "react";

import { Cast } from "../../types/Cast";
import { ChartData } from "../../types/ChartData";

import { AgeChart } from "./age-chart";
import { GenderChart } from "./gender-chart";
import { RaceEthnicityChart } from "./race-ethnicity-chart";

import {
	parseAges,
	// parseCountryOfBirth,
	parseEthnicity,
	parseGenders,
	parseRace,
} from "@/shared/utils/parse";

export const CastDataCard = memo(
	({
		cast,
		releaseDate,
	}: {
		cast: Cast[] | undefined;
		releaseDate?: number;
	}) => {
		// const lg = useMediaQuery("(max-width:1200px)");
		// const md = useMediaQuery("(max-width:960px)");
		// const sm = useMediaQuery("(max-width:600px)");
		// const xs = useMediaQuery("(max-width:425px)");
		const [ageData, setAgeData] = useState<ChartData[] | undefined>();
		const [genderData, setGenderData] = useState<ChartData[] | undefined>();
		const [raceData, setRaceData] = useState<ChartData[] | undefined>();
		const [ethnicityData, setEthnicityData] = useState<
			ChartData[] | undefined
		>();
		// const [cobData, setCOBData] = useState<ChartData[]>();

		useEffect(() => {
			const listAgeData = parseAges(cast, releaseDate);
			setAgeData(listAgeData);

			const listGenderData = parseGenders(cast);
			setGenderData(listGenderData);

			const listRaceData = parseRace(cast);
			setRaceData(listRaceData);

			const listEthnicityData = parseEthnicity(cast);
			setEthnicityData(listEthnicityData);

			// const listCOBData = parseCountryOfBirth(cast);
			// setCOBData(listCOBData);
		}, [cast, releaseDate]);

		return (
			<Paper
				sx={{
					display: "flex",
					flex: "0 1 auto",
					flexDirection: "column",
					mb: 2,
					mx: 2,
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
					Demographics
				</Typography>
				<Box
					sx={{
						display: "flex",
						flexDirection: "row",
						justifyContent: "space-evenly",
						flexWrap: "wrap",
					}}
				>
					<GenderChart data={genderData} />
					<AgeChart data={ageData} />
					<RaceEthnicityChart
						title="ethnicity"
						data={ethnicityData}
						colors={["#FFBB28"]}
					/>
					<RaceEthnicityChart
						title="race"
						data={raceData}
						colors={[
							"#fff",
							"#B63E76",
							"#0088FE",
							"#00C49F",
							"#FFBB28",
							"#FF8042",
						]}
					/>
				</Box>
			</Paper>
		);
	},
);
