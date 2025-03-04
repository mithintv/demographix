import {
  Box,
  CircularProgress,
  Paper,
  Typography,
  useMediaQuery,
  useTheme,
} from "@mui/material";
import * as d3 from "d3";
import { memo, useEffect, useState } from "react";
import { Bar, BarChart, Label, Tooltip, XAxis, YAxis } from "recharts";

import { CastHistogramDto } from "../../types/Cast";
import { Payload } from "../../types/Chart";
import { ChartData } from "../../types/ChartData";
import {
  axisLineStyle,
  cursorColor,
  histogramLabelStyle,
  tickStyle,
} from "../../utils/theme";
import ChartLabel from "./ChartLabel";

export type HistogramData = {
  ageGroup: string;
  count: number;
  cast: CastHistogramDto[];
};

export const CustomTooltip = ({
  active,
  payload,
}: // label,
{
  active: boolean | null;
  payload: Payload[] | null;
  label: string | null;
}) => {
  if (active && payload !== null && payload.length) {
    const ageGroup = payload[0].payload.ageGroup;
    const count = payload[0].value;
    // const cast = payload[0].payload.cast || [];
    return (
      <Paper sx={{ px: 2, py: 2, display: "flex", flexDirection: "column" }}>
        <Typography
          align="center"
          variant="overline"
        >{`${ageGroup}: ${count} Cast Member(s)`}</Typography>
        <Box
          sx={{
            maxWidth: "700px",
            width: "100%",
            display: "flex",
            flexDirection: "row",
            justifyContent: "center",
            flexWrap: "wrap",
            flexShrink: 1,
          }}
        >
          {/* {cast.map((el, index) => {
            let imgPath = `https://www.themoviedb.org/t/p/w600_and_h900_bestv2${el.profile_path}`;
            if (el.profile_path == null) {
              imgPath =
                "https://th.bing.com/th/id/OIP.rjbP0DPYm_qmV_cG-S-DUAAAAA?pid=ImgDet&rs=1";
            }
            return (
              <Card
                key={index}
                elevation={2}
                sx={{
                  display: "flex",
                  flexDirection: "column",
                  width: "75px",
                  mx: 1,
                  my: 1,
                  backgroundColor: "background.default",
                  flex: "0 0 auto",
                }}
              >
                <CardMedia
                  sx={{ width: "75px" }}
                  width="75px"
                  height="75px"
                  component="img"
                  image={imgPath}
                  alt={`Image of ${cast.name}`}
                />
                <Container disableGutters sx={{ px: 1, mb: 1 }}>
                  <Typography variant="caption">{el.name}</Typography>
                </Container>
              </Card>
            );
          })} */}
        </Box>
      </Paper>
    );
  }

  return null;
};

const Histogram = memo(({ data }: { data: ChartData[] }) => {
  const lg = useMediaQuery("(max-width:1200px)");
  const md = useMediaQuery("(max-width:960px)");
  const sm = useMediaQuery("(max-width:600px)");
  const xs = useMediaQuery("(max-width:425px)");
  const theme = useTheme();
  const [histogram, setHistogram] = useState<HistogramData[]>([]);

  useEffect(() => {
    const histogramData: HistogramData[] = d3.range(0, 10).map((i) => ({
      ageGroup: `${i * 10}-${(i + 1) * 10}`,
      count: 0,
      cast: [],
    }));

    data.forEach((item) => {
      const ageGroupIndex = Math.floor(item.amount / 10);
      if (ageGroupIndex >= 0 && ageGroupIndex < histogramData.length) {
        histogramData[ageGroupIndex].count++;
        histogramData[ageGroupIndex].cast.push({
          name: item.name,
          profile_path: item.profile_path!,
        });
      }
    });

    setHistogram(histogramData);
  }, [data]);

  return (
    <Paper
      elevation={2}
      sx={{
        p: 0,
        m: 2,
        display: "flex",
        flexDirection: "column",
        justifyContent: "space-between",
        alignItems: "center",
        backgroundColor: "background.default",
        flex: "1 0 auto",
      }}
    >
      <ChartLabel label={"Age Distribution"} />
      <Box
        sx={{
          display: "flex",
          flexDirection: "column",
          justifyContent: "center",
          alignItems: "center",
          width:
            (xs && "275px") ||
            (sm && "350px") ||
            (md && "550px") ||
            (lg && "900px") ||
            "550px",
          height: "350px",
          flex: "1 0 auto",
        }}
      >
        {data.length > 0 ? (
          <BarChart
            style={{ zIndex: 2 }}
            width={
              (xs && 275) || (sm && 350) || (md && 550) || (lg && 900) || 550
            }
            height={300}
            data={histogram}
            margin={{
              top: 25,
              right: 22.5,
              bottom: 10,
              left: (sm && 15) || 25,
            }}
          >
            <XAxis
              dataKey="ageGroup"
              tickLine={axisLineStyle}
              axisLine={axisLineStyle}
              tick={tickStyle}
            />
            <YAxis
              tickLine={axisLineStyle}
              axisLine={axisLineStyle}
              tick={tickStyle}
              dataKey="count"
              // label={{
              //   value: "Number of Cast Members",
              //   angle: -90,
              //   position: "insideLeft",
              //   fill: theme.palette.text.secondary,
              //   offset: 20,
              // }}
            >
              <Label
                angle={-90}
                fill={theme.palette.text.secondary}
                value="Number of Cast Members"
                position="insideLeft"
                style={{ textAnchor: "middle" }}
                offset={2}
                dx={10}
              />
            </YAxis>
            <Tooltip
              wrapperStyle={{ zIndex: 9999 }}
              content={
                <CustomTooltip active={null} payload={null} label={null} />
              }
              cursor={cursorColor}
            />
            <Bar
              dataKey="count"
              fill={theme.palette.primary.main}
              label={histogramLabelStyle}
              animationDuration={1000} // Duration of the animation in milliseconds
              animationBegin={500}
            ></Bar>
          </BarChart>
        ) : (
          <CircularProgress size={100} thickness={10} />
        )}
      </Box>
    </Paper>
  );
});

export default Histogram;
