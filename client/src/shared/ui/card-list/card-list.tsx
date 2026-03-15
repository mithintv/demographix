import {
	Accordion,
	AccordionSummary,
	IconButton,
	Typography,
} from "@mui/material";

import { CardListHeading } from "./card-list-heading";

export const CardList = <T,>({
	accordion,
	heading,
	cardList,
}: {
	accordion: boolean;
	heading: string;
	cardList: T[] | undefined;
}) => {
	const renderedList =
		cardList && cardList.length > 0 ? (
			<>{cardList}</>
		) : (
			<div className="flex flex-1 justify-center items-center h-[195.5px]">
				<Typography variant="overline" color="textSecondary">
					No data found
				</Typography>
			</div>
		);
	return (
		<>
			{accordion ? (
				<Accordion
					disableGutters
					sx={{
						width: "100%",
						overflowX: "hidden",
						mb: 2,
						mx: 2,
					}}
				>
					<AccordionSummary
						sx={{ borderBottom: "3px solid rgba(255, 255, 255, 0.05);" }}
						expandIcon={
							<IconButton
								size="large"
								edge="end"
								color="primary"
								aria-label="open drawer"
							>
								<span className="material-symbols-outlined">expand_more</span>
							</IconButton>
						}
						aria-controls="panel1a-content"
						id="panel1a-header"
					>
						<Typography
							sx={{
								width: "100%",
							}}
							variant="overline"
							color="primary"
						>
							{heading}
						</Typography>
					</AccordionSummary>
					<div className="px-4 pb-1">
						<div className="flex flex-row gap-4 py-2 mb-2 overflow-x-auto">
							{renderedList}
						</div>
					</div>
				</Accordion>
			) : (
				<div className="bg-purple-400 rounded-md mx-4">
					<CardListHeading heading={heading} />
					<div className="px-3">
						<div className="flex flex-row gap-4 pt-4 pb-2 mb-2 overflow-x-auto">
							{renderedList}
						</div>
					</div>
				</div>
			)}
		</>
	);
};
