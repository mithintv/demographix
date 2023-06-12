const parseGenders = (movieCast) => {
  const listGenderData = [
    { name: 'Male', amount: 0 },
    { name: 'Female', amount: 0 },
    { name: 'Non-Binary', amount: 0 }
  ];
  const filtered = movieCast.filter((cast) => cast.gender !== 'Unknown');
  filtered.forEach((cast) => {
    const new_entry = {};
    const entry = listGenderData.find(entry => entry.name == cast.gender);
    if (!entry) {
      new_entry.name = cast.gender;
      new_entry.amount = 1;
      listGenderData.push(new_entry);
    } else {
      entry.amount += 1;
    }
  });
  const removeEmpty = listGenderData.filter(label => label.amount !== 0);
  return removeEmpty;
};


const parseAges = (movieCast, releaseDate) => {
  const listAgeData = [];
  const filteredBdays = movieCast.filter((cast) => cast.birthday !== null);
  filteredBdays.forEach((cast) => {
    const birthday = new Date(cast.birthday).getFullYear();
    if (releaseDate === null) {
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


const parseRace = (movieCast) => {
  if (movieCast.length === 0) return [];
  const raceData = {};
  const filtered = movieCast.filter((cast) => cast.race.length !== 0);
  filtered.forEach((cast) => {
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
  ];
  for (const race in raceData) {
    const update = listRaceData.find(obj => obj.name == race.toString());
    update.amount = raceData[race];
  }
  return listRaceData;
};


const parseEthnicity = (movieCast) => {
  if (movieCast.length === 0) return [];
  const ethnicityData = {};
  const filtered = movieCast.filter((cast) => cast.ethnicity.length !== 0);
  filtered.forEach((cast) => {
    cast.ethnicity.forEach((ethnicity) => {
      ;
      ethnicityData[ethnicity.name] = ethnicityData[ethnicity.name]
        ? (ethnicityData[ethnicity.name] += 1)
        : 1;
    });
  });
  const listEthnicityData = [];
  for (const ethnicity in ethnicityData) {

    listEthnicityData.push({
      name: ethnicity,
      amount: ethnicityData[ethnicity]
    });
  }
  return listEthnicityData;
};


const parseCountryOfBirth = (movieCast) => {
  const listCOBData = [];
  movieCast.forEach((cast) => {
    const new_entry = {};
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
      const entry = listCOBData.find(entry => entry.name == cast.country_of_birth);
      if (!entry) {
        new_entry.name = cast.country_of_birth;
        new_entry.amount = 1;
        listCOBData.push(new_entry);
      } else {
        entry.amount += 1;
      }
    }
  });
  return listCOBData;
};
