use starknet::ContractAddress;
use super::coordinates::Coordinates;

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct CorridorPosition {
    #[key]
    pub player: ContractAddress,
    pub pos: Coordinates,
}