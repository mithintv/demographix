import { CardListHeading } from "./card-list-heading";

export const CardList = <T,>({ cardList }: { cardList: T[] | undefined }) => {
	return (
		<div className="bg-purple-400 rounded-md">
			<CardListHeading heading="Nominations" />
			<div className="px-3">
				<div className="flex flex-row gap-4 pt-4 pb-2 mb-2 overflow-x-auto">
					<>{cardList}</>
				</div>
			</div>
		</div>
	);
};
