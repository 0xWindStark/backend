use starknet::ContractAddress;
use origami_map::map::Map;

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Scene {
    #[key]
    pub player: ContractAddress,
    level: u8,
    pub map: felt252,
}