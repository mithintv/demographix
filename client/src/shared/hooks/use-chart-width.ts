import { useMediaQuery } from "@mui/material";

export const useChartWidth = () => {
	const lg = useMediaQuery("(max-width:1200px)");
	const md = useMediaQuery("(max-width:960px)");
	const sm = useMediaQuery("(max-width:600px)");
	const xs = useMediaQuery("(max-width:425px)");

	return (xs && 275) || (sm && 350) || (md && 515) || (lg && 875) || 515;
};
