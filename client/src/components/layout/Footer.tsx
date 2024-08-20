import { Box, Link, Typography } from "@mui/material";

export default function Footer() {
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
          <i className="fa-solid fa-code footer-icons" />
        </Link>
        <Link href="https://linkedin.com/in/mithintv">
          <i className="fa-brands fa-linkedin footer-icons"></i>
        </Link>
        <Link href="https://github.com/mithintv">
          <i className="fa-brands fa-github footer-icons"></i>
        </Link>
      </Box>
    </Box>
  );
}
