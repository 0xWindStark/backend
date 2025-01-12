pub enum Direction {
    Up,
    UpLeft,
    Left,
    DownLeft,
    Down,
    DownRight,
    Right,
    UpRight
}

impl DirectionIntoFelt252 of Into<Direction, felt252> {
    fn into(self: Direction) -> felt252 {
        match self {
            Direction::Up => 1,
            Direction::UpLeft => 2,
            Direction::Left => 3,
            Direction::DownLeft => 4,
            Direction::Down => 5,
            Direction::DownRight => 6,
            Direction::Right => 7,
            Direction::UpRight => 8
        }
    }
}

impl OptionDirectionIntoFelt252 of Into<Option<Direction>, felt252> {
    fn into(self: Option<Direction>) -> felt252 {
        match self {
            Option::None => 0,
            Option::Some(d) => d.into(),
        }
    }
}