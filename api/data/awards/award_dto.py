from dataclasses import dataclass

from api.data.awards.award_model import Award
from api.data.events.event_dto import EventDto


@dataclass
class AwardDto:
    id: int
    name: str
    event: EventDto

    @classmethod
    def from_model(cls, award: Award):
        return cls(id=award.id, name=award.name, event=EventDto.from_model(award.event))
