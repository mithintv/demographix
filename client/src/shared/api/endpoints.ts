import { NominationProjectionEnum } from "./nomination-projection.enum";

export const API_HOSTNAME = import.meta.env.PROD
  ? import.meta.env.VITE_API_HOSTNAME
  : "/api";

export const getNominationEndpoint = (
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

export const getMoviesEndpoint = (query: string, page?: number) => {
  const params = new URLSearchParams({
    query,
    ...(page ? { page: String(page) } : {}),
  });
  return `${API_HOSTNAME}/movies?${params}`;
};

export const getCastMemberEndpoint = (page: number, search: string) => {
  const params = new URLSearchParams({
    page: String(page),
    ...(search ? { search } : {}),
  });
  return `${API_HOSTNAME}/admin/cast?${params}`;
};

export const getCastMemberCheckEndpoint = (castMemberId: number) =>
  `${API_HOSTNAME}/admin/cast/${castMemberId}/check`;

export const getMovieCheckEndpoint = (movieId: number) =>
  `${API_HOSTNAME}/admin/movies/${movieId}/check`;

export const getDemographicEndpoint = (
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
