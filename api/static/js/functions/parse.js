const parseAges = (movieCast) => {
  const listAgeData = [];
  const filteredBdays = movieCast.filter((cast) => cast.birthday !== null);
  filteredBdays.forEach((cast) => {
    const birthday = new Date(cast.birthday).getFullYear();
    const currYear = new Date().getFullYear();
    const age = currYear - birthday;
    listAgeData.push({
      name: cast.name,
      age,
    });
  });

  return listAgeData;
};

const parseRace = (movieCast) => {
  const raceData = {};
  movieCast.forEach((cast) => {
    if (cast.race.length === 0) {
      raceData["Unknown"] = raceData["Unknown"]
        ? (raceData["Unknown"] += 1)
        : 1;
    }
    cast.race.forEach((race) => {
      raceData[race] = raceData[race]
        ? (raceData[race] += 1)
        : 1;
    });
  });
  const listRaceData = [];
  for (const race in raceData) {
    listRaceData.push({
      name: race,
      amount: raceData[race]
    });
  }
  return listRaceData;
};


const parseCountryOfBirth = (movieCast) => {
  const listCOBData = {};
  movieCast.forEach((cast) => {
    if (cast.country_of_birth === null) {
      listCOBData["Unknown"] = listCOBData["Unknown"]
        ? (listCOBData["Unknown"] += 1)
        : 1;
    } else {
      listCOBData[cast.country_of_birth] = listCOBData[cast.country_of_birth]
        ? (listCOBData[cast.country_of_birth] += 1)
        : 1;
    }
  });
  return listCOBData;
};
