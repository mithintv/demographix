export type Cast = {
  id: number;
  name: string;
  birthday: string | null;
  country_of_birth: string | null;
  race: string[];
  ethnicity: Ethnicity[];
  gender: string;
  profile_path: string;
  character: string;
  order: number;
};

export type Ethnicity = {
  name: string;
  sources: string[];
};

export type CastHistogramDto = {
  name: string;
  profile_path: string;
};
