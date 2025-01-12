use starknet::ContractAddress;
use starknet::Storage::Map;
use super::coordinates::Coordinates;

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct Enemy {
    #[key]
    pub player: ContractAddress,
    pub enemy_count: u8,
    pub enemies: Map<u8, Coordinates>
}