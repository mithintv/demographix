const {
	BrowserRouter,
	Route,
	Link: RouterLink,
	useHistory,
	useLocation,
} = ReactRouterDOM;
const {
	AppBar,
	Box,
	Button,
	Card,
	CardContent,
	CardMedia,
	Chip,
	CircularProgress,
	Collapse,
	colors,
	createTheme,
	CssBaseline,
	Container,
	Dialog,
	DialogActions,
	DialogContent,
	DialogTitle,
	Divider,
	Drawer,
	Fade,
	FormControl,
	Grid,
	GlobalStyles,
	InputAdornment,
	InputLabel,
	Link,
	MenuItem,
	Modal,
	IconButton,
	InputBase,
	Paper,
	Select,
	Stack,
	Tab,
	Tabs,
	TextField,
	ThemeProvider,
	Toolbar,
	Typography,
	useMediaQuery,
	useScrollTrigger,
	useTheme,
} = MaterialUI;

const {
	BarChart,
	Bar,
	Cell,
	XAxis,
	YAxis,
	CartesianGrid,
	Label,
	LabelList,
	PieChart,
	Pie,
	Sector,
	Tooltip,
	Legend,
	ResponsiveContainer,
	Treemap,
} = window.Recharts;

// Create a theme instance.
const darkTheme = createTheme({
	palette: {
		mode: "dark",
		primary: {
			main: "#fdbd25",
		},
		secondary: {
			main: "#e64788",
		},
		background: {
			default: "#151036",
			paper: "#2c274f",
		},
		text: {
			primary: "#fefffe",
			secondary: "rgba(255, 255, 255, 0.7)",
		},
		warning: {
			main: "#ed6c02",
		},
		success: {
			main: "#2e7d32",
		},
	},
	typography: {
		h1: {
			fontWeight: 700,
			"@media (max-width:960px)": {
				fontSize: "4rem", // for small screens and above
			},
			"@media (max-width:600px)": {
				fontSize: "3.5rem", // for small screens and above
			},
			"@media (max-width:425px)": {
				fontSize: "3rem", // for small screens and above
			},
		},
		h2: {
			fontWeight: 500,
		},
		h3: {
			fontWeight: 500,
		},
		h5: {
			fontWeight: 500,
			"@media (max-width:960px)": {
				fontSize: "1rem", // for small screens and above
			},
			"@media (max-width:600px)": {
				fontSize: "0.925rem", // for small screens and above
			},
			"@media (max-width:425px)": {
				fontSize: "0.85rem", // for small screens and above
			},
		},
		subtitle2: {
			fontWeight: 400,
		},
		overline: {
			fontWeight: 500,
			"@media (max-width:960px)": {
				fontSize: "0.7rem", // for small screens and above
			},
			"@media (max-width:600px)": {
				fontSize: "0.65rem", // for small screens and above
			},
			"@media (max-width:425px)": {
				fontSize: "0.50rem", // for small screens and above
			},
			"@media (max-width:375px)": {
				fontSize: "0.45rem", // for small screens and above
			},
		},
		overline2: {
			fontSize: "2rem",
			fontWeight: 700,
			textTransform: "uppercase",
			"@media (max-width:960px)": {
				fontSize: "1.75rem", // for small screens and above
			},
			"@media (max-width:600px)": {
				fontSize: "1.50rem", // for small screens and above
			},
			"@media (max-width:425px)": {
				fontSize: "1.45rem", // for small screens and above
			},
		},
	},
});

const backgroundGradient =
	"radial-gradient(ellipse at center, #151036 50%, #100b2a 100%)";

const axisLineStyle = {
	stroke: darkTheme.palette.text.secondary,
};
const tickStyle = {
	fill: darkTheme.palette.text.secondary,
	y: -10,
};
const cursorColor = {
	fill: darkTheme.palette.text.disabled,
};
const histogramLabelStyle = {
	fill: darkTheme.palette.text.secondary,
	position: "top",
};
const barChartLabelStyle = {
	fill: darkTheme.palette.text.secondary,
	position: "right",
	fontSize: "0.75em",
};
const barChartLabelStyle2 = {
	fill: darkTheme.palette.text.secondary,
	position: "right",
	fontSize: "0",
};

const globalStyles = (
	<GlobalStyles
		styles={{
			"*::-webkit-scrollbar-track": {
				padding: 1,
				backgroundColor: "#2c274f",
			},
			"*::-webkit-scrollbar": {
				m: 2,
				height: "0.4rem",
				width: "0.5em",
			},
			"*::-webkit-scrollbar-thumb": {
				backgroundColor: "#66689f",
				borderRadius: "2.5px",
			},
		}}
	/>
);

const App = () => {
	return (
		<BrowserRouter>
			{globalStyles}
			<Route path="/" component={LandingPage} exact></Route>
			<Route
				path="/noms/:awardParam/:rangeParam/:yearParam"
				component={NomMovies}
				exact
			></Route>
			<Route path="/movies/:id" component={MovieDetails} exact></Route>
		</BrowserRouter>
	);
};

ReactDOM.render(
	<ThemeProvider theme={darkTheme}>
		<CssBaseline />
		<App />
	</ThemeProvider>,
	document.getElementById("app")
);
