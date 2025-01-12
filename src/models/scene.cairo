use starknet::ContractAddress;
use starknet::Storage::Map;
use super::coordinates::Coordinates;

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct Scene {
    #[key]
    pub player: ContractAddress,
    pub map: Map<Coordinates, u8>,
}