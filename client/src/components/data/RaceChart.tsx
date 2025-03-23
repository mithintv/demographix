import {
	Box,
	CircularProgress,
	Paper,
	Typography,
	useMediaQuery,
	useTheme,
} from "@mui/material";
import * as d3 from "d3";
import { memo, useEffect } from "react";
import {
	Bar,
	BarChart,
	Cell,
	Label,
	ResponsiveContainer,
	Tooltip,
	XAxis,
	YAxis,
} from "recharts";
import { CustomizedTooltip } from "@/shared/types/Chart";
import {
	axisLineStyle,
	barChartLabelStyle,
	barChartLabelStyle2,
	tickStyle,
} from "@/shared/utils/theme";
import ChartLabel from "./ChartLabel";
import { ChartData } from "@/shared/types/ChartData";

const RaceTooltip = ({ active, payload }: CustomizedTooltip) => {
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

const formatYAxisLabel = (
	label: string
	// index: number
) => {
	if (label === "Hispanic/Latino") {
		return "HSPN";
	}
	if (label === "Middle Eastern/North African") {
		return "MENA";
	}
	if (label === "Native Hawaiian/Pacific Islander") {
		return "NHPI";
	}
	return label;
};

const CustomizedLabel = ({
	x,
	width,
	y,
	height,
	value,
	index,
	total,
}: {
	x: number;
	width: number;
	y: number;
	height: number;
	value: number;
	index: number;
	total: number;
}) => {
	if ((index % 2 === 0 && total > 10) || total < 10) {
		return (
			<g>
				<text
					x={x + 5 + width}
					y={total < 10 ? y + 4 + height / 2 : y + 3 + height / 2}
					style={total < 10 ? barChartLabelStyle : barChartLabelStyle2}
				>
					{value}
				</text>
			</g>
		);
	}
	return <></>;
};

const calculateInterval = (chartHeight: number, labelCount: number) => {
	// Customize the interval calculation based on your requirements
	const maxVisibleLabels = Math.floor(chartHeight / 25); // Assuming each label is 30px in height
	return Math.ceil(labelCount / maxVisibleLabels);
};

const RaceChart = memo(
	({
		data,
		title,
		colors,
	}: {
		data: ChartData[];
		title: string;
		colors: string[];
	}) => {
		const lg = useMediaQuery("(max-width:1200px)");
		const md = useMediaQuery("(max-width:960px)");
		const sm = useMediaQuery("(max-width:600px)");
		const xs = useMediaQuery("(max-width:425px)");
		const theme = useTheme();

		useEffect(() => {
			if (data.length > 10) {
				data = data.sort((a, b) => d3.descending(a.amount, b.amount));
			}
		}, [data]);

		return (
			<Paper
				elevation={2}
				sx={{
					p: 0,
					m: 2,
					mt: 1,
					display: "flex",
					flexDirection: "column",
					justifyContent: "space-between",
					backgroundColor: "background.default",
					flexGrow: 1,
				}}
			>
				<ChartLabel label={title} />

				<Box
					sx={{
						display: "flex",
						flexDirection: "column",
						justifyContent: "center",
						alignItems: "center",
						minHeight: "350px",
					}}
				>
					{data.length > 0 ? (
						<ResponsiveContainer
							width={
								(xs && 275) || (sm && 350) || (md && 550) || (lg && 900) || 550
							}
							height={350}
						>
							<BarChart
								layout="vertical"
								width={
									(xs && 275) ||
									(sm && 350) ||
									(md && 550) ||
									(lg && 900) ||
									550
								}
								height={350}
								data={data}
								margin={{
									top: 20,
									right: (sm && 20) || 50,
									left: (title === "race" && sm && 5) || (sm && 30) || 100,
									bottom: 30,
								}}
							>
								{/* <CartesianGrid strokeDasharray="3 3" /> */}
								<XAxis
									type="number"
									tickLine={axisLineStyle}
									axisLine={axisLineStyle}
									tick={tickStyle}
								>
									<Label
										fill={theme.palette.text.secondary}
										value={xs ? "# of Cast Members" : "Number of Cast Members"}
										offset={-10}
										position="insideBottom"
									/>
								</XAxis>
								<YAxis
									type="category"
									dataKey="name"
									tickLine={axisLineStyle}
									axisLine={axisLineStyle}
									tick={tickStyle}
									interval={
										data.length > 10 ? calculateInterval(300, data.length) : 0
									}
									tickFormatter={formatYAxisLabel}
								/>
								<Tooltip
									viewBox={{ x: 0, y: 0, width: 400, height: 400 }}
									content={<RaceTooltip />}
								/>
								<Bar
									animationDuration={1000} // Duration of the animation in milliseconds
									animationBegin={500}
									dataKey="amount"
									label={CustomizedLabel}
								>
									{data.map((entry, index) => {
										if (colors.length === 1) {
											return (
												<Cell
													key={`cell-${entry.name}-${index}`}
													fill={colors[0]}
												/>
											);
										}
										return <Cell key={`cell-${index}`} fill={colors[index]} />;
									})}
								</Bar>
							</BarChart>
						</ResponsiveContainer>
					) : (
						<CircularProgress size={100} thickness={10} />
					)}
				</Box>
			</Paper>
		);
	}
);

export default RaceChart;
