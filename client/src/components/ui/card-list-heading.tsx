export const CardListHeading = ({ heading }: { heading: string }) => {
	return (
		<div className="py-1 pb-1.5 grow border-solid border-b-3 border-purple-300">
			<span className="pl-4 text-gold-500 uppercase text-xxs font-medium tracking-[0.08333em]">
				{heading}
			</span>
		</div>
	);
};
