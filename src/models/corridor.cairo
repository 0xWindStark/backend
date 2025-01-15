use starknet::ContractAddress;
use super::coordinates::Coordinates;

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Corridor {
    #[key]
    pub player: ContractAddress,
    pub pos: Coordinates,
}
