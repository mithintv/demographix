import { Box, Typography } from "@mui/material";

export default function ChartLabel({ label }: { label: string }) {
  return (
    <Box
      sx={{
        display: "flex",
        flexDirection: "row",
        alignItems: "center",
        mt: 1,
        width: "100%",
      }}
    >
      <Box
        sx={{
          p: 0,
          m: 0,
          height: "1px",
          width: "100%",
          backgroundColor: "rgba(255, 255, 255, 0.1)",
          flex: "1 1 auto",
        }}
      ></Box>
      <Typography
        sx={{
          display: "inline",
          flex: "1 1 auto",
          whiteSpace: "nowrap",
          mx: 1,
        }}
        variant="overline"
        color="textSecondary"
      >
        {label}
      </Typography>
      <Box
        sx={{
          p: 0,
          m: 0,
          height: "1px",
          width: "100%",
          backgroundColor: "rgba(255, 255, 255, 0.1)",
          flex: "1 1 auto",
        }}
      ></Box>
    </Box>
  );
}
