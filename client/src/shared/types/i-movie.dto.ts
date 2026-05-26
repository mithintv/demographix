import { Cast } from "./Cast";

export interface IMovieDto {
  id: string | null;
  title: string | null;
  genres: string[];
  overview: string;
  runtime: number;
  poster_path: string;
  release_date: string | Date;
  budget: string;
  revenue: string | null;
  cast: Cast[];
}
