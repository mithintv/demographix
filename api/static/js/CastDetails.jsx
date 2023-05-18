const CastDetails = React.memo((props) => {
  console.log("Rendering Cast Data: ", props.cast);

  return (
    <div>
      {props.cast.map((cast, index) => {
        let age = "Unknown";
        if (cast.birthday) {
          const birthday = new Date(cast.birthday).getFullYear();
          const currYear = new Date().getFullYear();
          age = currYear - birthday;
        }

        let imgPath = `https://www.themoviedb.org/t/p/w600_and_h900_bestv2${cast.profile_path}`;
        if (cast.profile_path == null) {
          imgPath =
            "https://th.bing.com/th/id/OIP.rjbP0DPYm_qmV_cG-S-DUAAAAA?pid=ImgDet&rs=1";
        }
        return (
          <div key={index}>
            <img style={{ borderRadius: "25px" }} src={imgPath} width={100} />
            <span>Name: {cast.name} </span>
            <span>Gender: {cast.gender} </span>
            <span>Age: {age} </span>
            <div>
              Race:
              {cast.race.map((race, j) => {
                return <span key={j}>{race}, </span>;
              })}
            </div>
            <div>
              Ethnicity:{" "}
              {cast.ethnicity.map((ethnicity, k) => {
                return <span key={k}>{ethnicity}, </span>;
              })}
            </div>
            <span>Country of Birth: {cast.country_of_birth} </span>
            <hr />
          </div>
        );
      })}
    </div>
  );
});
