import {
	AppBar,
	Box,
	Button,
	Drawer,
	IconButton,
	Link,
	Typography,
	useMediaQuery,
	useTheme,
} from "@mui/material";
import { useEffect, useState } from "react";
import { Link as RouterLink, useLocation, useNavigate } from "react-router-dom";

import { SearchModal } from "../ui/search/search-modal";

export const NavBar = () => {
	const location = useLocation();
	const navigate = useNavigate();
	const md = useMediaQuery("(max-width:600px)");
	const theme = useTheme();
	const [open, setOpen] = useState(false);
	const [navTransparent, setNavTransparent] = useState(true);

	const handleScroll = () => {
		if (window.scrollY > 32) {
			setNavTransparent(false);
		} else {
			setNavTransparent(true);
		}
	};

	useEffect(() => {
		window.addEventListener("scroll", handleScroll);
		return () => {
			window.removeEventListener("scroll", handleScroll);
		};
	}, []);

	const handleDrawer = () => {
		setOpen(true);
	};

	return (
		<Box>
			{location.pathname === "/" ? (
				<></>
			) : (
				<AppBar
					sx={{
						backgroundColor: navTransparent
							? "transparent"
							: theme.palette.background.default,
						boxShadow: navTransparent ? "none" : "2px",
						backgroundImage: "none",
						transition: "background-color 500ms",
					}}
					position="fixed"
				>
					<div className="flex flex-row justify-between items-center py-4 px-5">
						<Link sx={{ textDecoration: "none" }} component={RouterLink} to="/">
							<Typography
								component="div"
								variant="h6"
								sx={{ pl: 0.5, flexGrow: 1 }}
							>
								Demographix
							</Typography>
						</Link>
						{md ? (
							<Box
								sx={{
									display: "flex",
									flexDiection: "row",
									alignItems: "center",
									height: 58,
								}}
							>
								<Drawer
									anchor={"top"}
									open={open}
									onClose={() => setOpen(false)}
								>
									{!location.pathname.startsWith("/visualizer") && (
										<Button
											sx={{ mt: 1 }}
											size="large"
											onClick={() =>
												navigate(
													`/visualizer?event=academy-awards&range=yearly&year=${new Date().getFullYear()}`,
												)
											}
											startIcon={
												<span className="material-symbols-outlined">
													bar_chart
												</span>
											}
										>
											Cumulative Data
										</Button>
									)}
									<SearchModal nav={true} />
								</Drawer>
								<IconButton
									onClick={handleDrawer}
									size="large"
									edge="end"
									color="primary"
									aria-label="open drawer"
								>
									<span className="material-symbols-outlined">menu</span>
								</IconButton>
							</Box>
						) : (
							<Box
								sx={{
									display: "flex",
									flexDiection: "row",
									alignItems: "center",
									gap: 2,
								}}
							>
								{!location.pathname.startsWith("/visualizer") && (
									<Button
										onClick={() =>
											navigate(
												`/visualizer?event=academy-awards&range=yearly&year=${new Date().getFullYear()}`,
											)
										}
										startIcon={
											<span className="material-symbols-outlined">
												bar_chart
											</span>
										}
									>
										Cumulative Data
									</Button>
								)}
								<SearchModal nav={true} />
							</Box>
						)}
					</div>
				</AppBar>
			)}
		</Box>
	);
};
