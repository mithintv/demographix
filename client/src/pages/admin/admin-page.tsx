import { Link as RouterLink } from "react-router-dom";

import {
  Box,
  Card,
  CardActionArea,
  CardContent,
  Container,
  Typography,
} from "@mui/material";
import { Film, Trophy, Users, type LucideIcon } from "lucide-react";

import { AdminHeader } from "./admin-header";
import {
  castMemberDescription,
  dashboardDescription,
  movieDescription,
  nominationDescription,
} from "./constants";

const sections: {
  label: string;
  description: string;
  icon: LucideIcon;
  to: string;
}[] = [
  {
    label: "Movies",
    description: movieDescription,
    icon: Film,
    to: "/admin/movies",
  },
  {
    label: "Cast Members",
    description: castMemberDescription,
    icon: Users,
    to: "/admin/cast",
  },
  {
    label: "Nominations",
    description: nominationDescription,
    icon: Trophy,
    to: "/admin/nominations",
  },
];

export const AdminPage = () => {
  return (
    <Box sx={{ minHeight: "100vh", bgcolor: "background.default", py: 4 }}>
      <Container maxWidth="lg">
        <AdminHeader
          subheader={dashboardDescription}
          crumbs={[{ label: "Dashboard" }]}
        />

        <Box sx={{ display: "flex", flexWrap: "wrap", gap: 2 }}>
          {sections.map((s) => (
            <Card key={s.to} sx={{ width: 220 }}>
              <CardActionArea
                component={RouterLink}
                to={s.to}
                sx={{ height: "100%" }}
              >
                <CardContent>
                  <s.icon />
                  <Typography variant="h6" color="primary" sx={{ mt: 1 }}>
                    {s.label}
                  </Typography>
                  <Typography variant="body2" color="text.secondary">
                    {s.description}
                  </Typography>
                </CardContent>
              </CardActionArea>
            </Card>
          ))}
        </Box>
      </Container>
    </Box>
  );
};
