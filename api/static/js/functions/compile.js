const compileAges = (movies) => {
  const castIds = {};
  let allMoviesCast = [];
  movies.forEach(movie => {
    allMoviesCast.push(...movie.cast);
  });

  allMoviesCast.forEach(cast => {
    castIds[cast.id] ? castIds[cast.id] += 1 : castIds[cast.id] = 1;
  });

  if (allMoviesCast.length !== Object.keys(castIds).length) {
    for (let id in castIds) {
      if (castIds[id] > 1) {
        const indexToRemove = allMoviesCast.findIndex(cast => cast.id != id);
        allMoviesCast.splice(indexToRemove, 1);
      }
    }
  }

  return allMoviesCast;
};
