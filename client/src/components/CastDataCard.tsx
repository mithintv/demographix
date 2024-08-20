import { Box, Paper, Typography } from "@mui/material";
import { memo, useEffect, useState } from "react";
import { Cast } from "../types/Cast";
import {
  AgeData,
  ChartData,
  GenderData,
  parseAges,
  // parseCountryOfBirth,
  parseEthnicity,
  parseGenders,
  parseRace,
} from "../utils/parse";
import GenderChart from "./data/GenderChart";
import Histogram from "./data/Histogram";
import RaceChart from "./data/RaceChart";

const CastDataCard = memo(
  ({ cast, releaseDate }: { cast: Cast[]; releaseDate?: number }) => {
    // const lg = useMediaQuery("(max-width:1200px)");
    // const md = useMediaQuery("(max-width:960px)");
    // const sm = useMediaQuery("(max-width:600px)");
    // const xs = useMediaQuery("(max-width:425px)");
    const [ageData, setAgeData] = useState<AgeData[]>([]);
    const [genderData, setGenderData] = useState<GenderData[]>([]);
    const [raceData, setRaceData] = useState<ChartData[]>([]);
    const [ethnicityData, setEthnicityData] = useState<ChartData[]>([]);
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
          flexDirection: "column",
          mb: 2,
          flex: "0 1 auto",
          // width: (sm && "425px") || (md && "600px") || (lg && "960px") || "960px",
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
          <Histogram data={ageData} />
          <RaceChart
            title="ethnicity"
            data={ethnicityData}
            colors={["#FFBB28"]}
          />
          <RaceChart
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
  }
);

export default CastDataCard;
