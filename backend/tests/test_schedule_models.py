from schedule.models import Event


def test_event_parses_teacher_string_list():
    event = Event(
        start_time="09:00",
        end_time="10:30",
        number_pair=1,
        discipline="Math",
        group_type=None,
        address=None,
        classroom=None,
        comment=None,
        place=None,
        url_online=None,
        group="GROUP-1",
        code="MATH",
        color=None,
        teachers=["Иванов Иван Иванович, Петров Петр"],
    )

    assert len(event.teachers) == 2
    assert event.teachers[0].last_name == "Иванов"
    assert event.teachers[0].first_name == "Иван"
    assert event.teachers[0].middle_name == "Иванович"
    assert event.teachers[1].last_name == "Петров"
    assert event.teachers[1].first_name == "Петр"


def test_event_keeps_teacher_dicts():
    event = Event(
        start_time="09:00",
        end_time="10:30",
        number_pair=1,
        discipline="Math",
        group_type=None,
        address=None,
        classroom=None,
        comment=None,
        place=None,
        url_online=None,
        group="GROUP-1",
        code="MATH",
        color=None,
        teachers=[{"first_name": "Иван", "last_name": "Иванов", "middle_name": None, "fio": "Иванов Иван"}],
    )

    assert len(event.teachers) == 1
    assert event.teachers[0].fio == "Иванов Иван"
