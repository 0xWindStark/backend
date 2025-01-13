use starknet::ContractAddress;
use super::coordinates::Coordinates;

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct PlayerPosition {
    #[key]
    pub player: ContractAddress,
    pub small_pos: Coordinates,
    pub big_pos: Coordinates,
    pub pos: Coordinates
}