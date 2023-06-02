const CastCard = React.memo((props) => {
  const { cast } = props;
  console.log("Rendering Cast Data: ", cast);

  return (
    <Paper
      elevation={2}
      sx={{
        mb: 2,
        px: 1,
        py: 2,
        display: "flex",
        flexDirection: "row",
        overflowX: "auto",
      }}
    >
      {cast ? (
        cast.map((cast, index) => {
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
            <Card
              key={index}
              elevation={2}
              sx={{
                width: 125,
                mx: 1,
                backgroundColor: "#151036",
                flex: "0 0 auto",
              }}
            >
              <CardMedia
                sx={{ mb: 1 }}
                width={150}
                component="img"
                image={imgPath}
                alt={`Image of ${cast.name}`}
              />
              <Container disableGutters sx={{ px: 1, mb: 1 }}>
                <Typography variant="caption">{cast.name}</Typography>
                <br />
                <Typography variant="caption" color="textSecondary">
                  {cast.character}
                </Typography>
              </Container>
            </Card>
          );
        })
      ) : (
        <CircularProgress />
      )}
    </Paper>
  );
});
