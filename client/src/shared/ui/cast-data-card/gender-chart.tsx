import {
	Box,
	CircularProgress,
	Fade,
	Paper,
	Typography,
	useMediaQuery,
} from "@mui/material";
import { memo } from "react";
import { Cell, Pie, PieChart, ResponsiveContainer, Tooltip } from "recharts";

import ChartLabel from "./chart-label";

import { useChartWidth } from "@/shared/hooks/use-chart-width";
import {
	CustomizedPieChartLabel,
	CustomizedTooltip,
} from "@/shared/types/Chart";
import { ChartData } from "@/shared/types/ChartData";

const GenderTooltip = ({ active, payload }: CustomizedTooltip) => {
	if (active && payload && payload.length) {
		const name = payload[0].payload.name;
		const count = payload[0].value;

		return (
			<Paper sx={{ p: 2 }}>
				<Typography variant="overline">{`${name}: ${count} Cast Member(s)`}</Typography>
			</Paper>
		);
	}

	return null;
};

const CustomLabel = ({
	cx,
	cy,
	midAngle,
	// innerRadius,
	outerRadius,
	// startAngle,
	// endAngle,
	fill,
	payload,
	percent,
}: // value,
CustomizedPieChartLabel) => {
	const RADIAN = Math.PI / 180;
	const sin = Math.sin(-RADIAN * midAngle);
	const cos = Math.cos(-RADIAN * midAngle);
	const sx = cx + (outerRadius + 10) * cos;
	const sy = cy + (outerRadius + 10) * sin;
	const mx = cx + (outerRadius + 30) * cos;
	const my = cy + (outerRadius + 30) * sin;
	const ex = mx + (cos >= 0 ? 1 : -1) + percent * 5;
	const ey = my + (sin >= 0 ? 1 : -1) + percent * 5;
	const textAnchor = cos >= 0 ? "start" : "end";

	return (
		<Fade in timeout={250}>
			<g>
				{/* <Sector
					cx={cx}
					cy={cy}
					innerRadius={innerRadius}
					outerRadius={outerRadius}
					startAngle={startAngle}
					endAngle={endAngle}
					fill={fill}
				/> */}
				{/* <Sector
          cx={cx}
          cy={cy}
          startAngle={startAngle}
          endAngle={endAngle}
          innerRadius={outerRadius + 6}
          outerRadius={outerRadius + 10}
          fill={fill}
        /> */}
				<path
					d={`M${sx},${sy}L${mx},${my}L${ex},${ey}`}
					stroke={fill}
					fill="none"
				/>
				<circle cx={ex} cy={ey} r={2} fill={fill} stroke="none" />
				<text
					x={ex + (cos >= 0 ? 1 : -1) * 5}
					y={ey + (sin >= 0 ? 1 : -1) + 2.5}
					textAnchor={textAnchor}
					fill="#fff"
				>
					{`${payload.name} (${(percent * 100).toFixed(2)}%)`}
				</text>
			</g>
		</Fade>
	);
};

export const GenderChart = memo(
	({ data }: { data: ChartData[] | undefined }) => {
		const sm = useMediaQuery("(max-width:600px)");
		const chartWidth = useChartWidth();

		const COLORS = ["#0088FE", "#B63E76", "#FFBB28", "#FF8042"];

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
				<ChartLabel label={"Gender"} />
				<Box
					sx={{
						display: "flex",
						flexDirection: "column",
						justifyContent: "center",
						alignItems: "center",
						minHeight: "350px",
						flex: "1 0 auto",
						width: chartWidth,
					}}
				>
					{data && data.length > 0 ? (
						<ResponsiveContainer width={chartWidth} height={350}>
							<PieChart width={chartWidth} height={350}>
								<Pie
									data={data}
									cx="50%"
									cy="50%"
									width={chartWidth}
									height={350}
									startAngle={90}
									endAngle={-450}
									innerRadius={sm ? 35 : 55}
									outerRadius={sm ? 55 : 90}
									stroke="none"
									fill="#8884d8"
									nameKey="name"
									dataKey="amount"
									label={CustomLabel}
								>
									{data.map((entry, index) => (
										<Cell
											key={`cell-${entry.name}-${index}`}
											fill={COLORS[index % COLORS.length]}
										/>
									))}
								</Pie>
								<Tooltip
									wrapperStyle={{ zIndex: 9999 }}
									content={<GenderTooltip />}
								/>
							</PieChart>
						</ResponsiveContainer>
					) : data && data.length === 0 ? (
						<Typography variant="overline" color="textSecondary">
							No data found
						</Typography>
					) : (
						<CircularProgress size={100} thickness={10} />
					)}
				</Box>
			</Paper>
		);
	},
);
