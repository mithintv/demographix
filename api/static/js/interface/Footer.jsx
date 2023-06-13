const Footer = () => {
  return (
    <Box
      sx={{
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        mt: 5,
        pb: 5,
        backgroundColor: "transparent",
      }}
    >
      <Typography align="center" variant="overline" color="textSecondary">
        Created by Mithin Thomas
      </Typography>
      <Box
        sx={{
          display: "flex",
          flexDirection: "row",
          backgroundColor: "transparent",
        }}
      >
        <Link href="https://mithin.com">
          <i
            className="fa-solid fa-code"
            style={{
              color: "rgba(255, 255, 255, 0.7)",
              "&:hover": {
                color: "#fff",
              },
            }}
          ></i>
        </Link>
        <Link href="https://linkedin.com/in/mithintv">
          <i
            className="fa-brands fa-linkedin"
            style={{ color: "rgba(255, 255, 255, 0.7)" }}
          ></i>
        </Link>
        <Link href="https://github.com/mithintv">
          <i
            className="fa-brands fa-github"
            style={{ color: "rgba(255, 255, 255, 0.7)" }}
          ></i>
        </Link>
      </Box>
    </Box>
  );
};
