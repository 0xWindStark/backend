use super::coordinates::Coordinates;

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct EnemyPosition {
    #[key]
    pub id: u32,
    pub small_pos: Coordinates,
    pub big_pos: Coordinates,
    pub pos: Coordinates
}