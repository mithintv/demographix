from dataclasses import dataclass

from api.data.events.event_model import Event


@dataclass
class EventDto:
    id: int
    name: str
    imdb_event_id: str

    @classmethod
    def from_model(cls, event: Event):
        return cls(id=event.id, name=event.name, imdb_event_id=event.imdb_event_id)
