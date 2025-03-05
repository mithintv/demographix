// const {
// 	BrowserRouter,
// 	Route,
// 	Link: RouterLink,
// 	useHistory,
// 	useLocation,
// } = ReactRouterDOM;
// const {
// 	Accordion,
// 	AccordionSummary,
// 	AccordionDetails,
// 	AppBar,
// 	Box,
// 	Button,
// 	Card,
// 	CardContent,
// 	CardMedia,
// 	Chip,
// 	CircularProgress,
// 	Collapse,
// 	colors,
// 	createTheme,
// 	CssBaseline,
// 	Container,
// 	Dialog,
// 	DialogActions,
// 	DialogContent,
// 	DialogTitle,
// 	Divider,
// 	Drawer,
// 	Fade,
// 	FormControl,
// 	Grid,
// 	GlobalStyles,
// 	InputAdornment,
// 	InputLabel,
// 	Link,
// 	MenuItem,
// 	Modal,
// 	IconButton,
// 	InputBase,
// 	Paper,
// 	Select,
// 	Stack,
// 	Tab,
// 	Tabs,
// 	TextField,
// 	ThemeProvider,
// 	Toolbar,
// 	Typography,
// 	useMediaQuery,
// 	useScrollTrigger,
// 	useTheme,
// } = MaterialUI;

import { Outlet } from "react-router-dom";

// const {
// 	BarChart,
// 	Bar,
// 	Cell,
// 	XAxis,
// 	YAxis,
// 	CartesianGrid,
// 	Label,
// 	LabelList,
// 	PieChart,
// 	Pie,
// 	Sector,
// 	Tooltip,
// 	Legend,
// 	ResponsiveContainer,
// 	Treemap,
// } = window.Recharts;


// const globalStyles = (
// 	<GlobalStyles
// 		styles={{
// 			"*::-webkit-scrollbar-track": {
// 				padding: 1,
// 				backgroundColor: "#2c274f",
// 			},
// 			"*::-webkit-scrollbar": {
// 				m: 2,
// 				height: "0.4rem",
// 				width: "0.5em",
// 			},
// 			"*::-webkit-scrollbar-thumb": {
// 				backgroundColor: "#66689f",
// 				borderRadius: "2.5px",
// 			},
// 		}}
// 	/>
// );

// const App = () => {
// 	return (
// 		<BrowserRouter>
// 			{globalStyles}
// 			<Route path="/" component={LandingPage} exact></Route>
// 			<Route
// 				path="/noms/:awardParam/:rangeParam/:yearParam"
// 				component={NomMovies}
// 				exact
// 			></Route>
// 			<Route path="/movies/:id" component={MovieDetails} exact></Route>
// 		</BrowserRouter>
// 	);
// };

function App() {
  return (
    <>
      <Outlet />
    </>
  );
}

export default App;
