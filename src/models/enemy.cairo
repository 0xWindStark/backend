use starknet::ContractAddress;
use super::coordinates::Coordinates;

#[derive(Drop, Serde)]
#[dojo::model]
pub struct Enemy {
    #[key]
    pub player: ContractAddress,
    pub enemy_count: u8,
    pub enemies: Array<u32>
}