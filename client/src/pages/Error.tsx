import { Typography } from "@mui/material";
import { useRouteError } from "react-router-dom";

type RouterError = {
  data: string;
  error: string;
  status: number;
  statusText: string;
  message: string;
};

export default function Error() {
  const error = useRouteError() as RouterError;
  console.error(error.error);

  return (
    <div
      style={{
        display: "flex",
        flexDirection: "column",
        justifyContent: "center",
        height: "100vh",
      }}
    >
      <Typography color="rgba(255, 255, 255, 0.7)" align="center" variant="h4">
        Oops!
      </Typography>
      <Typography
        color="rgba(255, 255, 255, 0.7)"
        align="center"
        variant="subtitle2"
      >
        Sorry, an unexpected error has occurred.
      </Typography>
      <Typography
        color="rgba(255, 255, 255, 0.7)"
        align="center"
        variant="subtitle2"
      >
        {`${error.status} ${error.statusText}`}
      </Typography>
    </div>
  );
}
