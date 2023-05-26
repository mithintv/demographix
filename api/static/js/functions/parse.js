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

const parseEthnicity = (movieCast) => {
  const listRaceData = {};
  movieCast.forEach((cast) => {
    if (cast.race.length === 0) {
      listRaceData["Unknown"] = listRaceData["Unknown"]
        ? (listRaceData["Unknown"] += 1)
        : 1;
    }
    cast.race.forEach((race) => {
      listRaceData[race] = listRaceData[race]
        ? (listRaceData[race] += 1)
        : 1;
    });
  });
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
