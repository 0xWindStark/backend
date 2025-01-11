use starknet::{ContractAddress};

#[derive(Copy, Drop, Serde, IntrospectPacked, Debug)]
pub struct Vec2 {
    pub x: u32,
    pub y: u32
}

#[derive(Serde, Copy, Drop, Introspect, PartialEq, Debug)]
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

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct PlayerPosition {
    #[key]
    pub player: ContractAddress,
    pub vec: Vec2,
}

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct PlayerState {
    #[key]
    pub player: ContractAddress,
    pub state: bool,
}

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct Enemy {
    #[key]
    pub player: ContractAddress,
    pub enemy_count: u8,
    pub enemies: Array<Enemy>
}

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct EnemyPosition {
    #[key]
    pub player: ContractAddress,
    #[key]
    pub enemy: u32,
    pub vec: Vec2,
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

#[generate_trait]
impl Vec2Impl of Vec2Trait {
    fn is_zero(self: Vec2) -> bool {
        if self.x - self.y == 0 {
            return true;
        }
        false
    }

    fn is_equal(self: Vec2, b: Vec2) -> bool {
        self.x == b.x && self.y == b.y
    }
}