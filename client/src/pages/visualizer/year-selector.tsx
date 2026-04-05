import {
	FormControl,
	InputLabel,
	MenuItem,
	Select,
	SelectChangeEvent,
	useMediaQuery,
} from "@mui/material";

import "@/shared/utils/to-sentence-case";

export enum YearSelectorTypeEnum {
	Yearly = "yearly",
	Cumulative = "cumulative",
}

const typeLabel: { [key in YearSelectorTypeEnum]: string } = {
	[YearSelectorTypeEnum.Yearly]: "year",
	[YearSelectorTypeEnum.Cumulative]: "cumulative",
};

export const YearSelector = ({
	type,
	data,
	value,
	onChange,
}: {
	type: YearSelectorTypeEnum;
	data: YearDto[] | CumulativeYearDto[] | undefined;
	value: string;
	onChange: (e: SelectChangeEvent) => void;
}) => {
	const md = useMediaQuery("(max-width:960px)");
	if (type === YearSelectorTypeEnum.Cumulative) {
		data = [
			{ id: "last-3", name: "Last 3 Years" },
			{ id: "last-5", name: "Last 5 Years" },
			{ id: "last-10", name: "Last 10 Years" },
		];
	}
	return (
		<FormControl
			sx={{
				ml: md ? 1 : 0,
				my: md ? 1 : 0,
				width: "150px",
			}}
		>
			<InputLabel id={typeLabel[type]}>
				{typeLabel[type].toSentenceCase()}
			</InputLabel>
			<Select
				labelId={typeLabel[type]}
				id={typeLabel[type]}
				value={value}
				label={typeLabel[type].toSentenceCase()}
				onChange={onChange}
			>
				{data &&
					data.map((year) => {
						return (
							<MenuItem key={year.id} value={year.id}>
								{year.name}
							</MenuItem>
						);
					})}
			</Select>
		</FormControl>
	);
};
