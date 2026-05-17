import { IResultsMeta } from "./i-results-meta";

export interface IResultsResponse<T> {
	results: T[];
	meta: IResultsMeta;
}
