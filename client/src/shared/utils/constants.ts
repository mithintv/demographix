export const API_HOSTNAME = import.meta.env.PROD
	? import.meta.env.VITE_API_HOSTNAME
	: "/api";

export const getDemographicsEndpoint = (
	event: string | undefined,
	range: string | undefined,
	year: string | undefined,
) => {
	if (!event) {
		throw new Error(`event: ${event} is invalid`);
	}
	if (!range) {
		throw new Error(`range: ${range} is invalid`);
	}
	if (!year) {
		throw new Error(`year: ${year} is invalid`);
	}
	if (
		range === "yearly" &&
		year &&
		Number.isSafeInteger(Number.parseInt(year)) === false
	) {
		throw new Error(`year: ${year} is invalid when range === 'yearly'`);
	}
	return `${API_HOSTNAME}/demographics?event=${event}&range=${range}&year=${year}`;
};
