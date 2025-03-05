import { Cast } from "../types/Cast";
import { ChartData } from "../types/ChartData";

/**
 * Parses gender data from a list of cast members.
 * @param {Cast[]} movieCast - Array of Cast.
 * @returns {ChartData[]} Array of ChartData.
 */
export const parseGenders = (movieCast: Cast[]): ChartData[] => {
  return movieCast.reduce((acc, cast) => {
    const el = acc.find((x) => x.name == cast.gender);
    if (el) {
      el.amount += 1;
    } else {
      acc.push({
        name: cast.gender,
        amount: 1,
      });
    }
    return acc;
  }, [] as ChartData[]);
};

/**
 * Parses age data from a list of cast members.
 * @param {Cast[]} movieCast - Array of Cast.
 * @returns {ChartData[]} Array of ChartData.
 */
export const parseAges = (
  movieCast: Cast[],
  releaseDate?: number
): ChartData[] => {
  if (movieCast.length === 0) return [];
  return movieCast
    .filter((cast) => cast.birthday !== null)
    .map((cast) => {
      const birthday = new Date(cast.birthday!).getFullYear();
      if (releaseDate === undefined) {
        releaseDate = new Date().getFullYear();
      }
      return {
        name: cast.name,
        profile_path: cast.profile_path,
        amount: releaseDate - birthday,
      };
    });
};

/**
 * Parses race data from a list of cast members.
 * @param {Cast[]} movieCast - Array of Cast.
 * @returns {ChartData[]} Array of ChartData.
 */
export const parseRace = (movieCast: Cast[]): ChartData[] => {
  if (movieCast.length === 0) return [];
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

  return movieCast
    .filter((cast) => cast.race.length !== 0)
    .flatMap((cast) => [...cast.race])
    .reduce((acc, race) => {
      const el = acc.find((x) => x.name === race);
      if (el) {
        el.amount += 1;
      }

      return listRaceData;
    }, listRaceData);
};

/**
 * Parses ethnicity data from a list of cast members.
 * @param {Cast[]} movieCast - Array of Cast.
 * @returns {ChartData[]} Array of ChartData.
 */
export const parseEthnicity = (movieCast: Cast[]): ChartData[] => {
  if (movieCast.length === 0) return [];

  return movieCast
    .flatMap((cast) => cast.ethnicity)
    .reduce((acc, ethnicity) => {
      const el = acc.find((x) => x.name == ethnicity.name);

      if (el) {
        el.amount += 1;
      } else {
        acc.push({
          name: ethnicity.name,
          amount: 1,
        });
      }
      return acc;
    }, [] as ChartData[])
    .sort((a, b) => b.amount - a.amount);
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
