const compileRuntime = (minutes) => {
  let hours = Math.floor(minutes / 60);
  let remainingMinutes = minutes % 60;
  return `${hours}h ${remainingMinutes}m`;
};

const compileCast = (movies) => {
  let allMoviesCast = [];
  movies.forEach(movie => {
    allMoviesCast.push(...movie.cast);
  });
  return allMoviesCast;
};
