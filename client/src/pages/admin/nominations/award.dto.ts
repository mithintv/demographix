import { EventDto } from "@/shared/types/event.dto";

export interface AwardDto {
	id: number;
	name: string;
	event: EventDto;
}
