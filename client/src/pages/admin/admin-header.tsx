import { Box, Breadcrumbs, Link, Typography } from "@mui/material";
import { Link as RouterLink } from "react-router-dom";

interface Crumb {
	label: string;
	to?: string;
}

interface AdminHeaderProps {
	subheader: string;
	crumbs: Crumb[];
	component?: JSX.Element;
}

export const AdminHeader = ({
	subheader,
	crumbs,
	component,
}: AdminHeaderProps) => {
	const last = crumbs[crumbs.length - 1];
	const parents = crumbs.slice(0, -1);

	return (
		<Box
			sx={{
				py: 2,
				display: "flex",
				flexDirection: "column",
				alignItems: "left",
			}}
		>
			<Box
				sx={{
					mb: 0.5,
					pb: 1,
					display: "flex",
					alignItems: "center",
				}}
			>
				<Breadcrumbs sx={{ flexGrow: 1 }}>
					{parents.map((crumb) => (
						<Link
							key={crumb.label}
							component={RouterLink}
							to={crumb.to!}
							underline="hover"
							color="text.secondary"
							variant="caption"
						>
							{crumb.label}
						</Link>
					))}
					<Typography variant="caption" color="text.disabled">
						{last.label}
					</Typography>
				</Breadcrumbs>
			</Box>
			<Box display="flex" flexDirection="row" justifyContent="space-between">
				<Box sx={{ display: "flex", flexDirection: "column" }}>
					<Typography variant="h4" color="primary" sx={{ display: "inline" }}>
						{last.label}
					</Typography>
					<Typography variant="subtitle2" color="text.secondary">
						{subheader}
					</Typography>
				</Box>
				{component}
			</Box>
		</Box>
	);
};
