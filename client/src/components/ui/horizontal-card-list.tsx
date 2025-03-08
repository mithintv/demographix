import { CardListHeading } from "./card-list-heading";

export const HorizontalCardList = <T,>({
	cardList,
}: {
	cardList: T[] | undefined;
}) => {
	return (
		<div className="bg-purple-400 rounded-md">
			<CardListHeading heading="Nominations" />
			<div className="px-3.5">
				<div className="flex flex-row gap-4 pt-4 pb-4 mb-2 overflow-x-scroll">
					<>{cardList}</>
				</div>
			</div>
		</div>
	);
};
