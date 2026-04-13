import { NominationProjectionEnum } from "./nomination-projection.enum";

export const API_HOSTNAME = import.meta.env.PROD
	? import.meta.env.VITE_API_HOSTNAME
	: "/api";
export const getNominationsEndpoint = (
	projection?: NominationProjectionEnum,
	imdb_event_id?: string,
) => {
	const url = new URL(`${API_HOSTNAME}/nominations`, window.location.origin);
	if (projection) {
		url.searchParams.set("projection", projection);
	}
	if (imdb_event_id) {
		url.searchParams.set("imdb_event_id", imdb_event_id);
	}
	return url;
};
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
