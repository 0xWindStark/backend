use starknet::ContractAddress;
use super::coordinates::Coordinates;

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct Trail {
    #[key]
    pub player: ContractAddress,
    pub path: Map<u8, Coordinates>,
}