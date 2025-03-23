import { Movie } from "@/shared/types/Movie";
import { getYear } from "date-fns";
import { Link } from "react-router-dom";

export const MovieCard = ({ movie }: { movie: Movie }) => {
	return (
		<div className="grow">
			<Link to={`/movies/${movie.id}`}>
				<img
					width={125}
					className="max-w-fit object-contain shadow-xl"
					src={`https://www.themoviedb.org/t/p/w600_and_h900_bestv2${movie.poster_path}`}
					alt={`Poster image of ${movie.title} (${getYear(
						movie.release_date
					)})`}
				/>
			</Link>
		</div>
	);
};
