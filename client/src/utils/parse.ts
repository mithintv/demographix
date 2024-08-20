import { Cast, Ethnicity } from "../types/Cast";

export type GenderData = {
  name: string;
  amount: number;
};

export type AgeData = {
  name: string;
  profile_path: string;
  amount: number;
};

export type ChartData = {
  name: string;
  amount: number;
};

export const parseGenders = (movieCast: Cast[]) => {
  const listGenderData: GenderData[] = [
    { name: "Male", amount: 0 },
    { name: "Female", amount: 0 },
    { name: "Non-Binary", amount: 0 },
  ];
  const filtered = movieCast.filter((cast) => cast.gender !== "Unknown");
  filtered.forEach((cast) => {
    const new_entry: GenderData = {
      name: "",
      amount: 0,
    };
    const entry = listGenderData.find((entry) => entry.name == cast.gender);
    if (!entry) {
      new_entry.name = cast.gender;
      new_entry.amount = 1;
      listGenderData.push(new_entry);
    } else {
      entry.amount += 1;
    }
  });
  const removeEmpty = listGenderData.filter((label) => label.amount !== 0);
  return removeEmpty;
};

export const parseAges = (movieCast: Cast[], releaseDate?: number) => {
  const listAgeData: AgeData[] = [];
  const filteredBdays = movieCast.filter((cast) => cast.birthday !== null);
  filteredBdays.forEach((cast) => {
    const birthday = new Date(cast.birthday!).getFullYear();
    if (releaseDate === undefined) {
      releaseDate = new Date().getFullYear();
    }
    const age = releaseDate - birthday;
    listAgeData.push({
      name: cast.name,
      profile_path: cast.profile_path,
      amount: age,
    });
  });

  return listAgeData;
};

export const parseRace = (movieCast: Cast[]) => {
  if (movieCast.length === 0) return [];
  const raceData: { [key: string]: number } = {};
  const filtered = movieCast.filter((cast) => cast.race.length !== 0);
  filtered.forEach((cast) => {
    cast.race.forEach((race) => {
      raceData[race] = raceData[race] ? (raceData[race] += 1) : 1;
    });
  });
  const listRaceData: ChartData[] = [
    {
      name: "White",
      amount: 0,
    },
    {
      name: "Black",
      amount: 0,
    },
    {
      name: "Hispanic/Latino",
      amount: 0,
    },
    {
      name: "Asian",
      amount: 0,
    },
    {
      name: "Middle Eastern/North African",
      amount: 0,
    },
    {
      name: "Native Hawaiian/Pacific Islander",
      amount: 0,
    },
  ];
  let counter = 0;
  for (const race in raceData) {
    const update = listRaceData.find((obj) => obj.name == race.toString());
    update!.amount = raceData[race];
    counter++;
  }
  return counter > 0 ? listRaceData : [];
};

export const parseEthnicity = (movieCast: Cast[]) => {
  if (movieCast.length === 0) return [];
  const ethnicityData: { [key: string]: number } = {};
  const filtered = movieCast.filter((cast) => cast.ethnicity.length !== 0);
  filtered.forEach((cast) => {
    cast.ethnicity.forEach((ethnicity: Ethnicity) => {
      ethnicityData[ethnicity.name] = ethnicityData[ethnicity.name]
        ? (ethnicityData[ethnicity.name] += 1)
        : 1;
    });
  });
  const listEthnicityData: ChartData[] = [];
  for (const ethnicity in ethnicityData) {
    listEthnicityData.push({
      name: ethnicity,
      amount: ethnicityData[ethnicity],
    });
  }
  return listEthnicityData.sort((a, b) => b.amount - a.amount);
};

export const parseCountryOfBirth = (movieCast: Cast[]) => {
  const listCOBData: ChartData[] = [];
  movieCast.forEach((cast) => {
    if (cast.country_of_birth !== null) {
      //   const entry = listCOBData.find(entry => entry.name == 'Unknown');
      //   if (!entry) {
      //     new_entry.name = 'Unknown';
      //     new_entry.amount = 1;
      //     listCOBData.push(new_entry);
      //   } else {
      //     entry.amount += 1;
      //   }
      // } else {
      const entry = listCOBData.find((e) => e.name == cast.country_of_birth);
      if (!entry) {
        const new_entry: ChartData = {
          name: cast.country_of_birth,
          amount: 1,
        };
        listCOBData.push(new_entry);
      } else {
        entry.amount += 1;
      }
    }
  });
  return listCOBData;
};
