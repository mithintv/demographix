const parseAges = (movieCast) => {
  const listAgeData = [];
  const filteredBdays = movieCast.filter((cast) => cast.birthday !== null);
  filteredBdays.forEach((cast) => {
    const birthday = new Date(cast.birthday).getFullYear();
    const currYear = new Date().getFullYear();
    const age = currYear - birthday;
    listAgeData.push({
      name: cast.name,
      amount: age,
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
  const listRaceData = [
    {
      name: "White",
      amount: 0
    },
    {
      name: "Black",
      amount: 0
    },
    {
      name: "Hispanic/Latino",
      amount: 0
    },
    {
      name: "Asian",
      amount: 0
    },
    {
      name: "Middle Eastern/North African",
      amount: 0
    },
    {
      name: "Native Hawaiian/Pacific Islander",
      amount: 0
    },
    {
      name: "Unknown",
      amount: 0
    },
  ];
  for (const race in raceData) {
    console.log(race);
    const update = listRaceData.find(obj => obj.name == race.toString());
    console.log(update);
    update.amount = raceData[race];
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
