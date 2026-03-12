import {
	Box,
	Card,
	CardActionArea,
	CardContent,
	Container,
	Typography,
} from "@mui/material";
import { Link as RouterLink } from "react-router-dom";

import { AdminHeader } from "./admin-header";
import {
	castMemberDescription,
	dashboardDescription,
	nominationDescription,
} from "./constants";

const sections = [
	{
		label: "Cast Members",
		description: castMemberDescription,
		icon: "people",
		to: "/admin/cast",
	},
	{
		label: "Nominations",
		description: nominationDescription,
		icon: "trophy",
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
									<span
										className="material-symbols-outlined"
										style={{ fontSize: 36 }}
									>
										{s.icon}
									</span>
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
