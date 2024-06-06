export type Movie = {
    id: string | null;
    title: string | null;
    genres: string[],
    overview: string,
    runtime: string,
    poster_path: string;
    release_date: string | null;
    budget: string,
    revenue: string | null,
    cast: string[]
  };
